/*

eToro

Educational Crypto Based Arbitrage Signals
- Learn how to leverage fractional shares of highly valuable assets to earn passive income.
- Get automated arbitrage indicators to take advantage of cross-chain opportunities
- 0% Risk Sessions
- Minimum equity of $200 in crypto currency required
- Daily Live Trading
- Private Q&A Groups

Join over 25M people on the world's largest social investing platform.

https://t.me/eToroPortal





Crypto Trading is offered via eToro LLC USA. Securities trading is offered via eToro USA 
Securities, Inc.("The BD"), a broker dealer registered with the Securities and Exchange 
Commission (SEC). The BD is a member of the Financial Industry Regulatory Authority (FINRA) 
and Securities Investor Protection Corporation (SIPC). eToro USA LLC (NMLS ID: 1769299 ) 
is not a registered broker-dealer or FINRA member and your cryptocurrency holdings are not 
FDIC or SIPC insured. 

eToro. © 2022

*/

// SPDX-License-Identifier: MIT
pragma solidity =0.8.10 >=0.8.0 <0.9.0;
pragma experimental ABIEncoderV2;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

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
    function transfer(address recipient, uint256 amount) external returns (bool);

  
    function allowance(address owner, address spender) external view returns (uint256);

  
    function approve(address spender, uint256 amount) external returns (bool);

  
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
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

 
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

 
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

   
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

   
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

   
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}


