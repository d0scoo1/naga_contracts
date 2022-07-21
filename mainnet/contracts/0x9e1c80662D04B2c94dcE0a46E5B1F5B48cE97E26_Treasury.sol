// Sources flattened with hardhat v2.8.0 https://hardhat.org

// File contracts/interfaces/IUniswapV3Factory.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

/// @title The interface for the Uniswap V3 Factory
/// @notice The Uniswap V3 Factory facilitates creation of Uniswap V3 pools and control over the protocol fees
interface IUniswapV3Factory {
    /// @notice Returns the pool address for a given pair of tokens and a fee, or address 0 if it does not exist
    /// @dev tokenA and tokenB may be passed in either token0/token1 or token1/token0 order
    /// @param tokenA The contract address of either token0 or token1
    /// @param tokenB The contract address of the other token
    /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
    /// @return pool The pool address
    function getPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external view returns (address pool);

    /// @notice Creates a pool for the given two tokens and fee
    /// @param tokenA One of the two tokens in the desired pool
    /// @param tokenB The other of the two tokens in the desired pool
    /// @param fee The desired fee for the pool
    /// @dev tokenA and tokenB may be passed in either order: token0/token1 or token1/token0. tickSpacing is retrieved
    /// from the fee. The call will revert if the pool already exists, the fee is invalid, or the token arguments
    /// are invalid.
    /// @return pool The address of the newly created pool
    function createPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external returns (address pool);
}


// File contracts/interfaces/IUniswapV3Pool.sol

interface IUniswapV3Pool {
    /// @notice Sets the initial price for the pool
    /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
    /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
    function initialize(uint160 sqrtPriceX96) external;

    /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
    /// when accessed externally.
    /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
    /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
    /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
    /// boundary.
    /// observationIndex The index of the last oracle observation that was written,
    /// observationCardinality The current maximum number of observations stored in the pool,
    /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
    /// feeProtocol The protocol fee for both tokens of the pool.
    /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
    /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
    /// unlocked Whether the pool is currently locked to reentrancy
    function slot0()
        external
        view
        returns (
            uint160 sqrtPriceX96,
            int24 tick,
            uint16 observationIndex,
            uint16 observationCardinality,
            uint16 observationCardinalityNext,
            uint8 feeProtocol,
            bool unlocked
        );

    /// @notice Increase the maximum number of price and liquidity observations that this pool will store
    /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
    /// the input observationCardinalityNext.
    /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
    function increaseObservationCardinalityNext(
        uint16 observationCardinalityNext
    ) external;

    /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
    /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
    /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
    /// you must call it with secondsAgos = [3600, 0].
    /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
    /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
    /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
    /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
    /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
    /// timestamp
    function observe(uint32[] calldata secondsAgos)
        external
        view
        returns (
            int56[] memory tickCumulatives,
            uint160[] memory secondsPerLiquidityCumulativeX128s
        );
}


// File contracts/interfaces/ISwapRouter.sol

/// @title Router token swapping functionality
/// @notice Functions for swapping tokens via Uniswap V3
interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInputSingle(ExactInputSingleParams calldata params)
        external
        payable
        returns (uint256 amountOut);

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }
}


// File contracts/interfaces/IERC20.sol

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}


// File contracts/interfaces/IWETH.sol

/// @title Interface for WETH
interface IWETH is IERC20 {
    /// @notice Deposit ether to get wrapped ether
    function deposit() external payable;

    /// @notice Withdraw wrapped ether to get ether
    function withdraw(uint256) external;
}


// File contracts/interfaces/INonfungiblePositionManager.sol

/// @title Non-fungible token for positions
/// @notice Wraps Uniswap V3 positions in a non-fungible token interface which allows for them to be transferred
/// and authorized.
interface INonfungiblePositionManager {
    struct MintParams {
        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        address recipient;
        uint256 deadline;
    }

    /// @notice Creates a new position wrapped in a NFT
    /// @dev Call this when the pool does exist and is initialized. Note that if the pool is created but not initialized
    /// a method does not exist, i.e. the pool is assumed to be initialized.
    /// @param params The params necessary to mint a position, encoded as `MintParams` in calldata
    /// @return tokenId The ID of the token that represents the minted position
    /// @return liquidity The amount of liquidity for this position
    /// @return amount0 The amount of token0
    /// @return amount1 The amount of token1
    function mint(MintParams calldata params)
        external
        payable
        returns (
            uint256 tokenId,
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        );

    struct DecreaseLiquidityParams {
        uint256 tokenId;
        uint128 liquidity;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    /// @notice Decreases the amount of liquidity in a position and accounts it to the position
    /// @param params tokenId The ID of the token for which liquidity is being decreased,
    /// amount The amount by which liquidity will be decreased,
    /// amount0Min The minimum amount of token0 that should be accounted for the burned liquidity,
    /// amount1Min The minimum amount of token1 that should be accounted for the burned liquidity,
    /// deadline The time by which the transaction must be included to effect the change
    /// @return amount0 The amount of token0 accounted to the position's tokens owed
    /// @return amount1 The amount of token1 accounted to the position's tokens owed
    function decreaseLiquidity(DecreaseLiquidityParams calldata params)
        external
        payable
        returns (uint256 amount0, uint256 amount1);

    struct CollectParams {
        uint256 tokenId;
        address recipient;
        uint128 amount0Max;
        uint128 amount1Max;
    }

    /// @notice Collects up to a maximum amount of fees owed to a specific position to the recipient
    /// @param params tokenId The ID of the NFT for which tokens are being collected,
    /// recipient The account that should receive the tokens,
    /// amount0Max The maximum amount of token0 to collect,
    /// amount1Max The maximum amount of token1 to collect
    /// @return amount0 The amount of fees collected in token0
    /// @return amount1 The amount of fees collected in token1
    function collect(CollectParams calldata params)
        external
        payable
        returns (uint256 amount0, uint256 amount1);

