/**
 *Submitted for verification at Etherscan.io on 2021-12-22
*/

// SPDX-License-Identifier: MIT

/***
*   .----------------.  .----------------.  .----------------.  .----------------. 
*  | .--------------. || .--------------. || .--------------. || .--------------. |
*  | | ____    ____ | || |  _________   | || |     _____    | || | ____   ____  | |
*  | ||_   \  /   _|| || | |  _   _  |  | || |    |_   _|   | || ||_  _| |_  _| | |
*  | |  |   \/   |  | || | |_/ | | \_|  | || |      | |     | || |  \ \   / /   | |
*  | |  | |\  /| |  | || |     | |      | || |      | |     | || |   \ \ / /    | |
*  | | _| |_\/_| |_ | || |    _| |_     | || |     _| |_    | || |    \ ' /     | |
*  | ||_____||_____|| || |   |_____|    | || |    |_____|   | || |     \_/      | |
*  | |              | || |              | || |              | || |              | |
*  | '--------------' || '--------------' || '--------------' || '--------------' |
*   '----------------'  '----------------'  '----------------'  '----------------' 
***/ 

pragma solidity ^0.8.10;

// 1. LIBRARIES

// File @openzeppelin/contracts/utils/Context.sol@v4.4.1
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

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


// File @openzeppelin/contracts/utils/Address.sol@v4.4.1
// OpenZeppelin Contracts v4.4.1 (utils/Address.sol)

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

// File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

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
        _transferOwnership(_msgSender());
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
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.1
// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)

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

// 2. ERC721 STANDARD INTERFACES

// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.1
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

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


// File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.1
// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)


// File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.1
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)

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


// File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.1
// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)

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


// File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.1
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)

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

// File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.1
// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Enumerable is IERC721 {
    /**
     * @dev Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256);
}

// 3. ERC721 STANDARD IMPLEMENTATIONS

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

// File contracts/ERC721MTIV.sol

abstract contract ERC721MTIV is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;

    // Token name
    string private _name;
    // Token symbol
    string private _symbol;
    // Array in which each index represents a token and hold its owner address
    address[] internal _owners;
    // Mapping from token ID to approved address
    mapping(uint256 => address) private _transferTokenApprovals;
    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _transferOperatorApprovals;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }
    
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
        interfaceId == type(IERC721).interfaceId ||
        interfaceId == type(IERC721Metadata).interfaceId ||
        super.supportsInterface(interfaceId);
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721MTIV: Owner query for token that does not exist yet");
        return owner;
    }

    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721MTIV: Balance query for the zero address");
        uint count = 0;
        uint length = _owners.length;
        for( uint i = 0; i < length; ++i ){
            if( owner == _owners[i] ){
                ++count;
            }
        }
        delete length;
        return count;
    }
    
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721MTIV.ownerOf(tokenId);
        require(to != owner, "ERC721MTIV: Approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721MTIV: Approve caller is not owner nor approved for all"
        );


        delete owner;

        _approve(to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal virtual {
        _transferTokenApprovals[tokenId] = to;
        emit Approval(ERC721MTIV.ownerOf(tokenId), to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721MTIV: Approve to caller");

        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits a {ApprovalForAll} event.
     */
    function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
         _transferOperatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721MTIV: Approved query for token that does not exist yet");

        return _transferTokenApprovals[tokenId];
    }
   
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _transferOperatorApprovals[owner][operator];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721MTIV: Transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721MTIV: Transfer caller is not owner nor approved");
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
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721MTIV: Transfer to non ERC721Receiver implementer");
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721MTIV.ownerOf(tokenId) == from, "ERC721MTIV: Transfer of token that is not own");
        require(to != address(0), "ERC721MTIV: Transfer to the zero address");

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
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
        return tokenId < _owners.length && _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721MTIV: Operator query for token that does not exist yet");
        address owner = ERC721MTIV.ownerOf(tokenId);
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
            "ERC721MTIV: Transfer to non ERC721Receiver implementer"
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
        require(to != address(0), "ERC721MTIV: Mint to the zero address");
        require(!_exists(tokenId), "ERC721MTIV: Token already minted");

        _owners.push(to);

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
        address owner = ERC721MTIV.ownerOf(tokenId);

        // Clear approvals
        _approve(address(0), tokenId);
        _owners[tokenId] = address(0);

        emit Transfer(owner, address(0), tokenId);
    }

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
}

// File contracts/ERC721EnumMTIV.sol

