// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract VoltToken is ERC20PresetFixedSupply {
    constructor() ERC20PresetFixedSupply("Volt", "VOLT", 1000000 * 10 ** 18, msg.sender) {
    }
}
