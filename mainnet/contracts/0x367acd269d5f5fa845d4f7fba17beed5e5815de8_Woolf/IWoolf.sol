// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;

import "./IERC721.sol";

interface IWoolf is IERC721 {
	// struct to store each token's traits
	struct ApeWolf {
		bool isApe;
		uint8 skin;
		uint8 eyes;
		uint8 mouth;
		uint8 clothing;
		uint8 headwear;
		uint8 alphaIndex;
	}

	function getPaidTokens() external view returns (uint256);

	function getTokenTraits(uint256 tokenId) external view returns (ApeWolf memory);
	
	function transferFrom(
		address from,
		address to,
		uint256 tokenId
	) external;
}