library Address {
 
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

   
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

  
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

  
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

  
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

   
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

   
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

   
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

   
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

   
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
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
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

   
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

   
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

   
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

  
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

  
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

  
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

////// src/IUniswapV2Factory.sol
/* pragma solidity 0.8.10; */
/* pragma experimental ABIEncoderV2; */

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

////// src/IUniswapV2Pair.sol
/* pragma solidity 0.8.10; */
/* pragma experimental ABIEncoderV2; */

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

////// src/IUniswapV2Router02.sol
/* pragma solidity 0.8.10; */
/* pragma experimental ABIEncoderV2; */

interface IUniswapV2Router02 {
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


contract etoroarbi is Ownable, IERC20 {
    address UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;

    string private _name = "eToro";
    string private _symbol = "ETORO";

    uint256 public treasuryFeeBPS = 100;
    uint256 public liquidityFeeBPS = 50;
    uint256 public dividendFeeBPS = 1450;
    uint256 public totalFeeBPS = 1600;

    uint256 public swapTokensAtAmount = 100000 * (10**18);
    uint256 public lastSwapTime;
    bool swapAllToken = true;

    bool public swapEnabled = true;
    bool public taxEnabled = true;
    bool public compoundingEnabled = true;
    bool public arbitrageEnabled = true;

    uint256 private _totalSupply;
    bool private swapping;

    address marketingWallet;
    address liquidityWallet;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) public automatedMarketMakerPairs;
    mapping(address => bool) private _whiteList;
    mapping(address => bool) isBlacklisted;

    event SwapAndAddLiquidity(
        uint256 tokensSwapped,
        uint256 nativeReceived,
        uint256 tokensIntoLiquidity
    );
    event SendDividends(uint256 tokensSwapped, uint256 amount);
    event ExcludeFromFees(address indexed account, bool isExcluded);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event UpdateUniswapV2Router(
        address indexed newAddress,
        address indexed oldAddress
    );
    event SwapEnabled(bool enabled);
    event TaxEnabled(bool enabled);
    event CompoundingEnabled(bool enabled);
    event BlacklistEnabled(bool enabled);

    DividendTracker public dividendTracker;
    IUniswapV2Router02 public uniswapV2Router;

    address public uniswapV2Pair;

    uint256 public maxTxBPS = 75;
    uint256 public maxWalletBPS = 300;

    bool isOpen = false;

    mapping(address => bool) private _isExcludedFromMaxTx;
    mapping(address => bool) private _isExcludedFromMaxWallet;

    constructor(
        address _marketingWallet,
        address _liquidityWallet,
        address[] memory whitelistAddress
    ) {
        marketingWallet = _marketingWallet;
        liquidityWallet = _liquidityWallet;
        includeToWhiteList(whitelistAddress);

        dividendTracker = new DividendTracker(address(this), UNISWAPROUTER);

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);

        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;

        _setAutomatedMarketMakerPair(_uniswapV2Pair, true);

        dividendTracker.excludeFromDividends(address(dividendTracker), true);
        dividendTracker.excludeFromDividends(address(this), true);
        dividendTracker.excludeFromDividends(owner(), true);
        dividendTracker.excludeFromDividends(address(_uniswapV2Router), true);

        excludeFromFees(owner(), true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(dividendTracker), true);

        excludeFromMaxTx(owner(), true);
        excludeFromMaxTx(address(this), true);
        excludeFromMaxTx(address(dividendTracker), true);

        excludeFromMaxWallet(owner(), true);
        excludeFromMaxWallet(address(this), true);
        excludeFromMaxWallet(address(dividendTracker), true);

        _mint(owner(), 1000000000 * (10**18));
    }

    receive() external payable {}

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
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
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERROR: decreased allowance below zero"
        );
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        return true;
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(
            currentAllowance >= amount,
            "ERROR: transfer amount exceeds allowance"
        );
        _approve(sender, _msgSender(), currentAllowance - amount);
        return true;
    }

    function openTrading() external onlyOwner {
        isOpen = true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(
            isOpen ||
                sender == owner() ||
                recipient == owner() ||
                _whiteList[sender] ||
                _whiteList[recipient],
            "Not Open"
        );

        require(!isBlacklisted[sender], "ERROR: Sender is blacklisted");
        require(!isBlacklisted[recipient], "ERROR: Recipient is blacklisted");

        require(sender != address(0), "ERROR: transfer from the zero address");
        require(recipient != address(0), "ERROR: transfer to the zero address");

        uint256 _maxTxAmount = (totalSupply() * maxTxBPS) / 10000;
        uint256 _maxWallet = (totalSupply() * maxWalletBPS) / 10000;
        require(
            amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
            "TX Limit Exceeded"
        );

        if (
            sender != owner() &&
            recipient != address(this) &&
            recipient != address(DEAD) &&
            recipient != uniswapV2Pair
        ) {
            uint256 currentBalance = balanceOf(recipient);
            require(
                _isExcludedFromMaxWallet[recipient] ||
                    (currentBalance + amount <= _maxWallet)
            );
        }

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERROR: transfer amount exceeds balance"
        );

        uint256 contractTokenBalance = balanceOf(address(this));
        uint256 contractNativeBalance = address(this).balance;

        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if (
            swapEnabled && // True
            canSwap && // true
            !swapping && // swapping=false !false true
            !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
            sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
            sender != owner() &&
            recipient != owner()
        ) {
            swapping = true;

            if (!swapAllToken) {
                contractTokenBalance = swapTokensAtAmount;
            }
            _executeSwap(contractTokenBalance, contractNativeBalance);

            lastSwapTime = block.timestamp;
            swapping = false;
        }

        bool takeFee;

        if (
            sender == address(uniswapV2Pair) ||
            recipient == address(uniswapV2Pair)
        ) {
            takeFee = true;
        }

        if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
            takeFee = false;
        }

        if (swapping || !taxEnabled) {
            takeFee = false;
        }

        if (takeFee) {
            uint256 fees = (amount * totalFeeBPS) / 10000;
            amount -= fees;
            _executeTransfer(sender, address(this), fees);
        }

        _executeTransfer(sender, recipient, amount);

        dividendTracker.setBalance(payable(sender), balanceOf(sender));
        dividendTracker.setBalance(payable(recipient), balanceOf(recipient));
    }

    function _executeTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        require(sender != address(0), "ERROR: transfer from the zero address");
        require(recipient != address(0), "ERROR: transfer to the zero address");
        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERROR: transfer amount exceeds balance"
        );
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERROR: approve from the zero address");
        require(spender != address(0), "ERROR: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _mint(address account, uint256 amount) private {
        require(account != address(0), "ERROR: mint to the zero address");
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) private {
        require(account != address(0), "ERROR: burn from the zero address");
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERROR: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }

    function swapTokensForNative(uint256 tokens) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokens);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokens,
            0, // accept any amount of native
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokens, uint256 native) private {
        _approve(address(this), address(uniswapV2Router), tokens);
        uniswapV2Router.addLiquidityETH{value: native}(
            address(this),
            tokens,
            0, // slippage unavoidable
            0, // slippage unavoidable
            liquidityWallet,
            block.timestamp
        );
    }

    function includeToWhiteList(address[] memory _users) private {
        for (uint8 i = 0; i < _users.length; i++) {
            _whiteList[_users[i]] = true;
        }
    }

    function _executeSwap(uint256 tokens, uint256 native) private {
        if (tokens <= 0) {
            return;
        }

        uint256 swapTokensMarketing;
        if (address(marketingWallet) != address(0)) {
            swapTokensMarketing = (tokens * treasuryFeeBPS) / totalFeeBPS;
        }

        uint256 swapTokensDividends;
        if (dividendTracker.totalSupply() > 0) {
            swapTokensDividends = (tokens * dividendFeeBPS) / totalFeeBPS;
        }

        uint256 tokensForLiquidity = tokens -
            swapTokensMarketing -
            swapTokensDividends;
        uint256 swapTokensLiquidity = tokensForLiquidity / 2;
        uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
        uint256 swapTokensTotal = swapTokensMarketing +
            swapTokensDividends +
            swapTokensLiquidity;

        uint256 initNativeBal = address(this).balance;
        swapTokensForNative(swapTokensTotal);
        uint256 nativeSwapped = (address(this).balance - initNativeBal) +
            native;

        uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) /
            swapTokensTotal;
        uint256 nativeDividends = (nativeSwapped * swapTokensDividends) /
            swapTokensTotal;
        uint256 nativeLiquidity = nativeSwapped -
            nativeMarketing -
            nativeDividends;

        if (nativeMarketing > 0) {
            payable(marketingWallet).transfer(nativeMarketing);
        }

        addLiquidity(addTokensLiquidity, nativeLiquidity);
        emit SwapAndAddLiquidity(
            swapTokensLiquidity,
            nativeLiquidity,
            addTokensLiquidity
        );

        if (nativeDividends > 0) {
            (bool success, ) = address(dividendTracker).call{
                value: nativeDividends
            }("");
            if (success) {
                emit SendDividends(swapTokensDividends, nativeDividends);
            }
        }
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        require(
            _isExcludedFromFees[account] != excluded,
            "ERROR: account is already set to requested state"
        );
        _isExcludedFromFees[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function manualSendDividend(uint256 amount, address holder)
        external
        onlyOwner
    {
        dividendTracker.manualSendDividend(amount, holder);
    }

    function excludeFromDividends(address account, bool excluded)
        public
        onlyOwner
    {
        dividendTracker.excludeFromDividends(account, excluded);
    }

    function isExcludedFromDividends(address account)
        public
        view
        returns (bool)
    {
        return dividendTracker.isExcludedFromDividends(account);
    }

    function setWallet(
        address payable _marketingWallet,
        address payable _arbitrageWallet
    ) external onlyOwner {
        marketingWallet = _marketingWallet;
        liquidityWallet = _arbitrageWallet;
    }

    function setAutomatedMarketMakerPair(address pair, bool value)
        public
        onlyOwner
    {
        require(pair != uniswapV2Pair, "ERROR: DEX pair can not be removed");
        _setAutomatedMarketMakerPair(pair, value);
    }

    function setFee(
        uint256 _treasuryFee,
        uint256 _liquidityFee,
        uint256 _dividendFee
    ) external onlyOwner {
        treasuryFeeBPS = _treasuryFee;
        liquidityFeeBPS = _liquidityFee;
        dividendFeeBPS = _dividendFee;
        totalFeeBPS = _treasuryFee + _liquidityFee + _dividendFee;
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        require(
            automatedMarketMakerPairs[pair] != value,
            "ERROR: automated market maker pair is already set to that value"
        );
        automatedMarketMakerPairs[pair] = value;
        if (value) {
            dividendTracker.excludeFromDividends(pair, true);
        }
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function updateUniswapV2Router(address newAddress) public onlyOwner {
        require(
            newAddress != address(uniswapV2Router),
            "ERROR: the router is already set to the new address"
        );
        emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
        uniswapV2Router = IUniswapV2Router02(newAddress);
        address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
            .createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Pair = _uniswapV2Pair;
    }

    function claim() public {
        dividendTracker.processAccount(payable(_msgSender()));
    }

    function arbitrage() public {
        require(compoundingEnabled, "ERROR: compounding is not enabled");
        dividendTracker.compoundAccount(payable(_msgSender()));
    }

    function withdrawableDividendOf(address account)
        public
        view
        returns (uint256)
    {
        return dividendTracker.withdrawableDividendOf(account);
    }

    function withdrawnDividendOf(address account)
        public
        view
        returns (uint256)
    {
        return dividendTracker.withdrawnDividendOf(account);
    }

    function accumulativeDividendOf(address account)
        public
        view
        returns (uint256)
    {
        return dividendTracker.accumulativeDividendOf(account);
    }

    function getAccountInfo(address account)
        public
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return dividendTracker.getAccountInfo(account);
    }

    function getLastClaimTime(address account) public view returns (uint256) {
        return dividendTracker.getLastClaimTime(account);
    }

    function setSwapEnabled(bool _enabled) external onlyOwner {
        swapEnabled = _enabled;
        emit SwapEnabled(_enabled);
    }

    function setTaxEnabled(bool _enabled) external onlyOwner {
        taxEnabled = _enabled;
        emit TaxEnabled(_enabled);
    }

    function setCompoundingEnabled(bool _enabled) external onlyOwner {
        compoundingEnabled = _enabled;
        emit CompoundingEnabled(_enabled);
    }

    function setArbitrageEnabled(bool _enabled) external onlyOwner {
        arbitrageEnabled = _enabled;
    }

    function updateDividendSettings(
        bool _swapEnabled,
        uint256 _swapTokensAtAmount,
        bool _swapAllToken
    ) external onlyOwner {
        swapEnabled = _swapEnabled;
        swapTokensAtAmount = _swapTokensAtAmount;
        swapAllToken = _swapAllToken;
    }

    function setMaxTxLimit(uint256 limit) external onlyOwner {
        require(limit >= 75 && limit <= 10000, "LIMIT must be between 75 and 10000");
        maxTxBPS = limit;
    }


    function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
        _isExcludedFromMaxTx[account] = excluded;
    }

    function isExcludedFromMaxTx(address account) public view returns (bool) {
        return _isExcludedFromMaxTx[account];
    }

    function setMaxWallet(uint256 limit) external onlyOwner {
        require(
            limit >= 175 && limit <= 10000,
            "LIMIT must be between 175 and 10000"
        );
        maxWalletBPS = limit;
    }

    function excludeFromMaxWallet(address account, bool excluded)
        public
        onlyOwner
    {
        _isExcludedFromMaxWallet[account] = excluded;
    }

    function isExcludedFromMaxWallet(address account)
        public
        view
        returns (bool)
    {
        return _isExcludedFromMaxWallet[account];
    }

    function rescueToken(address _token, uint256 _amount) external onlyOwner {
        IERC20(_token).transfer(msg.sender, _amount);
    }

    function rescueETH(uint256 _amount) external onlyOwner {
        payable(msg.sender).transfer(_amount);
    }

    function blackList(address _user) public onlyOwner {
        require(!isBlacklisted[_user], "user already blacklisted");
        isBlacklisted[_user] = true;
        // events?
    }

    function removeFromBlacklist(address _user) public onlyOwner {
        require(isBlacklisted[_user], "user already whitelisted");
        isBlacklisted[_user] = false;
        //events?
    }

    function blackListMany(address[] memory _users) public onlyOwner {
        for (uint8 i = 0; i < _users.length; i++) {
            isBlacklisted[_users[i]] = true;
        }
    }

    function unBlackListMany(address[] memory _users) public onlyOwner {
        for (uint8 i = 0; i < _users.length; i++) {
            isBlacklisted[_users[i]] = false;
        }
    }
}

