// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import { MemoryInterface, InstaMapping } from "./interfaces.sol";

abstract contract Stores {
	/**
	 * @dev Return ethereum address
	 */
	address internal constant ethAddr =
		0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

	/**
	 * @dev Return Wrapped ETH address
	 */
	address internal constant wethAddr =
		0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

	/**
	 * @dev Return memory variable address
	 */
	MemoryInterface internal constant instaMemory =
		MemoryInterface(0x8a5419CfC711B2343c17a6ABf4B2bAFaBb06957F);

	/**
	 * @dev Return InstaDApp Mapping Addresses
	 */
	InstaMapping internal constant instaMapping =
		InstaMapping(0xe81F70Cc7C0D46e12d70efc60607F16bbD617E88);

	/**
	 * @dev Get Uint value from InstaMemory Contract.
	 */
	function getUint(uint256 getId, uint256 val)
		internal
		returns (uint256 returnVal)
	{
		returnVal = getId == 0 ? val : instaMemory.getUint(getId);
	}

	/**
	 * @dev Set Uint value in InstaMemory Contract.
	 */
	function setUint(uint256 setId, uint256 val) internal virtual {
		if (setId != 0) instaMemory.setUint(setId, val);
	}
}
