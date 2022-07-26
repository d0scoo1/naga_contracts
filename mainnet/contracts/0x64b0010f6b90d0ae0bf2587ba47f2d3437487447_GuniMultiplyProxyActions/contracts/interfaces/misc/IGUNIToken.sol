// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "./../IERC20.sol";

abstract contract IGUNIToken is IERC20 {
  function mint(uint256 mintAmount, address receiver)
    public virtual
    returns (
      uint256 amount0,
      uint256 amount1,
      uint128 liquidityMinted
    );

  function burn(uint256 burnAmount, address receiver)
    public virtual
    returns (
      uint256 amount0,
      uint256 amount1,
      uint128 liquidityBurned
    );

  function getMintAmounts(uint256 amount0Max, uint256 amount1Max)
    public virtual
    view
    returns (
      uint256 amount0,
      uint256 amount1,
      uint256 mintAmount
    );

  function token0() public virtual view returns (address);

  function token1() public virtual view returns (address);

  function pool() public virtual view returns (address);

  function getUnderlyingBalances() public virtual view returns (uint256, uint256);
}