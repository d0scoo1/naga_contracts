// SPDX-License-Identifier: MIT
pragma solidity ^0.5.5;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract CybershinuToken is ERC20, ERC20Detailed {
  constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20Detailed(name, symbol, 18) public {
    _mint(msg.sender, initialSupply);
  }
}
