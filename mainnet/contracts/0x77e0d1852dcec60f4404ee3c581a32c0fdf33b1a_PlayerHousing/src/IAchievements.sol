// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

/// @title Solarbots Achievements Interface
/// @author Solarbots (https://solarbots.io)
interface IAchievements {
    function burn(address from, uint256 id, uint256 amount) external;
}
