// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IRevealContract {

    function enhancementCost(
        uint256
    )
        external
        view
        returns (
            uint256,
            bool
        );

    function getEnhancementRequest(
        uint256 tokenId
    )
        external
        view
        returns (
            uint256 id,
            address requester
        );

    function reveal(
        uint256[] calldata tokenIds
    )
        external;
}

interface HeroReveal {

    function getStats(
        uint256 _heroID
    )
        external
        view
        returns (
            uint256 heroDamageMultiplier,
            uint256 heroPartySize,
            uint256 heroUpgradeLevel
        );
}

interface FighterReveal {

    function getStats(
        uint256 _fighterID
    )
        external
        view
        returns (
            uint256 fighterDamageValue,
            uint256 fighterUpgradeLevel
        );
}
