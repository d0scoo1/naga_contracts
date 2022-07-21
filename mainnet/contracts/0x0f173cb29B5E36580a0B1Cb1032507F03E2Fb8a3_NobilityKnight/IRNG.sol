// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;


interface IRNG {
    function fetchRandom(uint256 seedOne, uint256 seedTwo) external returns (uint256);
}