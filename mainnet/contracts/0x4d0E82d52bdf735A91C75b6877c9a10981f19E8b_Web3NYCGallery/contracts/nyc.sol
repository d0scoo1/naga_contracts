// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Web3NYCGallery is
    ERC721,
    AccessControl
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    string public baseUri = "https://mint.web3nycgallery.com/token/";
    string public endingUri = ".json";
    uint256 public totalSupply = 0;

    constructor () ERC721("Web3NYCGallery", "WEB3NYC") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    receive() external payable {}
    
    function withdraw() public onlyRole(DEFAULT_ADMIN_ROLE)  {
        payable(msg.sender).transfer(address(this).balance);
    }

    function setBaseURI(string memory _URI) external onlyRole(DEFAULT_ADMIN_ROLE) {
        baseUri = _URI;
    }

    function setEndingURI(string memory _URI) external onlyRole(DEFAULT_ADMIN_ROLE) {
        endingUri = _URI;
    }

    function mint(address _to, uint256 tokenId) external onlyRole(MINTER_ROLE){
        totalSupply++;
        _mint(_to, tokenId);
    }

    function multiMint(address _to, uint256[] memory tokenIds) external onlyRole(MINTER_ROLE){
        uint256 amount = tokenIds.length;
        totalSupply = totalSupply + amount;
        for (uint i = 0; i < amount; i++) {
            _mint(_to, tokenIds[i]);
        }
    }

    function tokenURI(uint256 tokenId) public view  virtual override returns (string memory) {
        return string(abi.encodePacked(super.tokenURI(tokenId), endingUri));
    }

    function _baseURI() internal view override(ERC721) returns (string memory) {
        return baseUri;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}