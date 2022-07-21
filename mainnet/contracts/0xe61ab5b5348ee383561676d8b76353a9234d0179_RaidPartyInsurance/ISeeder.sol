// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface ISeeder{

    function getBatch()
        external
        view
        returns(uint256);

    function getNextAvailableBatch()
        external
        view
        returns(uint256);

    function getSeedSafe(
        address origin,
        uint256 identifier
    )
        external
        view
        returns(uint256);
}