abstract contract ERC721EnumMTIV is ERC721MTIV, IERC721Enumerable {
    
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721MTIV) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
        require(index < ERC721MTIV.balanceOf(owner), "ERC721EnumMTIV: Index greater than number of tokens owned");
        uint ownedNftInd;
        for( uint i; i < ERC721MTIV._owners.length; ++i ){
            if( owner == ERC721MTIV._owners[i] ){
                if( ownedNftInd == index ) {
                    delete ownedNftInd;
                    return i;
                } else {
                    ++ownedNftInd;
                }
            }
        }
        delete ownedNftInd;
        require(false, "ERC721EnumMTIV: No token found for the index");
    }

    function tokensOfOwner(address owner) public view returns (uint256[] memory) {
        uint256 noTokens = ERC721MTIV.balanceOf(owner);
        uint256 ownersLength = ERC721MTIV._owners.length;
        
        uint256 resultIdx = 0;
        uint256[] memory tokenIds = new uint256[](noTokens);
        
        for (uint256 i = 0; i < ownersLength; ++i) {
            if (owner == ERC721MTIV._owners[i]) {
                tokenIds[resultIdx] = i;
                ++resultIdx;
            }
        }

        delete noTokens;
        delete resultIdx;
        delete ownersLength;

        return tokenIds;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _owners.length;
    }
    
    function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
        require(index < ERC721EnumMTIV.totalSupply(), "ERC721EnumMTIV: Token does not exist yet");
        return index;
    }
}

//4. CONTRACT

// File contracts/MetaverseInvadersContract.sol

interface ITransferable {
    function invaderTransfered(address _from, address _to, uint256 _tokenId) external;
}

