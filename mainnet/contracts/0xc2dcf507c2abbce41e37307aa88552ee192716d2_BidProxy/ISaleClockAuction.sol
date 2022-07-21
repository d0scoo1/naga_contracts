//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface ISaleClockAuction {
    function bid(uint256 _tokenId) external payable;
    function getAuction(uint256 _tokenId) external view returns (address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt);
    function getCurrentPrice(uint256 _tokenId) external view returns (uint256);
}
