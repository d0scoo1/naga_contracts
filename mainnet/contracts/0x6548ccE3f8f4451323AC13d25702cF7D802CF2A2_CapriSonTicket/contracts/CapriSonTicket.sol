// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

contract CapriSonTicket is ERC1155, Ownable, ERC1155Burnable {
    uint256 public constant VIP = 1;
    uint256 public constant PRESS = 2;

    mapping(address => bool) _allowedMintingAddresses;

    constructor() ERC1155("http://releaseday.tv/tickets/{id}.json") {}

    function setURI(string memory uri) 
        public 
        onlyOwner 
    {
        _setURI(uri);
    }

    function mint(address account, uint256 id, uint256 amount)
        public
    {
        require(_allowedMintingAddresses[msg.sender], "Minting forbidden.");
        _mint(account, id, amount, "");
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, "");
    }

    function setAllowedMintingAddressState(address allowedMintingAddress, bool state)
        public
        onlyOwner
    {
        _allowedMintingAddresses[allowedMintingAddress] = state;
    }

    function withdraw() 
        public 
        onlyOwner 
    {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "CapriSonTicket: Withdraw failed.");
    }
}