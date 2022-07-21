// SPDX-License-Identifier: MIT


// Amended by HashLips

/**
   __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
*/



pragma solidity ^0.8.0;

/**
 __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol



pragma solidity ^0.8.0;


/**
 __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
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

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol



pragma solidity ^0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
   __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
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
   __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
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

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol



pragma solidity ^0.8.0;

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

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol



pragma solidity ^0.8.0;


/**
 __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol



pragma solidity ^0.8.0;


/**
 * @dev _Available since v3.1._
 */
interface IERC1155Receiver is IERC165 {
    /**
        __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
    */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
      __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
    */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol



pragma solidity ^0.8.0;


/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
        external
        view
        returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol



pragma solidity ^0.8.0;


/**
 * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
 * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155MetadataURI is IERC1155 {
    /**
     * @dev Returns the URI for token type `id`.
     *
     * If the `\{id\}` substring is present in the URI, it must be replaced by
     * clients with the actual token type ID.
     */
    function uri(uint256 id) external view returns (string memory);
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol



pragma solidity ^0.8.0;







/**
 * @dev Implementation of the basic standard multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by Enjin: https://github.com/enjin/erc-1155
 *
 * _Available since v3.1._
 */
contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
    using Address for address;

    // Mapping from token ID to account balances
    mapping(uint256 => mapping(address => uint256)) private _balances;

    // Mapping from account to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
    string private _uri;

    /**
     * @dev See {_setURI}.
     */
    constructor(string memory uri_) {
        _setURI(uri_);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
    function uri(uint256) public view virtual override returns (string memory) {
        return _uri;
    }

    /**
     * @dev See {IERC1155-balanceOf}.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
        require(account != address(0), "ERC1155: balance query for the zero address");
        return _balances[id][account];
    }

    /**
     * @dev See {IERC1155-balanceOfBatch}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
        public
        view
        virtual
        override
        returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }

    /**
     * @dev See {IERC1155-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC1155-isApprovedForAll}.
     */
    function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[account][operator];
    }

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );
        _safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: transfer caller is not owner nor approved"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    /**
 __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
     */
    function _safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }
        _balances[id][to] += amount;

        emit TransferSingle(operator, from, to, id, amount);

        _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
            _balances[id][to] += amount;
        }

        emit TransferBatch(operator, from, to, ids, amounts);

        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
    }

    /**
      __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
     */
    function _setURI(string memory newuri) internal virtual {
        _uri = newuri;
    }

    /**
     * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function _mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);

        _balances[id][to] += amount;
        emit TransferSingle(operator, address(0), to, id, amount);

        _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; i++) {
            _balances[ids[i]][to] += amounts[i];
        }

        emit TransferBatch(operator, address(0), to, ids, amounts);

        _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
    }

    /**
     * @dev Destroys `amount` tokens of token type `id` from `from`
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `from` must have at least `amount` tokens of token type `id`.
     */
    function _burn(
        address from,
        uint256 id,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }

        emit TransferSingle(operator, from, address(0), id, amount);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     */
    function _burnBatch(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");

        for (uint256 i = 0; i < ids.length; i++) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
        }

        emit TransferBatch(operator, from, address(0), ids, amounts);
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
        require(owner != operator, "ERC1155: setting approval status for self");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     __         ______   ________         ______                                          
|  \       /      \ |        \       /      \                                         
| $$      |  $$$$$$\| $$$$$$$$      |  $$$$$$\  ______    ______   __    __   ______  
| $$       \$$__| $$| $$__          | $$ __\$$ /      \  /      \ |  \  |  \ /      \ 
| $$       /      $$| $$  \         | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\
| $$      |  $$$$$$ | $$$$$         | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$
| $$_____ | $$_____ | $$_____       | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$
| $$     \| $$     \| $$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$
 \$$$$$$$$ \$$$$$$$$ \$$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$ 
                                                                            | $$      
                                                                            | $$      
                                                                             \$$      
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {}

    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
                if (response != IERC1155Receiver.onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
                bytes4 response
            ) {
                if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
}

pragma solidity ^0.8.0;

contract L2EPassPrinter is ERC1155, Ownable {
    
  string public name;
  string public symbol;

  mapping(uint => string) public tokenURI;

  constructor() ERC1155("") {
    name = "[L2E]Pass";
    symbol = "L2E";
  }
  
  function mint(address _to, uint _id, uint _amount) external onlyOwner {
    _mint(_to, _id, _amount, "");
  }

  function mintBatch(address _to, uint[] memory _ids, uint[] memory _amounts) external onlyOwner {
    _mintBatch(_to, _ids, _amounts, "");
  }

  function burn(uint _id, uint _amount) external {
    _burn(msg.sender, _id, _amount);
  }

  function burnBatch(uint[] memory _ids, uint[] memory _amounts) external {
    _burnBatch(msg.sender, _ids, _amounts);
  }

  function burnForMint(address _from, uint[] memory _burnIds, uint[] memory _burnAmounts, uint[] memory _mintIds, uint[] memory _mintAmounts) external onlyOwner {
    _burnBatch(_from, _burnIds, _burnAmounts);
    _mintBatch(_from, _mintIds, _mintAmounts, "");
  }

  function setURI(uint _id, string memory _uri) external onlyOwner {
    tokenURI[_id] = _uri;
    emit URI(_uri, _id);
  }
  

  function uri(uint _id) public override view returns (string memory) {
    return tokenURI[_id];
  }

}