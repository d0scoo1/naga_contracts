pragma solidity ^0.5.0;


/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor() internal {}

    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() public {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

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
    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

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
    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);

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
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC1155 {
    // Events

    /**
     * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
     *   Operator MUST be msg.sender
     *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
     *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
     *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
     *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
     */
    event TransferSingle(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _amount
    );

    /**
     * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
     *   Operator MUST be msg.sender
     *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
     *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
     *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
     *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
     */
    event TransferBatch(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _amounts
    );

    /**
     * @dev MUST emit when an approval is updated
     */
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    /**
     * @dev MUST emit when the URI is updated for a token ID
     *   URIs are defined in RFC 3986
     *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
     */
    event URI(string _amount, uint256 indexed _id);

    /**
     * @notice Transfers amount of an _id from the _from address to the _to address specified
     * @dev MUST emit TransferSingle event on success
     * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
     * MUST throw if `_to` is the zero address
     * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
     * MUST throw on any other error
     * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     * @param _from    Source address
     * @param _to      Target address
     * @param _id      ID of the token type
     * @param _amount  Transfered amount
     * @param _data    Additional data with no specified format, sent in call to `_to`
     */
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _amount,
        bytes calldata _data
    ) external;

    /**
     * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
     * @dev MUST emit TransferBatch event on success
     * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
     * MUST throw if `_to` is the zero address
     * MUST throw if length of `_ids` is not the same as length of `_amounts`
     * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
     * MUST throw on any other error
     * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
     * @param _from     Source addresses
     * @param _to       Target addresses
     * @param _ids      IDs of each token type
     * @param _amounts  Transfer amounts per token type
     * @param _data     Additional data with no specified format, sent in call to `_to`
     */
    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _amounts,
        bytes calldata _data
    ) external;

    /**
     * @notice Get the balance of an account's Tokens
     * @param _owner  The address of the token holder
     * @param _id     ID of the Token
     * @return        The _owner's balance of the Token type requested
     */
    function balanceOf(address _owner, uint256 _id)
        external
        view
        returns (uint256);

    /**
     * @notice Get the balance of multiple account/token pairs
     * @param _owners The addresses of the token holders
     * @param _ids    ID of the Tokens
     * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
     */
    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids)
        external
        view
        returns (uint256[] memory);

    /**
     * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
     * @dev MUST emit the ApprovalForAll event on success
     * @param _operator  Address to add to the set of authorized operators
     * @param _approved  True if the operator is approved, false to revoke approval
     */
    function setApprovalForAll(address _operator, bool _approved) external;

    /**
     * @notice Queries the approval status of an operator for a given owner
     * @param _owner     The owner of the Tokens
     * @param _operator  Address of authorized operator
     * @return           True if the operator is approved, false if not
     */
    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool);
}

interface IERC1155Metadata {
    /***********************************|
    |     Metadata Public Function s    |
    |__________________________________*/

    /**
     * @notice A distinct Uniform Resource Identifier (URI) for a given token.
     * @dev URIs are defined in RFC 3986.
     *      URIs are assumed to be deterministically generated based on token ID
     *      Token IDs are assumed to be represented in their hex format in URIs
     * @return URI string
     */
    function uri(uint256 _id) external view returns (string memory);
}

library Strings {
    // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c,
        string memory _d,
        string memory _e
    ) internal pure returns (string memory) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde =
            new string(
                _ba.length + _bb.length + _bc.length + _bd.length + _be.length
            );
        bytes memory babcde = bytes(abcde);
        uint256 k = 0;
        for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c,
        string memory _d
    ) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c
    ) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(string memory _a, string memory _b)
        internal
        pure
        returns (string memory)
    {
        return strConcat(_a, _b, "", "", "");
    }

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + (_i % 10)));
            _i /= 10;
        }
        return string(bstr);
    }
}

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath#mul: OVERFLOW");

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath#sub: UNDERFLOW");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath#add: OVERFLOW");

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
        return a % b;
    }
}

/**
 * Copyright 2018 ZeroEx Intl.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *   http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Utility library of inline functions on addresses
 */
