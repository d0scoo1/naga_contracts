// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.11;

import { AccessControl } from "./AccessControl.sol";

/// @title StakeOpsController
/// 3 roles are defined:
/// STAKE_OPS_ADMIN_ROLE: Accounts with this role have unrestricted execution permissions to all protected functions.
/// BALANCE_UPDATER_ROLE:  Accounts with this role have execution permissions over unlockStake function which applies rewards
/// PAUSER_ROLE: Accounts with this role can Pause or UnPause (see Pausable.sol) the PowerLedgerStakingV1 contract
/// STAKE_OPS_ADMIN_ROLE can be PAUSER_ROLE, but not BALANCE_UPDATER_ROLE
/// PAUSER_ROLE and BALANCE_UPDATER_ROLE must be different
contract StakeOpsController is AccessControl {

    bytes32 public constant STAKE_OPS_ADMIN_ROLE = keccak256("STAKE_OPS_ADMIN_ROLE");
    bytes32 public constant BALANCE_UPDATER_ROLE = keccak256("BALANCE_UPDATER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    /// @dev Construction of this contract requires the .
    /// @param _stakeOpsAdmin Admin account. Has all 3 permissions.
    /// @param _balanceUpdater Updater account. Can only execute stats update functionality
    /// @param _pauser Pauser account. Can only pause / unpause the contract.
    constructor(
        address _stakeOpsAdmin,
        address _balanceUpdater,
        address _pauser) {

        require(_stakeOpsAdmin != _balanceUpdater, "StakeOpsController: Accounts must be different");
        require(_balanceUpdater != _pauser, "StakeOpsController: Accounts must be different");

        _setRoleAdmin(STAKE_OPS_ADMIN_ROLE, STAKE_OPS_ADMIN_ROLE);
        _setRoleAdmin(BALANCE_UPDATER_ROLE, STAKE_OPS_ADMIN_ROLE);
        _setRoleAdmin(PAUSER_ROLE, STAKE_OPS_ADMIN_ROLE);

        _setupRole(STAKE_OPS_ADMIN_ROLE, _stakeOpsAdmin);
        _setupRole(BALANCE_UPDATER_ROLE, _stakeOpsAdmin);
        _setupRole(PAUSER_ROLE, _stakeOpsAdmin);

        _setupRole(BALANCE_UPDATER_ROLE, _balanceUpdater);
        _setupRole(PAUSER_ROLE, _pauser);
    }

    /// @dev Modifier to make a function callable only by a certain role. In
    /// addition to checking the sender's role, `address(0)` 's role is also
    /// considered. Granting a role to `address(0)` is equivalent to enabling
    /// this role for everyone.
    modifier onlyRole(bytes32 role) override {
        require(hasRole(role, _msgSender()) || hasRole(role, address(0)), "StakeOpsController: sender requires permission");
        _;
    }
}
