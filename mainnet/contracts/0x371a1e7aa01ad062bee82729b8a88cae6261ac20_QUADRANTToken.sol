/**
 *Submitted for verification at Etherscan.io on 2021-12-18
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).

 * https://t.me/MemeCoinFinanceBSC
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

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
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

// File contracts/IUniswapV2Router01.sol

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

// File contracts/IUniswapV2Router02.sol

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

// File contracts/IUniswapV2Factory.sol

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
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
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
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
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
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
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
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
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
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
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
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

contract QUADRANTToken is Context, IERC20, Ownable {
    using Address for address payable;
    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _isExcludedFromReflection;
    mapping(address => bool) private _isExcludedFromMaxWallet;

    mapping(address => bool) public isBot;

    address[] private _excluded;

    uint8 private constant _decimals = 18;
    uint256 private constant MAX = ~uint256(0);

    uint256 private _tTotal = 1_000_000_000_000_000 * 10**_decimals;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));

    uint256 public maxTxAmountBuy = _tTotal / 1000; // 10% of supply
    uint256 public maxTxAmountSell = _tTotal / 1000; // 10% of supply
    uint256 public maxWalletAmount = _tTotal / 1;

    uint256 public maxBurn = _tTotal * 3 / 10; //Burn up to 30% of supply

    //antisnipers
    uint256 public liqAddedBlockNumber;
    uint256 public blocksToWait = 1;

    address public rewardsAddress = 0xd934EBf314cbC46f52E10Fa2f78d7AA5A4aE6fa4;
    address public devAddress = 0xd941bA78146B6e198ad8d82EF7e2dA6042334733;
    address public burnAddress = 0x000000000000000000000000000000000000dEaD;
    address public lpAddress = 0x092e4FFCbf780561E8513cBD6e231721596a9DF3;

    mapping(address => bool) public isAutomatedMarketMakerPair;

    string private constant _name = "QUADRANT Token";
    string private constant _symbol = "QUADRANT";

    bool private inSwapAndLiquify;

    // Anti-Whale Settings
    uint256 public _whaleBuySellThreshold = 5_000_000_000 * 10**_decimals;
    mapping(address => uint256) private _amountBuy;
    mapping(address => uint256) private _amountSell;

    IUniswapV2Router02 public UniswapV2Router;
    address public uniswapPair;
    bool public swapAndLiquifyEnabled = true;
    uint256 public numTokensSellToAddToLiquidity = 5_000_000 * 10**_decimals;

    struct feeRatesStruct {
        uint8 rfi;
        uint8 reward;
        uint8 dev;
        uint8 lp;
        uint8 burn;
        uint8 toSwap;
    }

    feeRatesStruct public buySellRates =
        feeRatesStruct({
            rfi: 2, // 0 RFI rate, in %
            dev: 2, // dev team fee in %
            reward: 5, // reward fee in %
            lp: 2, // lp rate in %
            burn: 1,
            toSwap: 10 // reward + dev + lp + burn
        });

    feeRatesStruct public whaleRates =
        feeRatesStruct({
            rfi: 4, // 0 RFI rate, in %
            dev: 4, // dev team fee in %
            reward: 4, // reward fee in %
            lp: 4, // lp rate in %
            burn: 4,
            toSwap: 16 // reward + dev + lp + burn
        });

    feeRatesStruct private appliedRates = buySellRates;

    struct TotFeesPaidStruct {
        uint256 rfi;
        uint256 toSwap;
    }
    TotFeesPaidStruct public totFeesPaid;

    struct valuesFromGetValues {
        uint256 rAmount;
        uint256 rTransferAmount;
        uint256 rRfi;
        uint256 rToSwap;
        uint256 tTransferAmount;
        uint256 tRfi;
        uint256 tToSwap;
    }

    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ETHReceived,
        uint256 tokensIntotoSwap
    );
    event LiquidityAdded(uint256 tokenAmount, uint256 ETHAmount);
    event rewardAndDevFeesAdded(uint256 devFee, uint256 rewardFee);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event BlacklistedUser(address botAddress, bool indexed value);
    event MaxWalletAmountUpdated(uint256 amount);
    event ExcludeFromMaxWallet(address account, bool indexed isExcluded);

    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor() {
        IUniswapV2Router02 _UniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Uniswap V2

        uniswapPair = IUniswapV2Factory(_UniswapV2Router.factory()).createPair(
            address(this),
            _UniswapV2Router.WETH()
        );
        isAutomatedMarketMakerPair[uniswapPair] = true;
        emit SetAutomatedMarketMakerPair(uniswapPair, true);
        UniswapV2Router = _UniswapV2Router;

        _rOwned[owner()] = _rTotal;

        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[rewardsAddress] = true;
        _isExcludedFromFee[devAddress] = true;
        _isExcludedFromFee[burnAddress] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[lpAddress] = true;

        _isExcludedFromMaxWallet[owner()] = true;
        _isExcludedFromMaxWallet[address(this)] = true;
        _isExcludedFromMaxWallet[uniswapPair] = true;

        //Exclude these addresses from reflection
        _isExcludedFromReflection[owner()] = true;
        _isExcludedFromReflection[rewardsAddress] = true;
        _isExcludedFromReflection[devAddress] = true;
        _isExcludedFromReflection[burnAddress] = true;
        _isExcludedFromReflection[address(this)] = true;
        _isExcludedFromReflection[lpAddress] = true;

        _tOwned[owner()] = _tTotal;
        emit Transfer(address(0), owner(), _tTotal);
    }

    //std ERC20:
    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    //override ERC20:
    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcludedFromReflection[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcludedFromReflection[account];
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferRfi)
        public
        view
        returns (uint256)
    {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferRfi) {
            valuesFromGetValues memory s = _getValues(tAmount, true);
            return s.rAmount;
        } else {
            valuesFromGetValues memory s = _getValues(tAmount, true);
            return s.rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount)
        public
        view
        returns (uint256)
    {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount / currentRate;
    }

    //No current rfi - Tiered Rewarding Feature Applied at APP Launch
    function excludeFromReward(address account) external onlyOwner {
        require(!_isExcludedFromReflection[account], "Account is already excluded");
        if (_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcludedFromReflection[account] = true;
        _excluded.push(account);
    }

    function includeInReward(address account) external onlyOwner {
        require(_isExcludedFromReflection[account], "Account is not excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcludedFromReflection[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function excludeFromFee(address account) external onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function excludeMultipleAccountsFromMaxWallet(
        address[] calldata accounts,
        bool excluded
    ) public onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            require(
                _isExcludedFromMaxWallet[accounts[i]] != excluded,
                "_isExcludedFromMaxWallet already set to that value for one wallet"
            );
            _isExcludedFromMaxWallet[accounts[i]] = excluded;
            emit ExcludeFromMaxWallet(accounts[i], excluded);
        }
    }

    function includeInFee(address account) external onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function isExcludedFromMaxWallet(address account)
        public
        view
        returns (bool)
    {
        return _isExcludedFromMaxWallet[account];
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    //  @dev receive ETH from UniswapV2Router when swapping
    receive() external payable {}

    function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
        _rTotal -= rRfi;
        totFeesPaid.rfi += tRfi;
    }

    function _takeToSwap(uint256 rToSwap, uint256 tToSwap) private {
        _rOwned[address(this)] += rToSwap;
        if (_isExcludedFromReflection[address(this)]) _tOwned[address(this)] += tToSwap;
        totFeesPaid.toSwap += tToSwap;
    }

    function _getValues(uint256 tAmount, bool takeFee)
        private
        view
        returns (valuesFromGetValues memory to_return)
    {
        to_return = _getTValues(tAmount, takeFee);
        (
            to_return.rAmount,
            to_return.rTransferAmount,
            to_return.rRfi,
            to_return.rToSwap
        ) = _getRValues(to_return, tAmount, takeFee, _getRate());
        return to_return;
    }

    function _getTValues(uint256 tAmount, bool takeFee)
        private
        view
        returns (valuesFromGetValues memory s)
    {
        if (!takeFee) {
            s.tTransferAmount = tAmount;
            return s;
        }
        s.tRfi = (tAmount * appliedRates.rfi) / 100;
        s.tToSwap = (tAmount * appliedRates.toSwap) / 100;
        s.tTransferAmount = tAmount - s.tRfi - s.tToSwap;
        return s;
    }

    function _getRValues(
        valuesFromGetValues memory s,
        uint256 tAmount,
        bool takeFee,
        uint256 currentRate
    )
        private
        pure
        returns (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rRfi,
            uint256 rToSwap
        )
    {
        rAmount = tAmount * currentRate;

        if (!takeFee) {
            return (rAmount, rAmount, 0, 0);
        }

        rRfi = s.tRfi * currentRate;
        rToSwap = s.tToSwap * currentRate;
        rTransferAmount = rAmount - rRfi - rToSwap;
        return (rAmount, rTransferAmount, rRfi, rToSwap);
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply / tSupply;
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (
                _rOwned[_excluded[i]] > rSupply ||
                _tOwned[_excluded[i]] > tSupply
            ) return (_rTotal, _tTotal);
            rSupply -= _rOwned[_excluded[i]];
            tSupply -= _tOwned[_excluded[i]];
        }
        if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        if (liqAddedBlockNumber == 0 && isAutomatedMarketMakerPair[to]) {
            liqAddedBlockNumber = block.number;
        }

        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(!isBot[from], "ERC20: address blacklisted (bot)");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(
            amount <= balanceOf(from),
            "You are trying to transfer more than your balance"
        );
        bool takeFee = !(_isExcludedFromFee[from] || _isExcludedFromFee[to] || isAutomatedMarketMakerPair[from]);

        if (takeFee) {
            // Get the new total to see if it has spilled over the threshold
            //uint256 newTotalBuy = _amountBuy[from] + amount;
            uint256 newTotalSell = _amountSell[from] + amount;

            if (isAutomatedMarketMakerPair[from]) { //Buying
                if (block.number < liqAddedBlockNumber + blocksToWait) {
                    isBot[to] = true;
                    emit BlacklistedUser(to, true);
                }

                require(
                    amount <= maxTxAmountBuy,
                    "amount must be <= maxTxAmountBuy"
                );
            } else { //Selling
                if (newTotalSell > _whaleBuySellThreshold) {
                    appliedRates = whaleRates;
                } else {
                    appliedRates = buySellRates;
                }
                require(
                    amount <= maxTxAmountSell,
                    "amount must be <= maxTxAmountSell"
                );

                if (isAutomatedMarketMakerPair[to]) {
                    if (balanceOf(address(this)) >= numTokensSellToAddToLiquidity) {
                        distributeFees(balanceOf(address(this)));
                    }      
                }             
            }         
        }

        if ( ! isAutomatedMarketMakerPair[to]) {
            takeFee = false;
        }

        _tokenTransfer(from, to, amount, takeFee);
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee
    ) private {
        valuesFromGetValues memory s = _getValues(tAmount, takeFee);

        if (_isExcludedFromReflection[sender]) {
            _tOwned[sender] -= tAmount;
        }
        if (_isExcludedFromReflection[recipient]) {
            _tOwned[recipient] += s.tTransferAmount;
        }

        _rOwned[sender] -= s.rAmount;
        _rOwned[recipient] += s.rTransferAmount;
        if (takeFee) {
            _reflectRfi(s.rRfi, s.tRfi);
            _takeToSwap(s.rToSwap, s.tToSwap);
            emit Transfer(sender, address(this), s.tToSwap);
        }
        require(
            _isExcludedFromMaxWallet[recipient] ||
                balanceOf(recipient) <= maxWalletAmount,
            "Recipient cannot hold more than maxWalletAmount"
        );
        emit Transfer(sender, recipient, s.tTransferAmount);
    }

    function distributeFees(uint256 contractTokenBalance) private {
        //Rewards
        uint256 devFee = contractTokenBalance * appliedRates.dev / 100;
        updateBalance(devAddress, devFee);

        //Project fund
        uint256 rewardFee = contractTokenBalance * appliedRates.reward / 100;   
        updateBalance(rewardsAddress, rewardFee);

        //Liquidity
        uint256 lpFee = contractTokenBalance * appliedRates.lp / 100; 
        updateBalance(lpAddress, lpFee);

        //Burn
        if (totalBurned() < maxBurn) {
            uint256 burnFee = contractTokenBalance * appliedRates.burn / 100;  
            updateBalance(burnAddress, burnFee);
        }
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        uint256 toAddLiquidityWith = contractTokenBalance * appliedRates.lp / 100;
        uint256 tokensToSwapToEth = toAddLiquidityWith / 2;
        uint256 tokenToAddToLiquidity = tokensToSwapToEth;

        uint256 initialBalance = address(this).balance;

        // swap tokens for ETH
        swapTokensForETH(tokensToSwapToEth);

        uint256 ethToAddToLiquidity = address(this).balance - initialBalance;

        // add liquidity
        addLiquidity(tokenToAddToLiquidity, ethToAddToLiquidity);
    }

    function swapTokensForETH(uint256 tokenAmount) private {
        // generate the pair path of token
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = UniswapV2Router.WETH();

        if (allowance(address(this), address(UniswapV2Router)) < tokenAmount) {
            _approve(address(this), address(UniswapV2Router), ~uint256(0));
        }

        // make the swap
        UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
        // add the liquidity
        UniswapV2Router.addLiquidityETH{value: ETHAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            burnAddress,
            block.timestamp
        );
        emit LiquidityAdded(tokenAmount, ETHAmount);
    }

    function setAutomatedMarketMakerPair(address _pair, bool value)
        external
        onlyOwner
    {
        require(
            isAutomatedMarketMakerPair[_pair] != value,
            "Automated market maker pair is already set to that value"
        );
        isAutomatedMarketMakerPair[_pair] = value;
        if (value) {
            _isExcludedFromMaxWallet[_pair] = true;
            emit ExcludeFromMaxWallet(_pair, value);
        }
        emit SetAutomatedMarketMakerPair(_pair, value);
    }

    function setBuyFees(
        uint8 _rfi,
        uint8 _reward,
        uint8 _dev,
        uint8 _lp
    ) external onlyOwner {
        buySellRates.rfi = _rfi;
        buySellRates.reward = _reward;
        buySellRates.dev = _dev;
        buySellRates.lp = _lp;
        buySellRates.toSwap = _reward + _dev + _lp;
    }

    function setWhaleFees(
        uint8 _rfi,
        uint8 _reward,
        uint8 _dev,
        uint8 _lp
    ) external onlyOwner {
        whaleRates.rfi = _rfi;
        whaleRates.reward = _reward;
        whaleRates.dev = _dev;
        whaleRates.lp = _lp;
        whaleRates.toSwap = _reward + _dev + _lp;
    }

    function setMaxTransactionAmount(
        uint256 _maxTxAmountBuyPct,
        uint256 _maxTxAmountSellPct
    ) external onlyOwner {
        maxTxAmountBuy = _tTotal / _maxTxAmountBuyPct; // 100 = 1%, 50 = 2% etc.
        maxTxAmountSell = _tTotal / _maxTxAmountSellPct; // 100 = 1%, 50 = 2% etc.
    }

    function setNumTokensSellToAddToLiq(uint256 amountTokens)
        external
        onlyOwner
    {
        numTokensSellToAddToLiquidity = amountTokens * 10**_decimals;
    }

    function setRewardsAddress(address payable _rewardsAddress) external onlyOwner {
        rewardsAddress = _rewardsAddress;
    }

    function setDevAddress(address payable _devAddress) external onlyOwner {
        devAddress = _devAddress;
    }

    function setBurnAddress(address payable _burnAddress) external onlyOwner {
        burnAddress = _burnAddress;
    }

    function setLiquidityAddress(address payable _lpAddress) external onlyOwner {
        lpAddress = _lpAddress;
    }

    function setWhaleBuySellThreshold(uint256 amount) external onlyOwner {
        _whaleBuySellThreshold = amount;
    }

    function manualSwapAndAddToLiq() external onlyOwner {
        swapAndLiquify(balanceOf(address(this)));
    }

    // Cannot BLACKLIST user manually, the only way to get into the Blacklist is to snipe, buy in block no.1. We give grace here if a genuine user can prove that they did not snipe in block 0 or 1.
    function unblacklistSniper(address botAddress) external onlyOwner {
        require(
            isBot[botAddress],
            "address provided is already not blacklisted"
        );
        isBot[botAddress] = false;
        emit BlacklistedUser(botAddress, false);
    }

    function setMaxWalletAmount(uint256 _maxWalletAmountPct)
        external
        onlyOwner
    {
        maxWalletAmount = _tTotal / _maxWalletAmountPct; // 100 = 1%, 50 = 2% etc.
        emit MaxWalletAmountUpdated(maxWalletAmount);
    }

    function excludeFromMaxWallet(address account, bool excluded)
        external
        onlyOwner
    {
        require(
            _isExcludedFromMaxWallet[account] != excluded,
            "_isExcludedFromMaxWallet already set to that value"
        );
        _isExcludedFromMaxWallet[account] = excluded;

        emit ExcludeFromMaxWallet(account, excluded);
    }

    function totalBurned() public view returns (uint256) {
		return balanceOf(burnAddress);
	}

    function updateBalance(address account, uint256 tokenAmount) private {
        if (_isExcludedFromReflection[account]) {
            _tOwned[account] += tokenAmount;
        } else {
            _rOwned[account] += tokenAmount;
        }

        emit Transfer(address(this), account, tokenAmount);            
    }
}