// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "erc721a@3.3.0/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

interface OpenSea {
    function proxies(address) external view returns (address);
}

contract BullApePlanet is ERC721A("BullApePlanet", "BAP"), Ownable, ERC2981 {
    using Strings for uint256;

    bool public revealed = false;
    string public notRevealedMetadataFolderIpfsLink;
    uint256 public maxMintAmount = 4;
    uint256 public maxSupply = 6969;
    uint256 public costPerNft = 0.2 * 1e18;
    uint256 public nftsForOwner = 100;
    string public metadataFolderIpfsLink;
    string constant baseExtension = ".json";
    uint256 public publicmintActiveTime = 1654542000;

    constructor() {
        _setDefaultRoyalty(msg.sender, 10_00); // 10.00 %
    }

    // public
    function purchaseTokens(uint256 _mintAmount) public payable {
        require(block.timestamp > publicmintActiveTime, "the contract is paused");
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
        require(supply + _mintAmount + nftsForOwner <= maxSupply, "max NFT limit exceeded");
        require(msg.value >= costPerNft * _mintAmount, "insufficient funds");

        _safeMint(msg.sender, _mintAmount);
    }

    ///////////////////////////////////
    //       OVERRIDE CODE STARTS    //
    ///////////////////////////////////

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return metadataFolderIpfsLink;
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721A) returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        if (revealed == false) return notRevealedMetadataFolderIpfsLink;

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
    }

    //////////////////
    //  ONLY OWNER  //
    //////////////////

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner {
        nftsForOwner -= _sendNftsTo.length * _howMany;

        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    function revealFlip() public onlyOwner {
        revealed = !revealed;
    }

    function setCostPerNft(uint256 _newCostPerNft) public onlyOwner {
        costPerNft = _newCostPerNft;
    }

    function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    function setMetadataFolderIpfsLink(string memory _newMetadataFolderIpfsLink) public onlyOwner {
        metadataFolderIpfsLink = _newMetadataFolderIpfsLink;
    }

    function setNotRevealedMetadataFolderIpfsLink(string memory _notRevealedMetadataFolderIpfsLink) public onlyOwner {
        notRevealedMetadataFolderIpfsLink = _notRevealedMetadataFolderIpfsLink;
    }

    function setSaleActiveTime(uint256 _publicmintActiveTime) public onlyOwner {
        publicmintActiveTime = _publicmintActiveTime;
    }
}

contract BullApePlanetContract is BullApePlanet {}
