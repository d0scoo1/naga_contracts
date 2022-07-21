// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Ariadne is ERC20 {
  constructor() ERC20("Ariadne", "ARDN") {
    _mint(msg.sender, 25000000 * 1e18);
  }
}
