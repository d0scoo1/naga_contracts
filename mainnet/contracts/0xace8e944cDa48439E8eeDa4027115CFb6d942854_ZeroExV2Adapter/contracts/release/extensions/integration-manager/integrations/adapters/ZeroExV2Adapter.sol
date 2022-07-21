// SPDX-License-Identifier: GPL-3.0

/*
    This file is part of the Enzyme Protocol.

    (c) Enzyme Council <council@enzyme.finance>

    For the full license information, please view the LICENSE
    file that was distributed with this source code.
*/

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "../../../../utils/FundDeployerOwnerMixin.sol";
import "../utils/actions/ZeroExV2ActionsMixin.sol";
import "../utils/AdapterBase.sol";

/// @title ZeroExV2Adapter Contract
/// @author Enzyme Council <security@enzyme.finance>
/// @notice Adapter to 0xV2 Exchange Contract
contract ZeroExV2Adapter is AdapterBase, FundDeployerOwnerMixin, ZeroExV2ActionsMixin {
    event AllowedMakerAdded(address indexed account);

    event AllowedMakerRemoved(address indexed account);

    mapping(address => bool) private makerToIsAllowed;

    // Gas could be optimized for the end-user by also storing an immutable ZRX_ASSET_DATA,
    // for example, but in the narrow OTC use-case of this adapter, taker fees are unlikely.
    constructor(
        address _integrationManager,
        address _exchange,
        address _fundDeployer,
        address[] memory _allowedMakers
    )
        public
        AdapterBase(_integrationManager)
        FundDeployerOwnerMixin(_fundDeployer)
        ZeroExV2ActionsMixin(_exchange)
    {
        if (_allowedMakers.length > 0) {
            __addAllowedMakers(_allowedMakers);
        }
    }

    // EXTERNAL FUNCTIONS

    /// @notice Take an order on 0x
    /// @param _vaultProxy The VaultProxy of the calling fund
    /// @param _actionData Data specific to this action
    /// @param _assetData Parsed spend assets and incoming assets data for this action
    function takeOrder(
        address _vaultProxy,
        bytes calldata _actionData,
        bytes calldata _assetData
    )
        external
        onlyIntegrationManager
        postActionIncomingAssetsTransferHandler(_vaultProxy, _assetData)
    {
        (
            bytes memory encodedZeroExOrderArgs,
            uint256 takerAssetFillAmount
        ) = __decodeTakeOrderCallArgs(_actionData);

        IZeroExV2.Order memory order = __constructOrderStruct(encodedZeroExOrderArgs);
        (, , , bytes memory signature) = __decodeZeroExOrderArgs(encodedZeroExOrderArgs);

        __zeroExV2TakeOrder(order, takerAssetFillAmount, signature);
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
        require(_selector == TAKE_ORDER_SELECTOR, "parseAssetsForAction: _selector invalid");

        (
            bytes memory encodedZeroExOrderArgs,
            uint256 takerAssetFillAmount
        ) = __decodeTakeOrderCallArgs(_actionData);
        IZeroExV2.Order memory order = __constructOrderStruct(encodedZeroExOrderArgs);

        require(
            isAllowedMaker(order.makerAddress),
            "parseAssetsForAction: Order maker is not allowed"
        );
        require(
            takerAssetFillAmount <= order.takerAssetAmount,
            "parseAssetsForAction: Taker asset fill amount greater than available"
        );

        address makerAsset = __getAssetAddress(order.makerAssetData);
        address takerAsset = __getAssetAddress(order.takerAssetData);

        // Format incoming assets
        incomingAssets_ = new address[](1);
        incomingAssets_[0] = makerAsset;
        minIncomingAssetAmounts_ = new uint256[](1);
        minIncomingAssetAmounts_[0] = __calcRelativeQuantity(
            order.takerAssetAmount,
            order.makerAssetAmount,
            takerAssetFillAmount
        );

        if (order.takerFee > 0) {
            address takerFeeAsset = __getAssetAddress(
                IZeroExV2(getZeroExV2Exchange()).ZRX_ASSET_DATA()
            );
            uint256 takerFeeFillAmount = __calcRelativeQuantity(
                order.takerAssetAmount,
                order.takerFee,
                takerAssetFillAmount
            ); // fee calculated relative to taker fill amount

            if (takerFeeAsset == makerAsset) {
                require(
                    order.takerFee < order.makerAssetAmount,
                    "parseAssetsForAction: Fee greater than makerAssetAmount"
                );

                spendAssets_ = new address[](1);
                spendAssets_[0] = takerAsset;

                spendAssetAmounts_ = new uint256[](1);
                spendAssetAmounts_[0] = takerAssetFillAmount;

                minIncomingAssetAmounts_[0] = minIncomingAssetAmounts_[0].sub(takerFeeFillAmount);
            } else if (takerFeeAsset == takerAsset) {
                spendAssets_ = new address[](1);
                spendAssets_[0] = takerAsset;

                spendAssetAmounts_ = new uint256[](1);
                spendAssetAmounts_[0] = takerAssetFillAmount.add(takerFeeFillAmount);
            } else {
                spendAssets_ = new address[](2);
                spendAssets_[0] = takerAsset;
                spendAssets_[1] = takerFeeAsset;

                spendAssetAmounts_ = new uint256[](2);
                spendAssetAmounts_[0] = takerAssetFillAmount;
                spendAssetAmounts_[1] = takerFeeFillAmount;
            }
        } else {
            spendAssets_ = new address[](1);
            spendAssets_[0] = takerAsset;

            spendAssetAmounts_ = new uint256[](1);
            spendAssetAmounts_[0] = takerAssetFillAmount;
        }

        return (
            IIntegrationManager.SpendAssetsHandleType.Transfer,
            spendAssets_,
            spendAssetAmounts_,
            incomingAssets_,
            minIncomingAssetAmounts_
        );
    }

    // PRIVATE FUNCTIONS

    /// @dev Decode the parameters of a takeOrder call
    /// @param _actionData Encoded parameters passed from client side
    /// @return encodedZeroExOrderArgs_ Encoded args of the 0x order
    /// @return takerAssetFillAmount_ Amount of taker asset to fill
    function __decodeTakeOrderCallArgs(bytes memory _actionData)
        private
        pure
        returns (bytes memory encodedZeroExOrderArgs_, uint256 takerAssetFillAmount_)
    {
        return abi.decode(_actionData, (bytes, uint256));
    }

    /////////////////////////////
    // ALLOWED MAKERS REGISTRY //
    /////////////////////////////

    /// @notice Adds accounts to the list of allowed 0x order makers
    /// @param _accountsToAdd Accounts to add
    function addAllowedMakers(address[] calldata _accountsToAdd) external onlyFundDeployerOwner {
        __addAllowedMakers(_accountsToAdd);
    }

    /// @notice Removes accounts from the list of allowed 0x order makers
    /// @param _accountsToRemove Accounts to remove
    function removeAllowedMakers(address[] calldata _accountsToRemove)
        external
        onlyFundDeployerOwner
    {
        require(_accountsToRemove.length > 0, "removeAllowedMakers: Empty _accountsToRemove");

        for (uint256 i; i < _accountsToRemove.length; i++) {
            require(
                isAllowedMaker(_accountsToRemove[i]),
                "removeAllowedMakers: Account is not an allowed maker"
            );

            makerToIsAllowed[_accountsToRemove[i]] = false;

            emit AllowedMakerRemoved(_accountsToRemove[i]);
        }
    }

    /// @dev Helper to add accounts to the list of allowed makers
    function __addAllowedMakers(address[] memory _accountsToAdd) private {
        require(_accountsToAdd.length > 0, "__addAllowedMakers: Empty _accountsToAdd");

        for (uint256 i; i < _accountsToAdd.length; i++) {
            require(!isAllowedMaker(_accountsToAdd[i]), "__addAllowedMakers: Value already set");

            makerToIsAllowed[_accountsToAdd[i]] = true;

            emit AllowedMakerAdded(_accountsToAdd[i]);
        }
    }

    /// @dev Parses user inputs into a ZeroExV2.Order format
    function __constructOrderStruct(bytes memory _encodedOrderArgs)
        private
        pure
        returns (IZeroExV2.Order memory order_)
    {
        (
            address[4] memory orderAddresses,
            uint256[6] memory orderValues,
            bytes[2] memory orderData,

        ) = __decodeZeroExOrderArgs(_encodedOrderArgs);

        return
            IZeroExV2.Order({
                makerAddress: orderAddresses[0],
                takerAddress: orderAddresses[1],
                feeRecipientAddress: orderAddresses[2],
                senderAddress: orderAddresses[3],
                makerAssetAmount: orderValues[0],
                takerAssetAmount: orderValues[1],
                makerFee: orderValues[2],
                takerFee: orderValues[3],
                expirationTimeSeconds: orderValues[4],
                salt: orderValues[5],
                makerAssetData: orderData[0],
                takerAssetData: orderData[1]
            });
    }

    /// @dev Decode the parameters of a 0x order
    /// @param _encodedZeroExOrderArgs Encoded parameters of the 0x order
    /// @return orderAddresses_ Addresses used in the order
    /// - [0] 0x Order param: makerAddress
    /// - [1] 0x Order param: takerAddress
    /// - [2] 0x Order param: feeRecipientAddress
    /// - [3] 0x Order param: senderAddress
    /// @return orderValues_ Values used in the order
    /// - [0] 0x Order param: makerAssetAmount
    /// - [1] 0x Order param: takerAssetAmount
    /// - [2] 0x Order param: makerFee
    /// - [3] 0x Order param: takerFee
    /// - [4] 0x Order param: expirationTimeSeconds
    /// - [5] 0x Order param: salt
    /// @return orderData_ Bytes data used in the order
    /// - [0] 0x Order param: makerAssetData
    /// - [1] 0x Order param: takerAssetData
    /// @return signature_ Signature of the order
    function __decodeZeroExOrderArgs(bytes memory _encodedZeroExOrderArgs)
        private
        pure
        returns (
            address[4] memory orderAddresses_,
            uint256[6] memory orderValues_,
            bytes[2] memory orderData_,
            bytes memory signature_
        )
    {
        return abi.decode(_encodedZeroExOrderArgs, (address[4], uint256[6], bytes[2], bytes));
    }

    ///////////////////
    // STATE GETTERS //
    ///////////////////

    /// @notice Checks whether an account is an allowed maker of 0x orders
    /// @param _who The account to check
    /// @return isAllowedMaker_ True if _who is an allowed maker
    function isAllowedMaker(address _who) public view returns (bool isAllowedMaker_) {
        return makerToIsAllowed[_who];
    }
}