    /// @notice Burns a token ID, which deletes it from the NFT contract. The token must have 0 liquidity and all tokens
    /// must be collected first.
    /// @param tokenId The ID of the token that is being burned
    function burn(uint256 tokenId) external payable;
}


// File contracts/libraries/Lockable.sol

/// @title Prevents re-entry attack
abstract contract Lockable {
    bool private _locked;

    modifier lock() {
        require(!_locked, "Locked");
        _locked = true;
        _;
        _locked = false;
    }
}


// File contracts/libraries/Ownable.sol

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
abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(msg.sender);
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
        require(owner() == msg.sender, "Ownable: caller is not the owner");
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
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


// File contracts/libraries/SafeTransfer.sol

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x095ea7b3, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "safe approve failed"
        );
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0xa9059cbb, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "safe transfer failed"
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x23b872dd, from, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "safe transferFrom failed"
        );
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{ value: value }(new bytes(0));
        require(success, "safe transferETH failed");
    }
}


// File contracts/libraries/TickMath.sol

/// @title Math library for computing sqrt prices from ticks and vice versa
/// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
/// prices between 2**-128 and 2**128
library TickMath {
    /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
    int24 internal constant MIN_TICK = -887272;
    /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
    int24 internal constant MAX_TICK = -MIN_TICK;

    /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
    uint160 internal constant MIN_SQRT_RATIO = 4295128739;
    /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
    uint160 internal constant MAX_SQRT_RATIO =
        1461446703485210103287273052203988822378723970342;

    /// @notice Calculates sqrt(1.0001^tick) * 2^96
    /// @dev Throws if |tick| > max tick
    /// @param tick The input tick for the above formula
    /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
    /// at the given tick
    function getSqrtRatioAtTick(int24 tick)
        internal
        pure
        returns (uint160 sqrtPriceX96)
    {
        uint256 absTick = tick < 0
            ? uint256(-int256(tick))
            : uint256(int256(tick));
        require(absTick <= uint256(int256(MAX_TICK)), "T");

        uint256 ratio = absTick & 0x1 != 0
            ? 0xfffcb933bd6fad37aa2d162d1a594001
            : 0x100000000000000000000000000000000;
        if (absTick & 0x2 != 0)
            ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
        if (absTick & 0x4 != 0)
            ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
        if (absTick & 0x8 != 0)
            ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
        if (absTick & 0x10 != 0)
            ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
        if (absTick & 0x20 != 0)
            ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
        if (absTick & 0x40 != 0)
            ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
        if (absTick & 0x80 != 0)
            ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
        if (absTick & 0x100 != 0)
            ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
        if (absTick & 0x200 != 0)
            ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
        if (absTick & 0x400 != 0)
            ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
        if (absTick & 0x800 != 0)
            ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
        if (absTick & 0x1000 != 0)
            ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
        if (absTick & 0x2000 != 0)
            ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
        if (absTick & 0x4000 != 0)
            ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
        if (absTick & 0x8000 != 0)
            ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
        if (absTick & 0x10000 != 0)
            ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
        if (absTick & 0x20000 != 0)
            ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
        if (absTick & 0x40000 != 0)
            ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
        if (absTick & 0x80000 != 0)
            ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;

        if (tick > 0) ratio = type(uint256).max / ratio;

        // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
        // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
        // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
        sqrtPriceX96 = uint160(
            (ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1)
        );
    }

    /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
    /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
    /// ever return.
    /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
    /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
    function getTickAtSqrtRatio(uint160 sqrtPriceX96)
        internal
        pure
        returns (int24 tick)
    {
        // second inequality must be < because the price can never reach the price at the max tick
        require(
            sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO,
            "R"
        );
        uint256 ratio = uint256(sqrtPriceX96) << 32;

        uint256 r = ratio;
        uint256 msb = 0;

        assembly {
            let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(5, gt(r, 0xFFFFFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(4, gt(r, 0xFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(3, gt(r, 0xFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(2, gt(r, 0xF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(1, gt(r, 0x3))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := gt(r, 0x1)
            msb := or(msb, f)
        }

        if (msb >= 128) r = ratio >> (msb - 127);
        else r = ratio << (127 - msb);

        int256 log_2 = (int256(msb) - 128) << 64;

        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(63, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(62, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(61, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(60, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(59, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(58, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(57, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(56, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(55, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(54, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(53, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(52, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(51, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(50, f))
        }

        int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number

        int24 tickLow = int24(
            (log_sqrt10001 - 3402992956809132418596140100660247210) >> 128
        );
        int24 tickHi = int24(
            (log_sqrt10001 + 291339464771989622907027621153398088495) >> 128
        );

        tick = tickLow == tickHi
            ? tickLow
            : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96
            ? tickHi
            : tickLow;
    }
}


// File contracts/libraries/Math.sol

library Math {
    function compound(uint256 rewardRateX96, uint256 nCompounds)
        internal
        pure
        returns (uint256 compoundedX96)
    {
        if (nCompounds == 0) {
            compoundedX96 = 2**96;
        } else if (nCompounds == 1) {
            compoundedX96 = rewardRateX96;
        } else {
            compoundedX96 = compound(rewardRateX96, nCompounds / 2);
            compoundedX96 = mulX96(compoundedX96, compoundedX96);

            if (nCompounds % 2 == 1) {
                compoundedX96 = mulX96(compoundedX96, rewardRateX96);
            }
        }
    }

    // ref: https://blogs.sas.com/content/iml/2016/05/16/babylonian-square-roots.html
    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    function mulX96(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = (x * y) >> 96;
    }

    function divX96(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = (x << 96) / y;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}


// File contracts/libraries/Time.sol

library Time {
    function current_hour_timestamp() internal view returns (uint64) {
        return uint64((block.timestamp / 1 hours) * 1 hours);
    }

    function block_timestamp() internal view returns (uint64) {
        return uint64(block.timestamp);
    }
}


// File contracts/Const.sol

int24 constant INITIAL_QLT_PRICE_TICK = -23000; // QLT_USDC price ~ 100.0

// initial values
uint24 constant UNISWAP_POOL_FEE = 10000;
int24 constant UNISWAP_POOL_TICK_SPACING = 200;
uint16 constant UNISWAP_POOL_OBSERVATION_CADINALITY = 64;

// default values
uint256 constant DEFAULT_MIN_MINT_PRICE_X96 = 100 * Q96;
uint32 constant DEFAULT_TWAP_DURATION = 1 hours;
uint32 constant DEFAULT_UNSTAKE_LOCKUP_PERIOD = 3 days;

// floating point math
uint256 constant Q96 = 2**96;
uint256 constant MX96 = Q96 / 10**6;
uint256 constant TX96 = Q96 / 10**12;

// ERC-20 contract addresses
address constant WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
address constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
address constant USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
address constant DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
address constant BUSD = address(0x4Fabb145d64652a948d72533023f6E7A623C7C53);
address constant FRAX = address(0x853d955aCEf822Db058eb8505911ED77F175b99e);
address constant WBTC = address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);

// Uniswap, see `https://docs.uniswap.org/protocol/reference/deployments`
address constant UNISWAP_FACTORY = address(
    0x1F98431c8aD98523631AE4a59f267346ea31F984
);
address constant UNISWAP_ROUTER = address(
    0xE592427A0AEce92De3Edee1F18E0157C05861564
);
address constant UNISWAP_NFP_MGR = address(
    0xC36442b4a4522E871399CD717aBDD847Ab11FE88
);


// File contracts/libraries/ERC20.sol

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
contract ERC20 is IERC20 {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
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
    function decimals() public view virtual returns (uint8) {
        return _decimals;
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
    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
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
    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
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
        uint256 currentAllowance = _allowances[sender][msg.sender];
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: transfer amount exceeds allowance"
            );
            unchecked {
                _approve(sender, msg.sender, currentAllowance - amount);
            }
        }

        _transfer(sender, recipient, amount);

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
    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender] + addedValue
        );
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
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(msg.sender, spender, currentAllowance - subtractedValue);
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
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
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


// File contracts/QLT.sol

contract QLT is ERC20, Ownable {
    event Mint(address indexed account, uint256 amount);
    event Burn(uint256 amount);

    mapping(address => bool) public authorizedMinters;

    constructor() ERC20("Quantland", "QLT", 9) {
        require(
            address(this) < USDC,
            "QLT contract address must be smaller than USDC token contract address"
        );
        authorizedMinters[msg.sender] = true;

        // deploy uniswap pool
        IUniswapV3Pool pool = IUniswapV3Pool(
            IUniswapV3Factory(UNISWAP_FACTORY).createPool(
                address(this),
                USDC,
                UNISWAP_POOL_FEE
            )
        );
        pool.initialize(TickMath.getSqrtRatioAtTick(INITIAL_QLT_PRICE_TICK));
        pool.increaseObservationCardinalityNext(
            UNISWAP_POOL_OBSERVATION_CADINALITY
        );
    }

    function mint(address account, uint256 amount)
        external
        onlyAuthorizedMinter
    {
        _mint(account, amount);

        emit Mint(account, amount);
    }

    function burn(uint256 amount) external onlyOwner {
        _burn(msg.sender, amount);

        emit Burn(amount);
    }

    /* Access Control */
    modifier onlyAuthorizedMinter() {
        require(authorizedMinters[msg.sender], "not authorized minter");
        _;
    }

    function addAuthorizedMinter(address account) external onlyOwner {
        authorizedMinters[account] = true;
    }

    function removeAuthorizedMinter(address account) external onlyOwner {
        authorizedMinters[account] = false;
    }
}


// File contracts/interfaces/IERC721.sol

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
}


// File contracts/libraries/Strings.sol

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
    function toHexString(uint256 value, uint256 length)
        internal
        pure
        returns (string memory)
    {
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


// File contracts/libraries/ERC721.sol

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721 is IERC721 {
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Base URI
    string private _baseURI;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI_
    ) {
        _name = name_;
        _symbol = symbol_;
        _baseURI = baseURI_;
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            owner != address(0),
            "ERC721: balance query for the zero address"
        );
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        address owner = _owners[tokenId];
        require(
            owner != address(0),
            "ERC721: owner query for nonexistent token"
        );
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI;
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        require(
            _exists(tokenId),
            "ERC721: approved query for nonexistent token"
        );

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        _setApprovalForAll(msg.sender, operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );

        _transfer(from, to, tokenId);
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
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        virtual
        returns (bool)
    {
        require(
            _exists(tokenId),
            "ERC721: operator query for nonexistent token"
        );
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender));
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
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

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
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(
            ERC721.ownerOf(tokenId) == from,
            "ERC721: transfer from incorrect owner"
        );
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
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
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}


// File contracts/interfaces/IERC721Enumerable.sol

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
    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256 tokenId);

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256);
}


// File contracts/libraries/ERC721Enumerable.sol

/**
 * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
 * enumerability of all the token ids in the contract as well as all token ids owned by each
 * account.
 */
abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
    // Mapping from owner to list of owned token IDs
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    /**
     * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            index < ERC721.balanceOf(owner),
            "ERC721Enumerable: owner index out of bounds"
        );
        return _ownedTokens[owner][index];
    }

    /**
     * @dev See {IERC721Enumerable-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _allTokens.length;
    }

    /**
     * @dev See {IERC721Enumerable-tokenByIndex}.
     */
    function tokenByIndex(uint256 index)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            index < ERC721Enumerable.totalSupply(),
            "ERC721Enumerable: global index out of bounds"
        );
        return _allTokens[index];
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }

    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = ERC721.balanceOf(to);
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    /**
     * @dev Private function to add a token to this extension's token tracking data structures.
     * @param tokenId uint256 ID of the token to be added to the tokens list
     */
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
        private
    {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }
}


// File contracts/StakedQLT.sol

struct StakingInfo {
    bytes32 stakingPlan;
    uint256 stakedAmount;
    uint64 stakeTime;
    uint64 unstakeTime;
    uint64 redeemTime;
    uint64 lastHarvestTime;
    uint256 accumulatedStakingReward;
}

struct StakingRewardRate {
    uint256 rewardRateX96;
    uint64 startTime;
}

struct StakingPowerMultiplier {
    uint64 multiplier;
    uint64 startTime;
}

struct StakingPlan {
    bytes32 name;
    uint256 stakingAmount;
    uint256 accumulatedStakingReward;
    StakingRewardRate[] rewardRates;
    StakingPowerMultiplier[] multipliers;
    uint64 lockupPeriod;
    uint64 createdAt;
    uint64 deactivatedAt;
}

contract StakedQLT is ERC721Enumerable, Ownable {
    using Math for uint256;

    event Stake(
        uint256 indexed tokenId,
        address staker,
        bytes32 stakingPlan,
        uint256 amount
    );
    event Unstake(uint256 indexed tokenId);
    event Redeem(uint256 indexed tokenId, uint256 amount);
    event Harvest(uint256 indexed tokenId, uint256 rewardAmount);
    event HarvestAll(uint256[] tokenIds, uint256 rewardAmount);
    event StakingPlanCreated(bytes32 name);
    event StakingPlanDeactivated(bytes32 name);
    event StakingRewardRateUpdated(bytes32 name, uint256 rewardRateX96);
    event StakingPowerMultiplierUpdated(bytes32 name, uint256 multiplier);

    QLT private immutable QLTContract;

    uint256 public tokenIdCounter;
    uint64 public harvestStartTime;
    uint64 public unstakeLockupPeriod;

    uint256 public totalStakingAmount;
    address public treasuryAddress;
    mapping(uint256 => StakingInfo) public stakingInfos;
    mapping(bytes32 => StakingPlan) public stakingPlans;

    mapping(address => bool) public authorizedOperators;

    constructor(address _QLTContract)
        ERC721("Staked QLT", "sQLT", "https://staked.quantland.finance/")
    {
        addAuthorizedOperator(msg.sender);
        harvestStartTime = type(uint64).max;
        unstakeLockupPeriod = DEFAULT_UNSTAKE_LOCKUP_PERIOD;

        addStakingPlan("gold", 7 days, (100040 * Q96) / 100000, 1); // APY 3,222 %
        addStakingPlan("platinum", 30 days, (100060 * Q96) / 100000, 3); // APY 19,041 %
        addStakingPlan("diamond", 90 days, (100080 * Q96) / 100000, 5); // APY 110,200 %

        QLTContract = QLT(_QLTContract);
    }

    /* Staking Plan Governance Functions */
    function addStakingPlan(
        bytes32 name,
        uint64 lockupPeriod,
        uint256 rewardRateX96,
        uint64 multiplier
    ) public onlyOwner {
        require(stakingPlans[name].createdAt == 0, "already created");
        StakingPlan storage stakingPlan = stakingPlans[name];
        stakingPlan.name = name;
        stakingPlan.rewardRates.push(
            StakingRewardRate({
                rewardRateX96: rewardRateX96,
                startTime: Time.current_hour_timestamp()
            })
        );
        stakingPlan.multipliers.push(
            StakingPowerMultiplier({
                multiplier: multiplier,
                startTime: Time.block_timestamp()
            })
        );
        stakingPlan.lockupPeriod = lockupPeriod;
        stakingPlan.createdAt = Time.block_timestamp();

        emit StakingPlanCreated(name);
    }

    function deactivateStakingPlan(bytes32 name) public onlyOwner {
        _checkStakingPlanActive(name);

        StakingPlan storage stakingPlan = stakingPlans[name];
        stakingPlan.deactivatedAt = Time.block_timestamp();

        emit StakingPlanDeactivated(name);
    }

    function updateStakingRewardRate(bytes32 name, uint256 rewardRateX96)
        public
        onlyOperator
    {
        _checkStakingPlanActive(name);

        StakingPlan storage stakingPlan = stakingPlans[name];
        stakingPlan.rewardRates.push(
            StakingRewardRate({
                rewardRateX96: rewardRateX96,
                startTime: Time.current_hour_timestamp()
            })
        );

        emit StakingRewardRateUpdated(name, rewardRateX96);
    }

    function updateStakingPowerMultiplier(bytes32 name, uint64 multiplier)
        public
        onlyOperator
    {
        _checkStakingPlanActive(name);

        StakingPlan storage stakingPlan = stakingPlans[name];
        stakingPlan.multipliers.push(
            StakingPowerMultiplier({
                multiplier: multiplier,
                startTime: Time.block_timestamp()
            })
        );

        emit StakingPowerMultiplierUpdated(name, multiplier);
    }

    /* Staking-Related Functions */
    function stake(
        address recipient,
        bytes32 stakingPlan,
        uint256 amount
    ) external returns (uint256 tokenId) {
        require(amount > 0, "amount is 0");
        _checkStakingPlanActive(stakingPlan);

        // transfer QLT
        QLTContract.transferFrom(msg.sender, address(this), amount);

        // mint
        tokenIdCounter += 1;
        tokenId = tokenIdCounter;
        _mint(recipient, tokenId);
        _approve(address(this), tokenId);

        // update staking info
        StakingInfo storage stakingInfo = stakingInfos[tokenId];
        stakingInfo.stakingPlan = stakingPlan;
        stakingInfo.stakedAmount = amount;
        stakingInfo.stakeTime = Time.block_timestamp();
        stakingInfo.lastHarvestTime = Time.current_hour_timestamp();

        // update staking plan info
        stakingPlans[stakingPlan].stakingAmount += amount;
        totalStakingAmount += amount;

        emit Stake(tokenId, recipient, stakingPlan, amount);
    }

    function unstake(uint256 tokenId) external returns (uint256 rewardAmount) {
        _checkOwnershipOfStakingToken(tokenId);

        StakingInfo storage stakingInfo = stakingInfos[tokenId];
        uint64 lockupPeriod = stakingPlans[stakingInfo.stakingPlan]
            .lockupPeriod;
        uint64 stakeTime = stakingInfo.stakeTime;
        uint64 unstakeTime = stakingInfo.unstakeTime;

        if (msg.sender == treasuryAddress) {
            lockupPeriod = 0;
        }

        require(unstakeTime == 0, "already unstaked");
        require(
            Time.block_timestamp() >= (stakeTime + lockupPeriod),
            "still in lockup"
        );

        // harvest first
        rewardAmount = harvestInternal(tokenId);

        // update staking info
        uint256 unstakedAmount = stakingInfo.stakedAmount;
        stakingInfo.unstakeTime = Time.block_timestamp();

        // update staking plan info
        stakingPlans[stakingInfo.stakingPlan].stakingAmount -= unstakedAmount;
        totalStakingAmount -= unstakedAmount;

        emit Unstake(tokenId);
    }

    function redeem(uint256 tokenId) external returns (uint256 redeemedAmount) {
        _checkOwnershipOfStakingToken(tokenId);

        StakingInfo storage stakingInfo = stakingInfos[tokenId];
        uint64 unstakeTime = stakingInfo.unstakeTime;
        uint64 redeemTime = stakingInfo.redeemTime;
        uint64 _unstakeLockupPeriod = unstakeLockupPeriod;

        if (msg.sender == treasuryAddress) {
            _unstakeLockupPeriod = 0;
        }

        // check if can unstake
        require(unstakeTime > 0, "not unstaked");
        require(
            Time.block_timestamp() >= (unstakeTime + _unstakeLockupPeriod),
            "still in lockup"
        );
        require(redeemTime == 0, "already redeemed");

        // recycle and burn staking NFT
        address staker = ownerOf(tokenId);
        transferFrom(msg.sender, address(this), tokenId);
        _burn(tokenId);

        // transfer QLT back to staker
        redeemedAmount = stakingInfo.stakedAmount;
        QLTContract.transfer(staker, redeemedAmount);

        // update staking info
        stakingInfo.redeemTime = Time.block_timestamp();

        emit Redeem(tokenId, redeemedAmount);
    }

    function harvest(uint256 tokenId) external returns (uint256 rewardAmount) {
        return harvestInternal(tokenId);
    }

    function harvestAll(uint256[] calldata tokenIds)
        external
        returns (uint256 rewardAmount)
    {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            rewardAmount += harvestInternal(tokenIds[i]);
        }

        emit HarvestAll(tokenIds, rewardAmount);
    }

    function harvestInternal(uint256 tokenId)
        internal
        returns (uint256 rewardAmount)
    {
        require(Time.block_timestamp() >= harvestStartTime, "come back later");
        _checkOwnershipOfStakingToken(tokenId);

        rewardAmount = getRewardsToHarvest(tokenId);

        if (rewardAmount > 0) {
            // mint QLT to recipient
            QLTContract.mint(ownerOf(tokenId), rewardAmount);

            // update staking info
            StakingInfo storage stakingInfo = stakingInfos[tokenId];
            stakingInfo.lastHarvestTime = Time.current_hour_timestamp();
            stakingInfo.accumulatedStakingReward += rewardAmount;

            // update staking plan info
            StakingPlan storage stakingPlan = stakingPlans[
                stakingInfo.stakingPlan
            ];
            stakingPlan.accumulatedStakingReward += rewardAmount;

            emit Harvest(tokenId, rewardAmount);
        }
    }

    /* Staking State View Functions */
    function getRewardsToHarvest(uint256 tokenId)
        public
        view
        returns (uint256 rewardAmount)
    {
        require(tokenId <= tokenIdCounter, "not existent");

        StakingInfo storage stakingInfo = stakingInfos[tokenId];

        if (stakingInfo.unstakeTime > 0) {
            return 0;
        }

        StakingPlan storage stakingPlan = stakingPlans[stakingInfo.stakingPlan];

        // calculate compounded rewards of QLT
        uint256 stakedAmountX96 = stakingInfo.stakedAmount * Q96;
        uint256 compoundedAmountX96 = stakedAmountX96;
        uint64 rewardEndTime = Time.current_hour_timestamp();
        uint64 lastHarvestTime = stakingInfo.lastHarvestTime;

        StakingRewardRate[] storage rewardRates = stakingPlan.rewardRates;
        uint256 i = rewardRates.length;
        while (i > 0) {
            i--;

            uint64 rewardStartTime = rewardRates[i].startTime;
            uint256 rewardRateX96 = rewardRates[i].rewardRateX96;
            uint256 nCompounds;

            if (rewardEndTime < rewardStartTime) {
                continue;
            }

            if (rewardStartTime >= lastHarvestTime) {
                nCompounds = (rewardEndTime - rewardStartTime) / 1 hours;
                compoundedAmountX96 = compoundedAmountX96.mulX96(
                    Math.compound(rewardRateX96, nCompounds)
                );
                rewardEndTime = rewardStartTime;
            } else {
                nCompounds = (rewardEndTime - lastHarvestTime) / 1 hours;
                compoundedAmountX96 = compoundedAmountX96.mulX96(
                    Math.compound(rewardRateX96, nCompounds)
                );
                break;
            }
        }

        rewardAmount = (compoundedAmountX96 - stakedAmountX96) / Q96;
    }

    function getAllRewardsToHarvest(uint256[] calldata tokenIds)
        public
        view
        returns (uint256 rewardAmount)
    {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            rewardAmount += getRewardsToHarvest(tokenIds[i]);
        }
    }

    function getStakingPower(
        uint256 tokenId,
        uint64 startTime,
        uint64 endTime
    ) public view returns (uint256 stakingPower) {
        require(tokenId <= tokenIdCounter, "not existent");

        StakingInfo storage stakingInfo = stakingInfos[tokenId];
        if (stakingInfo.stakeTime >= endTime || stakingInfo.unstakeTime > 0) {
            return 0;
        }
        if (stakingInfo.stakeTime > startTime) {
            startTime = stakingInfo.stakeTime;
        }

        StakingPlan storage stakingPlan = stakingPlans[stakingInfo.stakingPlan];
        uint256 stakedAmount = stakingInfo.stakedAmount;
        StakingPowerMultiplier[] storage multipliers = stakingPlan.multipliers;
        uint256 i = multipliers.length;
        while (i > 0) {
            i--;

            uint64 rewardStartTime = multipliers[i].startTime;
            uint256 multiplier = multipliers[i].multiplier;

            if (rewardStartTime >= endTime) {
                continue;
            }

            if (rewardStartTime >= startTime) {
                stakingPower +=
                    stakedAmount *
                    (endTime - rewardStartTime) *
                    multiplier;
                endTime = rewardStartTime;
            } else {
                stakingPower +=
                    stakedAmount *
                    (endTime - startTime) *
                    multiplier;
                break;
            }
        }
    }

    function getAllStakingPower(
        uint256[] calldata tokenIds,
        uint64 startTime,
        uint64 endTime
    ) public view returns (uint256 stakingPower) {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            stakingPower += getStakingPower(tokenIds[i], startTime, endTime);
        }
    }

    /* Config Setters */
    function setHarvestStartTime(uint64 _harvestStartTime) external onlyOwner {
        harvestStartTime = _harvestStartTime;
    }

    function setUnstakeLockupPeriod(uint64 _unstakeLockupPeriod)
        external
        onlyOwner
    {
        unstakeLockupPeriod = _unstakeLockupPeriod;
    }

    function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
        treasuryAddress = _treasuryAddress;
    }

    /* Helper Functions */
    function _checkOwnershipOfStakingToken(uint256 tokenId) internal view {
        require(ownerOf(tokenId) == msg.sender, "not owner");
    }

    function _checkStakingPlanActive(bytes32 stakingPlan) internal view {
        require(
            stakingPlans[stakingPlan].deactivatedAt == 0,
            "staking plan not active"
        );
    }

    /* Access Control */
    function addAuthorizedOperator(address account) public onlyOwner {
        authorizedOperators[account] = true;
    }

    function removeAuthorizedOperator(address account) external onlyOwner {
        authorizedOperators[account] = false;
    }

    modifier onlyOperator() {
        require(authorizedOperators[msg.sender], "not authorized");
        _;
    }
}


// File contracts/Treasury.sol

struct TreasuryConfig {
    uint256 minMintPriceX96;
    uint64 mintStartTime;
    uint32 twapDuration;
    bool isGenesisPhase;
}

struct TreasuryStats {
    uint128 amountQLTMinted;
    uint128 amountUSDCReceived;
}

struct LiquidityPosition {
    uint256 tokenId;
    uint128 liquidity;
    int24 lowerTick;
    int24 upperTick;
    uint256 amountQLT;
    uint256 amountUSDC;
    int24 refreshedAtTick;
    uint64 refreshTime;
}

contract Treasury is Lockable, Ownable {
    using Math for uint256;

    event Mint(
        address indexed minter,
        address srcToken,
        uint256 amountSrcToken,
        uint256 amountUSDC,
        uint256 amountQLT,
        uint256 mintPriceX96,
        bytes32 stakingPlan,
        uint256 mintDiscountedRateX96,
        uint256 tokenId
    );
    event TreasuryBuy(uint256 amountUSDC, uint256 amountQLT);
    event TreasurySell(uint256 amountQLT, uint256 amountUSDC);
    event LiquidityPositionRefreshed(
        uint256 tokenId,
        uint128 liquidity,
        int24 lowerTick,
        int24 upperTick,
        uint256 amountQLT,
        uint256 amountUSDC,
        int24 refreshedAtTick
    );

    QLT public immutable QLTContract;
    StakedQLT public StakedQLTContract;
    IUniswapV3Pool public immutable QLT_USDC_Pool;
    INonfungiblePositionManager public immutable liquidityPositionManager;

    TreasuryConfig public config;
    TreasuryStats public stats;
    LiquidityPosition public liquidityPosition;
    uint256 public stakingTokenId;

    mapping(address => bool) public authorizedSrcToken;
    mapping(address => bool) public authorizedOperators;
    mapping(bytes32 => bool) public authorizedMintStakingPlan;
    mapping(bytes32 => uint256) public stakingPlanMintDiscountedRatesX96;

    constructor(address _QLTContract, address _StakedQLTContract) {
        authorizedOperators[msg.sender] = true;

        // initialize configs
        config = TreasuryConfig({
            minMintPriceX96: DEFAULT_MIN_MINT_PRICE_X96,
            mintStartTime: type(uint64).max,
            twapDuration: DEFAULT_TWAP_DURATION,
            isGenesisPhase: true
        });

        // authorized mint src token list
        authorizedSrcToken[WETH] = true;
        authorizedSrcToken[USDC] = true;
        authorizedSrcToken[USDT] = true;
        authorizedSrcToken[DAI] = true;
        authorizedSrcToken[BUSD] = true;
        authorizedSrcToken[FRAX] = true;
        authorizedSrcToken[WBTC] = true;

        // authorized mint staking plan list
        authorizedMintStakingPlan["gold"] = true;
        authorizedMintStakingPlan["platinum"] = true;
        authorizedMintStakingPlan["diamond"] = true;

        // mint discount rate
        stakingPlanMintDiscountedRatesX96["gold"] = (98 * Q96) / 100; // 2% discount
        stakingPlanMintDiscountedRatesX96["platinum"] = (95 * Q96) / 100; // 5% discount
        stakingPlanMintDiscountedRatesX96["diamond"] = (92 * Q96) / 100; // 8% discount

        QLTContract = QLT(_QLTContract);
        StakedQLTContract = StakedQLT(_StakedQLTContract);

        QLT_USDC_Pool = IUniswapV3Pool(
            IUniswapV3Factory(UNISWAP_FACTORY).getPool(
                address(QLTContract),
                USDC,
                UNISWAP_POOL_FEE
            )
        );

        liquidityPositionManager = INonfungiblePositionManager(UNISWAP_NFP_MGR);
    }

    function mint(
        address srcToken,
        uint256 amountSrcToken,
        uint24 poolFee,
        bytes32 stakingPlan
    ) external payable lock returns (uint256 amountQLT, uint256 tokenId) {
        require(block.timestamp >= config.mintStartTime, "come back later");
        require(authorizedMintStakingPlan[stakingPlan], "invalid staking plan");

        // mint by ETH -> convert to WETH
        if (msg.value > 0) {
            IWETH(WETH).deposit{value: msg.value}();
            srcToken = WETH;
            amountSrcToken = msg.value;
            poolFee = 500;
        } else {
            require(authorizedSrcToken[srcToken], "invalid srcToken");

            TransferHelper.safeTransferFrom(
                srcToken,
                msg.sender,
                address(this),
                amountSrcToken
            );
        }

        // Swap as USDC
        uint256 amountUSDC = 0;

        if (srcToken != USDC) {
            TransferHelper.safeApprove(
                srcToken,
                address(UNISWAP_ROUTER),
                amountSrcToken
            );
            amountUSDC = ISwapRouter(UNISWAP_ROUTER).exactInputSingle(
                ISwapRouter.ExactInputSingleParams({
                    tokenIn: srcToken,
                    tokenOut: USDC,
                    fee: poolFee,
                    recipient: address(this),
                    deadline: block.timestamp,
                    amountIn: amountSrcToken,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                })
            );
        } else {
            amountUSDC = amountSrcToken;
        }

        require(amountUSDC > 0, "no USDC received");
        uint256 mintPriceX96 = getMintPriceX96(stakingPlan, amountUSDC);
        amountQLT = ((amountUSDC * Q96).divX96(mintPriceX96) * 10**3) / Q96;
        QLTContract.mint(address(this), amountQLT * 2); // 1:1 for treasury reserve

        // stake
        QLTContract.approve(address(StakedQLTContract), amountQLT);
        tokenId = StakedQLTContract.stake(msg.sender, stakingPlan, amountQLT);

        // update stats
        stats.amountQLTMinted += uint128(amountQLT);
        stats.amountUSDCReceived += uint128(amountUSDC);

        emit Mint(
            msg.sender,
            srcToken,
            amountSrcToken,
            amountUSDC,
            amountQLT,
            mintPriceX96,
            stakingPlan,
            stakingPlanMintDiscountedRatesX96[stakingPlan],
            tokenId
        );
    }

    /* Token Transfer Utility Functions */
    function transferETH(address to, uint256 value) external onlyOwner {
        TransferHelper.safeTransferETH(to, value);
    }

    function transferToken(
        address token,
        address to,
        uint256 value
    ) external onlyOwner {
        TransferHelper.safeTransfer(token, to, value);
    }

    function approveToken(
        address token,
        address to,
        uint256 value
    ) external onlyOwner {
        TransferHelper.safeApprove(token, to, value);
    }

    function call(address target, bytes calldata payload) external onlyOwner {
        (bool success, ) = target.call(payload);
        require(success);
    }

    /* Treasury Utility Functions */
    function buyQLT(uint256 amountUSDC) external onlyOperator {
        require(amountUSDC > 0);

        TransferHelper.safeApprove(USDC, address(UNISWAP_ROUTER), amountUSDC);
        uint256 amountQLT = ISwapRouter(UNISWAP_ROUTER).exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: USDC,
                tokenOut: address(QLTContract),
                fee: UNISWAP_POOL_FEE,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountUSDC,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        emit TreasuryBuy(amountUSDC, amountQLT);
    }

    function sellQLT(uint256 amountQLT) external onlyOperator {
        require(amountQLT > 0);

        QLTContract.approve(address(UNISWAP_ROUTER), amountQLT);
        uint256 amountUSDC = ISwapRouter(UNISWAP_ROUTER).exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(QLTContract),
                tokenOut: USDC,
                fee: UNISWAP_POOL_FEE,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountQLT,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        emit TreasurySell(amountQLT, amountUSDC);
    }

    function refreshLiquidityPosition(
        int24 lowerTick,
        int24 upperTick,
        uint256 amountQLT,
        uint256 amountUSDC
    ) external onlyOperator {
        if (liquidityPosition.tokenId != 0) {
            // decrease liquidity
            liquidityPositionManager.decreaseLiquidity(
                INonfungiblePositionManager.DecreaseLiquidityParams({
                    tokenId: liquidityPosition.tokenId,
                    liquidity: liquidityPosition.liquidity,
                    amount0Min: 0,
                    amount1Min: 0,
                    deadline: block.timestamp
                })
            );

            // collect fees
            liquidityPositionManager.collect(
                INonfungiblePositionManager.CollectParams({
                    tokenId: liquidityPosition.tokenId,
                    recipient: address(this),
                    amount0Max: type(uint128).max,
                    amount1Max: type(uint128).max
                })
            );

            // burn liquidity position
            liquidityPositionManager.burn(liquidityPosition.tokenId);

            delete liquidityPosition;
        }

        // mint liquidity position
        if (amountQLT > 0 && amountUSDC > 0) {
            QLTContract.approve(address(liquidityPositionManager), amountQLT);
            TransferHelper.safeApprove(
                USDC,
                address(liquidityPositionManager),
                amountUSDC
            );
            (
                uint256 tokenId,
                uint128 liquidity,
                uint256 consumedQLT,
                uint256 consumedUSDC
            ) = liquidityPositionManager.mint(
                    INonfungiblePositionManager.MintParams({
                        token0: address(QLTContract),
                        token1: USDC,
                        fee: UNISWAP_POOL_FEE,
                        tickLower: lowerTick,
                        tickUpper: upperTick,
                        amount0Desired: amountQLT,
                        amount1Desired: amountUSDC,
                        amount0Min: 0,
                        amount1Min: 0,
                        recipient: address(this),
                        deadline: block.timestamp
                    })
                );
            QLTContract.approve(address(liquidityPositionManager), 0);
            TransferHelper.safeApprove(
                USDC,
                address(liquidityPositionManager),
                0
            );

            // update liquidity state
            liquidityPosition.tokenId = tokenId;
            liquidityPosition.liquidity = liquidity;
            liquidityPosition.lowerTick = lowerTick;
            liquidityPosition.upperTick = upperTick;
            liquidityPosition.amountQLT = consumedQLT;
            liquidityPosition.amountUSDC = consumedUSDC;
            liquidityPosition.refreshedAtTick = getPriceTick();
            liquidityPosition.refreshTime = Time.block_timestamp();
        }

        emit LiquidityPositionRefreshed(
            liquidityPosition.tokenId,
            liquidityPosition.liquidity,
            liquidityPosition.lowerTick,
            liquidityPosition.upperTick,
            liquidityPosition.amountQLT,
            liquidityPosition.amountUSDC,
            liquidityPosition.refreshedAtTick
        );
    }

    function updateStakingAmount(bytes32 stakingPlan, uint256 amount)
        external
        onlyOperator
    {
        if (stakingTokenId != 0) {
            StakedQLTContract.unstake(stakingTokenId);
            StakedQLTContract.redeem(stakingTokenId);
            stakingTokenId = 0;
        }

        if (amount > 0) {
            QLTContract.approve(address(StakedQLTContract), amount);
            stakingTokenId = StakedQLTContract.stake(
                address(this),
                stakingPlan,
                amount
            );
        }
    }

    /* Config Setters */
    function setTreasuryConfig(
        uint64 mintStartTime,
        bool isGenesisPhase,
        uint256 minMintPriceX96,
        uint32 twapDuration
    ) external onlyOperator {
        config.mintStartTime = mintStartTime;
        config.isGenesisPhase = isGenesisPhase;
        config.minMintPriceX96 = minMintPriceX96;
        config.twapDuration = twapDuration;
    }

    function setMintDiscountedRate(
        bytes32 stakingPlan,
        uint256 mintDiscountedRateX96
    ) external onlyOperator {
        stakingPlanMintDiscountedRatesX96[stakingPlan] = mintDiscountedRateX96;
    }

    function upgradeStakedQLTContract(address _StakedQLTContract)
        external
        onlyOwner
    {
        StakedQLTContract = StakedQLT(_StakedQLTContract);
    }

    /* Utility Functions */
    function getPriceTick() public view returns (int24 priceTick) {
        (, priceTick, , , , , ) = QLT_USDC_Pool.slot0();
    }

    function getMintPriceX96(bytes32 stakingPlan, uint256 amountUSDC)
        public
        view
        returns (uint256 mintPriceX96)
    {
        if (config.isGenesisPhase) {
            uint256 totalUSDC = stats.amountUSDCReceived + amountUSDC;
            uint256 receivedMX96 = stats.amountUSDCReceived * TX96;
            uint256 totalMX96 = totalUSDC * TX96;
            // d a(1+x^0.5/5) / dx = a(x+2x^1.5/15)
            mintPriceX96 = DEFAULT_MIN_MINT_PRICE_X96
                .mulX96(
                    totalMX96 -
                        receivedMX96 +
                        (2 *
                            (totalMX96.mulX96(Math.sqrt(totalUSDC) * MX96) -
                                receivedMX96.mulX96(
                                    Math.sqrt(stats.amountUSDCReceived) * MX96
                                ))) /
                        15
                )
                .divX96(amountUSDC * TX96);
        } else {
            mintPriceX96 = Math.max(getTwapPriceX96(), getPriceX96());
        }

        uint256 mintDiscountedRateX96 = stakingPlanMintDiscountedRatesX96[
            stakingPlan
        ];
        require(mintDiscountedRateX96 > 0);

        mintPriceX96 = Math.max(mintPriceX96, config.minMintPriceX96);
        mintPriceX96 = mintPriceX96.mulX96(mintDiscountedRateX96);
    }

    function getTwapPriceX96() public view returns (uint256 twapPriceX96) {
        (uint256 sqrtPriceX96, , , , , , ) = QLT_USDC_Pool.slot0();
        uint32 twapDuration = config.twapDuration;

        if (twapDuration > 0) {
            uint32[] memory secondsAgos = new uint32[](2);
            secondsAgos[0] = twapDuration;
            secondsAgos[1] = 0;

            try QLT_USDC_Pool.observe(secondsAgos) returns (
                int56[] memory tickCumulatives,
                uint160[] memory
            ) {
                sqrtPriceX96 = TickMath.getSqrtRatioAtTick(
                    int24(
                        (tickCumulatives[1] - tickCumulatives[0]) /
                            int32(twapDuration)
                    )
                );
            } catch {}
        }

        twapPriceX96 = (sqrtPriceX96 * sqrtPriceX96) / Q96;
    }

    function getPriceX96() public view returns (uint256 priceX96) {
        (uint256 sqrtPriceX96, , , , , , ) = QLT_USDC_Pool.slot0();

        priceX96 = (sqrtPriceX96 * sqrtPriceX96) / Q96;
    }

    /* Access Control */
    function addAuthorizedMintStakingPlan(bytes32 stakingPlan)
        external
        onlyOwner
    {
        authorizedMintStakingPlan[stakingPlan] = true;
    }

    function removeAuthorizedMintStakingPlan(bytes32 stakingPlan)
        external
        onlyOwner
    {
        authorizedMintStakingPlan[stakingPlan] = false;
    }

    function addAuthorizedSrcToken(address srcToken) external onlyOwner {
        authorizedSrcToken[srcToken] = true;
    }

    function removeAuthorizedSrcToken(address srcToken) external onlyOwner {
        authorizedSrcToken[srcToken] = false;
    }

    function addAuthorizedOperator(address account) external onlyOwner {
        authorizedOperators[account] = true;
    }

    function removeAuthorizedOperator(address account) external onlyOwner {
        authorizedOperators[account] = false;
    }

    modifier onlyOperator() {
        require(authorizedOperators[msg.sender], "not authorized");
        _;
    }

    /* Fallback Function */
    fallback() external payable {}

    receive() external payable {}
}