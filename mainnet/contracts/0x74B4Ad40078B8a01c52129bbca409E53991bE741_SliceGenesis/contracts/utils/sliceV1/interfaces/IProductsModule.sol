// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "../structs/Function.sol";
import "../structs/ProductParams.sol";
import "../structs/PurchaseParams.sol";

interface IProductsModule {
    function addProduct(
        uint256 slicerId,
        ProductParams memory params,
        Function memory externalCall_
    ) external;

    function setProductInfo(
        uint256 slicerId,
        uint32 productId,
        uint8 newMaxUnits,
        bool isFree,
        bool isInfinite,
        uint32 newUnits,
        CurrencyPrice[] memory currencyPrices
    ) external;

    function removeProduct(uint256 slicerId, uint32 productId) external;

    function payProducts(address buyer, PurchaseParams[] calldata purchases) external payable;

    function releaseEthToSlicer(uint256 slicerId) external;

    // function _setCategoryAddress(uint256 categoryIndex, address newCategoryAddress) external;

    function ethBalance(uint256 slicerId) external view returns (uint256);

    function productPrice(
        uint256 slicerId,
        uint32 productId,
        address currency
    ) external view returns (uint256 ethPayment, uint256 currencyPayment);

    function validatePurchaseUnits(
        address account,
        uint256 slicerId,
        uint32 productId
    ) external view returns (uint256 purchases);

    function validatePurchase(uint256 slicerId, uint32 productId)
        external
        view
        returns (uint256 purchases, bytes memory purchaseData);

    // function categoryAddress(uint256 categoryIndex) external view returns (address);
}
