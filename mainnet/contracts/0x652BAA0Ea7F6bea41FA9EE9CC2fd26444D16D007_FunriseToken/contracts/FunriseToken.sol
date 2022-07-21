pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract FunriseToken is ERC20PresetFixedSupply {
    constructor(address owner) ERC20PresetFixedSupply(
        "Funrise",
        "FRN",
        50000000*10**18,
        owner
    ) {}
}