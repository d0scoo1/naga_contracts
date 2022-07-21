// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "./utils/SignatureVerifier.sol";
import "./interfaces/IBurnableERC721.sol";

contract RoolahShopUpgradableV2 is
    SignatureVerifier,
    ERC721Holder,
    ERC1155Holder,
    Initializable,
    OwnableUpgradeable
{
    // -------------------------------- EVENTS V1 --------------------------------------

    event TransactionPosted(
        bytes32 indexed listingId,
        bytes32 indexed transactionId,
        address indexed user,
        uint256 quantity
    );

    // deprecated token received/sent events from V1

    // -------------------------------- STORAGE V1 -------------------------------------

    /**
     * The ROOLAH contract address.
     */
    IERC20 public roolahContract;

    /**
     * The RooTroop NFT contract address.
     */
    IBurnableERC721 public rooTroopContract;

    /**
     * The recipient of all ETH sent to the contract.
     */
    address public etherRecipient;

    /**
     * The ROOLAH gained by burning one RooTroop NFT (RIP).
     */
    uint256 public rooToRoolahConversion;

    /**
     * The backend message signer's address.
     */
    address public messageSigner;

    /**
     A mapping of GUID listing ids to number of units sold.
     */
    mapping(bytes32 => uint256) public unitsSold;

    /**
     * A nested mapping of listing ids to user addresses to
     * the number that the user has purchased.
     */
    mapping(bytes32 => mapping(address => uint256)) public userPurchases;

    // -------------------------------- INITIALIZER V1 ---------------------------------

    /**
     * Initializes the proxy contract.
     *
     * @param rooTroopNFT - the address of the RooTroop NFT contract.
     * @param roolah - the address of the ROOLAH contract.
     * @param rooToRoolahRate - the conversion rate in ROOLAH for burning one RooTroop NFT.
     * @param etherReceiver - the recipient of all ETH sent to the contract.
     */
    function initialize(
        address rooTroopNFT,
        address roolah,
        uint256 rooToRoolahRate,
        address etherReceiver,
        address signer
    ) public initializer {
        __Ownable_init();
        _updateDependencies(rooTroopNFT, roolah);
        _setRooToRoolahConversionRate(rooToRoolahRate);
        _setEtherReceiver(etherReceiver);
        _setMessageSigner(signer);
    }

    // -------------------------------- PUBLIC ACCESS V1 -------------------------------

    /**
     * Submits a transaction to the contract to be logged on the blockchain.
     *
     * @param listingId - the GUID listingId provided by the backend.
     * @param transactionId - the id of the transaction.
     *                        This will allow centralized services to tie the transaction to personal details.
     * @param quantity - the number of units to transact upon.
     * @param maxPerUser - the listing max per user.
     * @param supply - the listing maximum supply.
     * @param priceETH - the listing unit price in ETH.
     * @param priceROOLAH - the listing unit price in ROOLAH.
     * @param requiredTokens - the listing's required held tokens to allow transacting.
     * @param signature - the signature that will verify all of the listing data.
     */
    function transact(
        bytes32 listingId,
        bytes32 transactionId,
        uint256 quantity,
        uint256 maxPerUser,
        uint256 supply,
        uint256 priceETH,
        uint256 priceROOLAH,
        uint256 expires,
        address[] calldata requiredTokens,
        bytes memory signature
    ) external payable {
        require(expires > block.timestamp, "Signature expired");

        require(
            supply == 0 || supply >= unitsSold[listingId] + quantity,
            "Exceeds global max"
        );
        require(
            maxPerUser == 0 ||
                maxPerUser >= userPurchases[listingId][msg.sender] + quantity,
            "Exceeds user max"
        );

        require(
            _verifySignature(
                listingId,
                transactionId,
                maxPerUser,
                supply,
                priceETH,
                priceROOLAH,
                expires,
                requiredTokens,
                signature
            ),
            "Invalid signature"
        );

        require(
            requiredTokens.length == 0 ||
                _holdsToken(msg.sender, requiredTokens),
            "Not a holder"
        );

        if (priceETH > 0) {
            require(msg.value == priceETH * quantity, "Bad value");
            (bool success, ) = etherRecipient.call{value: priceETH * quantity}(
                ""
            );
            require(success, "ETH tx failed");
        }

        userPurchases[listingId][msg.sender] += quantity;
        unitsSold[listingId] += quantity;

        if (priceROOLAH > 0)
            roolahContract.transferFrom(
                msg.sender,
                address(this),
                priceROOLAH * quantity
            );

        emit TransactionPosted(listingId, transactionId, msg.sender, quantity);
    }

    /**
     * Burns the token ids passed to the function,
     * provided the contract is approved to access them.
     * Then, the user is returned the conversion in ROOLAH.
     *
     * @param tokenIds - the token ids to pull in and burn
     */
    function burnRoos(uint256[] calldata tokenIds) external {
        for (uint256 i; i < tokenIds.length; i++) {
            rooTroopContract.transferFrom(
                msg.sender,
                address(this),
                tokenIds[i]
            );

            // RIP, sweet prince
            rooTroopContract.burn(tokenIds[i]);
        }

        roolahContract.transfer(
            msg.sender,
            tokenIds.length * rooToRoolahConversion
        );
    }

    /**
     * Submits a transaction to the contract to be logged on the blockchain and results in the transfer of an NFT.
     *
     * @param listingId - the GUID listingId provided by the backend.
     * @param transactionId - the id of the transaction.
     *                        This will allow centralized services to tie the transaction to personal details.
     * @param tokenAddresses - the addresses of the token contracts.
     * @param tokenIds - the token ids to send (parallel with tokenAddresses).
     * @param priceETH - the listing unit price in ETH.
     * @param priceROOLAH - the listing unit price in ROOLAH.
     * @param requiredTokens - the listing's required held tokens to allow transacting.
     * @param signature - the signature that will verify all of the listing data.
     */
    function transactNFT(
        bytes32 listingId,
        bytes32 transactionId,
        address[] calldata tokenAddresses,
        uint256[] calldata tokenIds,
        uint256 priceETH,
        uint256 priceROOLAH,
        uint256 expires,
        address[] memory requiredTokens,
        bytes memory signature
    ) external payable {
        require(expires > block.timestamp, "Signature expired");
        require(tokenIds.length == tokenAddresses.length, "Length mismatch");

        require(
            _verifySignatureNFT(
                listingId,
                transactionId,
                priceETH,
                priceROOLAH,
                expires,
                requiredTokens,
                tokenAddresses,
                tokenIds,
                signature
            ),
            "Invalid signature"
        );

        require(
            requiredTokens.length == 0 ||
                _holdsToken(msg.sender, requiredTokens),
            "Not a holder"
        );

        if (priceETH > 0) {
            require(msg.value == priceETH, "Bad value");
            (bool success, ) = etherRecipient.call{value: priceETH}("");
            require(success, "ETH tx failed");
        }

        userPurchases[listingId][msg.sender] += 1;
        unitsSold[listingId] += 1;

        if (priceROOLAH > 0)
            roolahContract.transferFrom(msg.sender, address(this), priceROOLAH);

        for (uint256 i; i < tokenIds.length; i++) {
            IERC721(tokenAddresses[i]).safeTransferFrom(
                address(this),
                msg.sender,
                tokenIds[i]
            );
        }

        emit TransactionPosted(listingId, transactionId, msg.sender, 1);
    }

    // -------------------------------- OWNER ONLY V1 ----------------------------------

    /**
     * Updates pointers to the ROOLAH contract and RooTroop NFT contract.
     * @dev owner only.
     *
     * @param rooTroopNFT - the address of the RooTroop NFT contract.
     * @param roolah - the address of the ROOLAH contract.
     */
    function updateDependencies(address rooTroopNFT, address roolah)
        public
        onlyOwner
    {
        _updateDependencies(rooTroopNFT, roolah);
    }

    /**
     * Updates the conversion rate when burning a RooTroop NFT for ROOLAH.
     * @dev owner only.
     *
     * @param rate - the value in ROOLAH received for burning one RooTroop NFT.
     */
    function setRooToRoolahConversionRate(uint256 rate) public onlyOwner {
        _setRooToRoolahConversionRate(rate);
    }

    /**
     * Updates the message signer.
     * @dev owner only.
     *
     * @param signer - the new backend message signer.
     */
    function setMessageSigner(address signer) public onlyOwner {
        _setMessageSigner(signer);
    }

    /**
     * Updates the address that receives ETH transferred into the contract.
     * @dev owner only.
     *
     * @param receiver - the new receiver address.
     */
    function setEtherReceiver(address receiver) public onlyOwner {
        _setEtherReceiver(receiver);
    }

    /**
     * Removes the given amount of ROOLAH from the contract.
     * @dev owner only.
     *
     * @param to - the address to send the ROOLAH to.
     * @param amount - the amount of ROOLAH to send.
     */
    function withdrawRoolah(address to, uint256 amount) public onlyOwner {
        roolahContract.transfer(to, amount);
    }

    /**
     * Retrieves an NFT from the contract vault
     *
     * @param token - the token address
     * @param tokenId - the token id
     */
    function retrieveNFT(
        address token,
        uint256 tokenId,
        address to
    ) public onlyOwner {
        IERC721(token).transferFrom(address(this), to, tokenId);
    }

    // --------------------------------- INTERNAL V1 ------------------------------------

    function _updateDependencies(address rooTroopNFT, address roolah) internal {
        roolahContract = IERC20(roolah);
        rooTroopContract = IBurnableERC721(rooTroopNFT);
    }

    function _setRooToRoolahConversionRate(uint256 rate) internal {
        rooToRoolahConversion = rate;
    }

    function _setMessageSigner(address signer) internal {
        messageSigner = signer;
    }

    function _setEtherReceiver(address receiver) internal {
        etherRecipient = receiver;
    }

    function _holdsToken(address user, address[] memory tokens)
        internal
        view
        returns (bool)
    {
        for (uint256 i; i < tokens.length; i++) {
            if (IERC20(tokens[i]).balanceOf(user) > 0) return true;
        }

        return false;
    }

    function _verifySignature(
        bytes32 listingId,
        bytes32 transactionId,
        uint256 maxPerUser,
        uint256 supply,
        uint256 priceETH,
        uint256 priceROOLAH,
        uint256 expires,
        address[] calldata requiredTokens,
        bytes memory signature
    ) internal view returns (bool) {
        bytes memory packed = abi.encodePacked(
            listingId,
            transactionId,
            maxPerUser,
            supply,
            priceETH,
            priceROOLAH,
            expires
        );

        for (uint256 i; i < requiredTokens.length; i++) {
            packed = abi.encodePacked(packed, requiredTokens[i]);
        }

        bytes32 messageHash = keccak256(packed);

        return verify(messageSigner, messageHash, signature);
    }

    function _verifySignatureNFT(
        bytes32 listingId,
        bytes32 transactionId,
        uint256 priceETH,
        uint256 priceROOLAH,
        uint256 expires,
        address[] memory requiredTokens,
        address[] calldata tokenAddresses,
        uint256[] calldata tokenIds,
        bytes memory signature
    ) internal view returns (bool) {
        bytes memory packed = abi.encodePacked(
            listingId,
            transactionId,
            priceETH,
            priceROOLAH,
            expires
        );

        uint256 i;
        for (i; i < tokenIds.length; i++) {
            packed = abi.encodePacked(packed, tokenAddresses[i], tokenIds[i]);
        }
        for (i = 0; i < requiredTokens.length; i++) {
            packed = abi.encodePacked(packed, requiredTokens[i]);
        }

        bytes32 messageHash = keccak256(packed);

        return verify(messageSigner, messageHash, signature);
    }

    // ------------------------------- OWNER ONLY V2 ----------------------------------------

    /**
     * Forwards a call to a specified contract address, targeting the given function
     * with the provided abi encoded parameters.
     *
     * This will allow the market to mint directly from projects, etc. (essentially, allows the contract to behave like a wallet)
     *
     * @param contractAt - the address of the target contract
     * @param encodedCall - the ABI encoded function call (use web3.eth.abi.encodeFunctionCall)
     */
    function externalCall(address contractAt, bytes calldata encodedCall)
        external
        payable
        onlyOwner
        returns (bytes memory)
    {
        (bool success, bytes memory data) = contractAt.call{
            value: msg.value,
            gas: gasleft()
        }(encodedCall);

        if (success == false) {
            assembly {
                let ptr := mload(0x40)
                let size := returndatasize()
                returndatacopy(ptr, 0, size)
                revert(ptr, size)
            }
        }

        return data;
    }

    /**
     * Pulls in a bunch of ERC721 tokens that the contract has
     * been approved to access. Feeds from multiple source contracts.
     *
     * @param from - the current holder
     * @param tokens - the token contract addresses
     * @param tokenIds - the token ids (parallel to addresses)
     */
    function importBulkERC721MultiAddress(
        address from,
        address[] calldata tokens,
        uint256[] calldata tokenIds
    ) external onlyOwner {
        require(tokens.length == tokenIds.length, "length mismatch");

        for (uint256 i; i < tokens.length; i++) {
            IERC721(tokens[i]).transferFrom(from, address(this), tokenIds[i]);
        }
    }

    /**
     * Pulls in a bunch of ERC721 tokens that the contract has
     * been approved to access. Feeds from ONE source contract.
     *
     * @param from - the current holder
     * @param token - the token contract address
     * @param tokenIds - the token ids (parallel to addresses)
     */
    function importBulkERC721(
        address from,
        address token,
        uint256[] calldata tokenIds
    ) external onlyOwner {
        IERC721 source = IERC721(token);
        for (uint256 i; i < tokenIds.length; i++) {
            source.transferFrom(from, address(this), tokenIds[i]);
        }
    }
}
