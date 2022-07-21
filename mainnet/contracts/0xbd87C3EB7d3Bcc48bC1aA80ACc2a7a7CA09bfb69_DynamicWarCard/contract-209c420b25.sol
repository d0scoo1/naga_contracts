// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";

contract DynamicWarCard is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    bool warEnded = false;

    constructor() ERC721("War Cards", "DWC") {}

    function safeMint(address to, uint256 tokenId, string memory uri)
        public
        onlyOwner
    {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.
    
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function isWarEnded() public view returns (bool) {
        return warEnded;
    }

    function setWarEnd() public onlyOwner{
        warEnded = true;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
    function changeURI (string memory newTokenURI,uint256 tokenId) public onlyOwner{ 
        require(isWarEnded() == false);
        _setTokenURI(tokenId, newTokenURI);
    }
    
}
