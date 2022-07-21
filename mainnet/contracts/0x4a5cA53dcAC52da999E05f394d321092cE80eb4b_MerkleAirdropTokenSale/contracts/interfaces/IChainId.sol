//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


/// @notice interface that provides a method to query chain id
interface IChainId {

    /// @notice get the chain id
    /// @return uint256 chain id
    function getChainID() external view returns (uint256);

}
