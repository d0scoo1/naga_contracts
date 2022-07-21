//SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface IHappyKoalas {
    function isOwnerOf(address account, uint256[] calldata _tokenIds) external view returns (bool);
}