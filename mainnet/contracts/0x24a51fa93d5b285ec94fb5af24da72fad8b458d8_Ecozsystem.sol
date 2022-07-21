// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}


/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

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
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
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
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
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
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

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
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
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
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
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
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
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
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
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
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
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
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
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
}

pragma solidity >=0.7.0 <0.9.0;

interface IJag {
    function jagRandomizer(address user, uint256 jagID) external returns(uint256);
    function jaguarTokenURI(uint256 jagID, uint256 jagWeight) external view returns(string memory);
}

interface IBuck {
    function buckRandomizer(address user, uint256 buckID) external returns(uint256); 
    function bushBuckTokenURI(uint256 buckID, uint256 buckWeight) external view returns(string memory);
}

interface ITree {
    function treeRandomizer(address user, uint256 treeID) external returns(uint256); 
    function bananaTreeTokenURI(uint256 treeID, uint256 treeWeight) external view returns(string memory);
}

//--------------------------------------------------------------------------------------------------------//
//                           _________      _______    _________    ____________                          //                                  
//                          /         \    /       \  /         \  |            ]                         //
//                         |     _____|   /    ____/ |    ___    | |_____       ]                         //
//                         |    [        /    /      |   /   \   |       ]     /                          //
//                         |    [______ |    [       |  |     |  |      /     /                           //
//                         |          | |    |       |  |     |  |     /     /                            //
//                         |     _____| |    |       |  |     |  |    /     /                             //
//                         |    [       |    [       |  |     |  |   /     /                              //
//                         |    [_____   \    \____  |   \___/   |  /     [_____                          //
//                         |          |   \        \ |           | [            |                         //
//                          \_________/    \_______/  \_________/  [____________|                         //
//                                                                                                        //         
/*--------------------------------------------------------------------------------------------------------//
// We would like to give a tribute to Anonymice for providing us the inspiration and methods to write the //
//  Ecoz contract. They were truly way ahead of their time and have chagned on chain innovation forever.  //                    
//--------------------------------------------------------------------------------------------------------*/

