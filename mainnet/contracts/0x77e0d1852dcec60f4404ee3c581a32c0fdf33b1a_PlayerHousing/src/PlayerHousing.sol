// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "openzeppelin/utils/Strings.sol";
import "solmate/tokens/ERC1155B.sol";

import "./IAchievements.sol";
import "./ILockManager.sol";
import "./Owned.sol";

/// @title Solarbots Player Housing
/// @author Solarbots (https://solarbots.io)
contract PlayerHousing is ERC1155B, Owned {
    // ---------- CONSTANTS ----------

    /// @notice Maximum amount of tokens per faction that can be minted in total
    /// Arboria tokens use IDs 0-5999, Illskagaard tokens use IDs 6000-11999,
    /// and Lacrean Empire tokens use IDs 12000-17999 for a total of 18000 tokens
    uint256 public constant MAX_SUPPLY_PER_FACTION = 6000;

    /// @notice Maximum amount of tokens that can be minted per transaction
    uint256 public constant MAX_MINT_AMOUNT_PER_TX = 5;

    /// @notice Price to mint one token
    uint256 public constant MINT_PRICE = 0.1 ether;

    /// @notice FOA rewards emitted per second per token
    /// @dev 600_000_000*1e18/18_000/10/365/24/60/60
    uint256 public constant REWARDS_PER_SECOND = 105699306612548;

    /// @notice End of FOA rewards emittance
    uint256 public immutable rewardsEndTimestamp;

    /// @notice Start of whitelist sale
    uint256 public immutable whitelistSaleDate;

    /// @notice Start of public sale
    uint256 public immutable publicSaleDate;

    /// @notice Achievements contract
    address public immutable achievements;

    /// @notice Token ID of whitelist ticket in achievements contract
    uint256 public immutable whitelistTicketTokenID;

    /// @dev First 16 bits are all 1, remaining 240 bits are all 0
    uint256 private constant _TOTAL_SUPPLY_BITMASK = type(uint16).max;

    // ---------- STATE ----------

    mapping(address => uint256) public rewardsBitField;
    mapping(address => bool) public isApprovedForRewards;

    address public lockManager;

    /// @notice Metadata base URI
    string public baseURI;

    /// @notice Metadata URI suffix
    string public uriSuffix;

    /// @dev First 16 bits contain total supply of Arboria tokens,
    /// second 16 bits contain total supply of Illskagard tokens,
    /// and third 16 bits contain total supply of Lacrean Empire tokens
    uint256 private _totalSupplyBitField;

    // ---------- EVENTS ----------

    event ApprovalForRewards(address indexed operator, bool approved);

    event LockManagerTransfer(address indexed previousLockManager, address indexed newLockManager);

    // ---------- CONSTRUCTOR ----------

    /// @param owner Contract owner
    /// @param _whitelistSaleDate Start of whitelist sale
    /// @param _publicSaleDate Start of public sale
    /// @param _rewardsEndTimestamp End of FOA rewards emittance
    /// @param _achievements Address of Achievements contract
    /// @param _whitelistTicketTokenID Token ID of whitelist ticket in Achievements contract
    /// @param _lockManager Address of Lock Manager contract
    constructor(
        address owner,
        uint256 _whitelistSaleDate,
        uint256 _publicSaleDate,
        uint256 _rewardsEndTimestamp,
        address _achievements,
        uint256 _whitelistTicketTokenID,
        address _lockManager
    ) Owned(owner) {
        whitelistSaleDate = _whitelistSaleDate;
        publicSaleDate = _publicSaleDate;
        rewardsEndTimestamp = _rewardsEndTimestamp;
        achievements = _achievements;
        whitelistTicketTokenID = _whitelistTicketTokenID;
        lockManager = _lockManager;
    }

    // ---------- METADATA ----------

    /// @notice Get metadata URI
    /// @param id Token ID
    /// @return Metadata URI of token ID `id`
    function uri(uint256 id) public view override returns (string memory) {
        require(bytes(baseURI).length > 0, "NO_METADATA");
		return string(abi.encodePacked(baseURI, Strings.toString(id), uriSuffix));
    }

    /// @notice Set metadata base URI
    /// @param _baseURI New metadata base URI
    /// @dev Doesn't emit URI event, because `id` argument isn't used
    function setBaseURI(string calldata _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }

    /// @notice Set metadata URI suffix
    /// @param _uriSuffix New metadata URI suffix
    /// @dev Doesn't emit URI event, because `id` argument isn't used
    function setURISuffix(string calldata _uriSuffix) public onlyOwner {
        uriSuffix = _uriSuffix;
    }

    // ---------- TOTAL SUPPLY ----------

    function totalSupplyArboria() public view returns (uint256) {
        return _totalSupplyBitField & _TOTAL_SUPPLY_BITMASK;
    }

    function totalSupplyIllskagaard() public view returns (uint256) {
        return _totalSupplyBitField >> 16 & _TOTAL_SUPPLY_BITMASK;
    }

    function totalSupplyLacrean() public view returns (uint256) {
        return _totalSupplyBitField >> 32;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupplyArboria() + totalSupplyIllskagaard() + totalSupplyLacrean();
    }

    // ---------- LOCK MANAGER ----------

    function setLockManager(address _lockManager) public onlyOwner {
        emit LockManagerTransfer(lockManager, _lockManager);
        lockManager = _lockManager;
    }

    // ---------- REWARDS ----------

    function setApprovalForRewards(address operator, bool approved) public onlyOwner {
        isApprovedForRewards[operator] = approved;
        emit ApprovalForRewards(operator, approved);
    }

    function setRewardsBitField(address owner, uint256 _rewardsBitField) public {
        require(isApprovedForRewards[msg.sender], "NOT_AUTHORIZED");
        rewardsBitField[owner] = _rewardsBitField;
    }

    /// @notice Returns the token balance of the given address
    /// @param owner Address to check
    function balanceOf(address owner) public view returns (uint256) {
        return rewardsBitField[owner] & type(uint16).max;
    }

    /// @notice Returns the FOA rewards balance of the given address
    /// @param owner Address to check
    function rewardsOf(address owner) public view returns (uint256 rewardsBalance) {
        rewardsBalance = rewardsBitField[owner] >> 48;
        uint256 lastUpdated = rewardsBitField[owner] >> 16 & type(uint32).max;

        if (lastUpdated != rewardsEndTimestamp) {
            // Use current block timestamp or rewards end timestamp if reached
            uint256 timestamp = block.timestamp < rewardsEndTimestamp ? block.timestamp : rewardsEndTimestamp;
            uint256 tokenBalance = balanceOf(owner);

            // Calculate rewards collected since last update and add them to balance
            if (lastUpdated > 0) {
                uint256 secondsSinceLastUpdate = timestamp - lastUpdated;
                rewardsBalance += secondsSinceLastUpdate * REWARDS_PER_SECOND * tokenBalance;
            }
        }
    }

    function _updateRewardsForTransfer(address from, address to, uint256 tokenAmount) internal {
        // Use current block timestamp or rewards end timestamp if reached
        uint256 timestamp = block.timestamp < rewardsEndTimestamp ? block.timestamp : rewardsEndTimestamp;

        // Store bit field in memory to reduce number of SLOADs
        uint256 _rewardsBitField = rewardsBitField[from];
        uint256 lastUpdated = _rewardsBitField >> 16 & type(uint32).max;

        if (lastUpdated != rewardsEndTimestamp) {
            uint256 tokenBalance = _rewardsBitField & type(uint16).max;
            uint256 rewardsBalance = _rewardsBitField >> 48;

            // Calculate rewards collected since last update and add them to balance
            if (lastUpdated > 0) {
                uint256 secondsSinceLastUpdate = timestamp - lastUpdated;
                unchecked {
                    rewardsBalance += secondsSinceLastUpdate * REWARDS_PER_SECOND * tokenBalance;
                }
            }

            unchecked {
                rewardsBitField[from] = tokenBalance - tokenAmount | timestamp << 16 | rewardsBalance << 48;
            }
        }

        // Store bit field in memory to reduce number of SLOADs
        _rewardsBitField = rewardsBitField[to];
        lastUpdated = _rewardsBitField >> 16 & type(uint32).max;

        if (lastUpdated != rewardsEndTimestamp) {
            uint256 tokenBalance = _rewardsBitField & type(uint16).max;
            uint256 rewardsBalance = _rewardsBitField >> 48;

            // Calculate rewards collected since last update and add them to balance
            if (lastUpdated > 0) {
                uint256 secondsSinceLastUpdate = timestamp - lastUpdated;
                unchecked {
                    rewardsBalance += secondsSinceLastUpdate * REWARDS_PER_SECOND * tokenBalance;
                }
            }

            unchecked {
                rewardsBitField[to] = tokenBalance + tokenAmount | timestamp << 16 | rewardsBalance << 48;
            }
        }
    }

    function _updateRewardsForMint(address owner, uint256 tokenAmount) internal {
        // Store bit field in memory to reduce number of SLOADs
        uint256 _rewardsBitField = rewardsBitField[owner];
        uint256 tokenBalance = _rewardsBitField & type(uint16).max;
        uint256 lastUpdated = _rewardsBitField >> 16 & type(uint32).max;
        uint256 rewardsBalance = _rewardsBitField >> 48;

        // Calculate rewards collected since last update and add them to balance
        if (lastUpdated > 0) {
            uint256 secondsSinceLastUpdate = block.timestamp - lastUpdated;
            unchecked {
                rewardsBalance += secondsSinceLastUpdate * REWARDS_PER_SECOND * tokenBalance;
            }
        }

        unchecked {
            rewardsBitField[owner] = tokenBalance + tokenAmount | block.timestamp << 16 | rewardsBalance << 48;
        }
    }

    // ---------- TRANSFER ----------

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) public override {
        require(msg.sender == from || isApprovedForAll[from][msg.sender], "NOT_AUTHORIZED");
        require(from == ownerOf[id], "NOT_TOKEN_OWNER");
        require(amount == 1, "INVALID_AMOUNT");
        require(!ILockManager(lockManager).isLocked(from, to, id), "TOKEN_LOCKED");

        ownerOf[id] = to;
        _updateRewardsForTransfer(from, to, amount);
        emit TransferSingle(msg.sender, from, to, id, amount);

        if (to.code.length != 0) {
            require(
                ERC1155TokenReceiver(to).onERC1155Received(msg.sender, from, id, amount, data) ==
                    ERC1155TokenReceiver.onERC1155Received.selector,
                "UNSAFE_RECIPIENT"
            );
        } else require(to != address(0), "INVALID_RECIPIENT");
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) public override {
        require(msg.sender == from || isApprovedForAll[from][msg.sender], "NOT_AUTHORIZED");
        require(ids.length == amounts.length, "LENGTH_MISMATCH");
        require(!ILockManager(lockManager).isLocked(from, to, ids), "TOKEN_LOCKED");

        // Unchecked because the only math done is incrementing
        // the array index counter which cannot possibly overflow.
        unchecked {
            for (uint256 i = 0; i < ids.length; i++) {
                uint256 id;
                uint256 amount;

                /// @solidity memory-safe-assembly
                assembly {
                    // Load current array elements by adding offset of current
                    // array index to start of each array's data area inside calldata
                    let indexOffset := mul(i, 0x20)
                    id := calldataload(add(ids.offset, indexOffset))
                    amount := calldataload(add(amounts.offset, indexOffset))
                }

                // Can only transfer from the owner.
                require(from == ownerOf[id], "NOT_TOKEN_OWNER");

                // Can only transfer 1 with ERC1155B.
                require(amount == 1, "INVALID_AMOUNT");

                ownerOf[id] = to;
            }
        }

        _updateRewardsForTransfer(from, to, ids.length);
        emit TransferBatch(msg.sender, from, to, ids, amounts);

        if (to.code.length != 0) {
            require(
                ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, from, ids, amounts, data) ==
                    ERC1155TokenReceiver.onERC1155BatchReceived.selector,
                "UNSAFE_RECIPIENT"
            );
        } else require(to != address(0), "INVALID_RECIPIENT");
    }

    // ---------- WHITELIST SALE ----------

    /// @notice Mint a single Arboria token during whitelist sale
    function mintWhitelistArboria() external payable {
        require(block.timestamp >= whitelistSaleDate, "Whitelist sale not ready");

        // Burn whitelist ticket
        IAchievements(achievements).burn(msg.sender, whitelistTicketTokenID, 1);

        _mintArboria();
    }

    /// @notice Mint a single Illskagaard token during whitelist sale
    function mintWhitelistIllskagaard() external payable {
        require(block.timestamp >= whitelistSaleDate, "Whitelist sale not ready");

        // Burn whitelist ticket
        IAchievements(achievements).burn(msg.sender, whitelistTicketTokenID, 1);

        _mintIllskagaard();
    }

    /// @notice Mint a single Lacrean Empire token during whitelist sale
    function mintWhitelistLacrean() external payable {
        require(block.timestamp >= whitelistSaleDate, "Whitelist sale not ready");

        // Burn whitelist ticket
        IAchievements(achievements).burn(msg.sender, whitelistTicketTokenID, 1);

        _mintLacrean();
    }

    /// @notice Batch mint specified amount of tokens during whitelist sale
    /// @param arboriaAmount Amount of Arboria tokens to mint
    /// @param illskagaardAmount Amount of Illskagaard tokens to mint
    /// @param lacreanAmount Amount of Lacrean tokens to mint
    function batchMintWhitelist(uint256 arboriaAmount, uint256 illskagaardAmount, uint256 lacreanAmount) external payable {
        require(block.timestamp >= whitelistSaleDate, "Whitelist sale not ready");

        // Burn whitelist tickets
        IAchievements(achievements).burn(msg.sender, whitelistTicketTokenID, arboriaAmount + illskagaardAmount + lacreanAmount);

        _batchMint(arboriaAmount, illskagaardAmount, lacreanAmount);
    }

    // ---------- PUBLIC SALE ----------

    /// @notice Mint a single Arboria token during public sale
    function mintPublicArboria() external payable {
        require(block.timestamp >= publicSaleDate, "Public sale not ready");
        _mintArboria();
    }

    /// @notice Mint a single Illskagaard token during public sale
    function mintPublicIllskagaard() external payable {
        require(block.timestamp >= publicSaleDate, "Public sale not ready");
        _mintIllskagaard();
    }

    /// @notice Mint a single Lacrean Empire token during public sale
    function mintPublicLacrean() external payable {
        require(block.timestamp >= publicSaleDate, "Public sale not ready");
        _mintLacrean();
    }

    /// @notice Batch mint specified amount of tokens during public sale
    /// @param arboriaAmount Amount of Arboria tokens to mint
    /// @param illskagaardAmount Amount of Illskagaard tokens to mint
    /// @param lacreanAmount Amount of Lacrean tokens to mint
    function batchMintPublic(uint256 arboriaAmount, uint256 illskagaardAmount, uint256 lacreanAmount) external payable {
        require(block.timestamp >= publicSaleDate, "Public sale not ready");
        _batchMint(arboriaAmount, illskagaardAmount, lacreanAmount);
    }

    // ---------- MINT ----------

    /// @dev Mint a single Arboria token
    function _mintArboria() internal {
        require(msg.sender == tx.origin, "Smart contract minting not allowed");
        require(msg.value == MINT_PRICE, "Wrong price");
        // Total supply of Arboria tokens is stored in the first 16 bits of the bit field
        uint256 tokenId = _totalSupplyBitField & _TOTAL_SUPPLY_BITMASK;
        require(tokenId < MAX_SUPPLY_PER_FACTION, "Reached max Arboria supply");

        ownerOf[tokenId] = msg.sender;
        unchecked {
            // Incrementing the whole bit field increments just the total supply of
            // Arboria tokens, because only the value stored in the first bits gets updated
            _totalSupplyBitField++;
        }

        _updateRewardsForMint(msg.sender, 1);
        emit TransferSingle(msg.sender, address(0), msg.sender, tokenId, 1);
    }

    /// @dev Mint a single Illskagaard token
    function _mintIllskagaard() internal {
        require(msg.sender == tx.origin, "Smart contract minting not allowed");
        require(msg.value == MINT_PRICE, "Wrong price");
        // Store bit field in memory to reduce number of SLOADs
        uint256 totalSupplyBitField = _totalSupplyBitField;
        // Total supply of Illskagaard tokens is stored in the second 16 bits of the bit field
        uint256 _totalSupplyIllskagaard = totalSupplyBitField >> 16 & _TOTAL_SUPPLY_BITMASK;
        require(_totalSupplyIllskagaard < MAX_SUPPLY_PER_FACTION, "Reached max Illskagaard supply");

        unchecked {
            // Illskagaard token IDs start at 6000
            uint256 tokenId = MAX_SUPPLY_PER_FACTION + _totalSupplyIllskagaard;
            ownerOf[tokenId] = msg.sender;

            // Second 16 bits need to be all set to 0 before the new total supply of
            // Illskagaard tokens can be stored
            _totalSupplyBitField = totalSupplyBitField & ~(uint256(type(uint16).max) << 16) | ++_totalSupplyIllskagaard << 16;

            _updateRewardsForMint(msg.sender, 1);
            emit TransferSingle(msg.sender, address(0), msg.sender, tokenId, 1);
        }
    }

    /// @dev Mint a single Lacrean Empire token
    function _mintLacrean() internal {
        require(msg.sender == tx.origin, "Smart contract minting not allowed");
        require(msg.value == MINT_PRICE, "Wrong price");
        // Store bit field in memory to reduce number of SLOADs
        uint256 totalSupplyBitField = _totalSupplyBitField;
        // Total supply of Lacrean Empire tokens is stored in the third 16 bits of the bit field
        uint256 _totalSupplyLacrean = totalSupplyBitField >> 32;
        require(_totalSupplyLacrean < MAX_SUPPLY_PER_FACTION, "Reached max Lacrean supply");

        unchecked {
            // Lacrean Empire token IDs start at 12000
            uint256 tokenId = MAX_SUPPLY_PER_FACTION * 2 + _totalSupplyLacrean;
            ownerOf[tokenId] = msg.sender;

            // Third 16 bits need to be all set to 0 before the new total supply of
            // Lacrean Empire tokens can be stored
            _totalSupplyBitField = totalSupplyBitField & ~(uint256(type(uint16).max) << 32) | ++_totalSupplyLacrean << 32;

            _updateRewardsForMint(msg.sender, 1);
            emit TransferSingle(msg.sender, address(0), msg.sender, tokenId, 1);
        }
    }

    /// @notice Batch mint specified amount of tokens
    /// @param arboriaAmount Amount of Arboria tokens to mint
    /// @param illskagaardAmount Amount of Illskagaard tokens to mint
    /// @param lacreanAmount Amount of Lacrean tokens to mint
    function _batchMint(uint256 arboriaAmount, uint256 illskagaardAmount, uint256 lacreanAmount) internal {
        require(msg.sender == tx.origin, "Smart contract minting not allowed");
        // Doing these checks and later calculating the total amount unchecked costs less gas
        // than not doing these checks and calculating the total amount checked
        require(arboriaAmount <= MAX_MINT_AMOUNT_PER_TX, "Arboria amount over maximum allowed per transaction");
        require(illskagaardAmount <= MAX_MINT_AMOUNT_PER_TX, "Illskagaard amount over maximum allowed per transaction");
        require(lacreanAmount <= MAX_MINT_AMOUNT_PER_TX, "Lacrean amount over maximum allowed per transaction");

        // Once the supplied amounts are known to be under certain limits,
        // all following calculations are safe and can be performed unchecked
        unchecked {
            uint256 totalAmount = arboriaAmount + illskagaardAmount + lacreanAmount;
            require(totalAmount > 1, "Total amount must be at least 2");
            require(totalAmount <= MAX_MINT_AMOUNT_PER_TX, "Total amount over maximum allowed per transaction");
            require(msg.value == totalAmount * MINT_PRICE, "Wrong price");

            // Token IDs and amounts are collected in arrays to later emit the TransferBatch event
            uint256[] memory tokenIds = new uint256[](totalAmount);
            // Token amounts are all 1
            uint256[] memory amounts = new uint256[](totalAmount);
            // Keeps track of the current index of both arrays
            uint256 currentArrayIndex;

            // Store bit field in memory to reduce number of SLOADs
            uint256 totalSupplyBitField = _totalSupplyBitField;
            // New bit field gets updated in memory to reduce number of SSTOREs
            // _totalSupplyBitField is only updated once after all tokens are minted
            uint256 newTotalSupplyBitField = totalSupplyBitField;

            if (arboriaAmount > 0) {
                // Total supply of Arboria tokens is stored in the first 16 bits of the bit field
                uint256 _totalSupplyArboria = totalSupplyBitField & _TOTAL_SUPPLY_BITMASK;
                uint256 newTotalSupplyArboria = _totalSupplyArboria + arboriaAmount;
                require(newTotalSupplyArboria <= MAX_SUPPLY_PER_FACTION, "Reached max Arboria supply");

                for (uint256 i = 0; i < arboriaAmount; i++) {
                    uint256 tokenId = _totalSupplyArboria + i;
                    ownerOf[tokenId] = msg.sender;

                    /// @solidity memory-safe-assembly
                    assembly {
                        // Store token ID and amount in the
                        // corresponding memory arrays
                        let indexOffset := mul(i, 0x20)
                        mstore(add(add(tokenIds, 0x20), indexOffset), tokenId)
                        mstore(add(add(amounts, 0x20), indexOffset), 1)
                    }
                }
                currentArrayIndex = arboriaAmount;

                // First 16 bits need to be all set to 0 before the new total supply of Arboria tokens can be stored
                newTotalSupplyBitField = newTotalSupplyBitField & uint16(0) | newTotalSupplyArboria;
            }

            if (illskagaardAmount > 0) {
                // Total supply of Illskagaard tokens is stored in the second 16 bits of the bit field
                uint256 _totalSupplyIllskagaard = totalSupplyBitField >> 16 & _TOTAL_SUPPLY_BITMASK;
                uint256 newTotalSupplyIllskagaard = _totalSupplyIllskagaard + illskagaardAmount;
                require(newTotalSupplyIllskagaard <= MAX_SUPPLY_PER_FACTION, "Reached max Illskagaard supply");

                for (uint256 i = 0; i < illskagaardAmount; i++) {
                    // Illskagaard token IDs start at 6000
                    uint256 tokenId = MAX_SUPPLY_PER_FACTION + _totalSupplyIllskagaard + i;
                    ownerOf[tokenId] = msg.sender;

                    /// @solidity memory-safe-assembly
                    assembly {
                        // Store token ID and amount in the
                        // corresponding memory arrays
                        let indexOffset := mul(currentArrayIndex, 0x20)
                        mstore(add(add(tokenIds, 0x20), indexOffset), tokenId)
                        mstore(add(add(amounts, 0x20), indexOffset), 1)
                    }

                    currentArrayIndex++;
                }

                // Second 16 bits need to be all set to 0 before the new total supply of Illskagaard tokens can be stored
                newTotalSupplyBitField = newTotalSupplyBitField & ~(uint256(type(uint16).max) << 16) | newTotalSupplyIllskagaard << 16;
            }

            if (lacreanAmount > 0) {
                // Total supply of Lacrean Empire tokens is stored in the third 16 bits of the bit field
                uint256 _totalSupplyLacrean = totalSupplyBitField >> 32;
                uint256 newTotalSupplyLacrean = _totalSupplyLacrean + lacreanAmount;
                require(newTotalSupplyLacrean <= MAX_SUPPLY_PER_FACTION, "Reached max Lacrean supply");

                for (uint256 i = 0; i < lacreanAmount; i++) {
                    // Lacrean Empire token IDs start at 12000
                    uint256 tokenId = MAX_SUPPLY_PER_FACTION * 2 + _totalSupplyLacrean + i;
                    ownerOf[tokenId] = msg.sender;

                    /// @solidity memory-safe-assembly
                    assembly {
                        // Store token ID and amount in the
                        // corresponding memory arrays
                        let indexOffset := mul(currentArrayIndex, 0x20)
                        mstore(add(add(tokenIds, 0x20), indexOffset), tokenId)
                        mstore(add(add(amounts, 0x20), indexOffset), 1)
                    }

                    currentArrayIndex++;
                }

                // Third 16 bits need to be all set to 0 before the new total supply of Lacrean Empire tokens can be stored
                newTotalSupplyBitField = newTotalSupplyBitField & ~(uint256(type(uint16).max) << 32) | newTotalSupplyLacrean << 32;
            }

            _totalSupplyBitField = newTotalSupplyBitField;
            _updateRewardsForMint(msg.sender, totalAmount);
            emit TransferBatch(msg.sender, address(0), msg.sender, tokenIds, amounts);
        }
    }

    // ---------- ALL OWNERS ----------

    function allOwners() public view returns (address[] memory owners) {
        uint256 maxSupply = MAX_SUPPLY_PER_FACTION * 3;
        owners = new address[](maxSupply);

        for (uint256 i = 0; i < maxSupply;) {
            owners[i] = ownerOf[i];

            unchecked {
                i++;
            }
        }
    }

    // ---------- WITHDRAW ----------

    /// @notice Withdraw all Ether stored in this contract to address of contract owner
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