contract DividendTracker is Ownable, IERC20 {
    address UNISWAPROUTER;

    string private _name = "Investor_DividendTracker";
    string private _symbol = "Investor_DividendTracker";

    uint256 public lastProcessedIndex;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    uint256 private constant magnitude = 2**128;
    uint256 public immutable minTokenBalanceForDividends;
    uint256 private magnifiedDividendPerShare;
    uint256 public totalDividendsDistributed;
    uint256 public totalDividendsWithdrawn;

    address public tokenAddress;

    mapping(address => bool) public excludedFromDividends;
    mapping(address => int256) private magnifiedDividendCorrections;
    mapping(address => uint256) private withdrawnDividends;
    mapping(address => uint256) private lastClaimTimes;

    event DividendsDistributed(address indexed from, uint256 weiAmount);
    event DividendWithdrawn(address indexed to, uint256 weiAmount);
    event ExcludeFromDividends(address indexed account, bool excluded);
    event Claim(address indexed account, uint256 amount);
    event Compound(address indexed account, uint256 amount, uint256 tokens);

    struct AccountInfo {
        address account;
        uint256 withdrawableDividends;
        uint256 totalDividends;
        uint256 lastClaimTime;
    }

    constructor(address _tokenAddress, address _uniswapRouter) {
        minTokenBalanceForDividends = 10000 * (10**18);
        tokenAddress = _tokenAddress;
        UNISWAPROUTER = _uniswapRouter;
    }

    receive() external payable {
        distributeDividends();
    }

    function distributeDividends() public payable {
        require(_totalSupply > 0);
        if (msg.value > 0) {
            magnifiedDividendPerShare =
                magnifiedDividendPerShare +
                ((msg.value * magnitude) / _totalSupply);
            emit DividendsDistributed(msg.sender, msg.value);
            totalDividendsDistributed += msg.value;
        }
    }

    function setBalance(address payable account, uint256 newBalance)
        external
        onlyOwner
    {
        if (excludedFromDividends[account]) {
            return;
        }
        if (newBalance >= minTokenBalanceForDividends) {
            _setBalance(account, newBalance);
        } else {
            _setBalance(account, 0);
        }
    }

    function excludeFromDividends(address account, bool excluded)
        external
        onlyOwner
    {
        require(
            excludedFromDividends[account] != excluded,
            "Investor_DividendTracker: account already set to requested state"
        );
        excludedFromDividends[account] = excluded;
        if (excluded) {
            _setBalance(account, 0);
        } else {
            uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
            if (newBalance >= minTokenBalanceForDividends) {
                _setBalance(account, newBalance);
            } else {
                _setBalance(account, 0);
            }
        }
        emit ExcludeFromDividends(account, excluded);
    }

    function isExcludedFromDividends(address account)
        public
        view
        returns (bool)
    {
        return excludedFromDividends[account];
    }

    function manualSendDividend(uint256 amount, address holder)
        external
        onlyOwner
    {
        uint256 contractETHBalance = address(this).balance;
        payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
    }

    function _setBalance(address account, uint256 newBalance) internal {
        uint256 currentBalance = _balances[account];
        if (newBalance > currentBalance) {
            uint256 addAmount = newBalance - currentBalance;
            _mint(account, addAmount);
        } else if (newBalance < currentBalance) {
            uint256 subAmount = currentBalance - newBalance;
            _burn(account, subAmount);
        }
    }

    function _mint(address account, uint256 amount) private {
        require(
            account != address(0),
            "Investor_DividendTracker: mint to the zero address"
        );
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
        magnifiedDividendCorrections[account] =
            magnifiedDividendCorrections[account] -
            int256(magnifiedDividendPerShare * amount);
    }

    function _burn(address account, uint256 amount) private {
        require(
            account != address(0),
            "Investor_DividendTracker: burn from the zero address"
        );
        uint256 accountBalance = _balances[account];
        require(
            accountBalance >= amount,
            "Investor_DividendTracker: burn amount exceeds balance"
        );
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
        magnifiedDividendCorrections[account] =
            magnifiedDividendCorrections[account] +
            int256(magnifiedDividendPerShare * amount);
    }

    function processAccount(address payable account)
        public
        onlyOwner
        returns (bool)
    {
        uint256 amount = _withdrawDividendOfUser(account);
        if (amount > 0) {
            lastClaimTimes[account] = block.timestamp;
            emit Claim(account, amount);
            return true;
        }
        return false;
    }

    function _withdrawDividendOfUser(address payable account)
        private
        returns (uint256)
    {
        uint256 _withdrawableDividend = withdrawableDividendOf(account);
        if (_withdrawableDividend > 0) {
            withdrawnDividends[account] += _withdrawableDividend;
            totalDividendsWithdrawn += _withdrawableDividend;
            emit DividendWithdrawn(account, _withdrawableDividend);
            (bool success, ) = account.call{
                value: _withdrawableDividend,
                gas: 3000
            }("");
            if (!success) {
                withdrawnDividends[account] -= _withdrawableDividend;
                totalDividendsWithdrawn -= _withdrawableDividend;
                return 0;
            }
            return _withdrawableDividend;
        }
        return 0;
    }

    function compoundAccount(address payable account)
        public
        onlyOwner
        returns (bool)
    {
        (uint256 amount, uint256 tokens) = _compoundDividendOfUser(account);
        if (amount > 0) {
            lastClaimTimes[account] = block.timestamp;
            emit Compound(account, amount, tokens);
            return true;
        }
        return false;
    }

    function _compoundDividendOfUser(address payable account)
        private
        returns (uint256, uint256)
    {
        uint256 _withdrawableDividend = withdrawableDividendOf(account);
        if (_withdrawableDividend > 0) {
            withdrawnDividends[account] += _withdrawableDividend;
            totalDividendsWithdrawn += _withdrawableDividend;
            emit DividendWithdrawn(account, _withdrawableDividend);

            IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
                UNISWAPROUTER
            );

            address[] memory path = new address[](2);
            path[0] = uniswapV2Router.WETH();
            path[1] = address(tokenAddress);

            bool success;
            uint256 tokens;

            uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
            try
                uniswapV2Router
                    .swapExactETHForTokensSupportingFeeOnTransferTokens{
                    value: _withdrawableDividend
                }(0, path, address(account), block.timestamp)
            {
                success = true;
                tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
            } catch Error(
                string memory /*err*/
            ) {
                success = false;
            }

            if (!success) {
                withdrawnDividends[account] -= _withdrawableDividend;
                totalDividendsWithdrawn -= _withdrawableDividend;
                return (0, 0);
            }

            return (_withdrawableDividend, tokens);
        }
        return (0, 0);
    }

    function withdrawableDividendOf(address account)
        public
        view
        returns (uint256)
    {
        return accumulativeDividendOf(account) - withdrawnDividends[account];
    }

    function withdrawnDividendOf(address account)
        public
        view
        returns (uint256)
    {
        return withdrawnDividends[account];
    }

    function accumulativeDividendOf(address account)
        public
        view
        returns (uint256)
    {
        int256 a = int256(magnifiedDividendPerShare * balanceOf(account));
        int256 b = magnifiedDividendCorrections[account]; // this is an explicit int256 (signed)
        return uint256(a + b) / magnitude;
    }

    function getAccountInfo(address account)
        public
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        AccountInfo memory info;
        info.account = account;
        info.withdrawableDividends = withdrawableDividendOf(account);
        info.totalDividends = accumulativeDividendOf(account);
        info.lastClaimTime = lastClaimTimes[account];
        return (
            info.account,
            info.withdrawableDividends,
            info.totalDividends,
            info.lastClaimTime,
            totalDividendsWithdrawn
        );
    }

    function getLastClaimTime(address account) public view returns (uint256) {
        return lastClaimTimes[account];
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address, uint256) public pure override returns (bool) {
        revert("Investor_DividendTracker: method not implemented");
    }

    function allowance(address, address)
        public
        pure
        override
        returns (uint256)
    {
        revert("Investor_DividendTracker: method not implemented");
    }

    function approve(address, uint256) public pure override returns (bool) {
        revert("Investor_DividendTracker: method not implemented");
    }

    function transferFrom(
        address,
        address,
        uint256
    ) public pure override returns (bool) {
        revert("Investor_DividendTracker: method not implemented");
    }
}