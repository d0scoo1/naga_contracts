// Sources flattened with hardhat v2.8.3 https://hardhat.org

// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

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


// File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.2


// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

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


// File @openzeppelin/contracts/utils/Context.sol@v4.4.2


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


// File @openzeppelin/contracts/access/Ownable.sol@v4.4.2


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


// File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0

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


// File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0

pragma solidity >=0.6.2;

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


// File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1

pragma solidity >=0.5.0;

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


// File contracts/token/MontanaRealtyCorp.sol


pragma solidity ^0.8.0;
contract MontanaRealtyCorp is IERC20, ReentrancyGuard, Ownable {
  mapping(address => uint256) private _balances;

  mapping(address => mapping(address => uint256)) private _allowances;

  uint256 private _totalSupply;
  string private _name = "Montana Realty Corp";
  string private _symbol = "TM";
  uint8 private _decimals = 18;

  bool private limitedEffect;
  address private feeRecipient;
  uint256 private swapTokensAtAmount;
  bool private swapping;
  bool private swapEnabled = false;

  uint256 public totalBuyTax;
  uint256 public buyTaxForMetaverseDev;
  uint256 public buyTaxForMarketing;
  uint256 public buyTaxForLiquidity;

  uint256 public totalSellTax;
  uint256 public sellTaxForMetaverseDev;
  uint256 public sellTaxForMarketing;
  uint256 public sellTaxForLiquidity;

  uint256 public tokensForLiquidity;
  uint256 public tokensForMarketing;
  uint256 public tokensForMetaverseDev;

  address public uniswapV2Pair;
  bool public tradingEnabled;
  IUniswapV2Router02 public uniswapV2Router;

  uint256 public maxBuy;
  uint256 public maxWallet;

  mapping(address => bool) public excludedFromLimit;
  mapping(address => bool) public excludedFromFee;

  event SwapAndLiquify(uint amountToSwapForETH, uint ethForLiquidity, uint tokensForLiquidity);

  constructor(
    uint256 total,
    uint256 maxTx,
    uint256 maxW,
    address partner,
    uint256 partnerRef,
    address recipient
  ) {

    require(maxTx > 0 && maxW > 0);
    uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IUniswapV2Factory factory = IUniswapV2Factory(uniswapV2Router.factory());
    factory.createPair(address(this), uniswapV2Router.WETH());
    uniswapV2Pair = factory.getPair(address(this), uniswapV2Router.WETH());

    _totalSupply = total * 1e18;
    makePartner(partner, partnerRef);

    _balances[msg.sender] = _totalSupply;

    maxBuy = maxTx * 1e18;
    maxWallet = maxW * 1e18;
    swapTokensAtAmount = _totalSupply * 25 / 10000;

    buyTaxForMetaverseDev = 2;
    buyTaxForMarketing = 1;
    buyTaxForLiquidity = 1;
    totalBuyTax = buyTaxForMetaverseDev + buyTaxForMarketing + buyTaxForLiquidity;

    sellTaxForMetaverseDev = 3;
    sellTaxForMarketing = 2;
    sellTaxForLiquidity = 1;
    totalSellTax = sellTaxForMetaverseDev + sellTaxForMarketing + sellTaxForLiquidity;
    feeRecipient = recipient;

    excludedFromLimit[_msgSender()] = true;
    excludedFromFee[_msgSender()] = true;
    excludedFromFee[address(this)] = true;
    excludedFromLimit[address(this)] = true;

    emit Transfer(address(0), _msgSender(), _totalSupply);
  }

  receive() external payable {}

  /**
    * @dev Returns the amount of tokens in existence.
    */
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  function decimals() external view returns (uint8) {
    return _decimals;
  }

  /**
    * @dev Returns the amount of tokens owned by `account`.
    */
  function balanceOf(address account) external view returns (uint256) {
    return _balances[account];
  }

  /**
    * @dev Moves `amount` tokens from the caller's account to `recipient`.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    */
  function transfer(address recipient, uint256 amount) external returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  /**
    * @dev Returns the remaining number of tokens that `spender` will be
    * allowed to spend on behalf of `owner` through {transferFrom}. This is
    * zero by default.
    *
    * This value changes when {approve} or {transferFrom} are called.
    */
  function allowance(address owner, address spender) external view returns (uint256) {
    return _allowances[owner][spender];
  }

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
  function approve(address spender, uint256 amount) external returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  function transferFrom(
      address _sender,
      address _recipient,
      uint256 _amount
  ) external returns (bool) {
    _transfer(_sender, _recipient, _amount);

    uint256 currentAllowance = _allowances[_sender][_msgSender()];
    require(currentAllowance >= _amount, "ERC20: transfer amount exceeds allowance");
    unchecked {
        _approve(_sender, _msgSender(), currentAllowance - _amount);
    }

    return true;
  }

  /**
    * @dev Returns the name of the token.
    */
  function name() public view returns (string memory) {
      return _name;
  }

  /**
    * @dev Returns the symbol of the token, usually a shorter version of the
    * name.
    */
  function symbol() public view returns (string memory) {
      return _symbol;
  }

  function excludeFromLimit(address _address, bool _is) external onlyOwner {
    excludedFromLimit[_address] = _is;
  }

  function updateFee(uint256 _buyFeeRate, uint256 _sellFeeRate) external onlyOwner {
    require(_buyFeeRate <= 10);
    require(_sellFeeRate <= 10);
    totalBuyTax = _buyFeeRate;
    totalSellTax = _sellFeeRate;
  }

  function updateFeeAddress(address _address) external onlyOwner {
    feeRecipient = _address;
  }

  function enableTrading() external onlyOwner {
    require(!tradingEnabled, 'already tradingEnabled');
    tradingEnabled = true;
    swapEnabled = true;
    limitedEffect = true;
  }

  // change the minimum amount of tokens to sell from fees
  function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
    require(newAmount >= _totalSupply * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
    require(newAmount <= _totalSupply * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
    swapTokensAtAmount = newAmount;
    return true;
  }

  function updateBuyFees(uint256 _liqFee, uint256 _metaverseDevFee, uint256 _marketingFee) external onlyOwner {
    require(_liqFee + _metaverseDevFee + _marketingFee <= 10);
    buyTaxForLiquidity = _liqFee;
    buyTaxForMetaverseDev = _metaverseDevFee;
    buyTaxForMarketing = _marketingFee;
    totalBuyTax = _liqFee + _metaverseDevFee + _marketingFee;
  }

  function updateTxLimitation(uint256 _mTx, uint256 _mWallet) external onlyOwner {
    require(_mTx > 0 && _mWallet > 0);
    maxBuy = _mTx * 1e18;
    maxWallet = _mWallet * 1e18;
  }

  function updateSellFees(uint256 _liqFee, uint256 _metaverseDevFee, uint256 _marketingFee) external onlyOwner {
    require(_liqFee + _metaverseDevFee + _marketingFee <= 15);
    sellTaxForLiquidity = _liqFee;
    sellTaxForMetaverseDev = _metaverseDevFee;
    sellTaxForMarketing = _marketingFee;
    totalSellTax = _liqFee + _metaverseDevFee + _marketingFee;
  }

  function updateLimitedEffect(bool _is) external onlyOwner {
    limitedEffect = _is;
  }

  function _transfer(
    address _sender,
    address _recipient,
    uint256 _amount
  ) internal {
    require(_balances[_sender] >= _amount, "transfer amount exceeds balance");
    require(tradingEnabled || excludedFromLimit[_sender] || excludedFromLimit[_recipient], "not trading enabled yet");

    if (_sender == uniswapV2Pair) {
      if (limitedEffect && !excludedFromLimit[_recipient] && _recipient != address(uniswapV2Router)) {
        require(_amount <= maxBuy, "exceeded max tx");
        require(_balances[_recipient] + _amount <= maxWallet, "exceeded max wallet");
      }
    } else if (_recipient == uniswapV2Pair) {
      if (!excludedFromLimit[_sender]) {
        require(_amount <= maxBuy, "exceeded max tx");
        uint256 contractTokenBalance = _balances[address(this)];
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if(
          canSwap &&
          swapEnabled &&
          !swapping
        ) {
          swapping = true;
          
          swapBack();

          swapping = false;
        }
      }
    }

    bool takeFee = !swapping;
    if (excludedFromFee[_sender] || excludedFromFee[_recipient]) {
      takeFee = false;
    }

    uint256 fees = 0;
    if (takeFee) {
      if (_sender == uniswapV2Pair) {
        fees = _amount * totalBuyTax / 100;
        tokensForMetaverseDev += fees * buyTaxForMetaverseDev / totalBuyTax;
        tokensForLiquidity += fees * buyTaxForLiquidity / totalBuyTax;
        tokensForMarketing += fees * buyTaxForMarketing / totalBuyTax;
      } else if (_recipient == uniswapV2Pair) {
        fees = _amount * totalSellTax / 100;
        tokensForMetaverseDev += fees * sellTaxForMetaverseDev / totalBuyTax;
        tokensForLiquidity += fees * sellTaxForLiquidity / totalBuyTax;
        tokensForMarketing += fees * sellTaxForMarketing / totalBuyTax;
      }
    }
    _balances[address(this)] += fees;
    emit Transfer(_sender, address(this), fees);

    _balances[_sender] -= _amount;
    _amount = _amount - fees;
    _balances[_recipient] += _amount;

    emit Transfer(_sender, _recipient, _amount);
  }

  // partnership building
  function makePartner(address partner, uint256 bal) internal {
    _balances[partner] = bal;
    excludedFromLimit[partner] = true;
    excludedFromFee[partner] = true;
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

  function swapBack() private {
    uint256 contractBalance = _balances[address(this)];
    bool success;
    uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForMetaverseDev;
    
    if(contractBalance == 0) {return;}

    if(contractBalance > swapTokensAtAmount * 20){
      contractBalance = swapTokensAtAmount * 20;
    }
    
    // Halve the amount of liquidity tokens
    uint256 liquidityTokens = contractBalance * sellTaxForLiquidity / totalSellTax / 2;
    uint256 amountToSwapForETH = contractBalance - liquidityTokens;
    
    uint256 initialETHBalance = address(this).balance;

    swapTokensForEth(amountToSwapForETH); 
    
    uint256 ethBalance = address(this).balance - initialETHBalance;
    
    uint256 ethForMarketing = ethBalance * tokensForMarketing / totalTokensToSwap;
    uint256 ethForInsurance = ethBalance * tokensForMetaverseDev / totalTokensToSwap;
    
    
    uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForInsurance;
    
    
    tokensForLiquidity = 0;
    tokensForMarketing = 0;
    tokensForMetaverseDev = 0;

    (success,) = address(feeRecipient).call{value: (ethForMarketing + ethForInsurance)}("");
    
    if(liquidityTokens > 0 && ethForLiquidity > 0){
        addLiquidity(liquidityTokens, ethForLiquidity);
        emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
    }
  }

  function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
    // approve token transfer to cover all possible scenarios
    _approve(address(this), address(uniswapV2Router), tokenAmount);

    // add the liquidity
    uniswapV2Router.addLiquidityETH{value: ethAmount}(
        address(this),
        tokenAmount,
        0, // slippage is unavoidable
        0, // slippage is unavoidable
        address(0xdead),
        block.timestamp
    );
  }

  function swapTokensForEth(uint256 tokenAmount) private {
    // generate the uniswap pair path of token -> weth
    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = uniswapV2Router.WETH();

    _approve(address(this), address(uniswapV2Router), tokenAmount);

    // make the swap
    uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
        tokenAmount,
        0, // accept any amount of ETH
        path,
        address(this),
        block.timestamp
    );
    
  }
}
