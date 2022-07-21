// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

error NotApprovedMinter();


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RyoToken is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("Ryo", "RYO") {}

    mapping(address => bool) public approvedMinter;

    
    

    function mint(address to, uint256 amount) public {
        if(!approvedMinter[msg.sender]) revert NotApprovedMinter();
        _mint(to, amount);
    }

    function approveMinter(address _address) public onlyOwner{
        approvedMinter[_address] = true;
    }
    
    function unapproveMinter(address _address) public onlyOwner{
        approvedMinter[_address] = false;
    }

    
}