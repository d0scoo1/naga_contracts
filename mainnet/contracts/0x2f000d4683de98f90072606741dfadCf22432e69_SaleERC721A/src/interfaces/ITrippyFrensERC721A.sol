// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../utils/AccessLock.sol";

/// @title ITrippyFrens
/// @author 0xhohenheim <contact@0xhohenheim.com>
/// @notice Interface for the TRIPPY NFT contract
interface ITrippyFrensERC721A is IERC721 {
    /// @notice - Mint NFT
    /// @dev - callable only by admin
    /// @param recipient - mint to
    /// @param quantity - number of NFTs to mint
    function mint(address recipient, uint256 quantity) external;
}
