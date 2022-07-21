// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.10;

import {IPool} from "../../../interfaces/IPool.sol";
import {IInitializableOToken} from "../../../interfaces/IInitializableOToken.sol";
import {IInitializableDebtToken} from "../../../interfaces/IInitializableDebtToken.sol";
import {IRewardController} from "../../../interfaces/IRewardController.sol";
import {InitializableImmutableAdminUpgradeabilityProxy} from "../omni-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol";
import {ReserveConfiguration} from "../configuration/ReserveConfiguration.sol";
import {DataTypes} from "../types/DataTypes.sol";
import {ConfiguratorInputTypes} from "../types/ConfiguratorInputTypes.sol";

/**
 * @title ConfiguratorLogic library
 *
 * @notice Implements the functions to initialize reserves and update xTokens and debtTokens
 */
library ConfiguratorLogic {
    using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

    // See `IPoolConfigurator` for descriptions
    event ReserveInitialized(
        address indexed asset,
        address indexed xToken,
        address stableDebtToken,
        address variableDebtToken,
        address interestRateStrategyAddress
    );
    event XTokenUpgraded(
        address indexed asset,
        address indexed proxy,
        address indexed implementation
    );
    // TODO can we get rid of StableDebtToken?
    event StableDebtTokenUpgraded(
        address indexed asset,
        address indexed proxy,
        address indexed implementation
    );
    event VariableDebtTokenUpgraded(
        address indexed asset,
        address indexed proxy,
        address indexed implementation
    );

    /**
     * @notice Initialize a reserve by creating and initializing xToken, stable debt token and variable debt token
     * @dev Emits the `ReserveInitialized` event
     * @param pool The Pool in which the reserve will be initialized
     * @param input The needed parameters for the initialization
     */
    function executeInitReserve(
        IPool pool,
        ConfiguratorInputTypes.InitReserveInput calldata input
    ) public {
        address xTokenProxyAddress = _initTokenWithProxy(
            input.xTokenImpl,
            abi.encodeWithSelector(
                IInitializableOToken.initialize.selector,
                pool,
                input.treasury,
                input.underlyingAsset,
                input.incentivesController,
                input.underlyingAssetDecimals,
                input.xTokenName,
                input.xTokenSymbol,
                input.params
            )
        );

        address stableDebtTokenProxyAddress = _initTokenWithProxy(
            input.stableDebtTokenImpl,
            abi.encodeWithSelector(
                IInitializableDebtToken.initialize.selector,
                pool,
                input.underlyingAsset,
                input.incentivesController,
                input.underlyingAssetDecimals,
                input.stableDebtTokenName,
                input.stableDebtTokenSymbol,
                input.params
            )
        );

        address variableDebtTokenProxyAddress = _initTokenWithProxy(
            input.variableDebtTokenImpl,
            abi.encodeWithSelector(
                IInitializableDebtToken.initialize.selector,
                pool,
                input.underlyingAsset,
                input.incentivesController,
                input.underlyingAssetDecimals,
                input.variableDebtTokenName,
                input.variableDebtTokenSymbol,
                input.params
            )
        );

        pool.initReserve(
            input.underlyingAsset,
            input.assetType,
            xTokenProxyAddress,
            stableDebtTokenProxyAddress,
            variableDebtTokenProxyAddress,
            input.interestRateStrategyAddress
        );

        DataTypes.ReserveConfigurationMap memory currentConfig = DataTypes
            .ReserveConfigurationMap(0);

        currentConfig.setDecimals(input.underlyingAssetDecimals);

        currentConfig.setActive(true);
        currentConfig.setPaused(false);
        currentConfig.setFrozen(false);

        pool.setConfiguration(input.underlyingAsset, currentConfig);

        emit ReserveInitialized(
            input.underlyingAsset,
            xTokenProxyAddress,
            stableDebtTokenProxyAddress,
            variableDebtTokenProxyAddress,
            input.interestRateStrategyAddress
        );
    }

    /**
     * @notice Updates the xToken implementation and initializes it
     * @dev Emits the `XTokenUpgraded` event
     * @param cachedPool The Pool containing the reserve with the xToken
     * @param input The parameters needed for the initialize call
     */
    function executeUpdateXToken(
        IPool cachedPool,
        ConfiguratorInputTypes.UpdateXTokenInput calldata input
    ) public {
        DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(
            input.asset
        );

        (, , , uint256 decimals, ) = cachedPool
            .getConfiguration(input.asset)
            .getParams();

        bytes memory encodedCall = abi.encodeWithSelector(
            IInitializableOToken.initialize.selector,
            cachedPool,
            input.treasury,
            input.asset,
            input.incentivesController,
            decimals,
            input.name,
            input.symbol,
            input.params
        );

        _upgradeTokenImplementation(
            reserveData.xTokenAddress,
            input.implementation,
            encodedCall
        );

        emit XTokenUpgraded(
            input.asset,
            reserveData.xTokenAddress,
            input.implementation
        );
    }

    // TODO can we get rid of StableDebtToken?
    /**
     * @notice Updates the stable debt token implementation and initializes it
     * @dev Emits the `StableDebtTokenUpgraded` event
     * @param cachedPool The Pool containing the reserve with the stable debt token
     * @param input The parameters needed for the initialize call
     */
    function executeUpdateStableDebtToken(
        IPool cachedPool,
        ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
    ) public {
        DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(
            input.asset
        );

        (, , , uint256 decimals, ) = cachedPool
            .getConfiguration(input.asset)
            .getParams();

        bytes memory encodedCall = abi.encodeWithSelector(
            IInitializableDebtToken.initialize.selector,
            cachedPool,
            input.asset,
            input.incentivesController,
            decimals,
            input.name,
            input.symbol,
            input.params
        );

        _upgradeTokenImplementation(
            reserveData.stableDebtTokenAddress,
            input.implementation,
            encodedCall
        );

        emit StableDebtTokenUpgraded(
            input.asset,
            reserveData.stableDebtTokenAddress,
            input.implementation
        );
    }

    /**
     * @notice Updates the variable debt token implementation and initializes it
     * @dev Emits the `VariableDebtTokenUpgraded` event
     * @param cachedPool The Pool containing the reserve with the variable debt token
     * @param input The parameters needed for the initialize call
     */
    function executeUpdateVariableDebtToken(
        IPool cachedPool,
        ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
    ) public {
        DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(
            input.asset
        );

        (, , , uint256 decimals, ) = cachedPool
            .getConfiguration(input.asset)
            .getParams();

        bytes memory encodedCall = abi.encodeWithSelector(
            IInitializableDebtToken.initialize.selector,
            cachedPool,
            input.asset,
            input.incentivesController,
            decimals,
            input.name,
            input.symbol,
            input.params
        );

        _upgradeTokenImplementation(
            reserveData.variableDebtTokenAddress,
            input.implementation,
            encodedCall
        );

        emit VariableDebtTokenUpgraded(
            input.asset,
            reserveData.variableDebtTokenAddress,
            input.implementation
        );
    }

    /**
     * @notice Creates a new proxy and initializes the implementation
     * @param implementation The address of the implementation
     * @param initParams The parameters that is passed to the implementation to initialize
     * @return The address of initialized proxy
     */
    function _initTokenWithProxy(
        address implementation,
        bytes memory initParams
    ) internal returns (address) {
        InitializableImmutableAdminUpgradeabilityProxy proxy = new InitializableImmutableAdminUpgradeabilityProxy(
                address(this)
            );

        proxy.initialize(implementation, initParams);

        return address(proxy);
    }

    /**
     * @notice Upgrades the implementation and makes call to the proxy
     * @dev The call is used to initialize the new implementation.
     * @param proxyAddress The address of the proxy
     * @param implementation The address of the new implementation
     * @param  initParams The parameters to the call after the upgrade
     */
    function _upgradeTokenImplementation(
        address proxyAddress,
        address implementation,
        bytes memory initParams
    ) internal {
        InitializableImmutableAdminUpgradeabilityProxy proxy = InitializableImmutableAdminUpgradeabilityProxy(
                payable(proxyAddress)
            );

        proxy.upgradeToAndCall(implementation, initParams);
    }
}
