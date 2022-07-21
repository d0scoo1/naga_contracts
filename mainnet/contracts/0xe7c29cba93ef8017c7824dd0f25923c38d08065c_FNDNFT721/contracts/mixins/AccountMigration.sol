// SPDX-License-Identifier: MIT OR Apache-2.0

pragma solidity ^0.8.0;

import "../libraries/AccountMigrationLibrary.sol";
import "./roles/FoundationOperatorRole.sol";

abstract contract AccountMigration is FoundationOperatorRole {
  using AccountMigrationLibrary for address;

  modifier onlyAuthorizedAccountMigration(
    address originalAddress,
    address payable newAddress,
    bytes memory signature
  ) {
    require(_isFoundationOperator(), "AccountMigration: Caller is not an operator");
    originalAddress.requireAuthorizedAccountMigration(newAddress, signature);
    _;
  }
}
