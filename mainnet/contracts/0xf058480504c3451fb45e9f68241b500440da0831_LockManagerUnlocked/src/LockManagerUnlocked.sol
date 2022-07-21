// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "./ILockManager.sol";

/// @title Solarbots Unlocked Lock Manager
/// @author Solarbots (https://solarbots.io)
contract LockManagerUnlocked is ILockManager {
    function isLocked(address /*from*/, address /*to*/, uint256 /*id*/) external pure returns (bool) {
        return false;
    }

    function isLocked(address /*from*/, address /*to*/, uint256[] calldata /*id*/) external pure returns (bool) {
        return false;
    }
}
