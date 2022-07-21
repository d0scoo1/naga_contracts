// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";

contract OneProtocol is ERC20 {
  constructor(string memory name, string memory symbol, uint256 supply) ERC20(name, symbol) {
    _mint(msg.sender, supply);
  }
}