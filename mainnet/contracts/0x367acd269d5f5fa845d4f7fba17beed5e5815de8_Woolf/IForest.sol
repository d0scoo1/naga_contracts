// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;

interface IForest {
	function addManyToForestAndPack(address account, uint16[] calldata tokenIds) external;

	function randomWolfOwner(uint256 seed) external view returns (address);
}
