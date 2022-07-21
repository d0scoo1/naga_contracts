// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/IAccessControl.sol";

import "./libraries/BP.sol";
import "./libraries/IndexLibrary.sol";

import "./interfaces/IvToken.sol";
import "./interfaces/IOrderer.sol";
import "./interfaces/IIndexLogic.sol";
import "./interfaces/IvTokenFactory.sol";
import "./interfaces/IPhuturePriceOracle.sol";

import "./PhutureIndex.sol";

/// @title Index logic
/// @notice Contains common logic for index minting and burning
contract IndexLogic is PhutureIndex, IIndexLogic {
    using FullMath for uint;
    using EnumerableSet for EnumerableSet.AddressSet;

    /// @notice Asset role
    bytes32 internal immutable ASSET_ROLE;
    /// @notice Role granted for asset which should be skipped during burning
    bytes32 internal immutable SKIPPED_ASSET_ROLE;

    constructor() {
        ASSET_ROLE = keccak256("ASSET_ROLE");
        SKIPPED_ASSET_ROLE = keccak256("SKIPPED_ASSET_ROLE");
    }

    /// @notice Mints index to `_recipient` address
    /// @param _recipient Recipient address
    function mint(address _recipient) external override {
        address feePool = IIndexRegistry(registry).feePool();
        _chargeAUMFee(feePool);

        IPhuturePriceOracle oracle = IPhuturePriceOracle(IIndexRegistry(registry).priceOracle());

        uint lastAssetBalanceInBase;
        uint minAmountInBase = type(uint).max;

        uint assetsCount = assets.length();
        for (uint i; i < assetsCount; ) {
            address asset = assets.at(i);
            require(IAccessControl(registry).hasRole(ASSET_ROLE, asset), "Index: INVALID_ASSET");

            uint8 weight = weightOf[asset];
            if (weight != 0) {
                uint assetPerBaseInUQ = oracle.refreshedAssetPerBaseInUQ(asset);
                // Q_b * w_i * p_i = Q_i
                // Q_b = Q_i / (w_i * p_i)
                IvToken vToken = IvToken(IvTokenFactory(vTokenFactory).createdVTokenOf(asset));
                uint amountInAsset = IERC20(asset).balanceOf(address(vToken)) - vToken.lastAssetBalance();
                uint _minAmountInBase = amountInAsset.mulDiv(
                    FixedPoint112.Q112 * IndexLibrary.MAX_WEIGHT,
                    assetPerBaseInUQ * weight
                );
                if (_minAmountInBase < minAmountInBase) {
                    minAmountInBase = _minAmountInBase;
                }

                uint lastBalanceInAsset = vToken.lastAssetBalanceOf(address(this));
                vToken.mint();

                lastAssetBalanceInBase += lastBalanceInAsset.mulDiv(FixedPoint112.Q112, assetPerBaseInUQ);
            }

            unchecked {
                i = i + 1;
            }
        }

        uint inactiveAssetsCount = inactiveAssets.length();
        for (uint i; i < inactiveAssetsCount; ) {
            address inactiveAsset = inactiveAssets.at(i);
            if (!IAccessControl(registry).hasRole(SKIPPED_ASSET_ROLE, inactiveAsset)) {
                lastAssetBalanceInBase += IvToken(IvTokenFactory(vTokenFactory).createdVTokenOf(inactiveAsset))
                    .lastAssetBalanceOf(address(this))
                    .mulDiv(FixedPoint112.Q112, oracle.refreshedAssetPerBaseInUQ(inactiveAsset));
            }

            unchecked {
                i = i + 1;
            }
        }

        assert(minAmountInBase != type(uint).max);

        uint value;

        uint totalSupply = totalSupply();
        if (totalSupply != 0) {
            require(lastAssetBalanceInBase != 0, "Index: INSUFFICIENT_AMOUNT");

            value =
                (oracle.convertToIndex(minAmountInBase, decimals()) * totalSupply) /
                oracle.convertToIndex(lastAssetBalanceInBase, decimals());
        } else {
            value = oracle.convertToIndex(minAmountInBase, decimals()) - IndexLibrary.INITIAL_QUANTITY;
            _mint(address(0xdead), IndexLibrary.INITIAL_QUANTITY);
        }

        uint fee = (value * IFeePool(feePool).mintingFeeInBPOf(address(this))) / BP.DECIMAL_FACTOR;
        if (fee != 0) {
            _mint(feePool, fee);
            value -= fee;
        }

        _mint(_recipient, value);
    }

    /// @notice Burns index and transfers assets to `_recipient` address
    /// @param _recipient Recipient address
    function burn(address _recipient) external override {
        uint value = balanceOf(address(this));
        require(value != 0, "Index: INSUFFICIENT_AMOUNT");

        bool containsBlacklistedAssets;

        uint assetsCount = assets.length();
        for (uint i; i < assetsCount; ) {
            if (!IAccessControl(registry).hasRole(ASSET_ROLE, assets.at(i))) {
                containsBlacklistedAssets = true;
                break;
            }

            unchecked {
                i = i + 1;
            }
        }

        if (!containsBlacklistedAssets) {
            address feePool = IIndexRegistry(registry).feePool();

            uint fee = (value * IFeePool(feePool).burningFeeInBPOf(address(this))) / BP.DECIMAL_FACTOR;

            if (fee != 0) {
                // AUM charged in _transfer method
                _transfer(address(this), feePool, fee);
                value -= fee;
            } else {
                _chargeAUMFee(feePool);
            }
        }

        IOrderer orderer = IOrderer(IIndexRegistry(registry).orderer());
        uint lastOrderId = orderer.lastOrderIdOf(address(this));

        uint totalCount = inactiveAssets.length() + assetsCount;
        for (uint i; i < totalCount; ++i) {
            address asset = i < assetsCount ? assets.at(i) : inactiveAssets.at(i - assetsCount);

            if (containsBlacklistedAssets && IAccessControl(registry).hasRole(SKIPPED_ASSET_ROLE, asset)) {
                continue;
            }

            IvToken vToken = IvToken(IvTokenFactory(vTokenFactory).vTokenOf(asset));
            uint indexBalance = vToken.balanceOf(address(this));

            uint totalSupply = totalSupply();

            uint accountBalance = (value * indexBalance) / totalSupply;
            if (accountBalance != 0) {
                // calculate index value in vault to be burned
                vToken.transfer(address(vToken), accountBalance);
                vToken.burn(_recipient);
                if (lastOrderId != 0) {
                    // checks that asset is active
                    if (i < assetsCount) {
                        orderer.reduceOrderAsset(asset, totalSupply - value, totalSupply);
                    } else {
                        orderer.updateOrderDetails(asset, indexBalance - accountBalance);
                    }
                }
            }
        }

        _burn(address(this), value);
    }
}
