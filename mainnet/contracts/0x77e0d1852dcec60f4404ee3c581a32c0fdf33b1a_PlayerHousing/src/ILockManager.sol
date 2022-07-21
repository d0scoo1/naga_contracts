// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

/// @title Solarbots Lock Manager Interface
/// @author Solarbots (https://solarbots.io)
interface ILockManager {
    function isLocked(address from, address to, uint256 id) external returns (bool);
    function isLocked(address from, address to, uint256[] calldata ids) external returns (bool);
}
