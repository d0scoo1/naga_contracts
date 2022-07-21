// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "../interfaces/IMetadataProvider.sol";
import "../utils/BespokeStrings.sol";

/// @title Base On-Chain IMetadataProvider
abstract contract OnChainMetadataProvider is AccessControl, IMetadataProvider {

	/// Defines the metadata reader role
	bytes32 public constant METADATA_READER_ROLE = keccak256("METADATA_READER_ROLE");

	/// @dev Controls the reveal
	bool internal wenReveal_;

	/// @dev Constructs a new instance passing in the IERC1155 token contract
	/// @param tokenContract The IERC1155 that this OnChainMetadataProvider will support
	constructor(address tokenContract) {
		_grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
		_setRoleAdmin(METADATA_READER_ROLE, DEFAULT_ADMIN_ROLE);
		grantRole(METADATA_READER_ROLE, tokenContract);
	}

	/// @dev returns the raw json metadata for the specified token i
	/// @param tokenId the id of the requested token
	/// @return The bytes stream of the json metadata
	function contents(uint256 tokenId) internal virtual view returns (bytes memory) {
		if (wenReveal_) {
			string memory encoded = Base64.encode(bytes(svg()));
			return abi.encodePacked("{\"name\":\"", "The Normal Series Tier ", Strings.toString(tokenId+1), "\",\"image\":\"data:image/svg+xml;base64,", encoded, "\"}");
		}
		string memory image = "ipfs://QmdAcHWafrfQcaTW2sv2rurJGHGzK3gQHSLthQx5U1RgLJ";
		return abi.encodePacked("{\"name\":\"The Normal Series (Unrevealed)\",\"image\":\"", image, "\"}");
	}

	/// @inheritdoc IMetadataProvider
	function metadata(uint256 tokenId) external view onlyRole(METADATA_READER_ROLE) returns (string memory) {
		return string.concat("data:application/json;base64,", Base64.encode(contents(tokenId)));
	}

	/// Wen the world is ready
	/// @dev Only the contract owner can invoke this
	function revealTokens() external onlyRole(DEFAULT_ADMIN_ROLE) {
		wenReveal_ = true;
	}

	/// @inheritdoc IERC165
	function supportsInterface(bytes4 interfaceId) public view override(AccessControl, IERC165) returns (bool) {
		return interfaceId == type(IMetadataProvider).interfaceId || super.supportsInterface(interfaceId);
	}

	/// Generates the on-chain SVG
	/// @dev Subclasses must implement this function
	function svg() internal virtual pure returns (string memory);

	/// Renders the path element using the provided data and fills with black
	/// @param path The bytes representing all operations in the path element
	/// @return black A path element filled with black
	function _blackPathFull(bytes memory path) internal pure returns (string memory black) {
		black = string.concat("<path d='", BespokeStrings.fullPathAttribute(path), "' fill='#000'/>");
	}

	/// Renders the path element using the provided data and fills with black
	/// @param path The bytes representing all operations in the path element
	/// @return black A path element filled with black
	function _blackPathSimple(bytes memory path) internal pure returns (string memory black) {
		black = string.concat("<path d='M", BespokeStrings.simplePathAttribute(path), "Z' fill='#000'/>");
	}

	/// Renders the path element using the provided data and fills with white
	/// @param path The bytes representing the M and C operations in the path element
	/// @return white A path element filled with white
	function _whitePathFull(bytes memory path) internal pure returns (string memory white) {
		white = string.concat("<path d='", BespokeStrings.fullPathAttribute(path), "' fill='#fff'/>");
	}

	/// Renders the path element using the provided data and fills with white
	/// @param path The bytes representing the M and C operations in the path element
	/// @return white A path element filled with white
	function _whitePathSimple(bytes memory path) internal pure returns (string memory white) {
		white = string.concat("<path d='M", BespokeStrings.simplePathAttribute(path), "Z' fill='#fff'/>");
	}
}
