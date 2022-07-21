// SPDX-License-Identifier: GPL-3.0

/*
    This file is part of the Enzyme Protocol.

    (c) Enzyme Council <council@enzyme.finance>

    For the full license information, please view the LICENSE
    file that was distributed with this source code.
*/

pragma solidity 0.6.12;

import "../../../../infrastructure/price-feeds/derivatives/feeds/YearnVaultV2PriceFeed.sol";
import "../utils/actions/YearnVaultV2ActionsMixin.sol";
import "../utils/AdapterBase.sol";

/// @title YearnVaultV2Adapter Contract
/// @author Enzyme Council <security@enzyme.finance>
/// @notice Adapter for interacting with Yearn v2 vaults
contract YearnVaultV2Adapter is AdapterBase, YearnVaultV2ActionsMixin {
    address private immutable YEARN_VAULT_V2_PRICE_FEED;

    constructor(address _integrationManager, address _yearnVaultV2PriceFeed)
        public
        AdapterBase(_integrationManager)
    {
        YEARN_VAULT_V2_PRICE_FEED = _yearnVaultV2PriceFeed;
    }

    /// @notice Deposits an amount of an underlying asset into its corresponding yVault
    /// @param _vaultProxy The VaultProxy of the calling fund
    /// @param _assetData Parsed spend assets and incoming assets data for this action
    /// @dev Using postActionSpendAssetsTransferHandler is probably overkill, but since new
    /// yVault v2 contracts can update logic, this protects against a future implementation in
    /// which a partial underlying deposit amount is used if the desired amount exceeds the
    /// deposit limit, for example.
    function lend(
        address _vaultProxy,
        bytes calldata,
        bytes calldata _assetData
    )
        external
        onlyIntegrationManager
        postActionSpendAssetsTransferHandler(_vaultProxy, _assetData)
    {
        // More efficient to parse all from _assetData
        (
            address[] memory spendAssets,
            uint256[] memory spendAssetAmounts,
            address[] memory incomingAssets
        ) = __decodeAssetData(_assetData);

        __yearnVaultV2Lend(_vaultProxy, incomingAssets[0], spendAssets[0], spendAssetAmounts[0]);
    }

    /// @notice Redeems an amount of yVault shares for its underlying asset
    /// @param _vaultProxy The VaultProxy of the calling fund
    /// @param _actionData Data specific to this action
    /// @param _assetData Parsed spend assets and incoming assets data for this action
    /// @dev The amount of yVault shares to be redeemed can be adjusted in yVault.withdraw()
    /// depending on the available underlying balance, so we must send unredeemed yVault shares
    /// back to the _vaultProxy
    function redeem(
        address _vaultProxy,
        bytes calldata _actionData,
        bytes calldata _assetData
    )
        external
        onlyIntegrationManager
        postActionSpendAssetsTransferHandler(_vaultProxy, _assetData)
    {
        (
            address yVault,
            uint256 maxOutgoingYVaultSharesAmount,
            ,
            uint256 slippageToleranceBps
        ) = __decodeRedeemCallArgs(_actionData);

        __yearnVaultV2Redeem(
            _vaultProxy,
            yVault,
            maxOutgoingYVaultSharesAmount,
            slippageToleranceBps
        );
    }

    /// @dev Helper to get the underlying for a given Yearn Vault
    function __getUnderlyingForYVault(address _yVault) private view returns (address underlying_) {
        return
            YearnVaultV2PriceFeed(getYearnVaultV2PriceFeed()).getUnderlyingForDerivative(_yVault);
    }

    /////////////////////////////
    // PARSE ASSETS FOR METHOD //
    /////////////////////////////

    /// @notice Parses the expected assets in a particular action
    /// @param _selector The function selector for the callOnIntegration
    /// @param _actionData Data specific to this action
    /// @return spendAssetsHandleType_ A type that dictates how to handle granting
    /// the adapter access to spend assets (`None` by default)
    /// @return spendAssets_ The assets to spend in the call
    /// @return spendAssetAmounts_ The max asset amounts to spend in the call
    /// @return incomingAssets_ The assets to receive in the call
    /// @return minIncomingAssetAmounts_ The min asset amounts to receive in the call
    function parseAssetsForAction(
        address,
        bytes4 _selector,
        bytes calldata _actionData
    )
        external
        view
        override
        returns (
            IIntegrationManager.SpendAssetsHandleType spendAssetsHandleType_,
            address[] memory spendAssets_,
            uint256[] memory spendAssetAmounts_,
            address[] memory incomingAssets_,
            uint256[] memory minIncomingAssetAmounts_
        )
    {
        if (_selector == LEND_SELECTOR) {
            return __parseAssetsForLend(_actionData);
        } else if (_selector == REDEEM_SELECTOR) {
            return __parseAssetsForRedeem(_actionData);
        }

        revert("parseAssetsForAction: _selector invalid");
    }

    /// @dev Helper function to parse spend and incoming assets from encoded call args
    /// during lend() calls
    function __parseAssetsForLend(bytes calldata _actionData)
        private
        view
        returns (
            IIntegrationManager.SpendAssetsHandleType spendAssetsHandleType_,
            address[] memory spendAssets_,
            uint256[] memory spendAssetAmounts_,
            address[] memory incomingAssets_,
            uint256[] memory minIncomingAssetAmounts_
        )
    {
        (
            address yVault,
            uint256 outgoingUnderlyingAmount,
            uint256 minIncomingYVaultSharesAmount
        ) = __decodeLendCallArgs(_actionData);

        address underlying = __getUnderlyingForYVault(yVault);
        require(underlying != address(0), "__parseAssetsForLend: Unsupported yVault");

        spendAssets_ = new address[](1);
        spendAssets_[0] = underlying;

        spendAssetAmounts_ = new uint256[](1);
        spendAssetAmounts_[0] = outgoingUnderlyingAmount;

        incomingAssets_ = new address[](1);
        incomingAssets_[0] = yVault;

        minIncomingAssetAmounts_ = new uint256[](1);
        minIncomingAssetAmounts_[0] = minIncomingYVaultSharesAmount;

        return (
            IIntegrationManager.SpendAssetsHandleType.Transfer,
            spendAssets_,
            spendAssetAmounts_,
            incomingAssets_,
            minIncomingAssetAmounts_
        );
    }

    /// @dev Helper function to parse spend and incoming assets from encoded call args
    /// during redeem() calls
    function __parseAssetsForRedeem(bytes calldata _actionData)
        private
        view
        returns (
            IIntegrationManager.SpendAssetsHandleType spendAssetsHandleType_,
            address[] memory spendAssets_,
            uint256[] memory spendAssetAmounts_,
            address[] memory incomingAssets_,
            uint256[] memory minIncomingAssetAmounts_
        )
    {
        (
            address yVault,
            uint256 maxOutgoingYVaultSharesAmount,
            uint256 minIncomingUnderlyingAmount,

        ) = __decodeRedeemCallArgs(_actionData);

        address underlying = __getUnderlyingForYVault(yVault);
        require(underlying != address(0), "__parseAssetsForRedeem: Unsupported yVault");

        spendAssets_ = new address[](1);
        spendAssets_[0] = yVault;

        spendAssetAmounts_ = new uint256[](1);
        spendAssetAmounts_[0] = maxOutgoingYVaultSharesAmount;

        incomingAssets_ = new address[](1);
        incomingAssets_[0] = underlying;

        minIncomingAssetAmounts_ = new uint256[](1);
        minIncomingAssetAmounts_[0] = minIncomingUnderlyingAmount;

        return (
            IIntegrationManager.SpendAssetsHandleType.Transfer,
            spendAssets_,
            spendAssetAmounts_,
            incomingAssets_,
            minIncomingAssetAmounts_
        );
    }

    ///////////////////////
    // ENCODED CALL ARGS //
    ///////////////////////

    /// @dev Helper to decode callArgs for lending
    function __decodeLendCallArgs(bytes memory _actionData)
        private
        pure
        returns (
            address yVault_,
            uint256 outgoingUnderlyingAmount_,
            uint256 minIncomingYVaultSharesAmount_
        )
    {
        return abi.decode(_actionData, (address, uint256, uint256));
    }

    /// @dev Helper to decode callArgs for redeeming
    function __decodeRedeemCallArgs(bytes memory _actionData)
        private
        pure
        returns (
            address yVault_,
            uint256 maxOutgoingYVaultSharesAmount_,
            uint256 minIncomingUnderlyingAmount_,
            uint256 slippageToleranceBps_
        )
    {
        return abi.decode(_actionData, (address, uint256, uint256, uint256));
    }

    ///////////////////
    // STATE GETTERS //
    ///////////////////

    /// @notice Gets the `YEARN_VAULT_V2_PRICE_FEED` variable
    /// @return yearnVaultV2PriceFeed_ The `YEARN_VAULT_V2_PRICE_FEED` variable value
    function getYearnVaultV2PriceFeed() public view returns (address yearnVaultV2PriceFeed_) {
        return YEARN_VAULT_V2_PRICE_FEED;
    }
}
