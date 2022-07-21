// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "./interface/ITreasury.sol";
import "./interface/IUniswapV2Router02.sol";
import "./interface/IUniswapV2Pair.sol";
import "./interface/IGUniRouter.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @notice This contract handles migrating lps from uniswap v2 and sushiswap to uniswap v3 via gelato
///         to make use of the contract ensure a pool has been created on uniswap v3 and gelato
contract LiquidityMigrator is Ownable {
    using SafeERC20 for IERC20;

    struct TxDetails {
        uint256 contractV2lpBalanceBeforeRemovingLiquidity;
        uint256 contractV2lpBalanceAfterRemovingLiquidity;
        uint256 contractToken0Bal;
        uint256 contractToken1Bal;
        uint256 expectedToken0ToBeAddedOnGuni;
        uint256 expectedToken1ToBeAddedOnGuni;
        address lps;
    }

    uint256 public txCount;

    mapping(uint256 => TxDetails) public transactions;

    address immutable treasury = 0x9A315BdF513367C0377FB36545857d12e85813Ef;

    /// @notice Takes lp from treasury, remove liquidity from uniswap V2, adds liquidity to uniswap v3 via guni(gelato)
    /// @param dexRouter_ router address; can be uniswap or sushiswap
    /// @param gUniRouter_ gelato router address
    /// @param gUniPool_ gelato pool address for a pair on uniswap v3
    /// @param dexLpAddress_ v2 lp address of either uniswap or sushiswap
    /// @param amount_ lp amount to get from treasury and amount of liquidity to remove
    /// @param percentage_ minimum percentage when using the addLiquidityGuni function....i.e 95% will be 950
    function executeTx(
        address dexRouter_,
        address gUniRouter_,
        address gUniPool_,
        address dexLpAddress_,
        uint256 amount_,
        uint256 percentage_
    ) external onlyOwner {
        ITreasury(treasury).manage(dexLpAddress_, amount_);
        uint256 amount = IUniswapV2Pair(dexLpAddress_).balanceOf(address(this));

        removeLiquidity(dexLpAddress_, dexRouter_, amount);
        uint256 amountAfterTx = IUniswapV2Pair(dexLpAddress_).balanceOf(
            address(this)
        );
        (
            ,
            ,
            uint256 contractToken0Bal_,
            uint256 contractToken1Bal_
        ) = getTokenInfo(dexLpAddress_, address(this));

        (uint256 amount0, uint256 amount1, ) = IGUniPool(gUniPool_)
            .getMintAmounts(contractToken0Bal_, contractToken1Bal_);

        addLiquidityGuni(
            gUniRouter_,
            gUniPool_,
            contractToken0Bal_,
            contractToken1Bal_,
            (amount0 * percentage_) / 1000,
            (amount1 * percentage_) / 1000
        );

        transactions[txCount] = TxDetails({
            contractV2lpBalanceBeforeRemovingLiquidity: amount,
            contractV2lpBalanceAfterRemovingLiquidity: amountAfterTx,
            contractToken0Bal: contractToken0Bal_,
            contractToken1Bal: contractToken1Bal_,
            expectedToken0ToBeAddedOnGuni: amount0,
            expectedToken1ToBeAddedOnGuni: amount1,
            lps: dexLpAddress_
        });

        txCount++;
    }

    /// @notice Removes liquidity from sushiswap/uniswap
    /// @param pairAddr_ lp address
    /// @param router_ sushiswap/uniswap router address
    /// @param amount_ amount of lp to remove
    function removeLiquidity(
        address pairAddr_,
        address router_,
        uint256 amount_
    ) internal {
        (
            address token0,
            address token1,
            uint256 pairBalanaceInTokenA,
            uint256 pairBalanaceInTokenB
        ) = getTokenInfo(pairAddr_, pairAddr_);

        uint256 totalSupply = IUniswapV2Pair(pairAddr_).totalSupply();
        uint256 amount1Min = (pairBalanaceInTokenA * amount_) / totalSupply;

        uint256 amount2Min = (pairBalanaceInTokenB * amount_) / totalSupply;
        IUniswapV2Pair(pairAddr_).approve(router_, amount_);

        IUniswapV2Router02(router_).removeLiquidity(
            token0,
            token1,
            amount_,
            amount1Min,
            amount2Min,
            address(this),
            type(uint256).max
        );
    }

    /// @notice Adds liquidity to guni pool
    /// @param router_ guni router address
    /// @param pool_ guni pool address
    /// @param amount0Max_ max amount of token 0 to be added as liquidity
    /// @param amount1Max_ max amount of token 1 to be added as liquidity
    /// @param amount0Min_ min amount of token 0 to be added as liquidity
    /// @param amount1Min_ min amount of token 1 to be added as liquidity
    function addLiquidityGuni(
        address router_,
        address pool_,
        uint256 amount0Max_,
        uint256 amount1Max_,
        uint256 amount0Min_,
        uint256 amount1Min_
    ) internal {
        IERC20 token0 = IGUniPool(pool_).token0();
        IERC20 token1 = IGUniPool(pool_).token1();

        token0.approve(router_, amount0Max_);
        token1.approve(router_, amount1Max_);

        IGUniRouter(router_).addLiquidity(
            IGUniPool(pool_),
            amount0Max_,
            amount1Max_,
            amount0Min_,
            amount1Min_,
            address(this)
        );
    }

    /// @notice Returns token 0, token 1, contract balance of token 0, contract balance of token 1
    /// @param lp_ lp address
    /// @return address, address, uint, uint
    function getTokenInfo(address lp_, address addr_)
        public
        view
        returns (
            address,
            address,
            uint256,
            uint256
        )
    {
        address token0 = IUniswapV2Pair(lp_).token0();
        address token1 = IUniswapV2Pair(lp_).token1();

        uint256 token0Bal = IERC20(token0).balanceOf(addr_);
        uint256 token1Bal = IERC20(token1).balanceOf(addr_);

        return (token0, token1, token0Bal, token1Bal);
    }

    /// @notice Withdraws token left after adding liquidity to guni
    /// @param addr_ token address
    function withdrawToken(address addr_) external onlyOwner {
        uint256 tokenBal = IERC20(addr_).balanceOf(address(this));
        require(tokenBal > 0, "no funds to withdraw");

        IERC20(addr_).safeTransfer(msg.sender, tokenBal);
    }
}
