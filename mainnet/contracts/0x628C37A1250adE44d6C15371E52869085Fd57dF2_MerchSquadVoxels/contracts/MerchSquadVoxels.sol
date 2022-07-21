// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC1155.sol";

import "./extensions/Purchasable/SlicerPurchasable.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MerchSquadVoxels is SlicerPurchasable, ERC1155Receiver, Ownable {
    error Invalid();

    /// ============ Storage ============

    IERC1155 private immutable _erc1155;
    // Mapping from Product ID to erc1155 tokenId
    mapping(uint256 => uint256) private _productTokens;

    /// ========== Constructor ===========

    constructor(
        address productsModuleAddress_,
        uint256 slicerId_,
        address erc1155Address_
    ) SlicerPurchasable(productsModuleAddress_, slicerId_) {
        _erc1155 = IERC1155(erc1155Address_);
        _erc1155.setApprovalForAll(productsModuleAddress_, true);
    }

    /// ============ Functions ============

    // /**
    //  * @notice Overridable function containing the requirements for an account to be eligible for the purchase.
    //  *
    //  * @dev Used on the Slice interface to check whether a user is able to buy a product. See {ISlicerPurchasable}.
    //  * @dev Max quantity purchasable per address and total mint amount is handled on Slicer product logic
    //  */
    // function isPurchaseAllowed(
    //     uint256,
    //     uint256,
    //     address,
    //     uint256,
    //     bytes memory,
    //     bytes memory
    // ) public view override returns (bool isAllowed) {
    //     // Add all requirements related to product purchase here
    //     // Return true if account is allowed to buy product
    //     return true;
    // }

    /**
     * @notice Overridable function to handle external calls on product purchases from slicers. See {ISlicerPurchasable}
     */
    function onProductPurchase(
        uint256 slicerId,
        uint256 productId,
        address account,
        uint256 quantity,
        bytes memory,
        bytes memory
    ) external payable override onlyOnPurchaseFrom(slicerId) {
        // Check whether the account is allowed to buy a product.
        // if (
        //     !isPurchaseAllowed(
        //         slicerId,
        //         productId,
        //         account,
        //         quantity,
        //         slicerCustomData,
        //         buyerCustomData
        //     )
        // ) revert NotAllowed();

        // Add product purchase logic here
        _erc1155.safeTransferFrom(address(this), account, _productTokens[productId], quantity, "");
    }

    /**
     * @notice Sets a `productId` to execute the transfer of a certain `tokenId`
     */
    function setTokenIdToProduct(uint256 productId, uint256 tokenId) external onlyOwner {
        _productTokens[productId] = tokenId;
    }

    /**
     * @notice Function called when ERC1155 tokens are received
     */
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        // If token transferred is token of `_erc1155` contract
        if (msg.sender != address(_erc1155)) revert Invalid();

        return this.onERC1155Received.selector;
    }

    /**
     * @dev See `onERC1155Received`
     */
    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        if (msg.sender != address(_erc1155)) revert Invalid();

        return this.onERC1155BatchReceived.selector;
    }
}
