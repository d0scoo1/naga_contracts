//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/// @notice a pool of tokens that users can deposit into and withdraw from
interface IBank {

    /// @notice emitted when a token is added to the collection
    event Deposited (
        address indexed bank,
        address indexed account,
        uint256 indexed id,
        uint256 amount
    );

    /// @notice emitted when a token is added to the collection
    event Withdrew (
        address indexed bank,
        address indexed account,
        uint256 indexed id,
        uint256 amount
    );

    /// @notice deposit tokens into the pool
    /// @param id the token id to deposit
    /// @param amount the amount of tokens to deposit
    function deposit(uint256 id, uint256 amount) external payable;

    /// @notice deposit tokens into the pool
    /// @param id the token id to deposit
    /// @param amount the amount of tokens to deposit
    function depositFrom(address account, uint256 id, uint256 amount) external payable;

    /// @notice withdraw all tokens with id from the pool
    /// @param id the token id to withdraw
    function withdraw(uint256 id, uint256 amount) external returns (uint256);

    /// @notice withdraw all tokens with id from the pool
    /// @param to to address of the account
    /// @param id he token id to withdraw
    /// @param amount the amount of tokens to deposit
    function withdrawTo(address to, uint256 id, uint256 amount) external returns (uint256);

    /// @notice get the deposited amount of tokens with id
    /// @param id the token id to get the amount of
    /// @return the amount of tokens with id
    function balance(address _account, uint256 id) external view returns (uint256);

}
