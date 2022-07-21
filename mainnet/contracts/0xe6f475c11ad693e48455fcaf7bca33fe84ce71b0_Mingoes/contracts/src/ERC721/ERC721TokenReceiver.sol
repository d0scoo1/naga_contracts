// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @notice A generic interface for a contract which properly accepts ERC721 tokens.
/// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
interface ERC721TokenReceiver {
	function onERC721Received(
		address operator,
		address from,
		uint256 id,
		bytes calldata data
	) external returns (bytes4);
}