contract Ecoz is ERC721, Ownable {
    using Strings for uint256;

    IJag public jaguarsURI;
 	IBuck public bushBucksURI;
 	ITree public bananaTreesURI;
    
    uint256 public cost = 0.066 ether;
    uint256 public maxMintAmount = 4;
    uint256 public maxJagSupply = 150;
    uint256 public maxBuckSupply = 300;
    uint256 public maxTreeSupply = 600;
    uint256 jagSupply;
    uint256 buckSupply;
    uint256 treeSupply;

    bool ogSale = false;
    bool whitelistSale = false;
    bool publicSale = false;

    mapping (uint256 => uint256) public weightJaguar;
    mapping (uint256 => uint256) public weightBushBuck;
    mapping (uint256 => uint256) public weightBananaTree;

    mapping (address => uint256) balanceJaguar;
    mapping (address => uint256) balanceBushBuck;
    mapping (address => uint256) balanceBananaTree;
    mapping (address => uint256) weightOfOwner;
    mapping (address => uint256) jagMinted;
    mapping (address => uint256) buckMinted;
    mapping (address => uint256) treeMinted;
     
    mapping(address => bool) public ogAddress;
    mapping(address => bool) public wlAddress;
    
    constructor(address jagAddress, address buckAddress, address treeAddress) ERC721("Ecoz","ECOZ") {
		jaguarsURI = IJag(jagAddress);
		bushBucksURI = IBuck(buckAddress);
		bananaTreesURI = ITree(treeAddress);
	}
                /*----------------------//
                //  MINTING FUNCTIONS   //
                //----------------------*/

    function MintJaguar(uint256 mintAmount) public payable {  
        require(jagSupply + mintAmount <= maxJagSupply,          "Over max supply");
        require(msg.value == cost * mintAmount,        "Ether sent is not correct");

        if (ogSale == true) {   
            require(ogAddress[msg.sender] == true,                                                                          "This addres is not an OG");
            require(jagMinted[msg.sender] + buckMinted[msg.sender] + treeMinted[msg.sender] + mintAmount <= maxMintAmount,  "max amount of Ecoz minted");
            require(jagMinted[msg.sender] + mintAmount <= 2,                                                                "Only 2 mints per species allowed");
        }
        else if (whitelistSale == true) {
            require((ogAddress[msg.sender] == true) || (wlAddress[msg.sender] == true),                                     "This address is not whitelisted");
            require(jagMinted[msg.sender] + buckMinted[msg.sender] + treeMinted[msg.sender] + mintAmount <= maxMintAmount,  "max amount of Ecoz minted");
            require(jagMinted[msg.sender] + mintAmount <= 2,                                                                "Only 2 mints per species allowed");
        }
        else {
            require(publicSale == true,              "Public sale has not started");
        }

        for (uint256 i = 1; i <= mintAmount; i++) {
            jagSupply++;
            weightJaguar[jagSupply] = jaguarsURI.jagRandomizer(msg.sender, jagSupply);
            jagMinted[msg.sender]++;
            balanceJaguar[msg.sender]++;
            weightOfOwner[msg.sender] = weightOfOwner[msg.sender] + weightJaguar[jagSupply];
            _mint(msg.sender, jagSupply);
        }
    }
    
    function MintBushBuck(uint256 mintAmount) public payable { 
        require(buckSupply + mintAmount <= maxBuckSupply,         "Over max supply");
        require(msg.value == cost * mintAmount,         "Ether sent is not correct");

        if (ogSale == true) {   
            require(ogAddress[msg.sender] == true,                                                                          "This addres is not an OG");
            require(jagMinted[msg.sender] + buckMinted[msg.sender] + treeMinted[msg.sender] + mintAmount <= maxMintAmount,  "max amount of Ecoz minted");
            require(buckMinted[msg.sender] + mintAmount <= 2,                                                               "Only 2 mints per species allowed");
        }
        else if (whitelistSale == true) {
            require((ogAddress[msg.sender] == true) || (wlAddress[msg.sender] == true),                                     "This address is not whitelisted");
            require(jagMinted[msg.sender] + buckMinted[msg.sender] + treeMinted[msg.sender] + mintAmount <= maxMintAmount,  "max amount of Ecoz minted");
            require(buckMinted[msg.sender] + mintAmount <= 2,                                                               "Only 2 mints per species allowed");
        }
        else {
            require(publicSale == true,               "Public sale has not started");
        }

        for (uint256 i = 1; i <= mintAmount; i++) {
            buckSupply++;
            weightBushBuck[buckSupply + 1350] = bushBucksURI.buckRandomizer(msg.sender, buckSupply + 1350);
            buckMinted[msg.sender]++;
            balanceBushBuck[msg.sender]++;
            weightOfOwner[msg.sender] = weightOfOwner[msg.sender] + weightBushBuck[buckSupply + 1350];
            _mint(msg.sender, buckSupply + 1350);
        }
    }
    
    function MintBananaTree(uint256 mintAmount) public payable {       
        require(treeSupply + mintAmount <= maxTreeSupply,          "Over max supply");
        require(msg.value == cost * mintAmount,          "Ether sent is not correct");

        if (ogSale == true) {   
            require(ogAddress[msg.sender] == true,                                                                          "This addres is not an OG");
            require(jagMinted[msg.sender] + buckMinted[msg.sender] + treeMinted[msg.sender] + mintAmount <= maxMintAmount,  "max amount of Ecoz minted");
            require(treeMinted[msg.sender] + mintAmount <= 2,                                                               "Only 2 mints per species allowed");
        }
        else if (whitelistSale == true) {
            require((ogAddress[msg.sender] == true) || (wlAddress[msg.sender] == true),                                     "This address is not whitelisted");
            require(jagMinted[msg.sender] + buckMinted[msg.sender] + treeMinted[msg.sender] + mintAmount <= maxMintAmount,  "max amount of Ecoz minted");
            require(treeMinted[msg.sender] + mintAmount <= 2,                                                               "Only 2 mints per species allowed");
        }
        else {
            require(publicSale == true,                "Public sale has not started");
        }

        for (uint256 i = 1; i <= mintAmount; i++) {
            treeSupply++;
            weightBananaTree[treeSupply + 4050] = bananaTreesURI.treeRandomizer(msg.sender, treeSupply + 4050);
            treeMinted[msg.sender]++;
            balanceBananaTree[msg.sender]++;
            weightOfOwner[msg.sender] = weightOfOwner[msg.sender] + weightBananaTree[treeSupply + 4050];
            _mint(msg.sender, treeSupply + 4050);
        }
    }
                /*----------------------//
                //   OWNER FUNCTIONS    //
                //----------------------*/

    function ownerMint(uint256 species, uint256 amt) public onlyOwner {
        if (species == 0) {
            require(jagSupply + amt <= maxJagSupply);
            for (uint256 i = 1; i <= amt; i++) {
                jagSupply++;
                weightJaguar[jagSupply] = jaguarsURI.jagRandomizer(msg.sender, jagSupply);
                balanceJaguar[msg.sender]++;
                weightOfOwner[msg.sender] = weightOfOwner[msg.sender] + weightJaguar[jagSupply];
                _mint(msg.sender, jagSupply);
            }   
        }
        else if (species == 1) {
            require(buckSupply + amt <= maxBuckSupply);
            for (uint256 i = 1; i <= amt; i++) {
                buckSupply++;
                weightBushBuck[buckSupply + 1350] = bushBucksURI.buckRandomizer(msg.sender, buckSupply + 1350);
                balanceBushBuck[msg.sender]++;
                weightOfOwner[msg.sender] = weightOfOwner[msg.sender] + weightBushBuck[buckSupply + 1350];
                _mint(msg.sender, buckSupply + 1350);
            }
        }
        else {
            require(treeSupply + amt <= maxTreeSupply);
            for (uint256 i = 1; i <= amt; i++) {
                treeSupply++;
                weightBananaTree[treeSupply + 4050] = bananaTreesURI.treeRandomizer(msg.sender, treeSupply + 4050);
                balanceBananaTree[msg.sender]++;
                weightOfOwner[msg.sender] = weightOfOwner[msg.sender] + weightBananaTree[treeSupply + 4050];
                _mint(msg.sender, treeSupply + 4050);
            }
        }
    }

    function setCost(uint256 newCost) public onlyOwner {
        cost = newCost;
    }

    function setMaxMintAmount(uint256 newMaxMintAmount) public onlyOwner {
        maxMintAmount = newMaxMintAmount;
    }

    function toggleOGSale() public onlyOwner {
        if (ogSale == true) {
            ogSale = false;
        }
        else {
            ogSale = true;
        }
    }

    function toggleWhitelistSale() public onlyOwner {
        if (whitelistSale == true) {
            whitelistSale = false;
        }
        else {
            whitelistSale = true;
            maxMintAmount = 2;
        }
    }

    function togglePublicSale() public onlyOwner {
        if (publicSale == true) {
            publicSale = false;
        }
        else {
            publicSale = true;
            maxMintAmount = 3;
        }
    }
    
    function addWhitelistBundle(address[] memory wlBundle) public onlyOwner {
        for (uint256 i = 0; i < wlBundle.length; i++) {
            wlAddress[wlBundle[i]] = true;
        }
    }

    function addOGBundle(address[] memory ogBundle) public onlyOwner {
        for (uint256 i = 0; i < ogBundle.length; i++) {
            ogAddress[ogBundle[i]] = true;    
        }
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }
}

