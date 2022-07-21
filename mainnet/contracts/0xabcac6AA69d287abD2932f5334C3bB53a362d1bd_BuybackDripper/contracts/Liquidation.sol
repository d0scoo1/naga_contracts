// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Multicall.sol";

import "./Oracles/PriceOracle.sol";
import "./MToken.sol";
import "./Supervisor.sol";
import "./DeadDrop.sol";

/**
 * This contract provides the liquidation functionality.
 */

contract Liquidation is AccessControl, ReentrancyGuard, Multicall {
    using SafeERC20 for IERC20;

    uint256 private constant EXP_SCALE = 1e18;

    /**
     * @notice The maximum allowable value of a healthy factor after liquidation, scaled by 1e18
     */
    uint256 public healthyFactorLimit = 1.2e18; // 120%

    /**
     * @notice Maximum sum in USD for internal liquidation. Collateral for loans that are less than this parameter will
     * be counted as protocol interest, scaled by 1e18
     */
    uint256 public insignificantLoanThreshold = 100e18; // 100$

    /// @notice Value is the Keccak-256 hash of "TRUSTED_LIQUIDATOR"
    /// @dev Role that's allowed to liquidate in Auto mode
    bytes32 public constant TRUSTED_LIQUIDATOR =
        bytes32(0xf81d27a41879d78d5568e0bc2989cb321b89b84d8e1b49895ee98604626c0218);
    /// @notice Value is the Keccak-256 hash of "MANUAL_LIQUIDATOR"
    /// @dev Role that's allowed to liquidate in Manual mode.
    ///      Each MANUAL_LIQUIDATOR address has to be appended to TRUSTED_LIQUIDATOR role too.
    bytes32 public constant MANUAL_LIQUIDATOR =
        bytes32(0x53402487d33e65b38c49f6f89bd08cbec4ff7c074cddd2357722b7917cd13f1e);
    /// @dev Value is the Keccak-256 hash of "TIMELOCK"
    bytes32 public constant TIMELOCK = bytes32(0xaefebe170cbaff0af052a32795af0e1b8afff9850f946ad2869be14f35534371);

    /**
     * @notice Minterest deadDrop contract
     */
    DeadDrop public deadDrop;

    /**
     * @notice Oracle which gives the price of any given asset
     */
    PriceOracle public oracle;

    /**
     * @notice Minterest supervisor contract
     */
    Supervisor public supervisor;

    event HealthyFactorLimitChanged(uint256 oldValue, uint256 newValue);
    event NewSupervisor(Supervisor oldSupervisor, Supervisor newSupervisor);
    event NewPriceOracle(PriceOracle oldOracle, PriceOracle newOracle);
    event NewDeadDrop(DeadDrop oldDeadDrop, DeadDrop newDeadDrop);
    event NewInsignificantLoanThreshold(uint256 oldValue, uint256 newValue);
    event ReliableLiquidation(
        bool isManualLiquidation,
        bool isDebtHealthy,
        address liquidator,
        address borrower,
        MToken[] marketAddresses,
        uint256[] seizeIndexes,
        uint256[] debtRates
    );

    /**
     * @notice Construct a Liquidation contract
     * @param deadDrop_ Minterest deadDrop address
     * @param liquidators_ Array of addresses of liquidators
     * @param supervisor_ The address of the Supervisor contract
     * @param admin_ The address of the admin
     */
    constructor(
        address[] memory liquidators_,
        DeadDrop deadDrop_,
        Supervisor supervisor_,
        address admin_
    ) {
        require(
            supervisor_.supportsInterface(type(SupervisorInterface).interfaceId),
            ErrorCodes.CONTRACT_DOES_NOT_SUPPORT_INTERFACE
        );
        require(address(deadDrop_) != address(0), ErrorCodes.ZERO_ADDRESS);

        supervisor = supervisor_;
        _grantRole(DEFAULT_ADMIN_ROLE, admin_);
        _grantRole(TRUSTED_LIQUIDATOR, admin_);
        _grantRole(MANUAL_LIQUIDATOR, admin_);
        _grantRole(TIMELOCK, admin_);
        oracle = supervisor_.oracle();
        deadDrop = deadDrop_;

        for (uint256 i = 0; i < liquidators_.length; i++) {
            _grantRole(TRUSTED_LIQUIDATOR, liquidators_[i]);
        }
    }

    /**
     * @dev Local accountState for avoiding stack-depth limits in calculating liquidation amounts.
     */
    struct AccountLiquidationAmounts {
        uint256 accountTotalSupplyUsd;
        uint256 accountTotalCollateralUsd;
        uint256 accountPresumedTotalSeizeUsd;
        uint256 accountTotalBorrowUsd;
        uint256[] repayAmounts;
        uint256[] seizeAmounts;
    }

    /**
     * @notice Liquidate insolvent debt position
     * @param borrower_ Account which is being liquidated
     * @param seizeIndexes_ An array with market indexes that will be used as collateral.
     *        Each element corresponds to the market index in the accountAssets array
     * @param debtRates_  An array of debt redemption rates for each debt markets (scaled by 1e18).
     */
    //slither-disable-next-line reentrancy-benign
    function liquidateUnsafeLoan(
        address borrower_,
        uint256[] memory seizeIndexes_,
        uint256[] memory debtRates_
    ) external onlyRole(TRUSTED_LIQUIDATOR) nonReentrant {
        AccountLiquidationAmounts memory accountState;

        MToken[] memory accountAssets = supervisor.getAccountAssets(borrower_);
        verifyExternalData(accountAssets.length, seizeIndexes_, debtRates_);

        //slither-disable-next-line reentrancy-events
        accrue(accountAssets, seizeIndexes_, debtRates_);
        accountState = calculateLiquidationAmounts(borrower_, accountAssets, seizeIndexes_, debtRates_);

        require(
            accountState.accountTotalCollateralUsd < accountState.accountTotalBorrowUsd,
            ErrorCodes.INSUFFICIENT_SHORTFALL
        );

        bool isManualLiquidation = hasRole(MANUAL_LIQUIDATOR, msg.sender);
        bool isDebtHealthy = accountState.accountPresumedTotalSeizeUsd <= accountState.accountTotalSupplyUsd;

        seize(
            borrower_,
            accountAssets,
            accountState.seizeAmounts,
            accountState.accountTotalBorrowUsd <= insignificantLoanThreshold,
            isManualLiquidation
        );
        repay(borrower_, accountAssets, accountState.repayAmounts, isManualLiquidation);

        if (isDebtHealthy) {
            require(approveBorrowerHealthyFactor(borrower_, accountAssets), ErrorCodes.HEALTHY_FACTOR_NOT_IN_RANGE);
        }

        emit ReliableLiquidation(
            isManualLiquidation,
            isDebtHealthy,
            msg.sender,
            borrower_,
            accountAssets,
            seizeIndexes_,
            debtRates_
        );
    }

    /**
     * @notice Checks if input data meets requirements
     * @param accountAssetsLength The length of borrower's accountAssets array
     * @param seizeIndexes_ An array with market indexes that will be used as collateral.
     *        Each element corresponds to the market index in the accountAssets array
     * @param debtRates_ An array of debt redemption rates for each debt markets (scaled by 1e18).
     * @dev Indexes for arrays accountAssets && debtRates match each other
     */
    function verifyExternalData(
        uint256 accountAssetsLength,
        uint256[] memory seizeIndexes_,
        uint256[] memory debtRates_
    ) internal pure {
        uint256 debtRatesLength = debtRates_.length;
        uint256 seizeIndexesLength = seizeIndexes_.length;

        require(accountAssetsLength != 0 && debtRatesLength == accountAssetsLength, ErrorCodes.LQ_INVALID_DRR_ARRAY);
        require(
            seizeIndexesLength != 0 && seizeIndexesLength <= accountAssetsLength,
            ErrorCodes.LQ_INVALID_SEIZE_ARRAY
        );

        // Check all DRR are <= 100%
        for (uint256 i = 0; i < debtRatesLength; i++) {
            require(debtRates_[i] <= EXP_SCALE, ErrorCodes.LQ_INVALID_DEBT_REDEMPTION_RATE);
        }

        // Check all seizeIndexes are <= to (accountAssetsLength - 1)
        for (uint256 i = 0; i < seizeIndexesLength; i++) {
            require(seizeIndexes_[i] <= (accountAssetsLength - 1), ErrorCodes.LQ_INVALID_SEIZE_INDEX);
            // Check seizeIndexes array does not contain duplicates
            for (uint256 j = i + 1; j < seizeIndexesLength; j++) {
                require(seizeIndexes_[i] != seizeIndexes_[j], ErrorCodes.LQ_DUPLICATE_SEIZE_INDEX);
            }
        }
    }

    /**
     * @notice Accrues interest for all required borrower's markets
     * @dev Accrue is required if market is used as borrow (debtRate > 0)
     *      or collateral (seizeIndex arr contains market index)
     *      The caller must ensure that the lengths of arrays 'accountAssets' and 'debtRates' are the same,
     *      array 'seizeIndexes' does not contain duplicates and none of the indexes exceeds the value
     *      (accountAssets.length - 1).
     * @param accountAssets An array with addresses of markets where the debtor is in
     * @param seizeIndexes_ An array with market indexes that will be used as collateral
     *        Each element corresponds to the market index in the accountAssets array
     * @param debtRates_ An array of debt redemption rates for each debt markets (scaled by 1e18)
     */
    function accrue(
        MToken[] memory accountAssets,
        uint256[] memory seizeIndexes_,
        uint256[] memory debtRates_
    ) public {
        for (uint256 i = 0; i < accountAssets.length; i++) {
            //slither-disable-next-line calls-loop
            if (debtRates_[i] > 0 || includes(i, seizeIndexes_)) accountAssets[i].accrueInterest();
        }
    }

    /**
     * @notice Determines whether an array includes a certain value among its entries
     * @param index_ The value to search for
     * @param seizeIndexes_ An array with market indexes that will be used as collateral.
     * @return bool Returning true or false as appropriate.
     */
    function includes(uint256 index_, uint256[] memory seizeIndexes_) internal pure returns (bool) {
        for (uint256 i = 0; i < seizeIndexes_.length; i++) {
            if (seizeIndexes_[i] == index_) return true;
        }
        return false;
    }

    /**
     * @dev Local marketParams for avoiding stack-depth limits in calculating liquidation amounts.
     */
    struct MarketParams {
        uint256 supplyWrap;
        uint256 borrowUnderlying;
        uint256 exchangeRateMantissa;
        uint256 liquidationFeeMantissa;
        uint256 utilisationFactorMantissa;
    }

    /**
     * @notice For each market calculates the liquidation amounts based on borrower's state.
     * @param account_ The address of the borrower
     * @param marketAddresses An array with addresses of markets where the debtor is in
     * @param seizeIndexes_ An array with market indexes that will be used as collateral
     *        Each element corresponds to the market index in the accountAssets array
     * @param debtRates_ An array of debt redemption rates for each debt markets (scaled by 1e18)
     * @return accountState Struct that contains all balance parameters
     *         All arrays calculated in underlying assets, all total values calculated in USD.
     *         (the array indexes match each other)
     */
    function calculateLiquidationAmounts(
        address account_,
        MToken[] memory marketAddresses,
        uint256[] memory seizeIndexes_,
        uint256[] memory debtRates_
    ) public view virtual returns (AccountLiquidationAmounts memory accountState) {
        uint256 actualSeizeUsd = 0;
        uint256 accountMarketsLen = marketAddresses.length;
        uint256[] memory supplyAmountsUsd = new uint256[](accountMarketsLen);
        uint256[] memory oraclePrices = new uint256[](accountMarketsLen);

        accountState.repayAmounts = new uint256[](accountMarketsLen);
        accountState.seizeAmounts = new uint256[](accountMarketsLen);

        // For each market the borrower is in calculate liquidation amounts
        for (uint256 i = 0; i < accountMarketsLen; i++) {
            MToken market = marketAddresses[i];

            oraclePrices[i] = oracle.getUnderlyingPrice(market);
            require(oraclePrices[i] > 0, ErrorCodes.INVALID_PRICE);

            //slither-disable-next-line uninitialized-local
            MarketParams memory vars;
            (vars.supplyWrap, vars.borrowUnderlying, vars.exchangeRateMantissa) = market.getAccountSnapshot(account_);
            (vars.liquidationFeeMantissa, vars.utilisationFactorMantissa) = supervisor.getMarketData(market);

            if (vars.borrowUnderlying > 0) {
                // accountTotalBorrowUsd += borrowUnderlying * oraclePrice
                uint256 accountBorrowUsd = (vars.borrowUnderlying * oraclePrices[i]) / EXP_SCALE;
                accountState.accountTotalBorrowUsd += accountBorrowUsd;

                // accountPresumedTotalSeizeUsd parameter showing what the totalSeize would be under the condition of
                // complete liquidation.
                // accountPresumedTotalSeizeUsd += borrowUnderlying * oraclePrice * (1 + liquidationFee)
                uint256 fullSeizeUsd = (accountBorrowUsd * (vars.liquidationFeeMantissa + EXP_SCALE)) / EXP_SCALE;
                accountState.accountPresumedTotalSeizeUsd += fullSeizeUsd;

                // repayAmountUnderlying = borrowUnderlying * redemptionRate
                // actualSeizeUsd += borrowUnderlying * oraclePrice * (1 + liquidationFee) * redemptionRate
                if (debtRates_[i] > 0) {
                    accountState.repayAmounts[i] = (vars.borrowUnderlying * debtRates_[i]) / EXP_SCALE;
                    actualSeizeUsd += (fullSeizeUsd * debtRates_[i]) / EXP_SCALE;
                }
            }

            if (vars.supplyWrap > 0) {
                // supplyAmount = supplyWrap * exchangeRate
                uint256 supplyAmount = (vars.supplyWrap * vars.exchangeRateMantissa) / EXP_SCALE;

                // accountTotalSupplyUsd += supplyWrap * exchangeRate * oraclePrice
                uint256 accountSupplyUsd = (supplyAmount * oraclePrices[i]) / EXP_SCALE;
                accountState.accountTotalSupplyUsd += accountSupplyUsd;
                supplyAmountsUsd[i] = accountSupplyUsd;

                // accountTotalCollateralUsd += accountSupplyUSD * utilisationFactor
                accountState.accountTotalCollateralUsd +=
                    (accountSupplyUsd * vars.utilisationFactorMantissa) /
                    EXP_SCALE;
            }
        }

        if (actualSeizeUsd > 0) {
            for (uint256 i = 0; i < seizeIndexes_.length; i++) {
                uint256 marketIndex = seizeIndexes_[i];
                uint256 marketSupply = supplyAmountsUsd[marketIndex];

                if (marketSupply <= actualSeizeUsd) {
                    accountState.seizeAmounts[marketIndex] = type(uint256).max;
                    actualSeizeUsd -= marketSupply;
                } else {
                    accountState.seizeAmounts[marketIndex] = (actualSeizeUsd * EXP_SCALE) / oraclePrices[marketIndex];
                    actualSeizeUsd = 0;
                    break;
                }
            }
            require(actualSeizeUsd == 0, ErrorCodes.LQ_INVALID_SEIZE_DISTRIBUTION);
        }
        return (accountState);
    }

    /**
     * @dev Burns collateral tokens at the borrower's address, transfer underlying assets
     *      to the deadDrop or ManualLiquidator address, if loan is not insignificant, otherwise, all account's
     *      collateral is credited to the protocolInterest. Process all borrower's markets.
     * @param borrower_ The account having collateral seized
     * @param marketAddresses_ Array of markets the borrower is in
     * @param seizeUnderlyingAmounts_ Array of seize amounts in underlying assets
     * @param isLoanInsignificant_ Marker for insignificant loan whose collateral must be credited to the
     *        protocolInterest
     * @param isManualLiquidation_ Marker for manual liquidation process.
     */
    function seize(
        address borrower_,
        MToken[] memory marketAddresses_,
        uint256[] memory seizeUnderlyingAmounts_,
        bool isLoanInsignificant_,
        bool isManualLiquidation_
    ) internal {
        for (uint256 i = 0; i < marketAddresses_.length; i++) {
            uint256 seizeUnderlyingAmount = seizeUnderlyingAmounts_[i];
            if (seizeUnderlyingAmount > 0) {
                address receiver = isManualLiquidation_ ? msg.sender : address(deadDrop);

                MToken seizeMarket = marketAddresses_[i];
                seizeMarket.autoLiquidationSeize(borrower_, seizeUnderlyingAmount, isLoanInsignificant_, receiver);
            }
        }
    }

    /**
     * @dev Liquidator repays a borrow belonging to borrower. Process all borrower's markets.
     * @param borrower_ The account with the debt being payed off
     * @param marketAddresses_ Array of markets the borrower is in
     * @param repayAmounts_ Array of repay amounts in underlying assets
     * @param isManualLiquidation_ Marker for manual liquidation process.
     * Note: The calling code must be sure that the oracle price for all processed markets is greater than zero.
     */
    function repay(
        address borrower_,
        MToken[] memory marketAddresses_,
        uint256[] memory repayAmounts_,
        bool isManualLiquidation_
    ) internal {
        for (uint256 i = 0; i < marketAddresses_.length; i++) {
            uint256 repayAmount = repayAmounts_[i];
            if (repayAmount > 0) {
                MToken repayMarket = marketAddresses_[i];

                if (isManualLiquidation_) {
                    repayMarket.addProtocolInterestBehalf(msg.sender, repayAmount);
                }

                repayMarket.autoLiquidationRepayBorrow(borrower_, repayAmount);
            }
        }
    }

    /**
     * @dev Approve that current healthy factor satisfies the condition:
     *      currentHealthyFactor <= healthyFactorLimit
     * @param borrower_ The account with the debt being payed off
     * @param marketAddresses_ Array of markets the borrower is in
     * @return Whether or not the current account healthy factor is correct
     */
    function approveBorrowerHealthyFactor(address borrower_, MToken[] memory marketAddresses_)
        internal
        view
        returns (bool)
    {
        uint256 accountTotalCollateral = 0;
        uint256 accountTotalBorrow = 0;

        uint256 supplyWrap;
        uint256 borrowUnderlying;
        uint256 exchangeRateMantissa;
        uint256 utilisationFactorMantissa;

        for (uint256 i = 0; i < marketAddresses_.length; i++) {
            MToken market = marketAddresses_[i];
            uint256 oraclePriceMantissa = oracle.getUnderlyingPrice(market);
            require(oraclePriceMantissa > 0, ErrorCodes.INVALID_PRICE);

            (supplyWrap, borrowUnderlying, exchangeRateMantissa) = market.getAccountSnapshot(borrower_);

            if (borrowUnderlying > 0) {
                accountTotalBorrow += ((borrowUnderlying * oraclePriceMantissa) / EXP_SCALE);
            }
            if (supplyWrap > 0) {
                (, utilisationFactorMantissa) = supervisor.getMarketData(market);
                uint256 supplyAmountUsd = ((((supplyWrap * exchangeRateMantissa) / EXP_SCALE) * oraclePriceMantissa) /
                    EXP_SCALE);
                accountTotalCollateral += (supplyAmountUsd * utilisationFactorMantissa) / EXP_SCALE;
            }
        }
        // currentHealthyFactor = accountTotalCollateral / accountTotalBorrow
        uint256 currentHealthyFactor = (accountTotalCollateral * EXP_SCALE) / accountTotalBorrow;

        return (currentHealthyFactor <= healthyFactorLimit);
    }

    /*** Admin Functions ***/

    /**
     * @notice Sets a new value for healthyFactorLimit
     */
    function setHealthyFactorLimit(uint256 newValue_) external onlyRole(TIMELOCK) {
        uint256 oldValue = healthyFactorLimit;

        require(newValue_ != oldValue, ErrorCodes.IDENTICAL_VALUE);
        healthyFactorLimit = newValue_;

        emit HealthyFactorLimitChanged(oldValue, newValue_);
    }

    /**
     * @notice Sets a new supervisor for the market
     */
    function setSupervisor(Supervisor newSupervisor_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(
            newSupervisor_.supportsInterface(type(SupervisorInterface).interfaceId),
            ErrorCodes.CONTRACT_DOES_NOT_SUPPORT_INTERFACE
        );

        Supervisor oldSupervisor = supervisor;
        supervisor = newSupervisor_;

        emit NewSupervisor(oldSupervisor, newSupervisor_);
    }

    /**
     * @notice Sets a new price oracle for the liquidation contract
     */
    function setPriceOracle(PriceOracle newOracle_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(newOracle_ == supervisor.oracle(), ErrorCodes.NEW_ORACLE_MISMATCH);

        PriceOracle oldOracle = oracle;
        oracle = newOracle_;

        emit NewPriceOracle(oldOracle, newOracle_);
    }

    /**
     * @notice Sets a new minterest deadDrop
     */
    function setDeadDrop(DeadDrop newDeadDrop_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(address(newDeadDrop_) != address(0), ErrorCodes.ZERO_ADDRESS);
        DeadDrop oldDeadDrop = deadDrop;
        deadDrop = newDeadDrop_;

        emit NewDeadDrop(oldDeadDrop, newDeadDrop_);
    }

    /**
     * @notice Sets a new insignificantLoanThreshold
     */
    function setInsignificantLoanThreshold(uint256 newValue_) external onlyRole(TIMELOCK) {
        uint256 oldValue = insignificantLoanThreshold;
        insignificantLoanThreshold = newValue_;

        emit NewInsignificantLoanThreshold(oldValue, newValue_);
    }
}
