// SPDX-License-Identifier: Unlicense

pragma solidity 0.7.6;

import "./IICHIVault.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IVault is IICHIVault, IERC20 {}
