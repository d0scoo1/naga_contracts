// File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol


// OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)

pragma solidity ^0.8.0;

/**
 * @dev These functions deal with verification of Merkle Trees proofs.
 *
 * The proofs can be generated using the JavaScript library
 * https://github.com/miguelmota/merkletreejs[merkletreejs].
 * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
 *
 * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
 *
 * WARNING: You should avoid using leaf values that are 64 bytes long prior to
 * hashing, or use a hash function other than keccak256 for hashing leaves.
 * This is because the concatenation of a sorted pair of internal nodes in
 * the merkle tree could be reinterpreted as a leaf value.
 */
library MerkleProof {
    /**
     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
     * defined by `root`. For this, a `proof` must be provided, containing
     * sibling hashes on the branch from the leaf to the root of the tree. Each
     * pair of leaves and each pair of pre-images are assumed to be sorted.
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    /**
     * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
     * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
     * hash matches the root of the tree. When processing the proof, the pairs
     * of leafs & pre-images are assumed to be sorted.
     *
     * _Available since v4.4._
     */
    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if (computedHash <= proofElement) {
                // Hash(current computed hash + current element of the proof)
                computedHash = _efficientHash(computedHash, proofElement);
            } else {
                // Hash(current element of the proof + current computed hash)
                computedHash = _efficientHash(proofElement, computedHash);
            }
        }
        return computedHash;
    }

    function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

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

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;


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
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: @openzeppelin/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: @openzeppelin/contracts/utils/Address.sol


// OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)

pragma solidity ^0.8.1;

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
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
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

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

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

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;


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

// File: contracts/eggstaking.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/**
 * @title BBD Staking Platform
 * @author Decentralized Devs - Angelo
 */










interface IEgg {
	function mintFromExtentionContract(address _to, uint256 _amount) external;
}

