pragma solidity 0.5.16;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./CompleteCToken.sol";
import "../../weth/WETH9.sol";
import "@studydefi/money-legos/compound/contracts/ICEther.sol";

contract CompoundInteractor is ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public underlying;
    IERC20 public _weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    CompleteCToken public ctoken;
    ComptrollerInterface public comptroller;

    constructor(
        address _underlying,
        address _ctoken,
        address _comptroller
    ) public {
        // Comptroller:
        comptroller = ComptrollerInterface(_comptroller);

        underlying = IERC20(_underlying);
        ctoken = CompleteCToken(_ctoken);

        // Enter the market
        address[] memory cTokens = new address[](1);
        cTokens[0] = _ctoken;
        comptroller.enterMarkets(cTokens);
    }

    /**
     * Supplies Ether to Compound
     * Unwraps WETH to Ether, then invoke the special mint for cEther
     * We ask to supply "amount", if the "amount" we asked to supply is
     * more than balance (what we really have), then only supply balance.
     * If we the "amount" we want to supply is less than balance, then
     * only supply that amount.
     */
    function _supplyEtherInWETH(uint256 amountInWETH) internal nonReentrant {
        // underlying here is WETH
        uint256 balance = underlying.balanceOf(address(this)); // supply at most "balance"
        if (amountInWETH < balance) {
            balance = amountInWETH; // only supply the "amount" if its less than what we have
        }
        WETH9 weth = WETH9(address(_weth));
        weth.withdraw(balance); // Unwrapping
        ICEther(address(ctoken)).mint.value(balance)();
    }

    /**
     * Redeems Ether from Compound
     * receives Ether. Wrap all the ether that is in this contract.
     */
    function _redeemEtherInCTokens(uint256 amountCTokens)
        internal
        nonReentrant
    {
        _redeemInCTokens(amountCTokens);
        WETH9 weth = WETH9(address(_weth));
        weth.deposit.value(address(this).balance)();
    }

    /**
     * Supplies to Compound
     */
    function _supply(uint256 amount) internal returns (uint256) {
        uint256 balance = underlying.balanceOf(address(this));
        if (amount < balance) {
            balance = amount;
        }
        underlying.safeApprove(address(ctoken), 0);
        underlying.safeApprove(address(ctoken), balance);
        uint256 mintResult = ctoken.mint(balance);
        require(mintResult == 0, "Supplying failed");
        return balance;
    }

    /**
     * Borrows against the collateral
     */
    function _borrow(uint256 amountUnderlying) internal {
        // Borrow DAI, check the DAI balance for this contract's address
        uint256 result = ctoken.borrow(amountUnderlying);
        require(result == 0, "Borrow failed");
    }

    /**
     * Borrows against the collateral
     */
    function _borrowInWETH(uint256 amountUnderlying) internal {
        // Borrow ETH, wraps into WETH
        uint256 result = ctoken.borrow(amountUnderlying);
        require(result == 0, "Borrow failed");
        WETH9 weth = WETH9(address(_weth));
        weth.deposit.value(address(this).balance)();
    }

    /**
     * Repays a loan
     */
    function _repay(uint256 amountUnderlying) internal {
        underlying.safeApprove(address(ctoken), 0);
        underlying.safeApprove(address(ctoken), amountUnderlying);
        ctoken.repayBorrow(amountUnderlying);
        underlying.safeApprove(address(ctoken), 0);
    }

    /**
     * Repays a loan in ETH
     */
    function _repayInWETH(uint256 amountUnderlying) internal {
        WETH9 weth = WETH9(address(_weth));
        weth.withdraw(amountUnderlying); // Unwrapping
        ICEther(address(ctoken)).repayBorrow.value(amountUnderlying)();
    }

    /**
     * Redeem liquidity in cTokens
     */
    function _redeemInCTokens(uint256 amountCTokens) internal {
        if (amountCTokens > 0) {
            ctoken.redeem(amountCTokens);
        }
    }

    /**
     * Redeem liquidity in underlying
     */
    function _redeemUnderlying(uint256 amountUnderlying) internal {
        if (amountUnderlying > 0) {
            ctoken.redeemUnderlying(amountUnderlying);
        }
    }

    /**
     * Redeem liquidity in underlying
     */
    function redeemUnderlyingInWeth(uint256 amountUnderlying) internal {
        if (amountUnderlying > 0) {
            _redeemUnderlying(amountUnderlying);
            WETH9 weth = WETH9(address(_weth));
            weth.deposit.value(address(this).balance)();
        }
    }

    /**
     * Get COMP
     */
    function claimComp() public {
        comptroller.claimComp(address(this));
    }

    /**
     * Redeem the minimum of the WETH we own, and the WETH that the cToken can
     * immediately retrieve. Ensures that `redeemMaximum` doesn't fail silently
     */
    function redeemMaximumWeth() internal {
        // amount of WETH in contract
        uint256 available = ctoken.getCash();
        // amount of WETH we own
        uint256 owned = ctoken.balanceOfUnderlying(address(this));

        // redeem the most we can redeem
        redeemUnderlyingInWeth(available < owned ? available : owned);
    }

    function redeemMaximumWethWithLoan(
        uint256 collateralFactorNumerator,
        uint256 collateralFactorDenominator,
        uint256 borrowMinThreshold
    ) internal {
        // amount of liquidity in Compound
        uint256 available = ctoken.getCash();
        // amount of WETH we supplied
        uint256 supplied = ctoken.balanceOfUnderlying(address(this));
        // amount of WETH we borrowed
        uint256 borrowed = ctoken.borrowBalanceCurrent(address(this));

        while (borrowed > borrowMinThreshold) {
            uint256 requiredCollateral =
                borrowed
                    .mul(collateralFactorDenominator)
                    .add(collateralFactorNumerator.div(2))
                    .div(collateralFactorNumerator);

            // redeem just as much as needed to repay the loan
            uint256 wantToRedeem = supplied.sub(requiredCollateral);
            redeemUnderlyingInWeth(Math.min(wantToRedeem, available));

            // now we can repay our borrowed amount
            uint256 balance = underlying.balanceOf(address(this));
            _repayInWETH(Math.min(borrowed, balance));

            // update the parameters
            available = ctoken.getCash();
            borrowed = ctoken.borrowBalanceCurrent(address(this));
            supplied = ctoken.balanceOfUnderlying(address(this));
        }

        // redeem the most we can redeem
        redeemUnderlyingInWeth(Math.min(available, supplied));
    }

    function getLiquidity() external view returns (uint256) {
        return ctoken.getCash();
    }

    function redeemMaximumToken() internal {
        // amount of tokens in ctoken
        uint256 available = ctoken.getCash();
        // amount of tokens we own
        uint256 owned = ctoken.balanceOfUnderlying(address(this));

        // redeem the most we can redeem
        _redeemUnderlying(available < owned ? available : owned);
    }

    function() external payable {} // this is needed for the WETH unwrapping
}
