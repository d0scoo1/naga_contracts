pragma solidity ^0.8.10;

import "../interfaces/IAllocator.sol";
import "./interfaces/ISwapRouter.sol";
import "./interfaces/IWETH.sol";
import "./interfaces/LiquityInterfaces.sol";
import "../types/BaseAllocator.sol";

error LUSDAllocator_InputTooLarge();
error LUSDAllocator_TreasuryAddressZero();

/**
 *  Contract deploys LUSD from treasury into the liquity stabilty pool. Each update, rewards are harvested.
 *  The allocator stakes the LQTY rewards and sells part of the ETH rewards to stack more LUSD.
 *  This contract inherits BaseAllocator is and meant to be used with Treasury extender.
 */
contract LUSDAllocatorV2 is BaseAllocator {
    using SafeERC20 for IERC20;

    /* ======== STATE VARIABLES ======== */
    IStabilityPool public immutable lusdStabilityPool = IStabilityPool(0x66017D22b0f8556afDd19FC67041899Eb65a21bb);
    ILQTYStaking public immutable lqtyStaking = ILQTYStaking(0x4f9Fbb3f1E99B56e0Fe2892e623Ed36A76Fc605d);
    ISwapRouter public immutable swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address public treasuryAddress;
    address public immutable wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public immutable lqtyTokenAddress = 0x6DEA81C8171D0bA574754EF6F8b412F2Ed88c54D;
    address public hopTokenAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // Dai. Could be something else.

    uint256 public constant FEE_PRECISION = 1e6;
    uint256 public constant POOL_FEE_MAX = 10000;
    /**
     * @notice The target percent of eth to swap to LUSD at uniswap.  divide by 1e6 to get actual value.
     * Examples:
     * 500000 => 500000 / 1e6 = 0.50 = 50%
     * 330000 => 330000 / 1e6 = 0.33 = 33%
     */
    uint256 public ethToLUSDRatio = 330000; // 33% of ETH to LUSD
    /**
     * @notice poolFee parameter for uniswap swaprouter, divide by 1e6 to get the actual value.  See https://docs.uniswap.org/protocol/guides/swaps/multihop-swaps#calling-the-function-1
     * Maximum allowed value is 10000 (1%)
     * Examples:
     * poolFee =  3000 =>  3000 / 1e6 = 0.003 = 0.3%
     * poolFee = 10000 => 10000 / 1e6 =  0.01 = 1.0%
     */
    uint24 public poolFee = 3000; // Init the uniswap pool fee to 0.3%
    uint256 public minETHLUSDRate; // minimum amount of LUSD we are willing to swap WETH for.

    /**
     * @notice tokens in AllocatorInitData should be [LUSD Address]
     * LUSD Address (0x5f98805A4E8be255a32880FDeC7F6728C6568bA0)
     */
    constructor(
        AllocatorInitData memory data,
        address _treasuryAddress,
        uint256 _minETHLUSDRate
    ) BaseAllocator(data) {
        treasuryAddress = _treasuryAddress;
        minETHLUSDRate = _minETHLUSDRate;

        IERC20(wethAddress).safeApprove(treasuryAddress, type(uint256).max);
        IERC20(wethAddress).safeApprove(address(swapRouter), type(uint256).max);
        data.tokens[0].safeApprove(address(lusdStabilityPool), type(uint256).max);
        data.tokens[0].safeApprove(treasuryAddress, type(uint256).max);
        IERC20(lqtyTokenAddress).safeApprove(treasuryAddress, type(uint256).max);
    }

    /**
     *  @notice Need this because StabilityPool::withdrawFromSP() and LQTYStaking::stake() will send ETH here
     */
    receive() external payable {}

    /* ======== CONFIGURE FUNCTIONS for Guardian only ======== */
    /**
     *  @notice Set the target percent of eth from yield to swap to LUSD at uniswap. The rest is sent to treasury.
     *  @param _ethToLUSDRatio uint256 number between 0 and 100000. 100000 being 100%. Default is 33000 which is 33%.
     */
    function setEthToLUSDRatio(uint256 _ethToLUSDRatio) external {
        _onlyGuardian();
        if (_ethToLUSDRatio > FEE_PRECISION) revert LUSDAllocator_InputTooLarge();
        ethToLUSDRatio = _ethToLUSDRatio;
    }

    /**
     *  @notice set poolFee parameter for uniswap swaprouter
     *  @param _poolFee uint256 number between 0 and 10000. 10000 being 1%
     */
    function setPoolFee(uint24 _poolFee) external {
        _onlyGuardian();
        if (_poolFee > POOL_FEE_MAX) revert LUSDAllocator_InputTooLarge();
        poolFee = _poolFee;
    }

    /**
     *  @notice set the address of the hop token. Token to swap weth to before LUSD
     *  @param _hopTokenAddress address
     */
    function setHopTokenAddress(address _hopTokenAddress) external {
        _onlyGuardian();
        hopTokenAddress = _hopTokenAddress;
    }

    /**
     *  @notice sets minETHLUSDRate for swapping ETH for LUSD
     *  @param _rate uint
     */
    function setMinETHLUSDRate(uint256 _rate) external {
        _onlyGuardian();
        minETHLUSDRate = _rate;
    }

    /**
     *  @notice Updates address of treasury to authority.vault()
     */
    function updateTreasury() public {
        _onlyGuardian();
        if (authority.vault() == address(0)) revert LUSDAllocator_TreasuryAddressZero();
        treasuryAddress = address(authority.vault());
    }

    /* ======== INTERNAL FUNCTIONS ======== */

    /**
     *  @notice claims LQTY & ETH Rewards. minETHLUSDRate minimum rate of when swapping ETH->LUSD.  e.g. 3500 means we swap at a rate of 1 ETH for a minimum 3500 LUSD
     
        1.  Harvest from LUSD StabilityPool to get ETH+LQTY rewards
        2.  Stake LQTY rewards from #1.
        3.  If we have eth, convert to weth, then swap a percentage of it to LUSD.  If swap successul then send all remaining WETH to treasury
        4.  Deposit all LUSD in balance to into StabilityPool.
     */
    function _update(uint256 id) internal override returns (uint128 gain, uint128 loss) {
        if (getETHRewards() > 0 || getLQTYRewards() > 0) {
            // 1.  Harvest from LUSD StabilityPool to get ETH+LQTY rewards
            lusdStabilityPool.withdrawFromSP(0); //Passing 0 b/c we don't want to withdraw from the pool but harvest - see https://discord.com/channels/700620821198143498/818895484956835912/908031137010581594
        }

        // 2.  Stake LQTY rewards from #1 and any other LQTY in wallet.
        uint256 balanceLqty = IERC20(lqtyTokenAddress).balanceOf(address(this));
        if (balanceLqty > 0) {
            lqtyStaking.stake(balanceLqty); //Stake LQTY, also receives any prior ETH+LUSD rewards from prior staking
        }

        // 3.  If we have eth, convert to weth, then swap a percentage of it to LUSD.
        uint256 ethBalance = address(this).balance; // Use total balance in case we have leftover from a prior failed attempt
        bool swappedLUSDSuccessfully;
        if (ethBalance > 0) {
            // Wrap ETH to WETH
            IWETH(wethAddress).deposit{value: ethBalance}();

            if (ethToLUSDRatio > 0) {
                uint256 wethBalance = IWETH(wethAddress).balanceOf(address(this)); //Base off of WETH balance in case we have leftover from a prior failed attempt
                uint256 amountWethToSwap = (wethBalance * ethToLUSDRatio) / FEE_PRECISION;
                uint256 amountLUSDMin = amountWethToSwap * minETHLUSDRate; //WETH and LUSD is 18 decimals

                // From https://docs.uniswap.org/protocol/guides/swaps/multihop-swaps#calling-the-function-1
                // Multiple pool swaps are encoded through bytes called a `path`. A path is a sequence of token addresses and poolFees that define the pools used in the swaps.
                // The format for pool encoding is (tokenIn, fee, tokenOut/tokenIn, fee, tokenOut) where tokenIn/tokenOut parameter is the shared token across the pools.
                // Since we are swapping WETH to DAI and then DAI to LUSD the path encoding is (WETH, 0.3%, DAI, 0.3%, LUSD).
                ISwapRouter.ExactInputParams memory params = ISwapRouter.ExactInputParams({
                    path: abi.encodePacked(wethAddress, poolFee, hopTokenAddress, poolFee, address(_tokens[0])),
                    recipient: address(this),
                    deadline: block.timestamp,
                    amountIn: amountWethToSwap,
                    amountOutMinimum: amountLUSDMin
                });

                // Executes the swap
                if (swapRouter.exactInput(params) > 0) {
                    swappedLUSDSuccessfully = true;
                }
            }
        }

        // If swap was successful (or if percent to swap is 0), send the remaining WETH to the treasury.  Crucial check otherwise we'd send all our WETH to the treasury and not respect our desired percentage
        if (ethToLUSDRatio == 0 || swappedLUSDSuccessfully) {
            uint256 wethBalance = IWETH(wethAddress).balanceOf(address(this));
            if (wethBalance > 0) {
                IERC20(wethAddress).safeTransfer(treasuryAddress, wethBalance);
            }
        }

        // 4.  Deposit all LUSD in balance to into StabilityPool.
        uint256 lusdBalance = _tokens[0].balanceOf(address(this));
        if (lusdBalance > 0) {
            lusdStabilityPool.provideToSP(lusdBalance, address(0));

            uint128 total = uint128(lusdStabilityPool.getCompoundedLUSDDeposit(address(this)));
            uint128 last = extender.getAllocatorPerformance(id).gain + uint128(extender.getAllocatorAllocated(id));
            if (total >= last) gain = total - last;
            else loss = last - total;
        }
    }

    function deallocate(uint256[] memory amounts) public override {
        _onlyGuardian();
        if (amounts[0] > 0) lusdStabilityPool.withdrawFromSP(amounts[0]);
        if (amounts[1] > 0) lqtyStaking.unstake(amounts[1]);
    }

    function _deactivate(bool panic) internal override {
        if (panic) {
            // If panic unstake everything
            _withdrawEverything();
        }
    }

    function _prepareMigration() internal override {
        _withdrawEverything();

        // Could have leftover eth from unstaking unclaimed yield.
        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            IWETH(wethAddress).deposit{value: ethBalance}();
        }

        // Don't need to transfer WETH since its a utility token it will be migrated
    }

    /**
     *  @notice Withdraws LUSD and LQTY from pools. This also may result in some ETH being sent to wallet due to unclaimed yield after withdrawing.
     */
    function _withdrawEverything() internal {
        // Will throw exception if nothing to unstake
        if (lqtyStaking.stakes(address(this)) > 0) {
            // If unstake amount > amount available to unstake will unstake everything. So max int ensures unstake max amount.
            lqtyStaking.unstake(type(uint256).max);
        }

        if (lusdStabilityPool.getCompoundedLUSDDeposit(address(this)) > 0) {
            lusdStabilityPool.withdrawFromSP(type(uint256).max);
        }
    }

    /* ======== VIEW FUNCTIONS ======== */

    /**
     * @notice This returns the amount of LUSD allocated to the pool. Does not return how much LUSD deposited since that number is increasing and compounding.
     */
    function amountAllocated(uint256 id) public view override returns (uint256) {
        if (tokenIds[id] == 0) {
            return lusdStabilityPool.getTotalLUSDDeposits();
        }
        return 0;
    }

    function rewardTokens() public view override returns (IERC20[] memory) {
        IERC20[] memory rewards = new IERC20[](1);
        rewards[0] = IERC20(lqtyTokenAddress);
        return rewards;
    }

    function utilityTokens() public view override returns (IERC20[] memory) {
        IERC20[] memory utility = new IERC20[](2);
        utility[0] = IERC20(lqtyTokenAddress);
        utility[1] = IERC20(wethAddress);
        return utility;
    }

    function name() external view override returns (string memory) {
        return "LUSD Allocator";
    }

    /**
     *  @notice get ETH rewards from SP
     *  @return uint
     */
    function getETHRewards() public view returns (uint256) {
        return lusdStabilityPool.getDepositorETHGain(address(this));
    }

    /**
     *  @notice get LQTY rewards from SP
     *  @return uint
     */
    function getLQTYRewards() public view returns (uint256) {
        return lusdStabilityPool.getDepositorLQTYGain(address(this));
    }
}
