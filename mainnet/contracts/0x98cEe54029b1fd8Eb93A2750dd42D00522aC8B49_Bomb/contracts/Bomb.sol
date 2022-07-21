//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Bomb is ERC20, ERC20Burnable {
    constructor(uint256 initialSupply) ERC20("Osama Bin Santa", "BOMB") {
        _mint(msg.sender, initialSupply);
    }
}
