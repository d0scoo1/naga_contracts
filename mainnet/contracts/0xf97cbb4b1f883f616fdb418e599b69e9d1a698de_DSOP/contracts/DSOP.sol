// d8888b. .d8888.  .d88b.  d8888b.
// 88  `8D 88'  YP .8P  Y8. 88  `8D
// 88   88 `8bo.   88    88 88oodD'
// 88   88   `Y8b. 88    88 88~~~'
// 88  .8D db   8D `8b  d8' 88
// Y8888D' `8888Y'  `Y88P'  88

// Website:    https://dsopnft.com/
// OpenSea:    https://opensea.io/collection/dsop
// Discord:    https://discord.com/invite/seriesofpoker
// Instagram:  https://www.instagram.com/decentralandseriesofpoker/
// Twitter:    https://twitter.com/DSOP_NFT

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";

interface OpenSea {
    function proxies(address) external view returns (address);
}

contract DSOP is ERC721A("Decentraland Series Of Poker", "DSOP"), ERC721ABurnable, ERC2981, Ownable {
    uint256 saleActiveTime = 1648036800; // Saturday, March 23, 2022 11:00:00 PM French Timezone GMT + 1

    uint256 constant maxSupply = 5304;
    uint256 mintableSupply = 5000;
    uint256 itemPrice = 0.15 ether;
    string baseURI = "ipfs://QmSkn6CzKA1LDy7jYVzuRJimKhi8X9EtDRfubnRKVdJZjN/";

    constructor() {
        _setDefaultRoyalty(msg.sender, 10_00); // 10.00%
    }

    /// @notice Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany) external payable {
        _safeMint(msg.sender, _howMany);

        require(totalSupply() <= mintableSupply, "Try mint less");
        require(tx.origin == msg.sender, "The caller is a contract");
        require(_howMany >= 1 && _howMany <= 50, "Mint min 1, max 50");
        require(block.timestamp > saleActiveTime, "Sale is not active");
        require(msg.value >= _howMany * itemPrice, "Try to send more ETH");
    }

    /// @notice Owner can withdraw from here
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    /// @notice Change price in case of ETH price changes too much
    function setPrice(uint256 _newPrice) external onlyOwner {
        itemPrice = _newPrice;
    }

    /// @notice set sale active time
    function setSaleActiveTime(uint256 _saleActiveTime) external onlyOwner {
        saleActiveTime = _saleActiveTime;
    }

    /// @notice set mintableSupply
    function setMintableSupply(uint256 _mintableSupply) external onlyOwner {
        require(_mintableSupply <= maxSupply, "put a number less than max supply");
        mintableSupply = _mintableSupply;
    }

    /// @notice Hide identity or show identity from here, put images folder here, ipfs folder cid
    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    /// @notice Send NFTs to a list of addresses
    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner {
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
        require(totalSupply() <= maxSupply, "Try minting less");
    }

    ////////////////////
    // HELPER METHOD  //
    ////////////////////

    /// @notice get all nfts of a person
    function walletOfOwner(address _owner) external view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        return tokenIds;
    }

    function tokenOfOwnerByIndex(address _owner, uint256 index) public view returns (uint256) {
        if (index >= balanceOf(_owner)) revert();
        uint256 numMintedSoFar = _currentIndex;
        uint256 tokenIdsIdx;
        address currOwnershipAddr;
        unchecked {
            for (uint256 i; i < numMintedSoFar; i++) {
                TokenOwnership memory ownership = _ownerships[i];
                if (ownership.burned) continue;
                if (ownership.addr != address(0)) currOwnershipAddr = ownership.addr;
                if (currOwnershipAddr == _owner) {
                    if (tokenIdsIdx == index) return i;
                    tokenIdsIdx++;
                }
            }
        }
        revert();
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721A, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function burn(uint256 tokenId) public override {
        super._burn(tokenId);
        _resetTokenRoyalty(tokenId);
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    function receiveCoin() external payable {}

    receive() external payable {}

    ///////////////////////////////
    // AUTO APPROVE MARKETPLACES //
    ///////////////////////////////

    mapping(address => bool) projectProxy;

    function flipProxyState(address proxyAddress) external onlyOwner {
        projectProxy[proxyAddress] = !projectProxy[proxyAddress];
    }

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        return
            projectProxy[_operator] || // Auto Approve any Marketplace,
                _operator == OpenSea(0xa5409ec958C83C3f309868babACA7c86DCB077c1).proxies(_owner) ||
                _operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354 || // Looksrare
                _operator == 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e || // Rarible
                _operator == 0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be // X2Y2
                ? true
                : super.isApprovedForAll(_owner, _operator);
    }

    ///////////////////
    // DSOP Presale  //
    ///////////////////

    uint256 presaleActiveTime = 1647691200; // Saturday, March 19, 2022 11:00:00 PM French Timezone GMT + 1
    uint256 itemPricePresale = 0.1 ether;
    bytes32 whitelistMerkleRoot;

    function purchaseTokensPresale(uint256 _howMany, bytes32[] calldata _proof) external payable {
        _safeMint(msg.sender, _howMany);

        require(totalSupply() <= mintableSupply, "Try mint less");
        require(tx.origin == msg.sender, "The caller is a contract");
        require(_howMany >= 1 && _howMany <= 50, "Mint min 1, max 50");
        require(inWhitelist(msg.sender, _proof), "You are not in presale");
        require(block.timestamp > presaleActiveTime, "Presale is not active");
        require(msg.value >= _howMany * itemPricePresale, "Try to send more ETH");
    }

    function inWhitelist(address _owner, bytes32[] memory _proof) public view returns (bool) {
        return MerkleProof.verify(_proof, whitelistMerkleRoot, keccak256(abi.encodePacked(_owner)));
    }

    function setPresaleActiveTime(uint256 _presaleActiveTime) external onlyOwner {
        presaleActiveTime = _presaleActiveTime;
    }

    function setPresaleItemPrice(uint256 _itemPricePresale) external onlyOwner {
        itemPricePresale = _itemPricePresale;
    }

    function setWhitelist(bytes32 _whitelistMerkleRoot) external onlyOwner {
        whitelistMerkleRoot = _whitelistMerkleRoot;
    }
}
