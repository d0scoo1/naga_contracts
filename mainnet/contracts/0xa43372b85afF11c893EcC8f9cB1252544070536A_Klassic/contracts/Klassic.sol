// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Klassic is ERC20 {
    constructor(uint256 _supply) ERC20("Klassic", "KLS") {
        _mint(msg.sender, _supply * (10 ** decimals()));
    }
}
