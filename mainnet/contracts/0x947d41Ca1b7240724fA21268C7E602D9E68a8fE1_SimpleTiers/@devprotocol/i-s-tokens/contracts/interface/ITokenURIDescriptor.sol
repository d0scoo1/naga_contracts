// SPDX-License-Identifier: MPL-2.0
// solhint-disable-next-line compiler-version
pragma solidity ^0.8.0;

import "./ISTokensManagerStruct.sol";

interface ITokenURIDescriptor {
	/*
	 * @dev get image from custom descriopro
	 * @param _tokenId token id
	 * @param _owner owner address
	 * @param _positions staking position
	 * @param _rewards rewards
	 * @return string image information
	 */
	function image(
		uint256 _tokenId,
		address _owner,
		ISTokensManagerStruct.StakingPositions memory _positions,
		ISTokensManagerStruct.Rewards memory _rewards
	) external view returns (string memory);
}
