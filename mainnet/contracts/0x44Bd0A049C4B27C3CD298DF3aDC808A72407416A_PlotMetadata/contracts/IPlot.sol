//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IPlot is IERC721 {
  function getPlotCoordinate(uint256 tokenId)
    external
    view
    returns (int256, int256);
}
