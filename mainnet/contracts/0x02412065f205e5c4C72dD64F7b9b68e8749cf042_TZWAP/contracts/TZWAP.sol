// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**
*                                                                                  
..................................................................            
.                                                                .            
.  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  .            
.  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  .            
.  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  .            
.  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  .            
.  ::::::::::::::::::::--:.......:-==--:...::==::::::::::::::::  .            
.  ::::::::::::::::::--.    .:::.:--+=::::::--::-::::::::::::::  .            
.  :::::::::::::::::+:    ::.    .:--+=-===:..:--=-::::::::::::  .            
.  :::::::::::::::--     ..     .:-----=--. .:-=-:---::::::::::  .            
.  ::::::::::::::-.      .-::::.:+=====-=::---===--.:-:::::::::  .            
.  :::::::::::::-.   ...:...::::==+===::+=:-:::===:-=-==-::::::  .            
.  ::::::::::::=:.  :..:    ...---=-:::--=-:-=--::..:---+-:::::  .            
.  :::::::::::=:.. .::---...#+*@%%@-...:-==--=+*@@#-.:-=+::::::  .            
.  ::::::::::--..........::-%%#@=.%#    --=--:@+@#.+.   +::::::  .            
.  ::::::::::=..........:--:.-=*#%@=   ..=-=:-@#%@%%:.:-=::::::  .            
.  :::::::::-+=--:...:-:....-=========--:-=+**+:....::=-:::::::  .            
.  ::::::::--+==-:::-:..:::::------::--:..:::.-:.  ::::=-::::::  .            
.  ::::::::= ---. .:::..::::::--:-==--:::--:... ..     :+=:::::  .            
.  :::::::-: .:-:.:=++=-:::::::--=---------:.. ... .:--:*#-::::  .            
.  ::::::-=..  ::..-----=-::::---:--=---==--:..:. :---=*#=:::::  .            
.  :::::-: -   ....::.   .:::::=*####*****++====--++*##%-::::::  .            
.  ::::-.   :::....:.     .::::::+######################+::::::  .            
.  :::-.    .------:::::::::======+####################+:::::::  .            
.  ::-#=.     --++=-:=:::::-======++++*****+++++++=--:=::::::::  .            
.  ::#@@@%+:  ::  .-==-----*====::--:::-::   .:.:...:-=::::::::  .            
.  :=@@@@@@@@#-   --:...--++=-+....:..-*=-....:-::::-%@%+::::::  .            
.  :%@@@@@@@@@:::...:-=+-:. .--::-::..:+=:.  :==-.:: @@@@@*-:::  .            
.  =@@@@@@@@@+. .:..---:...:=:*@@@@@@@@@@@@@@@@@@@@+.@@@@@@@+::  .            
.  %@@@@@@@@@:..  .::::--:..:%@@@@@@@@@@@@@@@@@@@@@@#@@@@@@@@#-  .            
.  @@@@@@@@%-      .:::.:=#@=:%@@@#-.  -=:-=+*%@@@@@@@@@@@@@@@@  .            
.  @@@@@@@@@..        :#@@@@@%-:+@@.   ..  =-+%@@@@@@@@@@@@@@@@. .            
.  @@@@@@@@@%:...     :@@@@@@@@@@@@@=  :.:%@@@@@@@@@@@@@@@@@@@@. .            
.  @@@@@@@@@@@%+-:-*#@@@@@@@@@@@@@@#-  .. -@@@@@@@@@@@@@@@@@@@@. .            
.  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%. :. #@@@@@@@@@@@@@@@@@@@@. .            
.                                                                .            
..................................................................            

            ████████╗███████╗██╗    ██╗ █████╗ ██████╗ 
            ╚══██╔══╝╚══███╔╝██║    ██║██╔══██╗██╔══██╗
              ██║     ███╔╝ ██║ █╗ ██║███████║██████╔╝
              ██║    ███╔╝  ██║███╗██║██╔══██║██╔═══╝ 
              ██║   ███████╗╚███╔███╔╝██║  ██║██║     
              ╚═╝   ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝     
                                                      
                TZWAP: On-chain TWAP Service
*/
import {Pausable} from '@openzeppelin/contracts/security/Pausable.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {I1inchAggregationRouterV4} from './interfaces/I1inchAggregationRouterV4.sol';
import {IChainlinkOracle} from './interfaces/IChainlinkOracle.sol';
import {ICustomPriceOracle} from './interfaces/ICustomPriceOracle.sol';
import {IWETH9} from './interfaces/IWETH9.sol';
import {IERC20} from'./interfaces/IERC20.sol';
import {ISafeERC20} from './interfaces/ISafeERC20.sol';


