// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.4.2/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@4.4.2/token/ERC20/extensions/draft-ERC20Permit.sol";

contract MemeVerse is ERC20, ERC20Burnable, ERC20Permit {
    constructor() ERC20("MemeVerse", "MEV") ERC20Permit("MemeVerse") {
        _mint(msg.sender, 10000000000 * 10 ** decimals());
    }
}
