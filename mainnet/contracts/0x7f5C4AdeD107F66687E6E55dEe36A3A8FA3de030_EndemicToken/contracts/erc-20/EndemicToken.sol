// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract EndemicToken is ERC20PresetFixedSupply {
    constructor(address owner)
        ERC20PresetFixedSupply(
            "Endemic",
            "END",
            50000000 * 10**decimals(),
            owner
        )
    {}
}