library Address {
    /**
     * Returns whether the target address is a contract
     * @dev This function will return false if invoked during the constructor of a contract,
     * as the code is not actually created until after the constructor finishes.
     * @param account address of the account to check
     * @return whether the target address is a contract
     */
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;

        bytes32 accountHash =
            0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // XXX Currently there is no better way to check if there is a contract in an address
        // than to check the size of the code at that address.
        // See https://ethereum.stackexchange.com/a/14016/36603
        // for more details about how this works.
        // TODO Check this again before the Serenity release, because all addresses will be
        // contracts then.
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

// SPDX-License-Identifier: MIT
/////////////////////////////////////////////////
//  ____                        _   _          //
// | __ )    ___    _ __     __| | | |  _   _  //
// |  _ \   / _ \  | '_ \   / _` | | | | | | | //
// | |_) | | (_) | | | | | | (_| | | | | |_| | //
// |____/   \___/  |_| |_|  \__,_| |_|  \__, | //
//                                      |___/  //
/////////////////////////////////////////////////
contract BondlySwap is Ownable {
    using Strings for string;
    using SafeMath for uint256;
    using Address for address;

    // TokenType Definition
    enum TokenType {T20, T1155, T721}

    // SwapType Definition
    enum SwapType {TimedSwap, FixedSwap}

    struct Collection {
        address[] cardContractAddrs;
        uint256[] cardTokenIds; // amount for T20
        TokenType[] tokenTypes;
        uint256 nLength;
        address collectionOwner;
    }

    struct BSwap {
        uint256 totalAmount;
        uint256 currentAmount;
        Collection maker;
        bool isPrivate;
        uint256 startTime;
        uint256 endTime;
        bool isActive;
        SwapType swapType;
        Collection target;
        uint256 nAllowedBiddersLength;
        mapping(address => bool) allowedBidders;
    }

    mapping(uint256 => BSwap) private listings;
    uint256 public listIndex;

    uint256 public platformFee;
    address payable public feeCollector;
    uint256 public t20Fee;

    address private originCreator;

    // apply 0 fee to our NFTs
    mapping(address => bool) public whitelist;

    mapping(address => bool) public supportTokens;

    bool private emergencyStop;

    event AddedNewToken(address indexed tokenAddress);
    event BatchAddedNewToken(address[] tokenAddress);
    event NFTListed(uint256 listId, address indexed lister);
    event ListVisibilityChanged(uint256 listId, bool isPrivate);
    event ListEndTimeChanged(uint256 listId, uint256 endTime);
    event NFTSwapped(uint256 listId, address indexed buyer, uint256 count);
    event NFTClosed(uint256 listId, address indexed closer);

    event WhiteListAdded(address indexed addr);
    event WhiteListRemoved(address indexed addr);
    event BatchWhiteListAdded(address[] addr);
    event BatchWhiteListRemoved(address[] addr);

    constructor() public {
        originCreator = msg.sender;
        emergencyStop = false;
        listIndex = 0;

        platformFee = 1;
        feeCollector = msg.sender;
        t20Fee = 5;
    }

    modifier onlyNotEmergency() {
        require(emergencyStop == false, "BSwap: emergency stop");
        _;
    }

    modifier onlyValidList(uint256 listId) {
        require(listIndex >= listId, "Bswap: list not found");
        _;
    }

    modifier onlyListOwner(uint256 listId) {
        require(
            listings[listId].maker.collectionOwner == msg.sender || isOwner(),
            "Bswap: not your list"
        );
        _;
    }

    function _addNewToken(address contractAddr)
        public
        onlyOwner
        returns (bool)
    {
        require(
            supportTokens[contractAddr] == false,
            "BSwap: already supported"
        );
        supportTokens[contractAddr] = true;

        emit AddedNewToken(contractAddr);
        return true;
    }

    function _batchAddNewToken(address[] memory contractAddrs)
        public
        onlyOwner
        returns (bool)
    {
        for (uint256 i = 0; i < contractAddrs.length; i++) {
            require(
                supportTokens[contractAddrs[i]] == false,
                "BSwap: already supported"
            );
            supportTokens[contractAddrs[i]] = true;
        }

        emit BatchAddedNewToken(contractAddrs);
        return true;
    }

    function _sendToken(
        TokenType tokenType,
        address contractAddr,
        uint256 tokenId,
        address from,
        address to
    ) internal {
        if (tokenType == TokenType.T1155) {
            IERC1155(contractAddr).safeTransferFrom(from, to, tokenId, 1, "");
        } else if (tokenType == TokenType.T721) {
            IERC721(contractAddr).safeTransferFrom(from, to, tokenId, "");
        } else {
            IERC20(contractAddr).transferFrom(from, to, tokenId);
        }
    }

    function createSwap(
        uint256[] memory arrTokenTypes,
        address[] memory arrContractAddr,
        uint256[] memory arrTokenIds,
        uint256 swapType,
        uint256 endTime,
        bool _isPrivate,
        address[] memory bidders,
        uint256 batchCount
    ) public payable onlyNotEmergency {
        bool isWhitelisted = false;

        require(
            arrContractAddr.length == arrTokenIds.length &&
                arrTokenIds.length == arrTokenTypes.length,
            "BSwap: array lengths are different"
        );
        require(
            arrContractAddr.length > 1,
            "BSwap: expected more than 1 desire"
        );
        require(batchCount >= 1, "BSwap: expected more than 1 count");
        for (uint256 i = 0; i < arrTokenTypes.length; i++) {
            require(
                supportTokens[arrContractAddr[i]] == true,
                "BSwap: not supported"
            );

            if (isWhitelisted == false) {
                isWhitelisted = whitelist[arrContractAddr[i]];
            }

            if (i == 0) {
                if (arrTokenTypes[i] == uint256(TokenType.T1155)) {
                    IERC1155 _t1155Contract = IERC1155(arrContractAddr[i]);
                    require(
                        _t1155Contract.balanceOf(msg.sender, arrTokenIds[i]) >=
                            batchCount,
                        "BSwap: Do not have nft"
                    );
                    require(
                        _t1155Contract.isApprovedForAll(
                            msg.sender,
                            address(this)
                        ) == true,
                        "BSwap: Must be approved"
                    );
                } else if (arrTokenTypes[i] == uint256(TokenType.T721)) {
                    IERC721 _t721Contract = IERC721(arrContractAddr[i]);
                    require(
                        _t721Contract.ownerOf(arrTokenIds[i]) == msg.sender,
                        "BSwap: Do not have nft"
                    );
                    require(
                        batchCount == 1,
                        "BSwap: Don't support T721 Batch Swap"
                    );
                    require(
                        _t721Contract.isApprovedForAll(
                            msg.sender,
                            address(this)
                        ) == true,
                        "BSwap: Must be approved"
                    );
                }
            }
        }

        if (isWhitelisted == false) {
            uint256 _fee = msg.value;
            require(_fee >= platformFee.mul(10**16), "BSwap: out of fee");

            feeCollector.transfer(_fee);
        }

        address _makerContract = arrContractAddr[0];
        uint256 _makerTokenId = arrTokenIds[0];
        TokenType _makerTokenType = TokenType(arrTokenTypes[0]);

        // maker config
        Collection memory _maker;
        _maker.nLength = 1;
        _maker.collectionOwner = msg.sender;
        _maker.cardContractAddrs = new address[](1);
        _maker.cardTokenIds = new uint256[](1);
        _maker.tokenTypes = new TokenType[](1);
        _maker.cardContractAddrs[0] = _makerContract;
        _maker.cardTokenIds[0] = _makerTokenId;
        _maker.tokenTypes[0] = _makerTokenType;

        // target config
        Collection memory _target;
        uint256 _targetLength = arrTokenTypes.length - 1;
        _target.nLength = _targetLength;
        _target.collectionOwner = address(0);
        _target.cardContractAddrs = new address[](_targetLength);
        _target.cardTokenIds = new uint256[](_targetLength);
        _target.tokenTypes = new TokenType[](_targetLength);
        for (uint256 i = 0; i < _targetLength; i++) {
            _target.cardContractAddrs[i] = arrContractAddr[i + 1];
            _target.cardTokenIds[i] = arrTokenIds[i + 1];
            _target.tokenTypes[i] = TokenType(arrTokenTypes[i + 1]);
        }

        uint256 _id = _getNextListID();
        _incrementListId();
        BSwap storage list = listings[_id];

        list.totalAmount = batchCount;
        list.currentAmount = batchCount;
        list.maker = _maker;
        list.target = _target;
        list.isPrivate = _isPrivate;
        list.startTime = block.timestamp;
        list.endTime = block.timestamp + endTime;
        list.isActive = true;
        list.swapType = SwapType(swapType);
        list.nAllowedBiddersLength = bidders.length;
        for (uint256 i = 0; i < bidders.length; i++) {
            list.allowedBidders[bidders[i]] = true;
        }

        emit NFTListed(_id, msg.sender);
    }

    function swapNFT(uint256 listId, uint256 batchCount)
        public
        payable
        onlyValidList(listId)
        onlyNotEmergency
    {
        require(batchCount >= 1, "BSwap: expected more than 1 count");

        // maker config
        BSwap storage list = listings[listId];
        Collection memory _target = list.target;
        Collection memory _maker = list.maker;
        address lister = _maker.collectionOwner;

        bool isWhitelisted = false;

        require(
            list.isActive == true && list.currentAmount > 0,
            "BSwap: list is closed"
        );
        require(
            list.currentAmount >= batchCount,
            "BSwap: exceed current supply"
        );
        require(
            list.swapType == SwapType.FixedSwap ||
                list.endTime > block.timestamp,
            "BSwap: time is over"
        );
        require(
            list.isPrivate == false || list.allowedBidders[msg.sender] == true,
            "Bswap: not whiltelisted"
        );

        for (uint256 i = 0; i < _target.tokenTypes.length; i++) {
            if (isWhitelisted == false) {
                isWhitelisted = whitelist[_target.cardContractAddrs[i]];
            }

            if (_target.tokenTypes[i] == TokenType.T1155) {
                IERC1155 _t1155Contract =
                    IERC1155(_target.cardContractAddrs[i]);
                require(
                    _t1155Contract.balanceOf(
                        msg.sender,
                        _target.cardTokenIds[i]
                    ) > 0,
                    "BSwap: Do not have nft"
                );
                require(
                    _t1155Contract.isApprovedForAll(
                        msg.sender,
                        address(this)
                    ) == true,
                    "BSwap: Must be approved"
                );
                _t1155Contract.safeTransferFrom(
                    msg.sender,
                    lister,
                    _target.cardTokenIds[i],
                    batchCount,
                    ""
                );
            } else if (_target.tokenTypes[i] == TokenType.T721) {
                IERC721 _t721Contract = IERC721(_target.cardContractAddrs[i]);
                require(
                    batchCount == 1,
                    "BSwap: Don't support T721 Batch Swap"
                );
                require(
                    _t721Contract.ownerOf(_target.cardTokenIds[i]) ==
                        msg.sender,
                    "BSwap: Do not have nft"
                );
                require(
                    _t721Contract.isApprovedForAll(msg.sender, address(this)) ==
                        true,
                    "BSwap: Must be approved"
                );
                _t721Contract.safeTransferFrom(
                    msg.sender,
                    lister,
                    _target.cardTokenIds[i],
                    ""
                );
            } else {
                IERC20 _t20Contract = IERC20(_target.cardContractAddrs[i]);
                uint256 tokenAmount = _target.cardTokenIds[i].mul(batchCount);
                require(
                    _t20Contract.balanceOf(msg.sender) >= tokenAmount,
                    "BSwap: Do not enough funds"
                );
                require(
                    _t20Contract.allowance(msg.sender, address(this)) >=
                        tokenAmount,
                    "BSwap: Must be approved"
                );

                // T20 fee
                uint256 amountToPlatform = tokenAmount.mul(t20Fee).div(100);
                uint256 amountToLister = tokenAmount.sub(amountToPlatform);
                _t20Contract.transferFrom(
                    msg.sender,
                    feeCollector,
                    amountToPlatform
                );
                _t20Contract.transferFrom(msg.sender, lister, amountToLister);
            }
        }

        if (isWhitelisted == false) {
            isWhitelisted = whitelist[_maker.cardContractAddrs[0]];
        }

        if (isWhitelisted == false) {
            uint256 _fee = msg.value;
            require(_fee >= platformFee.mul(10**16), "BSwap: out of fee");

            feeCollector.transfer(_fee);
        }

        _sendToken(
            _maker.tokenTypes[0],
            _maker.cardContractAddrs[0],
            _maker.cardTokenIds[0],
            lister,
            msg.sender
        );

        list.currentAmount = list.currentAmount.sub(batchCount);
        if (list.currentAmount == 0) {
            list.isActive = false;
        }

        emit NFTSwapped(listId, msg.sender, batchCount);
    }

    function closeList(uint256 listId)
        public
        onlyValidList(listId)
        onlyListOwner(listId)
        returns (bool)
    {
        BSwap storage list = listings[listId];
        list.isActive = false;

        emit NFTClosed(listId, msg.sender);
        return true;
    }

    function setVisibility(uint256 listId, bool _isPrivate)
        public
        onlyValidList(listId)
        onlyListOwner(listId)
        returns (bool)
    {
        BSwap storage list = listings[listId];
        list.isPrivate = _isPrivate;

        emit ListVisibilityChanged(listId, _isPrivate);
        return true;
    }

    function increaseEndTime(uint256 listId, uint256 amount)
        public
        onlyValidList(listId)
        onlyListOwner(listId)
        returns (bool)
    {
        BSwap storage list = listings[listId];
        list.endTime = list.endTime.add(amount);

        emit ListEndTimeChanged(listId, list.endTime);
        return true;
    }

    function decreaseEndTime(uint256 listId, uint256 amount)
        public
        onlyValidList(listId)
        onlyListOwner(listId)
        returns (bool)
    {
        BSwap storage list = listings[listId];
        require(
            list.endTime.sub(amount) > block.timestamp,
            "BSwap: can't revert time"
        );
        list.endTime = list.endTime.sub(amount);

        emit ListEndTimeChanged(listId, list.endTime);
        return true;
    }

    function addWhiteListAddress(address addr) public onlyOwner returns (bool) {
        whitelist[addr] = true;

        emit WhiteListAdded(addr);
        return true;
    }

    function batchAddWhiteListAddress(address[] memory addr)
        public
        onlyOwner
        returns (bool)
    {
        for (uint256 i = 0; i < addr.length; i++) {
            whitelist[addr[i]] = true;
        }

        emit BatchWhiteListAdded(addr);
        return true;
    }

    function removeWhiteListAddress(address addr)
        public
        onlyOwner
        returns (bool)
    {
        whitelist[addr] = false;

        emit WhiteListRemoved(addr);
        return true;
    }

    function batchRemoveWhiteListAddress(address[] memory addr)
        public
        onlyOwner
        returns (bool)
    {
        for (uint256 i = 0; i < addr.length; i++) {
            whitelist[addr[i]] = false;
        }

        emit BatchWhiteListRemoved(addr);
        return true;
    }

    function _setPlatformFee(uint256 _fee) public onlyOwner returns (uint256) {
        platformFee = _fee;
        return platformFee;
    }

    function _setFeeCollector(address payable addr)
        public
        onlyOwner
        returns (bool)
    {
        feeCollector = addr;
        return true;
    }

    function _setT20Fee(uint256 _fee) public onlyOwner returns (uint256) {
        t20Fee = _fee;
        return t20Fee;
    }

    function getOfferingTokens(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (
            TokenType[] memory,
            address[] memory,
            uint256[] memory
        )
    {
        BSwap storage list = listings[listId];
        Collection memory maker = list.maker;
        address[] memory cardContractAddrs =
            new address[](maker.cardContractAddrs.length);
        TokenType[] memory tokenTypes =
            new TokenType[](maker.tokenTypes.length);
        uint256[] memory cardTokenIds =
            new uint256[](maker.cardTokenIds.length);
        for (uint256 i = 0; i < maker.cardContractAddrs.length; i++) {
            cardContractAddrs[i] = maker.cardContractAddrs[i];
            tokenTypes[i] = maker.tokenTypes[i];
            cardTokenIds[i] = maker.cardTokenIds[i];
        }
        return (tokenTypes, cardContractAddrs, cardTokenIds);
    }

    function getDesiredTokens(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (
            TokenType[] memory,
            address[] memory,
            uint256[] memory
        )
    {
        BSwap storage list = listings[listId];
        Collection memory target = list.target;
        address[] memory cardContractAddrs =
            new address[](target.cardContractAddrs.length);
        TokenType[] memory tokenTypes =
            new TokenType[](target.tokenTypes.length);
        uint256[] memory cardTokenIds =
            new uint256[](target.cardTokenIds.length);
        for (uint256 i = 0; i < target.cardContractAddrs.length; i++) {
            cardContractAddrs[i] = target.cardContractAddrs[i];
            tokenTypes[i] = target.tokenTypes[i];
            cardTokenIds[i] = target.cardTokenIds[i];
        }
        return (tokenTypes, cardContractAddrs, cardTokenIds);
    }

    function isAvailable(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (bool)
    {
        BSwap storage list = listings[listId];
        Collection memory maker = list.maker;
        address lister = maker.collectionOwner;
        for (uint256 i = 0; i < maker.cardContractAddrs.length; i++) {
            if (maker.tokenTypes[i] == TokenType.T1155) {
                IERC1155 _t1155Contract = IERC1155(maker.cardContractAddrs[i]);
                if (
                    _t1155Contract.balanceOf(lister, maker.cardTokenIds[i]) == 0
                ) {
                    return false;
                }
            } else if (maker.tokenTypes[i] == TokenType.T721) {
                IERC721 _t721Contract = IERC721(maker.cardContractAddrs[i]);
                if (_t721Contract.ownerOf(maker.cardTokenIds[i]) != lister) {
                    return false;
                }
            }
        }

        return true;
    }

    function isWhitelistedToken(address addr)
        public
        view
        returns (bool)
    {
        return whitelist[addr];
    }

    function isSupportedToken(address addr)
        public
        view
        returns (bool)
    {
        return supportTokens[addr];
    }

    function isAcive(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (bool)
    {
        BSwap memory list = listings[listId];

        return
            list.isActive &&
            (list.swapType == SwapType.FixedSwap ||
                list.endTime > block.timestamp);
    }

    function isPrivate(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (bool)
    {
        return listings[listId].isPrivate;
    }

    function getSwapType(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (uint256)
    {
        return uint256(listings[listId].swapType);
    }

    function getEndingTime(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (uint256)
    {
        return listings[listId].endTime;
    }

    function getTotalAmount(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (uint256)
    {
        return listings[listId].totalAmount;
    }

    function getCurrentAmount(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (uint256)
    {
        return listings[listId].currentAmount;
    }

    function getStartTime(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (uint256)
    {
        return listings[listId].startTime;
    }

    function getPeriod(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (uint256)
    {
        if (listings[listId].endTime <= block.timestamp) return 0;

        return listings[listId].endTime.sub(block.timestamp);
    }

    function isAllowedForList(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (bool)
    {
        return listings[listId].allowedBidders[msg.sender];
    }

    function getOwnerOfList(uint256 listId)
        public
        view
        onlyValidList(listId)
        returns (address)
    {
        return listings[listId].maker.collectionOwner;
    }

    function _getNextListID() private view returns (uint256) {
        return listIndex.add(1);
    }

    function _incrementListId() private {
        listIndex = listIndex.add(1);
    }

    function transferERC20(address erc20) public {
        require(msg.sender == originCreator, "BSwap: you are not admin");
        uint256 amount = IERC20(erc20).balanceOf(address(this));
        IERC20(erc20).transfer(msg.sender, amount);
    }

    function transferETH() public {
        require(msg.sender == originCreator, "BSwap: you are not admin");
        msg.sender.transfer(address(this).balance);
    }
}