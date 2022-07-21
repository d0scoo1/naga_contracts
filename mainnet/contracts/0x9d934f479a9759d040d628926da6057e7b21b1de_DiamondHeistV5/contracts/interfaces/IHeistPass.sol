// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";

interface IHeistPass is IERC721Upgradeable, IERC721MetadataUpgradeable {
  function getFee(uint256 amount) external view returns (uint256);
  function burn(address to, uint256[] memory tokenIds) external payable;
}