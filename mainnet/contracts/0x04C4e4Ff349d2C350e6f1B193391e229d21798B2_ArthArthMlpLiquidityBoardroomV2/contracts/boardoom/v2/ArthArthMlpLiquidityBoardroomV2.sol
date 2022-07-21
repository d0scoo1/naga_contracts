// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Vault} from '../core/Vault.sol';
import {IERC20} from '@openzeppelin/contracts/contracts/token/ERC20/IERC20.sol';
import {VestedVaultBoardroom} from '../core/VestedVaultBoardroom.sol';

contract ArthArthMlpLiquidityBoardroomV2 is VestedVaultBoardroom {
    constructor(
        IERC20 cash_,
        Vault arthMlpVault_,
        uint256 vestFor_
    ) VestedVaultBoardroom(cash_, arthMlpVault_, vestFor_) {}
}
