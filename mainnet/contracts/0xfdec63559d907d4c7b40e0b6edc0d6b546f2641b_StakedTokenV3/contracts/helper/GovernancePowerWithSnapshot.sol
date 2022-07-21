// SPDX-License-Identifier: MIT
// File contracts/lib/GovernancePowerWithSnapshot.sol

/**
 * @title ERC20WithSnapshot
 * @notice ERC20 including snapshots of balances on transfer-related actions
 * @author Aave
 **/

pragma solidity 0.7.5;
import "./GovernancePowerDelegationERC20.sol";
import "../interface/ITransferHook.sol";

abstract contract GovernancePowerWithSnapshot is GovernancePowerDelegationERC20 {
  using SafeMath for uint256;

  /**
   * @dev The following storage layout points to the prior StakedToken.sol implementation:
   * _snapshots => _votingSnapshots
   * _snapshotsCounts =>  _votingSnapshotsCounts
   * _aaveGovernance => _aaveGovernance
   */
  mapping(address => mapping(uint256 => Snapshot)) public _votingSnapshots;
  mapping(address => uint256) public _votingSnapshotsCounts;

  /// @dev reference to the Aave governance contract to call (if initialized) on _beforeTokenTransfer
  /// !!! IMPORTANT The Aave governance is considered a trustable contract, being its responsibility
  /// to control all potential reentrancies by calling back the this contract
  ITransferHook public _aaveGovernance;

  function _setAaveGovernance(ITransferHook aaveGovernance) internal virtual {
    _aaveGovernance = aaveGovernance;
  }
}