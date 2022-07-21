// SPDX-License-Identifier: ISC
pragma solidity 0.7.5;
pragma abicoder v2;

import "./pool/IUniswapV3PoolImmutables.sol";
import "./pool/IUniswapV3PoolState.sol";

/// @title The interface for a Uniswap V3 Pool
/// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
/// to the ERC20 specification
/// @dev The pool interface is broken up into many smaller pieces
// solhint-disable-next-line no-empty-blocks
interface IUniswapV3Pool is IUniswapV3PoolImmutables, IUniswapV3PoolState {

}
