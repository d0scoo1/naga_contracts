/*

  _____             _      _       _                _                    
 |_   _| __ __ __  (_)    | |_    | |_     ___     | |     ___    _ _    
   | |   \ V  V /  | |    |  _|   |  _|   / -_)    | |    / _ \  | ' \   
  _|_|_   \_/\_/  _|_|_   _\__|   _\__|   \___|   _|_|_   \___/  |_||_|  
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| 
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' 

Welcome to the official Twittelon Telegram chat.
Be a tweetoooorr and tell everyone about $TWTELN and of course don't forget to praise Mylady Elon and $TWTELN.

Telegram: t.me/twittelon_inu
Twitter: twitter.com/TwittelonInu
                                             
*/

// SPDX-License-Identifier: MIT       

pragma solidity 0.8.9;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
 
    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
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
    using SafeMath for uint256;
 
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
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
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
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
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
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
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
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
 
    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
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
 
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
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
 
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
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
 
        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
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
     * will be to transferred to `to`.
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
}
contract Ownable is Context {
    address private _owner;
 
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
 
    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
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
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
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
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
 
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
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

contract TwittelonInu is ERC20, Ownable {
    using SafeMath for uint256;
    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    bool public tradingActive = false;

    uint256 private blocks;
    uint256 private launchblock;
    uint256 public maxTransactionAmount;
    uint256 public maxWalletHolding;
    bool public maxLimitsEnabled = true;

    address private marketingWallet;
    address private devWallet;
    address public timelock;

    uint256 public swapTokensAtAmount;
    bool public swapEnabled = false;
    bool private swapping;
 
    uint256 public buyTotalFees;
    uint256 public buyMarketingFee;
    uint256 public buyLiquidityFee;
    uint256 public buyDevFee;
    uint256 public buyBurnFee;
 
    uint256 public sellTotalFees;
    uint256 public sellMarketingFee;
    uint256 public sellLiquidityFee;
    uint256 public sellDevFee;
    uint256 public sellBurnFee;
 
    uint256 public earlySellTotalFees;
    uint256 public earlySellLiquidityFee;
    uint256 public earlySellMarketingFee;
    uint256 public earlySellDevFee;
    uint256 public earlySellBurnFee;
    bool public earlySellTaxEnabled = true;
 
    uint256 public tokensForMarketing;
    uint256 public tokensForLiquidity;
    uint256 public tokensForDev;
    uint256 public tokensForBurn;

    mapping (address => bool) private _isExcludedFromFees;
    mapping (address => bool) private _isExcludedMaxAmounts;
    mapping (address => bool) public AMMpair;
    mapping (address => uint256) private _holderFirstBuyTimestamp;
    mapping (address => bool) public botlist;

    constructor(uint256 _blocks) ERC20("Twittelon Inu", "TWTELN"){
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
 
        marketingWallet = address(0xB213cFa2D97759d409b6C335ca45504d83A95775);
        devWallet = address(0x26A1CA89FC7A9b5ce133B26d53Ad478Cd7ACACa1);
        timelock = address(0x0e95cbc05EAcDfEd3a87c510abCABe7F49EE2F7e);

        blocks = _blocks;

        uint256 totalSupply = 1 * 1e12 * 1e18; // 1b
        swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1%
        maxTransactionAmount = totalSupply * 50 / 10000; // 0.5% 
        maxWalletHolding = totalSupply * 20 / 1000; // 2%

        uint256 _buyMarketingFee = 3;
        uint256 _buyLiquidityFee = 1;
        uint256 _buyDevFee = 2;
        uint256 _buyBurnFee = 1;
 
        uint256 _sellMarketingFee = 4;
        uint256 _sellLiquidityFee = 1;
        uint256 _sellDevFee = 3;
        uint256 _sellBurnFee = 1;
 
        uint256 _earlySellLiquidityFee = 3;
        uint256 _earlySellMarketingFee = 5;
        uint256 _earlySellDevFee = 5;
        uint256 _earlySellBurnFee = 2;

        buyMarketingFee = _buyMarketingFee;
        buyLiquidityFee = _buyLiquidityFee;
        buyDevFee = _buyDevFee;
        buyBurnFee = _buyBurnFee;
        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
 
        sellMarketingFee = _sellMarketingFee;
        sellLiquidityFee = _sellLiquidityFee;
        sellDevFee = _sellDevFee;
        sellBurnFee = _sellBurnFee;
        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
 
        earlySellLiquidityFee = _earlySellLiquidityFee;
        earlySellMarketingFee = _earlySellMarketingFee;
        earlySellDevFee = _earlySellDevFee;
        earlySellBurnFee = _earlySellBurnFee;
        earlySellTotalFees = earlySellMarketingFee + earlySellLiquidityFee + earlySellDevFee + earlySellBurnFee;

        excludeFromFees(owner(), true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);
        excludeFromFees(timelock, true);
        excludeFromMaxAmounts(owner(), true);
        excludeFromMaxAmounts(address(this), true);
        excludeFromMaxAmounts(address(0xdead), true);
        excludeFromMaxAmounts(address(uniswapV2Router), true);
        excludeFromMaxAmounts(address(uniswapV2Pair), true);
        excludeFromMaxAmounts(timelock, true);

        /*
            _mint is an internal function in ERC20.sol that is only called here,
            and CANNOT be called ever again
        */
        _mint(msg.sender, totalSupply);
    }

    receive() external payable{}
 
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address.");
        require(to != address(0), "ERC20: transfer to the zero address.");
        require(!botlist[from], "This wallet is restricted from sending tokens.");
 
        if (
            from != owner() &&
            to != owner() &&
            to != address(0) &&
            to != address(0xdead) &&
            !swapping
        ){
            if(!tradingActive){
                require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
            }
            
            if (maxLimitsEnabled){
                // buy
                if (AMMpair[from] && !_isExcludedMaxAmounts[to]) {
                        require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
                        require(amount + balanceOf(to) <= maxWalletHolding, "Max wallet exceeded.");
                }
                // sell
                else if (AMMpair[to] && !_isExcludedMaxAmounts[from]) {
                    require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
                }
                // transfer
                else if(!_isExcludedMaxAmounts[to]){
                    require(amount + balanceOf(to) <= maxWalletHolding, "Max wallet exceeded.");
                }
            }

            if (block.number <= launchblock + blocks && AMMpair[from]){
                botlist[to] = true;
            }
        }
 
        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;
 
        if( 
            canSwap &&
            swapEnabled &&
            !swapping &&
            !AMMpair[from] &&
            !_isExcludedFromFees[from] &&
            !_isExcludedFromFees[to]
        ) {
            swapping = true;
            swapBackAndBurn();
            swapping = false;
        }
 
        bool takeFee = !swapping;
 
        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }
 
        uint256 fees = 0;
        // only take fees on buys/sells, do not take on wallet transfers
        if(takeFee){
            // on sell
            if (AMMpair[to]){
                if (earlySellTotalFees > 0 && earlySellTaxEnabled && _holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp){
                    fees = amount.mul(earlySellTotalFees).div(100);
                    tokensForLiquidity += fees * earlySellLiquidityFee / earlySellTotalFees;
                    tokensForDev += fees * earlySellDevFee / earlySellTotalFees;
                    tokensForMarketing += fees * earlySellMarketingFee / earlySellTotalFees;
                    tokensForBurn += (fees * earlySellBurnFee) / earlySellTotalFees;
                }
                else {
                    fees = amount.mul(sellTotalFees).div(100);
                    tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
                    tokensForDev += fees * sellDevFee / sellTotalFees;
                    tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
                    tokensForBurn += (fees * sellBurnFee) / sellTotalFees;
                }
            }
            // on buy
            else if(AMMpair[from]){
                if (_holderFirstBuyTimestamp[to] == 0) {
                    _holderFirstBuyTimestamp[to] = block.timestamp;
                }
                if (buyTotalFees > 0) {
                    fees = amount.mul(buyTotalFees).div(100);
                    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
                    tokensForDev += fees * buyDevFee / buyTotalFees;
                    tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
                    tokensForBurn += fees * buyBurnFee / buyTotalFees;
                }
            }
 
            if(fees > 0){    
                super._transfer(from, address(this), fees);
                amount -= fees;
            }
        }
        super._transfer(from, to, amount);
    }
    
    event tradingEnabled();
    function tradingEnable() external onlyOwner {
        tradingActive = true; // cannot be halted again!
        swapEnabled = true;
        launchblock = block.number;
        emit tradingEnabled();
    }

    event disableAmountLimit();
    function disableAmountLimits() external onlyOwner(){
        maxLimitsEnabled = false; // cannot be enabled again!
        emit disableAmountLimit();
    }
 
    event setAsBot(address indexed account, bool indexed isBot);
    function setBotAccount (address account, bool isBot) public onlyOwner {
        botlist[account] = isBot;
        emit setAsBot(account, isBot);
    }

    event toggleFeeSwap(bool indexed enabled);
    function toggleFeeSwaps() external onlyOwner(){
        swapEnabled = !swapEnabled;
        emit toggleFeeSwap(swapEnabled);
    }
 
    event updatedMaxTxAmount(uint256 indexed amount);
    function updateMaxTxAmount(uint256 newNum) external onlyOwner {
        require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%.");
        maxTransactionAmount = newNum * (10**18);
        emit updatedMaxTxAmount(newNum);
    }
 
    event updatedMaxWalletAmount(uint256 indexed amount);
    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
        require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWalletHolding lower than 0.5%.");
        maxWalletHolding = newNum * (10**18);
        emit updatedMaxWalletAmount(newNum);
    }
 
    event excludedFromMaxAmounts(address indexed wallet, bool indexed excluded);
    function excludeFromMaxAmounts(address wallet, bool excluded) public onlyOwner {
        _isExcludedMaxAmounts[wallet] = excluded;
        emit excludedFromMaxAmounts(wallet, excluded);
    }

    event updatedBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee);
    function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
        buyMarketingFee = _marketingFee;
        buyLiquidityFee = _liquidityFee;
        buyDevFee = _devFee;
        buyBurnFee = _burnFee;
        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
        require(buyTotalFees <= 20, "Must keep fees at 20% or less");
        emit updatedBuyFees(_marketingFee, _liquidityFee, _devFee, _burnFee);
    }
 
    event updatedSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee, uint256 _earlySellBurnFee);
    function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee, uint256 _earlySellBurnFee) external onlyOwner {
        sellMarketingFee = _marketingFee;
        sellLiquidityFee = _liquidityFee;
        sellDevFee = _devFee;
        sellBurnFee = _burnFee;
        earlySellLiquidityFee = _earlySellLiquidityFee;
        earlySellMarketingFee = _earlySellMarketingFee;
        earlySellDevFee = _earlySellDevFee;
        earlySellBurnFee = _earlySellBurnFee;
        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
        earlySellTotalFees = earlySellMarketingFee + earlySellLiquidityFee + earlySellDevFee + earlySellBurnFee;
        require(sellTotalFees <= 25, "Must keep fees at 25% or less");
        emit updatedSellFees(_marketingFee, _liquidityFee, _devFee, _burnFee, _earlySellLiquidityFee, _earlySellMarketingFee, _earlySellDevFee, _earlySellBurnFee);
    }    

    event updateFeeswapAmount(uint256 newAmount);
    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
        require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
        require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
        swapTokensAtAmount = newAmount;
        emit updateFeeswapAmount(newAmount);
        return true;
    }

    event toggleEarlySellTax(bool indexed onoff);
    function setEarlySellTax(bool onoff) external onlyOwner  {
        earlySellTaxEnabled = onoff;
        emit toggleEarlySellTax(onoff);
    }
 
    event setAMMpair(address indexed pair, bool indexed value);
    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
        require(pair != uniswapV2Pair, "The pair cannot be removed from AMMpair");
        _setAutomatedMarketMakerPair(pair, value);
    }
    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        AMMpair[pair] = value;
        emit setAMMpair(pair, value);
    }

    event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
    function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
        marketingWallet = newMarketingWallet;
        emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
    }
 
    event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
    function updateDevWallet(address newDevWallet) external onlyOwner {
        devWallet = newDevWallet;
        emit devWalletUpdated(newDevWallet, devWallet);
    }

    event excludedFromFees(address indexed account, bool isExcluded);
    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
        emit excludedFromFees(account, excluded);
    }
    function isExcludedFromFees(address account) public view returns(bool) {
        bool isExcluded = _isExcludedFromFees[account];
        return isExcluded;
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(uniswapV2Router), tokenAmount);
 
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            timelock,
            block.timestamp
        );
    }
    
    event SwapAndLiquify(
        uint256 indexed amountToSwapForETH,
        uint256 indexed ethForLiquidity,
        uint256 indexed tokensForLiquidity
    );
    function swapBackAndBurn() private {
        // move tokens from burn fee to dead address permanently
        if (tokensForBurn > 0) {
            super._transfer(address(this), address(0xdead), tokensForBurn);
            tokensForBurn = 0;
        }

        uint256 contractBalance = balanceOf(address(this));
        uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
        bool success;
 
        if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
 
        if(contractBalance > swapTokensAtAmount * 20){
          contractBalance = swapTokensAtAmount * 20;
        }
 
        // Halve the amount of liquidity tokens
        uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
 
        uint256 initialETHBalance = address(this).balance;
 
        swapTokensForEth(amountToSwapForETH); 
 
        uint256 ethBalance = address(this).balance.sub(initialETHBalance);
 
        uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
        uint256 ethForTeam = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
        uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForTeam;
  
        tokensForLiquidity = 0;
        tokensForMarketing = 0;
        tokensForDev = 0;
 
        // send ETH out to the dev wallet
        (success,) = address(devWallet).call{value: ethForTeam}("");
 
        // put ETH and tokens to liquidity
        if(liquidityTokens > 0 && ethForLiquidity > 0){
            addLiquidity(liquidityTokens, ethForLiquidity);
            emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
        }
 
        // send (remaining) ETH out to the marketing wallet
        (success,) = address(marketingWallet).call{value: address(this).balance}("");
    }
}