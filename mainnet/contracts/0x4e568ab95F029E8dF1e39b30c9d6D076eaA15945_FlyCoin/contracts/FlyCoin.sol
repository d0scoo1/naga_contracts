// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

//import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
//import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract FlyCoin is ERC20, ERC20Burnable {
    constructor() ERC20("FlyCoin", "FLY") {
        _mint(msg.sender, 100000000000 * 10 ** decimals()); // 18 decimal places, the default.
    }

}
