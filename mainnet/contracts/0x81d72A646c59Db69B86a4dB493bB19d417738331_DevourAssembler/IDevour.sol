// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDevour {
  function ownerOf(uint256 tokenId) external view returns (address owner);
  function assemble(uint256 devourType, uint256[] calldata tokenIds) external;
}
