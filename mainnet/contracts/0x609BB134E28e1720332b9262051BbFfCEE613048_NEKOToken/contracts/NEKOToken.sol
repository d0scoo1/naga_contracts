// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NEKOToken is ERC20 {

    constructor() ERC20("NekoChanFeedToken", "NCFT") {
        _mint(msg.sender, 3 * 10**7 * 10**18);
    }
}