contract TZWAP is Ownable, Pausable {

  using ISafeERC20 for IERC20;

  I1inchAggregationRouterV4 public aggregationRouterV4;
  IWETH9 public weth;

  // Min TWAP interval in seconds
  uint public minInterval = 60;

  // Min number of intervals for a TWAP order
  uint public minNumOfIntervals = 3;

  // Precision for all % math
  uint public percentagePrecision =  10 ** 5;

  // Auto-incrementing of orders
  uint public orderCount;
  // TWAP orders mapped to auto-incrementing ID
  mapping (uint => TWAPOrder) public orders;
  // IDs of TWAP orders for a certain user address
  mapping (address => uint[]) public userOrders;
  // Fills for TWAP orders
  mapping (uint => Fill[]) public fills;
  // Token addresses mapped to oracles
  mapping (address => Oracle) public oracles;
  // Whitelisted addresses who can interact with fillOrder
  mapping (address => bool) public whitelist;

  // If true only whitelisted addresses can interact with fillOrder
  bool public isWhitelistActive;

  struct Oracle {
    // Address of oracle
    address oracleAddress;
    // Toggled to false if oracle is not chainlink
    bool isChainlink;
  }

  struct TWAPOrder {
    // Order creator
    address creator;
    // Token to swap from
    address srcToken;
    // Token to swap to
    address dstToken;
    // How often a swap should be made
    uint interval;
    // srcToken to swap per interval
    uint tickSize;
    // Total srcToken to swap
    uint total;
    // Min fees in % to be paid per swap interval
    uint minFees;
    // Max fees in % to be paid per swap interval
    uint maxFees;
    // Creation timestamp
    uint created;
    // Toggled to true when an order is killed
    bool killed;
  }
  
  struct Fill {
    // Address that called fill
    address filler;
    // Amount of ticks filled
    uint ticksFilled;
    // Amount of srcToken spent
    uint srcTokensSwapped;
    // Amount of dstToken received
    uint dstTokensReceived;
    // Fees collected
    uint fees;
    // Time of last fill
    uint timestamp;
  }

  // 1inch swaps structs

  struct swapParams {
    address caller;
    I1inchAggregationRouterV4.SwapDescription desc;
    bytes data;
  }

  struct unoswapParams {
    address srcToken;
    uint256 amount;
    uint256 minReturn;
    bytes32[] pools;
  }

  struct uniswapV3Params {
    uint256 amount;
    uint256 minReturn;
    uint256[] pools;
  }

  event LogNewOrder(uint id);
  event LogNewFill(uint id, uint fillIndex);
  event LogOrderKilled(uint id);

  constructor(
    address payable _aggregationRouterV4Address,
    address payable _wethAddress
  ) {
    aggregationRouterV4 = I1inchAggregationRouterV4(_aggregationRouterV4Address);
    weth = IWETH9(_wethAddress);
    isWhitelistActive = true;
  }

  receive() external payable {}

  /**
  * Creates a new TWAP order
  * @param order Order params
  * @return Whether order was created
  */
  function newOrder(
    TWAPOrder memory order
  )
  payable
  public
  whenNotPaused
  returns (bool) {
    require(order.srcToken != address(0), "Invalid srcToken address");
    require(order.dstToken != address(0), "Invalid dstToken address");
    require(order.interval >= minInterval, "Invalid interval");
    require(order.tickSize > 0, "Invalid tickSize");
    require(order.total > order.tickSize && order.total % order.tickSize == 0, "Invalid total");
    require(order.total / order.tickSize > minNumOfIntervals, "Number of intervals is too less");
    order.creator = msg.sender;
    order.created = block.timestamp;
    order.killed = false;

    if (order.srcToken == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
      require(msg.value == order.total, "Invalid msg value");
      weth.deposit{value: msg.value}();
      order.srcToken = address(weth);
    }
    else {
      require(IERC20(order.srcToken).transferFrom(msg.sender, address(this), order.total));
    }

    require(oracles[order.srcToken].oracleAddress != address(0) && oracles[order.dstToken].oracleAddress != address(0), "Oracle is missing");

    orders[orderCount++] = order;
    userOrders[msg.sender].push(orderCount - 1);
    emit LogNewOrder(orderCount - 1);

    return true;
  }

  /**
  * Fills an active order
  * @param id Order ID
  * @param swapType 0: swap() 1: unoswap() 2: uniswapV3SwapTo()
  * @param _swapParams Default 1inch swap
  * @param _unoswapParams 1inch swap through only sushi or uni v2
  * @param _uniswapV3Params 1inch swap through only uni v3
  * @return Whether order was filled
  */
  function fillOrder(
    uint id,
    uint swapType,
    swapParams calldata _swapParams,
    unoswapParams calldata _unoswapParams,
    uniswapV3Params calldata _uniswapV3Params
  )
  public
  whenNotPaused
  returns (uint) {
    if (isWhitelistActive)
      require(whitelist[msg.sender] == true, "Not whitelisted");

    require(orders[id].created != 0, "Invalid order");
    require(!orders[id].killed, "Order was killed");
    require(getSrcTokensSwappedForOrder(id) < orders[id].total, "Order is already filled");

    uint ticksToFill = getTicksToFill(id);

    require(ticksToFill > 0, "Interval must pass before next fill");

    fills[id].push(
      Fill({
        filler: msg.sender, 
        ticksFilled: ticksToFill, 
        srcTokensSwapped: 0, // Update after swap
        dstTokensReceived: 0, // Update after swap
        fees: 0, // Update after swap
        timestamp: block.timestamp
      })
    );

    uint preSwapSrcTokenBalance = IERC20(orders[id].srcToken).balanceOf(address(this));
    uint preSwapDstTokenBalance = IERC20(orders[id].dstToken).balanceOf(address(this));

    if (IERC20(orders[id].srcToken).allowance(address(this), address(aggregationRouterV4)) == 0)
      IERC20(orders[id].srcToken).safeIncreaseAllowance(address(aggregationRouterV4), 2**256 - 1);

    if (swapType == 0) aggregationRouterV4.swap(_swapParams.caller, _swapParams.desc, _swapParams.data);
    else if (swapType == 1) aggregationRouterV4.unoswap(_unoswapParams.srcToken, _unoswapParams.amount, _unoswapParams.minReturn, _unoswapParams.pools);
    else aggregationRouterV4.uniswapV3Swap(_uniswapV3Params.amount, _uniswapV3Params.minReturn, _uniswapV3Params.pools);

    uint256 srcTokensSwapped = preSwapSrcTokenBalance - IERC20(orders[id].srcToken).balanceOf(address(this));
    uint256 dstTokensReceived = IERC20(orders[id].dstToken).balanceOf(address(this)) - preSwapDstTokenBalance;

    _ensureSwapValidityAndUpdate(id, srcTokensSwapped, dstTokensReceived);

    require(srcTokensSwapped == ticksToFill * orders[id].tickSize, "Invalid amount");
    require(getSrcTokensSwappedForOrder(id) <= orders[id].total, "Overbought");

    _setFeesAndDistribute(id);

    emit LogNewFill(id, fills[id].length - 1);

    return fills[id][fills[id].length - 1].fees;
  }

  /**
  * Execute post-swap checks and updates
  */
  function _ensureSwapValidityAndUpdate(
    uint id,
    uint256 srcTokensSwapped,
    uint256 dstTokensReceived
  )
  internal {
    // Estimate amount to receive using oracles
    uint srcTokenPriceInUsd;
    uint dstTokenPriceInUsd;

    if (oracles[orders[id].srcToken].isChainlink)
      srcTokenPriceInUsd = uint(IChainlinkOracle(oracles[orders[id].srcToken].oracleAddress).latestAnswer());
    else
      srcTokenPriceInUsd = ICustomPriceOracle(oracles[orders[id].srcToken].oracleAddress).getPriceInUSD();

    if (oracles[orders[id].dstToken].isChainlink)
      dstTokenPriceInUsd = uint(IChainlinkOracle(oracles[orders[id].dstToken].oracleAddress).latestAnswer());
    else
      dstTokenPriceInUsd = ICustomPriceOracle(oracles[orders[id].dstToken].oracleAddress).getPriceInUSD();

    // 10% max slippage
    uint srcTokenDecimals = IERC20(orders[id].srcToken).decimals();
    uint dstTokenDecimals = IERC20(orders[id].dstToken).decimals();
    uint minDstTokenReceived = (900 * srcTokensSwapped * srcTokenPriceInUsd * (10 ** dstTokenDecimals)) / (1000 * dstTokenPriceInUsd * (10 ** srcTokenDecimals));

    require(dstTokensReceived > minDstTokenReceived, "Tokens received are not enough");

    fills[id][fills[id].length - 1].srcTokensSwapped = srcTokensSwapped;
    fills[id][fills[id].length - 1].dstTokensReceived = dstTokensReceived;
  }

  /**
  * Set fees and distribute
  */
  function _setFeesAndDistribute(
    uint id
  )
  internal {
    uint timeElapsed = getTimeElapsedSinceLastFill(id);

    uint timeElapsedSinceCallable;

    if (fills[id].length > 1)
      timeElapsedSinceCallable = timeElapsed - orders[id].interval;
    else
      timeElapsedSinceCallable = timeElapsed;

    uint minFeesAmount = (fills[id][fills[id].length - 1].dstTokensReceived / fills[id][fills[id].length - 1].ticksFilled) * orders[id].minFees / percentagePrecision;
    uint maxFeesAmount = (fills[id][fills[id].length - 1].dstTokensReceived / fills[id][fills[id].length - 1].ticksFilled) * orders[id].maxFees / percentagePrecision;

    fills[id][fills[id].length - 1].fees = Math.min(maxFeesAmount, minFeesAmount * ((1000 + timeElapsedSinceCallable / 6) / 1000));
    // minFees + 0.1% every 6 secs

    IERC20(orders[id].dstToken).safeTransfer(
      msg.sender,
      fills[id][fills[id].length - 1].fees
    );

    IERC20(orders[id].dstToken).safeTransfer(
      orders[id].creator,
      fills[id][fills[id].length - 1].dstTokensReceived - fills[id][fills[id].length - 1].fees
    );
  }


  /**
  * Kills an active order
  * @param id Order ID
  * @return Whether order was killed
  */
  function killOrder(
    uint id
  )
  public
  whenNotPaused
  returns (bool) {
    require(msg.sender == orders[id].creator, "Invalid sender");
    require(!orders[id].killed, "Order already killed");
    orders[id].killed = true;
    IERC20(orders[id].srcToken).safeTransfer(
      orders[id].creator, 
      orders[id].total - getSrcTokensSwappedForOrder(id)
    );
    emit LogOrderKilled(id);
    return true;
  }

  /**
  * Returns total DST tokens received for an order
  * @param id Order ID
  * @return Total DST tokens received for an order
  */
  function getDstTokensReceivedForOrder(uint id)
  public
  view
  returns (uint) {
    require(orders[id].created != 0, "Invalid order");
    uint dstTokensReceived = 0;
    for (uint i = 0; i < fills[id].length; i++) 
      dstTokensReceived += fills[id][i].dstTokensReceived;
    return dstTokensReceived;
  }

  /**
  * Returns seconds passed since last fill
  * @param id Order ID
  * @return number of seconds
  */
  function getTimeElapsedSinceLastFill(uint id)
  public
  view
  returns (uint) {
    uint timeElapsed;

    if (fills[id].length > 0) {
      timeElapsed = block.timestamp - fills[id][fills[id].length - 1].timestamp;
    } else
      timeElapsed = block.timestamp - orders[id].created;

    return timeElapsed;
  }

  /**
  * Returns total SRC tokens received for an order
  * @param id Order ID
  * @return Total SRC tokens received for an order
  */
  function getSrcTokensSwappedForOrder(uint id)
  public
  view
  returns (uint) {
    require(orders[id].created != 0, "Invalid order");
    uint srcTokensSwapped = 0;
    for (uint i = 0; i < fills[id].length; i++) 
      srcTokensSwapped += fills[id][i].srcTokensSwapped;
    return srcTokensSwapped;
  }

  /**
  * Returns total number of ticks filled of a certain order
  * @param id Order ID
  * @return number of ticks filled
  */
  function getTicksFilled(uint id)
  public
  view
  returns (uint) {
    require(orders[id].created != 0, "Invalid order");
    uint ticksFilled = 0;
    for (uint i = 0; i < fills[id].length; i++)
      ticksFilled += fills[id][i].ticksFilled;
    return ticksFilled;
  }

  /**
  * Get the number of ticks that is possible to fill
  * @param id Order ID
  * @return number of ticks that can be filled
  */
  function getTicksToFill(uint id)
  public view
  returns (uint) {
    uint timeElapsed = getTimeElapsedSinceLastFill(id);

    uint ticksToFill = timeElapsed / orders[id].interval;
    uint ticksFilled = getTicksFilled(id);
    uint maxTicksFillable = (orders[id].total / orders[id].tickSize) - ticksFilled;

    if (ticksToFill >= maxTicksFillable) return maxTicksFillable;
    else return ticksToFill;
  }

  /**
  * Get the required amount of token that is possible to swap
  * @param id Order ID
  * @return amount of srcToken that can be swapped
  */
  function getSrcTokensToSwap(uint id)
  public view
  returns (uint) {
    return getTicksToFill(id) * orders[id].tickSize;
  }

  /**
  * Returns whether an order is active
  * @param id Order ID
  * @return Whether order is active
  */
  function isOrderActive(uint id) 
  public
  view
  returns (bool) {
    return orders[id].created != 0 && 
      !orders[id].killed && 
      getSrcTokensSwappedForOrder(id) < orders[id].total;
  }

  function addOracle(address token, Oracle memory oracle)
  public
  onlyOwner
  {
    // This is required to make it impossible to exploit 1inch params even for contract owner
    require(oracles[token].oracleAddress == address(0), "Oracles cannot be updated");

    oracles[token] = oracle;
  }

  function toggleWhitelist(bool value)
  public
  onlyOwner
  {
    isWhitelistActive = value;
  }

  function addToWhitelist(address authorized)
  public
  onlyOwner
  {
    whitelist[authorized] = true;
  }

  function removeFromWhitelist(address authorized)
  public
  onlyOwner
  {
    whitelist[authorized] = false;
  }
}
