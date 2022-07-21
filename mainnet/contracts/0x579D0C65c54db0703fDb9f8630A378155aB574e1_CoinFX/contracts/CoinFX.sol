//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract CoinFX is ERC20PresetMinterPauser {
    constructor() ERC20PresetMinterPauser("CoinFX", "FXR") {}
}
