//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/// @notice a contract that can be withdrawn from by some user
interface IWithdrawable {

    /// @notice withdraw some amount of either a token or ether
    /// @param token the erc20 token to withdraw or 0 for the base token (ether)
    /// @param id the token id to withdraw or 0 for the base token (ether)
    /// @param amount the amount to withdraw
    function withdraw(address recipient, address token, uint256 id, uint256 amount) external;

    /// @notice emitted when a withdrawal is made
    event TokenWithdrawn(address recipient, address token, uint256 id, uint256 amount);

}
