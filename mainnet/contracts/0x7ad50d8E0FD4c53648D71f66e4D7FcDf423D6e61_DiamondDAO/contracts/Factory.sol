//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "@openzeppelin/contracts/token/ERC20/utils/TokenTimelock.sol";

contract DiamondDAO is ERC20PresetMinterPauser {
    constructor() ERC20PresetMinterPauser("DiamondDAO", "DMND") {

    }
}

