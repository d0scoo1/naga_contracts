// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

error QueryForZeroAddress();
error QueryForNonExistentToken(uint256 tokenId);
error ApprovalToOwner();
error CallerNotApprovedOrOwner();
error TransferToNonERC721Receiver();
error MintFromOwnAddress();
error MintToZeroAddress();
error TokenAlreadyMinted();
error TransferToZeroAddress();
error TransferFromNotTheOwner();
error ApproveToOwner();

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
abstract contract ERC721 is ERC165, IERC721, IERC721Metadata {
	// Token name
	string private _name;

	// Token symbol
	string private _symbol;

	// Mapping from token ID to owner address
	mapping(uint256 => address) private _owners;

	// Mapping owner address to token count
	mapping(address => uint256) private _balances;

	// Mapping from token ID to approved address
	mapping(uint256 => address) private _tokenApprovals;

	// Mapping from owner to operator approvals
	mapping(address => mapping(address => bool)) private _operatorApprovals;

	/**
	 * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
	 */
	constructor(string memory name_, string memory symbol_) {
		_name = name_;
		_symbol = symbol_;
	}

	/**
	 * @dev See {IERC165-supportsInterface}.
	 */
	function supportsInterface(bytes4 interfaceId)
		public
		view
		virtual
		override(ERC165, IERC165)
		returns (bool)
	{
		return
			interfaceId == type(IERC721).interfaceId ||
			interfaceId == type(IERC721Metadata).interfaceId ||
			super.supportsInterface(interfaceId);
	}

	/**
	 * @dev See {IERC721-balanceOf}.
	 */
	function balanceOf(address owner) public view virtual override returns (uint256) {
		if (owner == address(0)) revert QueryForZeroAddress();
		return _balances[owner];
	}

	/**
	 * @dev See {IERC721-ownerOf}.
	 */
	function ownerOf(uint256 tokenId) public view virtual override returns (address) {
		address owner = _owners[tokenId];
		if (owner == address(0)) revert QueryForNonExistentToken(tokenId);
		return owner;
	}

	/**
	 * @dev See {IERC721Metadata-name}.
	 */
	function name() public view virtual override returns (string memory) {
		return _name;
	}

	/**
	 * @dev See {IERC721Metadata-symbol}.
	 */
	function symbol() public view virtual override returns (string memory) {
		return _symbol;
	}

	/**
	 * @dev See {IERC721Metadata-tokenURI}.
	 */
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory);

	/**
	 * @dev See {IERC721-approve}.
	 */
	function approve(address to, uint256 tokenId) public virtual override {
		address owner = ERC721.ownerOf(tokenId);
		if (to == owner) revert ApprovalToOwner();

		if (msg.sender != owner && !isApprovedForAll(owner, msg.sender))
			revert CallerNotApprovedOrOwner();

		_approve(to, tokenId);
	}

	/**
	 * @dev See {IERC721-getApproved}.
	 */
	function getApproved(uint256 tokenId) public view virtual override returns (address) {
		if (!_exists(tokenId)) revert QueryForNonExistentToken(tokenId);

		return _tokenApprovals[tokenId];
	}

	/**
	 * @dev See {IERC721-setApprovalForAll}.
	 */
	function setApprovalForAll(address operator, bool approved) public virtual override {
		_setApprovalForAll(msg.sender, operator, approved);
	}

	/**
	 * @dev See {IERC721-isApprovedForAll}.
	 */
	function isApprovedForAll(address owner, address operator)
		public
		view
		virtual
		override
		returns (bool)
	{
		return _operatorApprovals[owner][operator];
	}

	/**
	 * @dev See {IERC721-transferFrom}.
	 */
	function transferFrom(
		address from,
		address to,
		uint256 tokenId
	) public virtual override {
		if (!_isApprovedOrOwner(msg.sender, tokenId)) revert CallerNotApprovedOrOwner();
		_transfer(from, to, tokenId);
	}

	/**
	 * @dev See {IERC721-safeTransferFrom}.
	 */
	function safeTransferFrom(
		address from,
		address to,
		uint256 tokenId
	) public virtual override {
		safeTransferFrom(from, to, tokenId, "");
	}

	/**
	 * @dev See {IERC721-safeTransferFrom}.
	 */
	function safeTransferFrom(
		address from,
		address to,
		uint256 tokenId,
		bytes memory _data
	) public virtual override {
		if (!_isApprovedOrOwner(msg.sender, tokenId)) revert CallerNotApprovedOrOwner();
		_safeTransfer(from, to, tokenId, _data);
	}

	/**
	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
	 *
	 * `_data` is additional data, it has no specified format and it is sent in call to `to`.
	 *
	 * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
	 * implement alternative mechanisms to perform token transfer, such as signature-based.
	 *
	 * Requirements:
	 *
	 * - `from` cannot be the zero address.
	 * - `to` cannot be the zero address.
	 * - `tokenId` token must exist and be owned by `from`.
	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
	 *
	 * Emits a {Transfer} event.
	 */
	function _safeTransfer(
		address from,
		address to,
		uint256 tokenId,
		bytes memory _data
	) internal virtual {
		_transfer(from, to, tokenId);
		if (!_checkOnERC721Received(from, to, tokenId, _data)) {
			revert TransferToNonERC721Receiver();
		}
	}

	/**
	 * @dev Returns whether `tokenId` exists.
	 *
	 * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
	 *
	 * Tokens start existing when they are minted (`_mint`),
	 * and stop existing when they are burned (`_burn`).
	 */
	function _exists(uint256 tokenId) internal view virtual returns (bool) {
		return _owners[tokenId] != address(0);
	}

	/**
	 * @dev Returns whether `spender` is allowed to manage `tokenId`.
	 *
	 * Requirements:
	 *
	 * - `tokenId` must exist.
	 */
	function _isApprovedOrOwner(address spender, uint256 tokenId)
		internal
		view
		virtual
		returns (bool)
	{
		if (!_exists(tokenId)) revert QueryForNonExistentToken(tokenId);
		address owner = ERC721.ownerOf(tokenId);
		return (spender == owner ||
			getApproved(tokenId) == spender ||
			isApprovedForAll(owner, spender));
	}

	/**
	 * @dev Mints `tokenId` and transfers it to `to`.
	 *
	 * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
	 *
	 * Requirements:
	 *
	 * - `tokenId` must not exist.
	 * - `to` cannot be the zero address.
	 *
	 * Emits a {Transfer} event.
	 */
	function _mint(address to, uint256 tokenId) internal virtual {
		if (to == address(0)) revert MintToZeroAddress();
		if (_exists(tokenId)) revert TokenAlreadyMinted();

		_beforeTokenTransfer(address(0), to, tokenId);

		_balances[to] += 1;
		_owners[tokenId] = to;

		emit Transfer(address(0), to, tokenId);

		_afterTokenTransfer(address(0), to, tokenId);
	}

	/**
	 * @dev Mints `tokenId` and transfers it to `receiver`.
	 *
	 * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
	 *
	 * Requirements:
	 *
	 * - `tokenId` must not exist.
	 * - `receiver` cannot be the zero address.
	 *
	 * Emits a {Transfer} event from `AddressZero` to `minter` if minter is not AddressZero.
	 * Emits a {Transfer} event from `minter` to `receiver`.
	 */
	function _sleepMint(
		address minter,
		address receiver,
		uint256 tokenId
	) internal virtual {
		if (minter == receiver) revert MintFromOwnAddress();
		if (receiver == address(0)) revert MintToZeroAddress();
		if (_exists(tokenId)) revert TokenAlreadyMinted();

		_beforeTokenTransfer(address(0), receiver, tokenId);

		_balances[receiver] += 1;
		_owners[tokenId] = receiver;

		if (minter != address(0)) {
			emit Transfer(address(0), minter, tokenId);
		}

		emit Transfer(minter, receiver, tokenId);

		_afterTokenTransfer(address(0), receiver, tokenId);
	}

	/**
	 * @dev Destroys `tokenId`.
	 * The approval is cleared when the token is burned.
	 *
	 * Requirements:
	 *
	 * - `tokenId` must exist.
	 *
	 * Emits a {Transfer} event.
	 */
	function _burn(uint256 tokenId) internal virtual {
		address owner = ERC721.ownerOf(tokenId);

		_beforeTokenTransfer(owner, address(0), tokenId);

		// Clear approvals
		_approve(address(0), tokenId);

		_balances[owner] -= 1;
		delete _owners[tokenId];

		emit Transfer(owner, address(0), tokenId);

		_afterTokenTransfer(owner, address(0), tokenId);
	}

	/**
	 * @dev Transfers `tokenId` from `from` to `to`.
	 *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
	 *
	 * Requirements:
	 *
	 * - `to` cannot be the zero address.
	 * - `tokenId` token must be owned by `from`.
	 *
	 * Emits a {Transfer} event.
	 */
	function _transfer(
		address from,
		address to,
		uint256 tokenId
	) internal virtual {
		if (ERC721.ownerOf(tokenId) != from) revert TransferFromNotTheOwner();
		if (to == address(0)) revert TransferToZeroAddress();

		_beforeTokenTransfer(from, to, tokenId);

		// Clear approvals from the previous owner
		_approve(address(0), tokenId);

		_balances[from] -= 1;
		_balances[to] += 1;
		_owners[tokenId] = to;

		emit Transfer(from, to, tokenId);

		_afterTokenTransfer(from, to, tokenId);
	}

	/**
	 * @dev Approve `to` to operate on `tokenId`
	 *
	 * Emits a {Approval} event.
	 */
	function _approve(address to, uint256 tokenId) internal virtual {
		_tokenApprovals[tokenId] = to;
		emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
	}

	/**
	 * @dev Approve `operator` to operate on all of `owner` tokens
	 *
	 * Emits a {ApprovalForAll} event.
	 */
	function _setApprovalForAll(
		address owner,
		address operator,
		bool approved
	) internal virtual {
		if (owner == operator) revert ApproveToOwner();
		_operatorApprovals[owner][operator] = approved;
		emit ApprovalForAll(owner, operator, approved);
	}

	/**
	 * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
	 * The call is not executed if the target address is not a contract.
	 *
	 * @param from address representing the previous owner of the given token ID
	 * @param to target address that will receive the tokens
	 * @param tokenId uint256 ID of the token to be transferred
	 * @param _data bytes optional data to send along with the call
	 * @return bool whether the call correctly returned the expected magic value
	 */
	function _checkOnERC721Received(
		address from,
		address to,
		uint256 tokenId,
		bytes memory _data
	) private returns (bool) {
		if (to.code.length > 0) {
			try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (
				bytes4 retval
			) {
				return retval == IERC721Receiver.onERC721Received.selector;
			} catch (bytes memory reason) {
				if (reason.length == 0) {
					revert TransferToNonERC721Receiver();
				} else {
					assembly {
						revert(add(32, reason), mload(reason))
					}
				}
			}
		} else {
			return true;
		}
	}

	/**
	 * @dev Hook that is called before any token transfer. This includes minting
	 * and burning.
	 *
	 * Calling conditions:
	 *
	 * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
	 * transferred to `to`.
	 * - When `from` is zero, `tokenId` will be minted for `to`.
	 * - When `to` is zero, ``from``'s `tokenId` will be burned.
	 * - `from` and `to` are never both zero.
	 *
	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
	 */
	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	) internal virtual {}

	/**
	 * @dev Hook that is called after any transfer of tokens. This includes
	 * minting and burning.
	 *
	 * Calling conditions:
	 *
	 * - when `from` and `to` are both non-zero.
	 * - `from` and `to` are never both zero.
	 *
	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
	 */
	function _afterTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	) internal virtual {}
}
