// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DreamNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address[] public whitelists;
    mapping(address => bool) public whitelisted;

    constructor() ERC721("DreamNFT", "DNFT") {
        whitelisted[msg.sender] = true;
        whitelists.push(msg.sender);
    }

    struct Item {
        address minter;
        string uri;
    }

    mapping(uint256 => Item) public Items;

    function createItem(string memory uri) public returns (uint256) {
        require(whitelisted[msg.sender] == true, "Only whitelisted users can create items");
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        Items[newItemId] = Item(msg.sender, uri);
        return newItemId;
    }

    function minter(uint256 tokenId)
        public
        view
        returns (address)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: minter query for nonexistent token"
        );
        return Items[tokenId].minter;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return Items[tokenId].uri;
    }
    // add user's address to whitelist
    function addWhitelistUser(address[] memory _user) public onlyOwner {
        for(uint256 idx = 0; idx < _user.length; idx++) {
            require(whitelisted[_user[idx]] == false, "already set");
            whitelisted[_user[idx]] = true;
            whitelists.push(_user[idx]);
        }
    }

    // remove user's address to whitelist
    function removeWhitelistUser(address[] memory _user) public onlyOwner {
        for(uint256 idx = 0; idx < _user.length; idx++) {
            require(whitelisted[_user[idx]] == true, "not exist");
            whitelisted[_user[idx]] = false;
            removeWhitelistByValue(_user[idx]);
        }
    }

    function removeWhitelistByValue(address value) internal{
        uint i = 0;
        while (whitelists[i] != value) {
            i++;
        }
        removeWhitelistByIndex(i);
    }    

    function removeWhitelistByIndex(uint i) internal{
        while (i<whitelists.length-1) {
            whitelists[i] = whitelists[i+1];
            i++;
        }
        whitelists.pop();        
    }
}