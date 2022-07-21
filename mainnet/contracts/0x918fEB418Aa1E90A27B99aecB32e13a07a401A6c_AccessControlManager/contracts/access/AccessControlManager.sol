// SPDX-License-Identifier: MIT
pragma solidity =0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./AllowListAccessControl.sol";
import "../vaults/roles/Governable.sol";
import "../interfaces/IAccessControlManager.sol";

/// @notice This contract will keep an registry for the access control policies that have been added, and check to see if any of them will allow a user to access to a particular vault.
///  A vault can either be a SingleAssetVault, or the staking contract.
contract AccessControlManager is IAccessControlManager, Governable {
  /// @notice Emitted when a new policy is added
  event AccessControlPolicyAdded(address indexed _policy);
  /// @notice Emitted when a new policy is removed
  event AccessControlPolicyRemoved(address indexed _policy);
  // Add the library methods
  using EnumerableSet for EnumerableSet.AddressSet;
  // internal registry for all the enabled policies
  EnumerableSet.AddressSet internal accessControlPolicies;

  // solhint-disable-next-line no-empty-blocks
  constructor(address _governance, address[] memory _policies) Governable(_governance) {
    _addAccessControlPolicys(_policies);
  }

  /// @notice Enable the given access control policies. Can only be set by the governance
  /// @param _policies The address of the access control policies
  function addAccessControlPolicies(address[] calldata _policies) external onlyGovernance {
    _addAccessControlPolicys(_policies);
  }

  /// @notice Disable the given access control policies. Can only be set by the governance
  /// @param _policies The address of the access control policies
  function removeAccessControlPolicies(address[] calldata _policies) external onlyGovernance {
    _removeAccessControlPolicys(_policies);
  }

  /// @notice Returns the current enabled access control policies
  /// @return the addresses of enabled access control policies
  function getAccessControlPolicies() external view returns (address[] memory) {
    return accessControlPolicies.values();
  }

  /// @notice Check if the given user has access to the given vault based on the current access control policies.
  /// @param _user the user address
  /// @param _vault the vault address. Can either be a SingleAssetVault or staking contract
  /// @return will return true if any of the current policies allows access
  function hasAccess(address _user, address _vault) external view returns (bool) {
    return _hasAccess(_user, _vault);
  }

  // Had to use memory here instead of calldata as the function is
  // used in the constructor
  function _addAccessControlPolicys(address[] memory _policies) internal {
    for (uint256 i = 0; i < _policies.length; i++) {
      if (_policies[i] != address(0)) {
        bool added = accessControlPolicies.add(_policies[i]);
        if (added) {
          emit AccessControlPolicyAdded(_policies[i]);
        }
      }
    }
  }

  function _removeAccessControlPolicys(address[] memory _policies) internal {
    for (uint256 i = 0; i < _policies.length; i++) {
      if (_policies[i] != address(0)) {
        bool removed = accessControlPolicies.remove(_policies[i]);
        if (removed) {
          emit AccessControlPolicyRemoved(_policies[i]);
        }
      }
    }
  }

  function _hasAccess(address _user, address _vault) internal view returns (bool) {
    require(_vault != address(0), "invalid vault address");
    require(_user != address(0), "invalid user address");
    // disable access if no policies are set
    if (accessControlPolicies.length() == 0) {
      return false;
    }
    bool userHasAccess = false;
    for (uint256 i = 0; i < accessControlPolicies.length(); i++) {
      if (IAccessControlPolicy(accessControlPolicies.at(i)).hasAccess(_user, _vault)) {
        userHasAccess = true;
        break;
      }
    }
    return userHasAccess;
  }
}
