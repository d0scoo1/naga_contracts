// SPDX-License-Identifier: MIT LICENSE 

pragma solidity ^0.8.0;

interface IStaking {
  function addManyToStaking(address account, uint16[] calldata tokenIds) external;
}
