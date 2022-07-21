// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

////////////////////////////////////////////////////////////////////////////////
///              ░▒█▀▀▄░█▀▀█░▒█▀▀█░█▀▀▄░▒█▀▄▀█░▄█░░▒█▄░▒█░▒█▀▀▀              ///
///              ░▒█░▒█░█▄▀█░▒█▄▄█▒█▄▄█░▒█▒█▒█░░█▒░▒█▒█▒█░▒█▀▀▀              ///
///              ░▒█▄▄█░█▄▄█░▒█░░░▒█░▒█░▒█░░▒█░▄█▄░▒█░░▀█░▒█▄▄▄              ///
////////////////////////////////////////////////////////////////////////////////

import "./IDopamineHonoraryTabEvents.sol";

/// @title Dopamine ERC-721 honorary membership tab interface
interface IDopamineHonoraryTab is IDopamineHonoraryTabEvents {

    /// @notice Mints an honorary Dopamine tab to address `to`.
    /// @dev This function is only callable by the owner address.
    function mint(address to) external;

    /// @notice Gets the owner address, which controls minting and metadata.
    function owner() external view returns (address);

    /// @notice Retrieves a URI describing the overall contract-level metadata.
    /// @return A string URI pointing to the tab contract metadata.
    function contractURI() external view returns (string memory);

    /// @notice Sets the owner address to `newOwner`.
    /// @param newOwner The address of the new owner.
    /// @dev This function is only callable by the owner address.
    function setOwner(address newOwner) external;

    /// @notice Sets the base URI to `newBaseURI`.
    /// @param newBaseURI The new base metadata URI to set for the collection.
    /// @dev This function is only callable by the owner address.
    function setBaseURI(string calldata newBaseURI) external;

    /// @notice Sets the permanent storage URI to `newStorageURI`.
    /// @param newStorageURI The new permanent URI to set for the collection.
    /// @dev This function is only callable by the owner address.
    function setStorageURI(string calldata newStorageURI) external;

    /// @notice Sets the EIP-2981 royalties for the NFT collection.
    /// @param receiver Address to which royalties will be received.
    /// @param royalties The amount of royalties to receive, in bips.
    /// @dev This function is only callable by the owner address.
    function setRoyalties(address receiver, uint96 royalties) external;

}
