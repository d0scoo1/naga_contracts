//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "./interfaces/ICandyToken.sol";

contract UninterestedUnicornsV2 is
    AccessControlEnumerableUpgradeable,
    PausableUpgradeable,
    OwnableUpgradeable,
    ERC721Upgradeable
{
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using StringsUpgradeable for uint256;
    using ECDSAUpgradeable for bytes32;

    struct Parents {
        uint16 parent_1;
        uint16 parent_2;
    }

    // Stores quantity of UUs left in a season
    uint256 public QUANTITY_LEFT;

    // Breeding Information
    uint256 public BREEDING_COST; // UCD Breeding Cost
    uint256 public BREEDING_COST_ETH; // ETH Breeding cost
    uint256[] public BREEDING_DISCOUNT_THRESHOLD; // UCD to hold for discount
    uint256[] public BREEDING_DISCOUNT_PERC; // UCD to hold for discount

    // Signers
    address private BREED_SIGNER;
    address private WHITELIST_SIGNER;

    // External Contracts
    ICandyToken public CANDY_TOKEN;

    // GNOSIS SAFE
    address public TREASURY;

    // Passive Rewards
    uint256 public REWARDS_PER_DAY;
    mapping(uint256 => uint256) public lastClaim;

    // Private Variables
    CountersUpgradeable.Counter private _tokenIds;
    string private baseTokenURI;

    // UU Status
    mapping(uint256 => bool) private isBred; // Mapping that determines if the UUv1 is Bred

    // Toggles
    bool private breedingOpen;
    bool private presaleOpen;
    bool private publicOpen;

    // Mint Caps
    mapping(address => uint8) public privateSaleMintedAmount;
    mapping(address => uint8) public publicSaleMintedAmount;

    // Nonce
    mapping(bytes => bool) private _nonceUsed;

    // Parent Mapping
    mapping(uint256 => Parents) private _parents;

    // Reserve Storage (important: New variables should be declared below)
    uint256 private maxPerTransactionPrivate;
    uint256 private maxPerTransactionPublic;
    uint256 private maxPerWalletPrivate;
    uint256 private maxPerWalletPublic;

    // Reserved Variable
    uint256 public reserved;
    uint256[45] private ______gap;

    // Free claim mapping
    mapping(address => uint8) public claimMintedAmount;

    // More Toggles
    bool private claimOpen;
    bool private rewardsOpen;

    // ------------------------ EVENTS ----------------------------
    event Minted(address indexed minter, uint256 indexed tokenId);

    event Breed(
        address indexed minter,
        uint256 tokenId,
        uint256 parent_1_tokenId,
        uint256 parent_2_tokenId
    );

    event RewardsClaimed(
        address indexed user,
        uint256 tokenId,
        uint256 amount,
        uint256 timestamp
    );

    // ---------------------- MODIFIERS ---------------------------

    /// @dev Only EOA modifier
    modifier onlyEOA() {
        require(msg.sender == tx.origin, "UUv2: Only EOA");
        _;
    }

    function __UUv2_init(
        address owner,
        address _treasury,
        address _breedSigner,
        address _whitelistSigner
    ) public initializer {
        __Context_init_unchained();
        __ERC165_init_unchained();
        __ERC721_init_unchained("UninterestedUnicornsV2", "UUv2");
        __Ownable_init_unchained();
        __AccessControl_init_unchained();
        __AccessControlEnumerable_init_unchained();
        __Pausable_init_unchained();

        transferOwnership(owner);
        TREASURY = _treasury;
        REWARDS_PER_DAY = 2 ether;
        BREEDING_COST = 1000 ether;
        BREEDING_COST_ETH = 0.1 ether;
        BREEDING_DISCOUNT_THRESHOLD = [10000 ether, 5000 ether];
        BREEDING_DISCOUNT_PERC = [75, 90]; // Percentage Discount
        BREED_SIGNER = _breedSigner;
        WHITELIST_SIGNER = _whitelistSigner;
        QUANTITY_LEFT = 5000;
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender()); // To revoke access after deployment
        grantRole(DEFAULT_ADMIN_ROLE, TREASURY);
        _setBaseURI(
            "https://lit-island-00614.herokuapp.com/api/v1/uuv2/chromosomes/"
        );
    }

    // ------------------------- USER FUNCTION ---------------------------

    /**
     * @notice Takes the input of 2 genesis UU ids and breed them together to get a Gen 2 Baby
     * @param parent_1_tokenId Token ID of genesis token 1
     * @param parent_2_tokenId Token ID of genesis token 1
     * @param nonce Nonce of Transaction
     * @param signature Signature generated by off-chain signer
     * @dev Ownership verication is done off-chain and signed by BREED_SIGNER
     * @dev Each Genesis token can only be used to breed once
     * @dev UCD is burnt during when bred
     */
    function breed(
        uint16 parent_1_tokenId,
        uint16 parent_2_tokenId,
        bytes memory nonce,
        bytes memory signature
    ) public {
        require(
            breedSigned(
                msg.sender,
                nonce,
                signature,
                parent_1_tokenId,
                parent_2_tokenId
            ),
            "UUv2: Invalid Signature"
        );
        require(isBreedingOpen(), "UUv2: Breeding is not open");
        require(
            CANDY_TOKEN.balanceOf(msg.sender) >= BREEDING_COST,
            "UUv2: Insufficient UCD for breeding"
        );
        require(QUANTITY_LEFT != 0, "UUv2: No more UUs available");
        require(
            !isBred[parent_1_tokenId] && !isBred[parent_2_tokenId],
            "UUv2: UUs have been bred before!"
        );

        // Reduce Quantity Left
        QUANTITY_LEFT -= 1;
        // Increase Token ID
        _tokenIds.increment();
        isBred[parent_1_tokenId] = true;
        isBred[parent_2_tokenId] = true;
        // Burn UCD Token
        CANDY_TOKEN.burn(msg.sender, BREEDING_COST);

        // Store Parent Id
        _parents[_tokenIds.current()] = Parents(
            parent_1_tokenId,
            parent_2_tokenId
        );

        // Set Last Claim
        lastClaim[_tokenIds.current()] = block.timestamp;

        // Mint
        _mint(msg.sender, _tokenIds.current());

        emit Breed(
            _msgSender(),
            _tokenIds.current(),
            parent_1_tokenId,
            parent_2_tokenId
        );
    }

    /**
     * @notice Mint a random UUv2. Whitelisted addresses only
     * @param _amount Token ID of genesis token 1
     * @param _tier Token ID of genesis token 1
     * @param nonce Nonce of Transaction
     * @param signature Signature generated by off-chain signer
     * @dev Whitelist is done off-chain and signed by WHITELIST_SIGNER
     * @dev Number of whitelist mints a user has is capped by their tier
     * @dev Cost of mint in ETH is discounted by the amount of UCD held by the user
     */
    function whitelistMint(
        uint8 _amount,
        uint8 _tier,
        bytes memory nonce,
        bytes memory signature
    ) public payable onlyEOA {
        require(isPresaleOpen(), "UUv2: Presale Mint not open!");
        require(!_nonceUsed[nonce], "UUv2: Nonce was used");
        _nonceUsed[nonce] = true;
        require(
            whitelistSigned(msg.sender, _tier, nonce, signature),
            "UUv2: Invalid signature"
        );

        // Max X = _tier Per Presale
        require(
            privateSaleMintedAmount[msg.sender] + _amount <= _tier,
            "UUv2: Presale Limit Exceeded!"
        );

        // Increase private sale amount
        privateSaleMintedAmount[msg.sender] += _amount;

        require(
            msg.value == getETHPrice(msg.sender) * _amount,
            "UUv2: Insufficient ETH!"
        );

        // Check Quantity
        require(
            QUANTITY_LEFT - _amount >= reserved,
            "UUv2: No more UUs available"
        );

        // Reduce Quantity
        QUANTITY_LEFT -= _amount;

        for (uint8 i; i < _amount; i++) {
            _tokenIds.increment();

            // Set Last Claim
            lastClaim[_tokenIds.current()] = block.timestamp;

            _mint(msg.sender, _tokenIds.current());
        }

        (bool success, ) = TREASURY.call{value: msg.value}(""); // forward amount to treasury wallet
        require(success, "UUv2: Unable to forward message to treasury!");
    }

    /**
     * @notice Mint a random UUv2.
     * @param _amount Amount to mint
     * @dev msg.value must be equals to `_amount` times price
     * @dev Maximum of 5 mints per transaction
     * @dev Maximum of 10 mints per wallet
     * @dev Cost of mint in ETH is discounted by the amount of UCD held by the user
     */
    function mint(uint8 _amount) public payable onlyEOA {
        require(isPublicOpen(), "UUv2: Public Mint not open!");
        require(
            _amount <= maxPerTransactionPublic,
            "UUv2: Maximum of 5 mints per transaction!"
        );
        require(
            publicSaleMintedAmount[msg.sender] + _amount <= maxPerWalletPublic,
            "UUv2: Public Limit Exceeded!"
        );

        publicSaleMintedAmount[msg.sender] += _amount;

        require(
            msg.value == getETHPrice(msg.sender) * _amount,
            "UUv2: Insufficient ETH!"
        );

        // Check Quantity
        require(
            QUANTITY_LEFT - _amount >= reserved,
            "UUv2: No more UUs available"
        );

        // Reduce Quantity
        QUANTITY_LEFT -= _amount;

        for (uint8 i; i < _amount; i++) {
            _tokenIds.increment();

            // Set Last Claim
            lastClaim[_tokenIds.current()] = block.timestamp;

            _mint(msg.sender, _tokenIds.current());
        }

        (bool success, ) = TREASURY.call{value: msg.value}(""); // forward amount to treasury wallet
        require(success, "UUv2: Unable to forward message to treasury!");
    }

    /**
     * @notice Mint a random UUv2 using UCD. Whitelist Only
     * @param _amount Token ID of genesis token 1
     * @param _tier Token ID of genesis token 1
     * @param nonce Nonce of Transaction
     * @param signature Signature generated by off-chain signer
     * @dev Whitelist is done off-chain and signed by WHITELIST_SIGNER
     * @dev Number of whitelist mints a user has is capped by their tier
     * @dev Cost of mint in ETH is discounted by the amount of UCD held by the user
     */
    function UCDwhitelistMint(
        uint8 _amount,
        uint8 _tier,
        bytes memory nonce,
        bytes memory signature
    ) public onlyEOA {
        require(isPresaleOpen(), "UUv2: Presale Mint not open!");
        require(!_nonceUsed[nonce], "UUv2: Nonce was used");
        _nonceUsed[nonce] = true;

        require(
            whitelistSigned(msg.sender, _tier, nonce, signature),
            "UUv2: Invalid signature"
        );

        require(
            privateSaleMintedAmount[msg.sender] + _amount <= _tier,
            "UUv2: Presale Limit Exceeded!"
        );

        // Increase private sale minted amount
        privateSaleMintedAmount[msg.sender] += _amount;

        require(
            CANDY_TOKEN.balanceOf(msg.sender) >= BREEDING_COST * _amount,
            "UUv2: Insufficient UCD for minting"
        );

        // Check Quantity
        require(
            QUANTITY_LEFT - _amount >= reserved,
            "UUv2: No more UUs available"
        );

        // Reduce Quantity
        QUANTITY_LEFT -= _amount;

        // Burn UCD Token
        CANDY_TOKEN.burn(msg.sender, BREEDING_COST * _amount);

        for (uint8 i; i < _amount; i++) {
            _tokenIds.increment();

            // Set Last Claim
            lastClaim[_tokenIds.current()] = block.timestamp;

            _mint(msg.sender, _tokenIds.current());
        }
    }

    /**
     * @notice Mint a random UUv2 using UCD.
     * @param _amount Amount to mint
     * @dev User must have approved enough UCD
     * @dev User must have enough UCD (> BREEDING_COST)
     * @dev Maximum of 5 mints per transaction
     * @dev Maximum of 10 mints per wallet
     */
    function UCDmint(uint8 _amount) public payable onlyEOA {
        require(isPublicOpen(), "UUv2: Public Mint not open!");
        require(_amount != 0, "UUv2: Amount must not be 0!");

        require(
            _amount <= maxPerTransactionPublic,
            "UUv2: Maximum of 5 mints per transaction!"
        );
        require(
            publicSaleMintedAmount[msg.sender] + _amount < maxPerWalletPublic,
            "UUv2: Public Limit Exceeded!"
        );

        publicSaleMintedAmount[msg.sender] += _amount;

        require(
            CANDY_TOKEN.balanceOf(msg.sender) >= BREEDING_COST * _amount,
            "UUv2: Insufficient UCD for breeding"
        );

        // Check Quantity
        require(
            QUANTITY_LEFT - _amount >= reserved,
            "UUv2: No more UUs available"
        );

        // Reduce Quantity
        QUANTITY_LEFT -= _amount;

        // Burn UCD Token
        CANDY_TOKEN.burn(msg.sender, BREEDING_COST * _amount);

        for (uint8 i; i < _amount; i++) {
            _tokenIds.increment();

            // Set Last Claim
            lastClaim[_tokenIds.current()] = block.timestamp;

            _mint(msg.sender, _tokenIds.current());
        }
    }

    /**
     * @notice Allow UUv2 Holders to claim UCD Rewards
     * @param tokenId Token Id to claim UCD Rewards
     * @dev User must be owner of the token
     */
    function claimRewards(uint256 tokenId) public {
        require(isRewardsOpen(), "UUv2: UCD Claiming not Open");
        require(
            ownerOf(tokenId) == msg.sender,
            "UUv2: Claimant is not the owner!"
        );
        uint256 amount = calculateRewards(tokenId);

        // Update Last Claim
        lastClaim[tokenId] = block.timestamp;

        CANDY_TOKEN.mint(msg.sender, amount);
        emit RewardsClaimed(msg.sender, tokenId, amount, block.timestamp);
    }

    /**
     * @notice Allow UUv2 Holders to claim UCD Rewards for a array of tokens
     * @param tokenIds Token Ids to claim UCD Rewards
     * @dev User must be owner of the tokens
     */
    function claimRewardsMultiple(uint256[] memory tokenIds) public {
        require(isRewardsOpen(), "UUv2: UCD Claiming not Open");
        uint256 amount = 0; // Store total amount

        // Update Last Claim
        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(
                ownerOf(tokenIds[i]) == msg.sender,
                "UUv2: Claimant is not the owner!"
            );
            uint256 claimAmount = calculateRewards(tokenIds[i]);
            amount += claimAmount;
            lastClaim[tokenIds[i]] = block.timestamp;
            emit RewardsClaimed(
                msg.sender,
                tokenIds[i],
                claimAmount,
                block.timestamp
            );
        }

        // Claim all tokens in 1 transaction
        CANDY_TOKEN.mint(msg.sender, amount);
    }

    /**
     * @notice Redeem Free Mint.
     * @param nonce Nonce of Transaction
     * @param signature Signature generated by off-chain signer
     */
    function claim(
        uint8 _amount,
        uint8 _tier,
        bytes memory nonce,
        bytes memory signature
    ) public payable onlyEOA {
        require(isClaimOpen(), "UUv2: Claiming is not open!");
        require(!_nonceUsed[nonce], "UUv2: Nonce was used");
        _nonceUsed[nonce] = true;

        require(
            whitelistSigned(msg.sender, _tier, nonce, signature),
            "UUv2: Invalid signature"
        );

        require(
            claimMintedAmount[msg.sender] + _amount <= _tier,
            "UUv2: Claim Limit Exceeded!"
        );

        // Increase private sale minted amount
        claimMintedAmount[msg.sender] += _amount;

        // Check Quantity
        require(QUANTITY_LEFT - _amount >= 0, "UUv2: No more UUs available");

        // Reduce Quantity
        QUANTITY_LEFT -= _amount;

        for (uint8 i; i < _amount; i++) {
            _tokenIds.increment();

            // Set Last Claim
            lastClaim[_tokenIds.current()] = block.timestamp;

            _mint(msg.sender, _tokenIds.current());
        }
    }

    // --------------------- VIEW FUNCTIONS ---------------------

    /**
     * @dev Returns total supply of tokens
     */
    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }

    /**
     * @dev Determines if UU has already been used for breeding
     */
    function canBreed(uint256 tokenId) public view returns (bool) {
        return !isBred[tokenId];
    }

    /**
     * @dev Get last claim timestamp of a specified tokenId
     */
    function getLastClaim(uint256 tokenId) public view returns (uint256) {
        return lastClaim[tokenId];
    }

    /**
     * @dev Get Token URI Concatenated with Base URI
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721URIStorage: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();

        return
            bytes(currentBaseURI).length > 0
                ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
                : "";
    }

    /**
     *  @dev Get ETH Mint Price. Discounts are calculated here.
     */
    function getETHPrice(address _user) public view returns (uint256) {
        uint256 discount;
        if (CANDY_TOKEN.balanceOf(_user) >= BREEDING_DISCOUNT_THRESHOLD[0]) {
            discount = BREEDING_DISCOUNT_PERC[0];
        } else if (
            CANDY_TOKEN.balanceOf(_user) >= BREEDING_DISCOUNT_THRESHOLD[1]
        ) {
            discount = BREEDING_DISCOUNT_PERC[1];
        } else {
            discount = 100;
        }
        // Take original breeding cost multiply by 90, divide by 100
        return (BREEDING_COST_ETH * discount) / 100;
    }

    /**
     *  @dev Get UCD cost for breeding & minting
     */
    function getUCDPrice() public view returns (uint256) {
        return BREEDING_COST;
    }

    /**
     *  @dev Check if breeding is open
     */
    function isBreedingOpen() public view returns (bool) {
        return breedingOpen;
    }

    /**
     *  @dev Check if pre-sale is open
     */
    function isPresaleOpen() public view returns (bool) {
        return presaleOpen;
    }

    /**
     *  @dev Check if public sale is open
     */
    function isPublicOpen() public view returns (bool) {
        return publicOpen;
    }

    /**
     *  @dev Check if Claiming is open
     */
    function isClaimOpen() public view returns (bool) {
        return claimOpen;
    }

    /**
     *  @dev Check if UCD Rewards is open
     */
    function isRewardsOpen() public view returns (bool) {
        return rewardsOpen;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControlEnumerableUpgradeable, ERC721Upgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     *  @notice Get parent tokenIds of child
     *  @param tokenId Token ID of Gen2 UU
     */
    function getParents(uint256 tokenId) public view returns (Parents memory) {
        return _parents[tokenId];
    }

    // ----------------------- CALCULATION FUNCTIONS ----------------------

    /**
     *  @dev Check if breeding signature is valid
     *  @param sender User address
     *  @param nonce Random Nonce
     *  @param signature Signature generated by BREED_SIGNER
     *  @param parent_1_id Token ID of Parent 1 from Gen 1 Collection
     *  @param parent_2_id Token ID of Parent 2 from Gen 1 Collection
     */
    function breedSigned(
        address sender,
        bytes memory nonce,
        bytes memory signature,
        uint256 parent_1_id,
        uint256 parent_2_id
    ) private view returns (bool) {
        bytes32 hash = keccak256(
            abi.encodePacked(sender, nonce, parent_1_id, parent_2_id)
        );
        return BREED_SIGNER == hash.recover(signature);
    }

    /**
     *  @dev Check if whitelist signature is valid
     *  @param sender User address
     *  @param _tier Tier which determines max number of whitelist mints
     *  @param nonce Random Nonce
     *  @param signature Signature generated by BREED_SIGNER
     */
    function whitelistSigned(
        address sender,
        uint8 _tier,
        bytes memory nonce,
        bytes memory signature
    ) private view returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(sender, _tier, nonce));
        return WHITELIST_SIGNER == hash.recover(signature);
    }

    /**
     *  @notice Calculates the amount of UCD that can be claimed
     *  @param tokenId Token ID to claim reward for
     *  @return rewardAmount Amount UCD to be rewarded
     */
    function calculateRewards(uint256 tokenId)
        public
        view
        returns (uint256 rewardAmount)
    {
        rewardAmount =
            ((REWARDS_PER_DAY) * (block.timestamp - getLastClaim(tokenId))) /
            (1 days);
    }

    /**
     *  @notice Calculates the amount of UCD that can be claimed for multiple tokens
     *  @dev Since ERC721Enumerable is not used, we must get the tokenIds owned by the user off-chain using Moralis.
     *  @param tokenIds Token IDs to claim reward for
     *  @return rewardAmount Amount UCD to be rewarded
     */
    function calculateRewardsMulti(uint256[] memory tokenIds)
        public
        view
        returns (uint256 rewardAmount)
    {
        for (uint256 i; i < tokenIds.length; i++) {
            rewardAmount += calculateRewards(tokenIds[i]);
        }
    }

    // ---------------------- ADMIN FUNCTIONS -----------------------

    /**
     *  @notice Airdrop UUv2 to addresses
     *  @param addresses Addresses to airdrop Gen2 UU
     */
    function airdrop(address[] memory addresses)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(
            QUANTITY_LEFT >= addresses.length,
            "UUv2: No more UUs available"
        );

        QUANTITY_LEFT -= addresses.length;

        for (uint256 i; i < addresses.length; i++) {
            _tokenIds.increment();

            // Set Last Claim
            lastClaim[_tokenIds.current()] = block.timestamp;

            _mint(addresses[i], _tokenIds.current());
        }
    }

    /// @dev Set UCD Contract
    function setCandyToken(address _addr) public onlyRole(DEFAULT_ADMIN_ROLE) {
        CANDY_TOKEN = ICandyToken(_addr);
    }

    /// @dev Set Quantity of mints/breeds left
    function setQuantity(uint256 _amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        QUANTITY_LEFT = _amount;
    }

    /// @dev Set Rewards per day for holding UU
    function setRewardsPerDay(uint256 _amount)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        REWARDS_PER_DAY = _amount;
    }

    /// @dev Set Breeding Cost
    function setBreedingCost(uint256 _amount)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        BREEDING_COST = _amount;
    }

    /// @dev Set Mint Cost
    function setMintCost(uint256 _amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        BREEDING_COST_ETH = _amount;
    }

    /// @dev Set maxPerTransactionPrivate
    function setMaxPerTransactionPrivate(uint256 _amount)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        maxPerTransactionPrivate = _amount;
    }

    /// @dev Set maxPerTransactionPublic
    function setMaxPerTransactionPublic(uint256 _amount)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        maxPerTransactionPublic = _amount;
    }

    /// @dev Set maxPerWalletPrivate
    function setMaxPerWalletPrivate(uint256 _amount)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        maxPerWalletPrivate = _amount;
    }

    /// @dev Set maxPerWalletPublic
    function setMaxPerWalletPublic(uint256 _amount)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        maxPerWalletPublic = _amount;
    }

    /// @dev Update token metadata baseURI
    function updateBaseURI(string memory newURI)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _setBaseURI(newURI);
    }

    /// @dev Toggle Breeding Open
    function toggleBreeding() public onlyRole(DEFAULT_ADMIN_ROLE) {
        breedingOpen = !breedingOpen;
    }

    /// @dev Toggle Presale Open
    function togglePresale() public onlyRole(DEFAULT_ADMIN_ROLE) {
        presaleOpen = !presaleOpen;
    }

    /// @dev Toggle Public Open
    function togglePublicSale() public onlyRole(DEFAULT_ADMIN_ROLE) {
        publicOpen = !publicOpen;
    }

    /// @dev Toggle Free Claim Open
    function toggleClaim() public onlyRole(DEFAULT_ADMIN_ROLE) {
        claimOpen = !claimOpen;
    }

    /// @dev Toggle UCD Rewards Open
    function toggleRewards() public onlyRole(DEFAULT_ADMIN_ROLE) {
        rewardsOpen = !rewardsOpen;
    }

    ///  @dev Pauses all token transfers.
    function pause() public virtual onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    /// @dev Unpauses all token transfers.
    function unpause() public virtual onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    /// @dev Reserves Tokens
    function setReserved(uint256 _amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        reserved = _amount;
    }

    // --------------------- INTERNAL FUNCTIONS ---------------------

    /// @dev Set Base URI internal function
    function _setBaseURI(string memory _baseTokenURI) internal virtual {
        baseTokenURI = _baseTokenURI;
    }

    /// @dev Gets baseToken URI
    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721Upgradeable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