contract MetaverseInvadersContract is ERC721EnumMTIV, Ownable, ReentrancyGuard {
    using Strings for uint256;

    address public trustedContract = address(0);

    //max number of NFTs (Invaders)
    uint256 constant private MAX_SUPPLY = 9777;

    //invaders that will help us building community
    uint256 private FOUNDERS_RESERVED_MINTS = 77;

    //start/stop PRESALE phase
    bool public isPresaleActive = false;

    //max amount of Invaders to mint per address - PRESALE
    uint256 private MAX_PRESALE_MINT = 2;

    //addresses allowed to mint Invaders during presale
    mapping(address => bool) private presaleWhitelist;

    //map how many Invaders an address has minted during presale
    mapping(address => uint256) private presaleMints;

    //start/stop SALE phase
    bool public isSaleActive = false;

    //max amount of Invaders to mint per transaction - SALE
    uint256 private MAX_SALE_MINT = 7;

    //Cost of MINT
    uint256 private COST = 0.077 ether;

    //UNREVEALED_URI
    string private UNREVEALED_URI;
    bool public isRevealActive = false;

    //storage
    string private BASE_URI;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721MTIV(_name, _symbol) {}

    function _unrevealedUri() internal view virtual returns (string memory) {
        return UNREVEALED_URI;
    }

    function _baseURI() internal view virtual returns (string memory) {
        return BASE_URI;
    }

    function _publicSupply() internal view virtual returns (uint256) {
        return MAX_SUPPLY - FOUNDERS_RESERVED_MINTS;
    }

    function _transferNotice(address _from, address _to, uint256 _tokenId) internal {
        if (trustedContract != address(0)) {
            ITransferable(trustedContract).invaderTransfered(_from, _to, _tokenId);
        }
    }

    // external
    function isWhitelisted (address _address) external view returns (bool) {
        return presaleWhitelist[_address];
    }

    function setTrustedContract(address _contractAddress) external onlyOwner {
        trustedContract = _contractAddress;
    }

    function flipPresaleState() external onlyOwner {
        isPresaleActive = !isPresaleActive;
    }

    function flipSaleState() external onlyOwner {
        isSaleActive = !isSaleActive;
    }

    function flipRevealState() external onlyOwner {
        isRevealActive = !isRevealActive;
    }

    //SALE MINT
    function mintInvaders(uint256 _noInvaders) 
        external 
        payable 
    {
        require(isSaleActive, "MTIV: Sale is not active");
        require(_noInvaders > 0, "MTIV: Minted amount should be positive" );
        require(_noInvaders <= MAX_SALE_MINT, "MTIV: Minted amount exceeds sale limit" );

        uint256 totalSupply = ERC721EnumMTIV.totalSupply();

        require(totalSupply + _noInvaders <= _publicSupply(), "MTIV: The requested amount exceeds the remaining supply" );
        require(msg.value >= COST * _noInvaders , "MTIV: Provided funds are not enough for buying");

        for (uint256 i = 0; i < _noInvaders; i++) {
            _safeMint(msg.sender, totalSupply + i);
        }

        delete totalSupply;
    }

    //PRESALE MINT
    function presaleMintInvaders(uint256 _noInvaders) 
        external 
        payable 
    {
        require(isPresaleActive, "MTIV: Presale is not active");
        require(presaleWhitelist[msg.sender], "MTIV: Caller is not whitelisted");
        require(_noInvaders > 0, "MTIV: Minted amount should be positive" );

        uint256 totalSupply = ERC721EnumMTIV.totalSupply();
        uint256 availableMints = MAX_PRESALE_MINT - presaleMints[msg.sender];

        require(_noInvaders <= availableMints, "MTIV: Too many invaders requested");
        require(totalSupply + _noInvaders <= _publicSupply(), "MTIV: The requested amount exceeds the remaining supply");
        require(msg.value >= COST * _noInvaders , "MTIV: Provided funds are not enough for buying");

        presaleMints[msg.sender] += _noInvaders;

        for(uint256 i = 0; i < _noInvaders; i++){
            _safeMint(msg.sender, totalSupply + i);
        }

        delete totalSupply;
        delete availableMints;
    }

    function withdraw() 
        external 
        onlyOwner 
    {
        require(address(this).balance > 0, "MTIV: No funds to withdraw");
        require(payable(msg.sender).send(address(this).balance));
    }

    function setWhitelistedAddresses(address[] calldata _whitelistedAddresses) 
        external 
        onlyOwner 
    {
        for (uint256 i = 0; i < _whitelistedAddresses.length; i++) {
            require(_whitelistedAddresses[i] != address(0), "MTIV: Null address is not allowed");
            presaleWhitelist[_whitelistedAddresses[i]] = true;
        }
    }

    function setCost(uint256 _newCost) external onlyOwner {
        COST = _newCost;
    }

    function setMaxPresaleMintAmount(uint256 _newMaxPresaleMintAmount) 
        external 
        onlyOwner 
    {
        MAX_PRESALE_MINT = _newMaxPresaleMintAmount;
    }

    function setMaxMintAmount(uint256 _newMaxMintAmount) 
        external 
        onlyOwner 
    {
        MAX_SALE_MINT = _newMaxMintAmount;
    }

    function setStockReserverdFounders(uint256 _newStockReservedFounders) 
        external 
        onlyOwner 
    {
        FOUNDERS_RESERVED_MINTS = _newStockReservedFounders;
    }

    function changeUnrevealedUri(string memory _newUnrevealedUri) 
        external 
        onlyOwner 
    {
        UNREVEALED_URI = _newUnrevealedUri;
    }

    function changeBaseUri(string memory _newBaseUri) 
        external 
        onlyOwner 
    {
        BASE_URI = _newBaseUri;
    }

    function tokenURI(uint256 _tokenId) 
        external 
        view 
        virtual 
        override 
        returns (string memory) 
    {
        require(_exists(_tokenId), "ERC721Metadata: Token does not exist yet");

        if (isRevealActive) {
            string memory currentBaseURI = _baseURI();
            return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
        } else {
            string memory unrevealedUri = _unrevealedUri();
            return bytes(unrevealedUri).length > 0	? unrevealedUri : "";
        }

    }

    // founders minting
    function reservedFounders(address _to, uint256 _noInvaders) 
        external 
        onlyOwner 
    {
        uint256 supply = ERC721EnumMTIV.totalSupply();

        require(_noInvaders > 0, "MTIV: Minted amount must be greater than 0");
        require(_noInvaders <= FOUNDERS_RESERVED_MINTS, "MTIV: Not enough reserve left for team");

        for (uint256 i = 0; i < _noInvaders; i++) {
            _safeMint(_to, supply + i);
        }

        FOUNDERS_RESERVED_MINTS -= _noInvaders;

        delete supply;
    }

    // No of Invaders remained for the founders
    function stockReservedFounders() 
        external  
        view
        returns (uint256)
    {
        return FOUNDERS_RESERVED_MINTS;
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) 
        public 
        override 
    {
        super.safeTransferFrom(_from, _to, _tokenId);
        _transferNotice(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
        public 
        override 
    {
        super.safeTransferFrom(_from, _to, _tokenId);
        _transferNotice(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) 
        public 
        override 
    {
        super.safeTransferFrom(_from, _to, _tokenId, _data);
        _transferNotice(_from, _to, _tokenId);
    }
}