interface IThrive {
    function burn(address from, uint256 amount) external;
    function updateThrive(address from, address to) external;
    function levelUpdate(address user) external;
} 
                /*----------------------//
                //  BREEDING FUNCTIONS  //
                //----------------------*/

contract Ecozsystem is Ecoz {
    
    IThrive public Thrive;

    uint256 public babyJagSupply = 0;
    uint256 public babyBuckSupply = 0;
    uint256 public babyTreeSupply = 0;
    uint256 public maxBabyJagSupply = 450;
    uint256 public maxBabyBuckSupply = 900;
    uint256 public maxBabyTreeSupply = 1800;
    uint256 public breedCostJag = 600;
    uint256 public breedCostBuck = 480;
    uint256 public breedCostTree = 360;

    bool public breedingPaused = false;

    uint256 [] populationRange = [1,   2,   3,   4,   5,   6,   7,   8,   9,   10,  11,  12];
    uint256 [] jagRangeOver =    [605, 610, 615, 620, 625, 630, 635, 640, 645, 650, 655, 660, 690];
    uint256 [] jagRangeUnder =   [595, 590, 585, 580, 575, 570, 565, 560, 555, 550, 545, 540, 510];
    uint256 [] buckRangeOver =   [485, 490, 495, 500, 505, 510, 515, 520, 525, 530, 535, 540, 570];
    uint256 [] buckRangeUnder =  [475, 470, 465, 460, 455, 450, 445, 440, 435, 430, 425, 420, 390];
    uint256 [] treeRangeOver =   [365, 370, 375, 380, 385, 390, 395, 400, 405, 410, 415, 420, 450];
    uint256 [] treeRangeUnder =  [355, 350, 345, 340, 335, 330, 325, 320, 315, 310, 305, 300, 270];

    mapping(uint256 => uint256) public level;
    uint8 public maxLevel = 3;
    
    constructor(address jagAddress, address buckAddress, address treeAddress) Ecoz(jagAddress,buckAddress,treeAddress) {}
    
    function BreedJaguar() public {
        require(breedingPaused == false,                    "Breeding is temporarily paused");
        require(balanceJaguar[msg.sender] >= 2,             "Must own two genesis jaguars to breed");
        require(babyJagSupply + 1 <= maxBabyJagSupply,      "Max amount of jaguars bred");
    
        Thrive.burn(msg.sender, (breedCostJag * 1000000000000000000));
        babyJagSupply++;
        weightJaguar[babyJagSupply + 450] = jaguarsURI.jagRandomizer(msg.sender, babyJagSupply + 450);
        _mint(msg.sender, babyJagSupply + 450);
        updateBreedCosts();
    }
    
    function BreedBushBuck() public {
        require(breedingPaused == false,                    "Breeding is temporarily paused");
        require(balanceBushBuck[msg.sender] >= 2,           "Must own two genesis bush bucks to breed");
        require(babyBuckSupply + 1 <= maxBabyBuckSupply,    "Max amount of bush bucks bred");
        
        Thrive.burn(msg.sender, (breedCostBuck * 1000000000000000000));
        babyBuckSupply++;
        weightBushBuck[babyBuckSupply + 2250] = bushBucksURI.buckRandomizer(msg.sender, babyBuckSupply + 2250);
        _mint(msg.sender, babyBuckSupply + 2250);
        updateBreedCosts();
    }
    
    function BreedBananaTree() public {
        require(breedingPaused == false,                    "Breeding is temporarily paused");
        require(balanceBananaTree[msg.sender] >= 2,         "Must own two genesis banana trees to breed");
        require(babyTreeSupply + 1 <= maxBabyTreeSupply,    "Max amount of banana trees bred");     
    
        Thrive.burn(msg.sender, (breedCostTree * 1000000000000000000));
        babyTreeSupply++;
        weightBananaTree[babyTreeSupply + 5850] = bananaTreesURI.treeRandomizer(msg.sender, babyTreeSupply + 5850);
        _mint(msg.sender, babyTreeSupply + 5850);
        updateBreedCosts();
    }

    function upgrade(uint256 ecozID, uint8 numLevels) public {
        require(msg.sender == ownerOf(ecozID));
        if (ecozID > 0 && ecozID <= 450) {
            require(level[ecozID] + numLevels <= maxLevel);
            for(uint8 i; i < numLevels; i++) {
                Thrive.levelUpdate(msg.sender);
                weightJaguar[ecozID] = weightJaguar[ecozID] + 4;
                level[ecozID] = level[ecozID] + 1;
                Thrive.burn(msg.sender, ((breedCostJag - (breedCostJag % 3)) / 3) * 1000000000000000000);
            }
        }
        else if (ecozID > 1350 && ecozID <= 2250) {
            require(level[ecozID] + numLevels <= maxLevel);
            for(uint8 i; i < numLevels; i++) {
                Thrive.levelUpdate(msg.sender);
                weightBushBuck[ecozID] = weightBushBuck[ecozID] + 3;
                level[ecozID] = level[ecozID] + 1;
                Thrive.burn(msg.sender, ((breedCostBuck - (breedCostBuck % 3)) / 3) * 1000000000000000000);
            }
        }
        else if (ecozID > 4050 && ecozID <= 5850) {
            require(level[ecozID] + numLevels <= maxLevel);
            for(uint8 i; i < numLevels; i++) {
                Thrive.levelUpdate(msg.sender);
                weightBananaTree[ecozID] = weightBananaTree[ecozID] + 2;
                level[ecozID] = level[ecozID] + 1;
                Thrive.burn(msg.sender, ((breedCostTree - (breedCostTree % 3)) / 3) * 1000000000000000000);
            }
        }
        else {
            revert();
        }
    }
    
    function toggleBreeding() public onlyOwner {
        if (breedingPaused == true) {
            breedingPaused = false;
        }
        else {
            breedingPaused = true;
        }
    }

    function setThrive(address thriveAddress) external onlyOwner {
        Thrive = IThrive(thriveAddress);
    }

    function transferFrom(address from, address to, uint256 tokenID) public override {
        if (tokenID <= 1350) {
            if (tokenID <= 450) {
                Thrive.updateThrive(from, to);
                balanceJaguar[from]--;
                balanceJaguar[to]++;
                weightOfOwner[from] = weightOfOwner[from] - weightJaguar[tokenID];
                weightOfOwner[to] = weightOfOwner[to] + weightJaguar[tokenID];
            }

            ERC721.transferFrom(from, to, tokenID);
        }
        else if ((tokenID > 1350) && (tokenID <= 4050)) {
            if (tokenID <= 2250) {
                Thrive.updateThrive(from, to);
                balanceBushBuck[from]--;
                balanceBushBuck[to]++;
                weightOfOwner[from] = weightOfOwner[from] - weightBushBuck[tokenID];
                weightOfOwner[to] = weightOfOwner[to] + weightBushBuck[tokenID];
            }

            ERC721.transferFrom(from, to, tokenID);
        }
        else if (tokenID > 4050) {
            if (tokenID <= 5850) {
                Thrive.updateThrive(from, to);
                balanceBananaTree[from]--;
                balanceBananaTree[to]++;
                weightOfOwner[from] = weightOfOwner[from] - weightBananaTree[tokenID];
                weightOfOwner[to] = weightOfOwner[to] + weightBananaTree[tokenID];
            }

            ERC721.transferFrom(from, to, tokenID);
        }
    }

    function safeTransferFrom(address from, address to, uint256 tokenID) public override {
        if (tokenID <= 1350) {
            if (tokenID <= 450) {
                Thrive.updateThrive(from, to);
                balanceJaguar[from]--;
                balanceJaguar[to]++;
                weightOfOwner[from] = weightOfOwner[from] - weightJaguar[tokenID];
                weightOfOwner[to] = weightOfOwner[to] + weightJaguar[tokenID];
            }
                
            ERC721.safeTransferFrom(from, to, tokenID);
        }
        else if ((tokenID > 1350) && (tokenID <= 4050)) {
            if (tokenID <= 2250) {
                Thrive.updateThrive(from, to);
                balanceBushBuck[from]--;
                balanceBushBuck[to]++;
                weightOfOwner[from] = weightOfOwner[from] - weightBushBuck[tokenID];
                weightOfOwner[to] = weightOfOwner[to] + weightBushBuck[tokenID];
            }
                
            ERC721.safeTransferFrom(from, to, tokenID);
        }
        else if (tokenID > 4050) {
            if (tokenID <= 5850) {
                Thrive.updateThrive(from, to);
                balanceBananaTree[from]--;
                balanceBananaTree[to]++;
                weightOfOwner[from] = weightOfOwner[from] - weightBananaTree[tokenID];
                weightOfOwner[to] = weightOfOwner[to] + weightBananaTree[tokenID];
            }
                
            ERC721.safeTransferFrom(from, to, tokenID);
        }
    } 
                /*----------------------//
                //    READ FUNCTIONS    //
                //----------------------*/

    function jaguarPopulation() public view returns(uint256) {
        return jagSupply + babyJagSupply;
    }

     function bushBuckPopulation() public view returns(uint256) {
        return buckSupply + babyBuckSupply;
    }

     function bananaTreePopulation() public view returns(uint256) {
        return treeSupply + babyTreeSupply;
    }

    function totalPopulation() public view returns(uint256) {
        return jagSupply + buckSupply + treeSupply + babyJagSupply + babyBuckSupply + babyTreeSupply;
    }

    function getWeight(address user) external view returns(uint256) {
        require(msg.sender == address(Thrive));
        return weightOfOwner[user];
    }

    function tokenURI(uint256 tokenID) public view virtual override returns(string memory) {
        require((tokenID != 0) && (tokenID <= 9450),   "Ecoz TokenID does not exist");

        if (tokenID <= 1350) {
            return jaguarsURI.jaguarTokenURI(tokenID, weightJaguar[tokenID]);
        }
        else if ((tokenID > 1350) && (tokenID <= 4050)) {
            return bushBucksURI.bushBuckTokenURI(tokenID, weightBushBuck[tokenID]);
        }
        else {
            return bananaTreesURI.bananaTreeTokenURI(tokenID, weightBananaTree[tokenID]);
        }
    }
    
    //Simplified implementation of the Lotka-Volterra equations used to model predator/prey interactions in nature.
    function updateBreedCosts() internal {
        uint256 jagPopulation = jaguarPopulation();
        uint256 buckPopulation = bushBuckPopulation();
        uint256 treePopulation = bananaTreePopulation();
        
        if (((jagPopulation * 2) >= buckPopulation) && ((buckPopulation * 2) >= treePopulation)) {
            uint256 a = (jagPopulation * 2) - buckPopulation;
            uint256 b = (buckPopulation * 2) - treePopulation;
            for (uint8 i; i < populationRange.length; i++) {
                if (a == 0) {
                    breedCostJag = 600;
                    break;
                }
                if (a == populationRange[i]) {
                    breedCostJag = jagRangeOver[i];
                    break;
                }
                if (a > populationRange[11]) {
                    breedCostJag = jagRangeOver[12];
                    break;
                }
            }
            for (uint8 j; j < populationRange.length; j++) {
                if (b == 0) {
                    breedCostBuck = 480;
                    breedCostTree = 360;
                    break;
                }
                if (b == populationRange[j]) {
                    breedCostBuck = buckRangeOver[j];
                    breedCostTree = treeRangeUnder[j];
                    break;
                }
                if (b > populationRange[11]) {
                    breedCostBuck = buckRangeOver[12];
                    breedCostTree = treeRangeUnder[12];
                    break;
                }
            }
        }
        else if (((jagPopulation * 2) < buckPopulation) && ((buckPopulation * 2) < treePopulation)) {
            uint256 a = buckPopulation - (jagPopulation * 2);
            uint256 b = treePopulation - (buckPopulation * 2);
            for (uint8 i; i < populationRange.length; i++) {
                if (a == populationRange[i]) {
                    breedCostJag = jagRangeUnder[i];
                    break;
                }
                if (a > populationRange[11]) {
                    breedCostJag = jagRangeUnder[12];
                    break;
                }
            }
            for (uint8 j; j < populationRange.length; j++) {
                if (b == populationRange[j]) {
                    breedCostBuck = buckRangeUnder[j];
                    breedCostTree = treeRangeOver[j];
                    break;
                }
                if (b > populationRange[11]) {
                    breedCostBuck = buckRangeUnder[12];
                    breedCostTree = treeRangeOver[12];
                    break;
                }
            }
        }
        else if (((jagPopulation * 2) >= buckPopulation) && ((buckPopulation * 2) < treePopulation)) {
            uint256 a = (jagPopulation * 2) - buckPopulation;
            uint256 b = treePopulation - (buckPopulation * 2);
            for (uint8 i; i < populationRange.length; i++) {
                if (a == 0) {
                    breedCostJag = 600;
                    break;
                }
                if (a == populationRange[i]) {
                    breedCostJag = jagRangeOver[i];
                    break;
                }
                if (a > populationRange[11]) {
                    breedCostJag = jagRangeOver[12];
                    break;
                }
            }
            for (uint8 j; j < populationRange.length; j++) {
                if (b == populationRange[j]) {
                    breedCostBuck = buckRangeUnder[j];
                    breedCostTree = treeRangeOver[j];
                    break;
                }
                if (b > populationRange[11]) {
                    breedCostBuck = buckRangeUnder[12];
                    breedCostTree = treeRangeOver[12];
                    break;
                }
            }
        }
        else if (((jagPopulation * 2) < buckPopulation) && ((buckPopulation * 2) >= treePopulation)) {
            uint256 a = buckPopulation - (jagPopulation * 2);
            uint256 b = (buckPopulation * 2) - treePopulation;
            for (uint8 i; i < populationRange.length; i++) {
                if (a == populationRange[i]) {
                    breedCostJag = jagRangeUnder[i];
                    break;
                }
                if (a > populationRange[11]) {
                    breedCostJag = jagRangeUnder[12];
                    break;
                }
            }
            for (uint8 j; j < populationRange.length; j++) {
                if (b == 0) {
                    breedCostBuck = 480;
                    breedCostTree = 360;
                    break;
                }
                if (b == populationRange[j]) {
                    breedCostBuck = buckRangeOver[j];
                    breedCostTree = treeRangeUnder[j];
                    break;
                }
                if (b > populationRange[11]) {
                    breedCostBuck = buckRangeOver[12];
                    breedCostTree = treeRangeUnder[12];
                    break;
                }
            }
        }
    }
}