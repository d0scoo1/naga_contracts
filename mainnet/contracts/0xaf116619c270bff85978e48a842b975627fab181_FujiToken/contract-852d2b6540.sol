// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.2.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.2.0/token/ERC20/extensions/ERC20Burnable.sol";

contract FujiToken is ERC20, ERC20Burnable {
    constructor(address to) ERC20("36 BLOCKS OF FUJI", "FUJI") {
        _mint(to, 37760000 * 10 ** decimals());
    }
}
