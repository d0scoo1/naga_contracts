// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {Storage} from "./Storage.sol";

/**
 * @dev Contract for access control where the governance address specified
 * in the Storage contract can be granted access to specific functions
 * on a contract that inherits this contract.
 *
 * The difference between GovernableInit and Governable is that GovernableInit supports proxy
 * smart contracts.
 */

contract GovernableInit is Initializable {

  bytes32 internal constant _STORAGE_SLOT = 0xa7ec62784904ff31cbcc32d09932a58e7f1e4476e1d041995b37c917990b16dc;

  modifier onlyGovernance() {
    require(Storage(_storage()).isGovernance(msg.sender), "Governable: Not governance");
    _;
  }

  constructor() {
    assert(_STORAGE_SLOT == bytes32(uint256(keccak256("eip1967.governableInit.storage")) - 1));
  }

  function __Governable_init_(address _store) public initializer {
    _setStorage(_store);
  }

  function _setStorage(address newStorage) private {
    bytes32 slot = _STORAGE_SLOT;
    // solhint-disable-next-line no-inline-assembly
    assembly {
      sstore(slot, newStorage)
    }
  }

  function setStorage(address _store) public onlyGovernance {
    require(_store != address(0), "Governable: New storage shouldn't be empty");
    _setStorage(_store);
  }

  function _storage() internal view returns (address str) {
    bytes32 slot = _STORAGE_SLOT;
    // solhint-disable-next-line no-inline-assembly
    assembly {
      str := sload(slot)
    }
  }

  function governance() public view returns (address) {
    return Storage(_storage()).governance();
  }
}