// SPDX-License-Identifier: MIT OR Apache-2.0

pragma solidity ^0.8.0;

import "../../interfaces/IAdminRole.sol";

import "../FoundationTreasuryNode.sol";

/**
 * @notice Allows a contract to leverage the admin role defined by the Foundation treasury.
 */
abstract contract FoundationAdminRole is FoundationTreasuryNode {
  // This file uses 0 data slots (other than what's included via FoundationTreasuryNode)

  modifier onlyFoundationAdmin() {
    require(isAdmin(msg.sender), "FoundationAdminRole: caller does not have the Admin role");
    _;
  }

  /**
   * @notice Returns true if the user is a Foundation admin.
   * @dev This API may be consumed by 3rd party contracts.
   */
  function isAdmin(address user) public view returns (bool) {
    return IAdminRole(getFoundationTreasury()).isAdmin(user);
  }
}
