// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/// @custom:security-contact connect@fint.finance
contract FINT is ERC20, ERC20Burnable {
    constructor() ERC20("FINT Token", "FINT") {
        _mint(msg.sender, 300000000 * 10**decimals());
    }
}
