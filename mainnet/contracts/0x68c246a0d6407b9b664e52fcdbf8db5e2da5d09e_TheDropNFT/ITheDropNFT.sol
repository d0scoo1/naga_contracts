// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ITheDropNFT {
    event TokenCreated(uint256 indexed tokenId, string url, address indexed owner);
    
    function baseURI() external view returns (string memory);
    function exists(uint256 tokenId) external view returns (bool);
    function burn(uint256 tokenId) external;
    function tokenSellRate(uint256 tokenId) external view returns (uint256);
    function uriOriginalToken(string memory _uri) external view returns (uint256);
    function creatorOf(uint256 _tokenId) external view returns (address);
    function createToken(uint256 _id, string memory _uri, uint256 _sellRate) external  returns (uint256);
    function createTokenFor(uint256 _id, string memory _uri, address _creator, address _buyer, uint256 _sellRate) external;
    function createTokenForEdition(uint256 _id, string memory _uri, address _creator, address _buyer, bool _isOriginal, uint256 _sellRate) external;
}