// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract RaidPartyInsuranceEvents {

    event insurancePurchased(
        uint256 indexed tokenID,
        address indexed user,
        bool isFighter,
        uint256 enhanceCost,
        uint256 indexed batch,
        uint256 cost
    );

    event insuranceClaimed(
        uint256 indexed tokenID,
        uint256 indexed batch,
        address indexed user,
        bool isFighter,
        bool nftCompensation,
        uint256 tokensClaimed
    );

    event PassedBatchCheck(
        uint256[] tokenIDs
    );
}
