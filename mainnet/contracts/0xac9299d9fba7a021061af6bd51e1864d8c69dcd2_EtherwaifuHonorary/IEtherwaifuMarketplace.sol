// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IEtherwaifuMarketplace {
    function getAuction(uint256 artworkId) external view
        returns(address seller, uint256 timeStart, uint256 timeEnd,
        uint256 priceStart, uint256 priceEnd, uint256 priceInstantGet);
}
