// SPDX-License-Identifier: MIT

/*
  _               _                              
 | |             | |                             
 | |__  _ __ ___ | | _____   _ __   __ _ ___ ___ 
 | '_ \| '__/ _ \| |/ / _ \ | '_ \ / _` / __/ __|
 | |_) | | | (_) |   <  __/_| |_) | (_| \__ \__ \
 |_.__/|_|  \___/|_|\_\___(_) .__/ \__,_|___/___/
                            | |                  
                            |_|                  

*/

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error HadClaimed();
error OutofMaxSupply();

contract brokepass is ERC721A, Ownable {

    mapping(address => bool) public claimed;

    bool freeMintActive = false;

    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public cost = 0.0069 ether;

    string public baseUrl = "ipfs://QmSy9xhACHXCVSVPJQ5qkobk5V8RSjkhmhAL7UhAY7eMhe";

    constructor() ERC721A("broke.pass", "bp") {}

    function freeMint(uint256 _amount) external payable {
        require(freeMintActive, "Free mint closed");
        if(totalSupply() + _amount > MAX_SUPPLY) revert OutofMaxSupply();
    
        if(claimed[msg.sender]) {
            require(msg.value >= _amount * cost, "Insufficient funds");
        } else {
            require(msg.value >= (_amount - 1) * cost, "Insufficient funds");
        }

        claimed[msg.sender] = true;
        _safeMint(msg.sender, _amount);
    }

    function revive() external payable {
        require(!freeMintActive, "Free mint is open");
        require(msg.value >= cost, "Insufficient funds");
        if(totalSupply() + 1 > MAX_SUPPLY) revert OutofMaxSupply();
        _safeMint(msg.sender, 1);
    }
    
    function ownerBatchMint(uint256 amount) external onlyOwner {
        if(totalSupply() + amount > MAX_SUPPLY) revert OutofMaxSupply();
        _safeMint(msg.sender, amount);
    }

    function batchBurn(uint256[] memory tokenids) external onlyOwner {
        uint256 len = tokenids.length;
        for (uint256 i; i < len; i++) {
            _burn(tokenids[i]);
        }
    }

    function toggleFreeMint(bool _state) external onlyOwner {
        freeMintActive = _state;
    }

    function withdraw() external onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}('');
        require(os);
    }

    function setBaseURI(string memory url) external onlyOwner {
        baseUrl = url;
    }

    function setCost(uint256 _cost) external onlyOwner {
        cost = _cost;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        string memory currentBaseURI = _baseURI();
        return currentBaseURI;
    }

   function _baseURI() internal view virtual override returns (string memory) {
        return baseUrl;
    }
}