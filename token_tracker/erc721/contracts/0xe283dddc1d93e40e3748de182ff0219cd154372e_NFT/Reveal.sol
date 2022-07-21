// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "./Strings.sol";
import "./AccessControl.sol";

/// @title The NFT reveal contract.
contract Reveal is AccessControl {
  using Strings for uint256;
  // The base URI.
  string private baseUri = "ipfs://none";
  // The URI that used until NFTs are revealed.
  string private unrevealedUri;
  // The flag that indicates if NFTs have been revealed.
  bool public revealed = false;

  constructor(string memory _unrevealedUri) {
    unrevealedUri = _unrevealedUri;
  }

  /// Reveals the NFTs.
  function reveal() external onlyRole(DEFAULT_ADMIN_ROLE) {
    revealed = true;
  }

  /// Unreveals the NFTs.
  function unreveal() external onlyRole(DEFAULT_ADMIN_ROLE) {
    revealed = false;
  }

  /// Sets base URI that is used when NFTs are revealed.
  function setBaseUri(string memory uri) external onlyRole(DEFAULT_ADMIN_ROLE) {
    baseUri = uri;
    revealed = true;
  }

  /// Sets URI to be used while NFTs are unrevealed.
  function setUnrevealedUri(string memory uri) external onlyRole(DEFAULT_ADMIN_ROLE) {
    unrevealedUri = uri;
  }

  /// Gets the base URI.
  function getBaseUri() public view returns (string memory) {
    return baseUri;
  }

  /// Gets a token URI.
  function getTokenUri(uint256 tokenId) internal view returns (string memory) {
    if (!revealed) {
      return unrevealedUri;
    }

    return bytes(baseUri).length != 0 ? string(abi.encodePacked(baseUri, tokenId.toString())) : "";
  }
}