contract DinoFamEggStaking is  Ownable{
    using SafeMath for uint256;
    bool public paused = false;
	IERC721 BBD;
    IERC721 CD;
    IEgg egg;

    uint256 public BADBAYDINO_REWARD = 1 ether;
    uint256 public CAVEDINO_REWARD = 2 ether;
    uint256 public BOTHSTAKED_REWARD = 10 ether;
    uint256 public SPECIALID_REWARD = 10 ether;

    //specialtokenRange
    uint256 public specialTokenRange = 12223;
    uint256 public CAVEDINO_SEPERATOR = 10001;

    mapping(uint256 => uint256) public lastClaimTime;
    mapping(uint256 => address) public tokenIdOwners;
    //user address => []
    mapping(address => mapping(uint256 => uint256)) public ownerTokenIds;
    mapping(address => uint256) public numberTokensStaked;
    mapping(address => uint256) public _balances;
    mapping(address => bool) public staff;
    
  
   
    modifier onlyAllowedContracts {
        require(staff[msg.sender] || msg.sender == owner());
        _;
    }

    constructor(address _badBabyDinosNFtAddress, address _caveDinosAddress, address _tokenAddress){
		
		BBD = IERC721(_badBabyDinosNFtAddress);
        CD = IERC721(_caveDinosAddress);
        egg = IEgg(_tokenAddress);

	}

    function _makeId(bool isBBD, uint256 _val) internal view returns(uint256){
       if(isBBD){
           return _val;
       }else{
            return _val + CAVEDINO_SEPERATOR;
       }
    }

    function _isIDBbd(uint256 _id) internal view returns(bool){
        return _id < CAVEDINO_SEPERATOR ? true:false;
    }

    function _getId(uint256 _id) internal view returns(uint256){
        return _id<CAVEDINO_SEPERATOR? _id: (_id - CAVEDINO_SEPERATOR);
    }

    function setTokenAddress(address _val) public onlyOwner{
        egg = IEgg(_val);
    }

    

     function setNftAddress(bool _isBBD, address _val) public onlyOwner{
       if(_isBBD){
           BBD = IERC721(_val);
       
       }else{
            CD = IERC721(_val);
       }
    }

    

    function setRewards(bool isBBD, uint256 _amount) public onlyOwner{
        if(isBBD){
                BADBAYDINO_REWARD = _amount;
        }else {
            CAVEDINO_REWARD = _amount;
           }
    }

    function _mint(address user, uint256 amount) internal {
        egg.mintFromExtentionContract(user,amount);
    }

    function _syncTime(address _user, uint256 _time) internal {
        uint256 len = numberTokensStaked[_user]; 
        unchecked {
            for (uint256 i = 0; i < len; ++i) {
                uint256 tid = ownerTokenIds[_user][i];
                lastClaimTime[tid] = _time;
            }
        }
    }
    function stake(uint256[] calldata tokenIds, bool[] calldata isBBDContract ) public  {
        require(!paused, "Contract is paused");
        require(tokenIds.length > 0, "Require More than 1 to stake");

        //calculate rewards for older staked tokens and sync
        if(numberTokensStaked[msg.sender] > 0){
             uint256 lastIndex = numberTokensStaked[msg.sender] - 1;
             uint256 tid = ownerTokenIds[msg.sender][lastIndex];
             uint256 lastUpdated = lastClaimTime[tid];
             //cal rewards 
             uint256 oldRewards = getRewardInfo(msg.sender);
             uint256 calRewards = _calculateTokenRewards(block.timestamp, lastUpdated, oldRewards);
             //update balance
             _balances[msg.sender] += calRewards;
             //synctime
             _syncTime(msg.sender, block.timestamp);
        }
       


        for (uint256 i = 0; i < tokenIds.length; ++i) {
            bool isBBDC = isBBDContract[i];
            uint256 tokenId = tokenIds[i];
            uint256 formattedTokenId = _makeId(isBBDC, tokenId);
            address owner;
            if(isBBDC){
                owner  = BBD.ownerOf(tokenId);
            require(
                owner == msg.sender,
                "BBDStaking: you don't own the token on BBD Contract"
            );
            }else{
                 owner = CD.ownerOf(tokenId);
            require(
                owner == msg.sender,
                "BBDStaking: you don't own the token on CD Contract"
            );
            }

            require(
                tokenIdOwners[tokenId] == address(0),
                "StakingERC20: This token is already staked"
            );

            lastClaimTime[formattedTokenId] = block.timestamp;
            tokenIdOwners[formattedTokenId] = owner;
            ownerTokenIds[owner][numberTokensStaked[owner]] = formattedTokenId;
            numberTokensStaked[owner]++;
           if(isBBDC){
                BBD.transferFrom(msg.sender,address(this),tokenId);
           }else{
                CD.transferFrom(msg.sender,address(this),tokenId);
           }
        }
    }

     function overideTranser(address _user, uint256 _id, bool isBBDContract) public onlyOwner{
         if(isBBDContract){
             BBD.transferFrom(
            address(this),
            _user,
            _id
        );
         }else{
               CD.transferFrom(
            address(this),
            _user,
            _id
        );
         }
    }

    function setStaffState(address _address, bool _state) public onlyOwner {
        staff[_address] = _state;
    }

    function togglePause() public onlyOwner {
		paused = !paused;
	}


    	

    function claimRewards(address _user) public {
        uint256 c = getStakingRewards(_user);
        _resetBal(_user);
        _syncTime(_user, block.timestamp);
        _mint(_user, c);
    }

    function unstake(uint256[] calldata tokenIds) public   {
       
       
        
       unchecked {
            for (uint256 i = 0; i < tokenIds.length; ++i) {
           
            uint tokenId = tokenIds[i];
            uint formattedTokenId = _getId(tokenId);
            bool isBBDC = _isIDBbd(tokenId);

            require(
                tokenIdOwners[tokenId] == msg.sender,
                "StakingERC20: You don't own this token"
            );

           //mint rewards
             uint256 c = getStakingRewardsSingle(tokenId);
            _mint(msg.sender, c);
            tokenIdOwners[tokenId] = address(0);
           for (uint256 j = 0; j < numberTokensStaked[msg.sender]; ++j) {
                    if (ownerTokenIds[msg.sender][j] == tokenId) {
                        uint256 lastIndex = numberTokensStaked[msg.sender] - 1;
                        ownerTokenIds[msg.sender][j] = ownerTokenIds[msg.sender][
                            lastIndex
                        ];
                        delete ownerTokenIds[msg.sender][lastIndex];
                        break;
                    }
                }
            numberTokensStaked[msg.sender]--;
             if(isBBDC){
                BBD.transferFrom(
            address(this),
            msg.sender,
            formattedTokenId
        );
            }else{
                 BBD.transferFrom(
            address(this),
            msg.sender,
            formattedTokenId
        );
        }
    }
       }

       
    }

    function _calculateTokenRewards(
        uint256 currenTime,
        uint256 lastClaimed,
        uint256 reward
    ) internal pure  returns (uint256) {
        return reward.mul(currenTime.sub(lastClaimed)).div(86400);
    }

    function getUserstakedIds(address _user) public view returns (uint256[] memory){
        uint256 len = numberTokensStaked[_user];
        uint256[] memory temp = new uint[](len);
        for (uint256 i = 0; i < len; ++i) {
             temp[i] = ownerTokenIds[_user][i];
        }
        return temp;
    }


    function getStakingRewardsSingle(uint256 tokenId) public view returns (uint256) {
            uint256 lastClaimed = lastClaimTime[tokenId];
            //check ID from which contract 
            bool isBBDc = _isIDBbd(tokenId);
            if(tokenId >= 10001 && tokenId <= specialTokenRange){
                 return _calculateTokenRewards(block.timestamp, lastClaimed, SPECIALID_REWARD);
            }else{
                 return _calculateTokenRewards(block.timestamp, lastClaimed, isBBDc?BADBAYDINO_REWARD:CAVEDINO_REWARD);
            }
      }
      function decimals() pure internal returns (uint8) {
        return 18;
    }

    
  function setSpecialIdReward(uint256 _val) public onlyOwner{
        SPECIALID_REWARD = _val;
    }

    function setBothStakedReward(uint256 _val) public onlyOwner{
        BOTHSTAKED_REWARD = _val;
    }


    function getTokenReward(uint256 _id) view  internal returns (uint256) {
        bool isBBDc = _isIDBbd(_id);
         if(_id >= 10001 && _id <= specialTokenRange){ 
            return SPECIALID_REWARD;
        }else{
            return isBBDc?BADBAYDINO_REWARD:CAVEDINO_REWARD;
        }
    }


    function getStakingRewards(address _user) public view returns (uint256) {
        uint256 reward =  getRewardInfo(_user);
        if(numberTokensStaked[msg.sender] > 0){
            uint256 lastIndex = numberTokensStaked[msg.sender] - 1;
            uint256 tid = ownerTokenIds[msg.sender][lastIndex];
            uint256 lastUpdated = lastClaimTime[tid];
            uint256 calRewards = _calculateTokenRewards(block.timestamp, lastUpdated, reward);
            uint256 oldBalance = _balances[msg.sender];
            return  calRewards + oldBalance;
        }else{
            return 0;
        }
      }

      function _resetBal(address _user) internal {
          _balances[_user] = 0;
      }


    function getRewardInfo(address _user)
        public
        view
        returns (
            uint256
        )
    {
        uint256 len = numberTokensStaked[_user];
        uint256 babyBabyDinoCount;
        uint256 caveDinoCount;
        uint256 specialIdCount;
        
        unchecked {
            for (uint256 i = 0; i < len; ++i) {

                uint256 tid = ownerTokenIds[_user][i];
           
            if (tid < CAVEDINO_SEPERATOR) {
                //bad baby token
                    babyBabyDinoCount++;
            } else {
                //cave dino token
                   if(tid >= 10001 && tid <= specialTokenRange){
                        specialIdCount++;
                    }
                    caveDinoCount++;
                
            }  
        }
        }

         //logic
            if (babyBabyDinoCount >= caveDinoCount) {
                uint256 bal = babyBabyDinoCount - caveDinoCount;
                if ((bal) == 0) {
                   
                    return calculateRewards(0, 0, babyBabyDinoCount, specialIdCount);
                } else {
                      return calculateRewards(bal, 0, caveDinoCount, specialIdCount);
                }
            } else {
                
                uint256 bal = caveDinoCount - babyBabyDinoCount;
                if ((bal) == 0) {
                    return calculateRewards(0, 0, caveDinoCount, specialIdCount);
                } 
                else if(bal == caveDinoCount){
                 
                    return calculateRewards(0, caveDinoCount, 0, specialIdCount);
                }
                else {
                      return calculateRewards(0, bal, babyBabyDinoCount, specialIdCount);
                }
            } 
    }

     function calculateRewards(uint256 badbabycount, uint256 cavedinocount, uint256 pairs, uint256 specials) public view returns (uint256){
             if(specials > 0 ){
                   if(specials >= cavedinocount){
                        if(pairs == 0){
                              return (badbabycount * BADBAYDINO_REWARD) + (pairs * BOTHSTAKED_REWARD) + (cavedinocount * SPECIALID_REWARD);
                        }else{
                              return (badbabycount * BADBAYDINO_REWARD) + (pairs * BOTHSTAKED_REWARD) + (specials * SPECIALID_REWARD);
                        }
                   }else{
                         uint a = cavedinocount - specials;
                         return (badbabycount * BADBAYDINO_REWARD) + (a * CAVEDINO_REWARD) +  (pairs * BOTHSTAKED_REWARD) + (specials * SPECIALID_REWARD);
                    }
                    }else{
                            return (badbabycount * BADBAYDINO_REWARD) + (cavedinocount * CAVEDINO_REWARD) +  (pairs * BOTHSTAKED_REWARD);
                    }
            }
}