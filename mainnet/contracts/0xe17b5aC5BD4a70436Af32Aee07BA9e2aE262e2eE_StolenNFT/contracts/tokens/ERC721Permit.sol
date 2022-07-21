// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721Permit.sol";
import "./ERC721.sol";
import "../utils/EIP712.sol";

error NotTheTokenOwner();
error PermitToOwner();
error PermitDeadLineExpired();

/**
 * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC721 approval (see {IERC721-approval}) by
 * presenting a message signed by the account. By not relying on `{IERC721-approve}`, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 *
 * _Available since v3.4._
 */
abstract contract ERC721Permit is ERC721, IERC721Permit, EIP712 {
	mapping(address => uint256) private _nonces;

	// solhint-disable-next-line var-name-mixedcase
	bytes32 private immutable _PERMIT_TYPEHASH =
		keccak256(
			"Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
		);

	/**
	 * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
	 *
	 * It's a good idea to use the same `name` that is defined as the ERC721 token name.
	 */
	constructor(string memory _name, string memory _symbol)
		ERC721(_name, _symbol)
		EIP712(_name, "1")
	{}

	/**
	 * @dev See {IERC20Permit-permit}.
	 */
	function permit(
		address owner,
		address spender,
		uint256 value,
		uint256 deadline,
		uint8 v,
		bytes32 r,
		bytes32 s
	) public virtual override {
		if (owner != ERC721.ownerOf(value)) revert NotTheTokenOwner();
		if (spender == owner) revert PermitToOwner();
		if (block.timestamp > deadline) revert PermitDeadLineExpired();

		bytes32 structHash = keccak256(
			abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline)
		);

		bytes32 hash = _hashTypedDataV4(structHash);

		address signer = ECDSA.recover(hash, v, r, s);
		if (signer != owner) revert InvalidSignature();

		_approve(spender, value);
	}

	/**
	 * @dev See {IERC20Permit-nonces}.
	 */
	function nonces(address owner) public view virtual override returns (uint256) {
		return _nonces[owner];
	}

	/**
	 * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
	 */
	// solhint-disable-next-line func-name-mixedcase
	function DOMAIN_SEPARATOR() external view override returns (bytes32) {
		return _domainSeparatorV4();
	}

	/**
	 * @dev "Consume a nonce": return the current value and increment.
	 *
	 * _Available since v4.1._
	 */
	function _useNonce(address owner) internal virtual returns (uint256 current) {
		current = _nonces[owner];
		unchecked {
			_nonces[owner] = current + 1;
		}
	}
}
