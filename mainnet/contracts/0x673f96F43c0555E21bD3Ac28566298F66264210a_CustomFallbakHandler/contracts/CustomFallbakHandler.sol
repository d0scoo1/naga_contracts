// SPDX-License-Identifier: MPL-2.0
pragma solidity =0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./CompatibilityFallbackHandler.sol";
import "./interfaces/ERC223Contract.sol";

contract CustomFallbakHandler is
	CompatibilityFallbackHandler,
	OwnableUpgradeable,
	UUPSUpgradeable
{
	function initialize() public initializer {
		__Ownable_init();
		__UUPSUpgradeable_init();
	}

	function _authorizeUpgrade(address) internal override onlyOwner {}
}
