// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IMainGame {

    function getUserFighters(
        address user
    )
        external
        view
        returns (
            uint256[] memory
        );

    function getUserHero(
        address user
    )
        external
        view
        returns (uint256);

    function equip(
        uint8 item,
        uint256 id,
        uint8 slot
    )
        external;

    function unequip(
        uint8 item,
        uint8 slot
    )
        external;

    function enhance(
        uint8 item,
        uint8 slot,
        uint256 burnTokenId
    )
        external;
}
