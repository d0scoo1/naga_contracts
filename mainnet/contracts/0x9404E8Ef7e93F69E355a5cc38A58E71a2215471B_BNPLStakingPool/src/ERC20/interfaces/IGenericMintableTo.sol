// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGenericMintableTo {
    function mint(address to, uint256 amount) external;
}
