//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "../interfaces/IChainId.sol";

/// @notice interface that provides a method to query chain id
contract ChainId is IChainId {

    /// @notice get the chain id
    /// @return uint256 chain id
    function _getChainID() internal view returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }

    /// @notice get the chain id
    /// @return uint256 chain id
    function getChainID() external view override returns (uint256) {
        return _getChainID();
    }

}
