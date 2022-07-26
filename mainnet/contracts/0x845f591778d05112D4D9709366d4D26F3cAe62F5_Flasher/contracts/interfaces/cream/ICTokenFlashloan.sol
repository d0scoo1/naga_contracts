// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ICTokenFlashloan {
  function flashLoan(
    address receiver,
    uint256 amount,
    bytes calldata params
  ) external;
}
