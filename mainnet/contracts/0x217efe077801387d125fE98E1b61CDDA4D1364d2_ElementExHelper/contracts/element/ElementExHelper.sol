// SPDX-License-Identifier: Apache-2.0
/*

  Copyright 2022 Element.Market

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "../zero-ex/src/features/libs/LibNFTOrder.sol";
import "../zero-ex/src/features/libs/LibSignature.sol";

interface IERC721OrdersFeature {
    function validateERC721SellOrderSignature(LibNFTOrder.NFTSellOrder calldata order, LibSignature.Signature calldata signature) external view;
    function validateERC721BuyOrderSignature(LibNFTOrder.NFTBuyOrder calldata order, LibSignature.Signature calldata signature) external view;
    function getERC721SellOrderHash(LibNFTOrder.NFTSellOrder calldata order) external view returns (bytes32);
    function getERC721BuyOrderHash(LibNFTOrder.NFTBuyOrder calldata order) external view returns (bytes32);
    function getERC721OrderStatusBitVector(address maker, uint248 nonceRange) external view returns (uint256);
    function getHashNonce(address maker) external view returns (uint256);
}

interface IERC1155OrdersFeature {
    function validateERC1155SellOrderSignature(LibNFTOrder.ERC1155SellOrder calldata order, LibSignature.Signature calldata signature) external view;
    function validateERC1155BuyOrderSignature(LibNFTOrder.ERC1155BuyOrder calldata order, LibSignature.Signature calldata signature) external view;
    function getERC1155SellOrderInfo(LibNFTOrder.ERC1155SellOrder calldata order) external view returns (LibNFTOrder.OrderInfo memory orderInfo);
    function getERC1155BuyOrderInfo(LibNFTOrder.ERC1155BuyOrder calldata order) external view returns (LibNFTOrder.OrderInfo memory orderInfo);
}

contract ElementExHelper {

    struct ERC20CheckInfo {
        uint256 balance;
        uint256 allowance;
        bool balanceCheck;
        bool allowanceCheck;
    }

    struct ERC721CheckInfo {
        bool ecr721TokenIdCheck;
        bool erc721OwnerCheck;
        bool erc721ApprovedCheck;
    }

    struct ERC721SellOrderCheckInfo {
        bool success;
        uint256 hashNonce;
        bytes32 orderHash;
        bool makerCheck;
        bool takerCheck;
        bool listingTimeCheck;
        bool expireTimeCheck;
        bool extraCheck;
        bool nonceCheck;
        bool feesCheck;
        bool erc20AddressCheck;
        bool erc721AddressCheck;
        bool erc721OwnerCheck;
        bool erc721ApprovedCheck;
        uint256 erc20TotalAmount;
    }

    struct ERC721BuyOrderCheckInfo {
        bool success;
        uint256 hashNonce;
        bytes32 orderHash;
        bool makerCheck;
        bool takerCheck;
        bool listingTimeCheck;
        bool expireTimeCheck;
        bool nonceCheck;
        bool feesCheck;
        bool propertiesCheck;
        bool erc20AddressCheck;
        bool erc721AddressCheck;
        uint256 erc20TotalAmount;
        uint256 erc20Balance;
        uint256 erc20Allowance;
        bool erc20BalanceCheck;
        bool erc20AllowanceCheck;
    }

    struct ERC1155SellOrderCheckInfo {
        bool success;
        uint256 hashNonce;
        bytes32 orderHash;
        uint256 erc1155RemainingAmount;
        uint256 erc1155Balance;
        LibNFTOrder.OrderStatus status;
        bool makerCheck;
        bool takerCheck;
        bool listingTimeCheck;
        bool expireTimeCheck;
        bool extraCheck;
        bool statusCheck;
        bool remainingAmountCheck;
        bool feesCheck;
        bool erc20AddressCheck;
        bool erc1155AddressCheck;
        bool erc1155BalanceCheck;
        bool erc1155ApprovedCheck;
        uint256 erc20TotalAmount;
    }

    struct ERC1155BuyOrderCheckInfo {
        bool success;
        uint256 hashNonce;
        bytes32 orderHash;
        uint256 erc1155RemainingAmount;
        LibNFTOrder.OrderStatus status;
        bool makerCheck;
        bool takerCheck;
        bool listingTimeCheck;
        bool expireTimeCheck;
        bool statusCheck;
        bool remainingAmountCheck;
        bool feesCheck;
        bool propertiesCheck;
        bool erc20AddressCheck;
        bool erc1155AddressCheck;
        uint256 erc20TotalAmount;
        uint256 erc20Balance;
        uint256 erc20Allowance;
        bool erc20BalanceCheck;
        bool erc20AllowanceCheck;
    }

    struct ERC1155SellOrderTakerCheckInfo {
        uint256 erc20Balance;
        uint256 erc20Allowance;
        uint256 erc20WillPayAmount;
        bool balanceCheck;
        bool allowanceCheck;
        bool buyAmountCheck;
    }

    struct ERC1155BuyOrderTakerCheckInfo {
        uint256 erc1155Balance;
        bool ecr1155TokenIdCheck;
        bool erc1155BalanceCheck;
        bool erc1155ApprovedCheck;
        bool sellAmountCheck;
    }

    using Address for address;

    address constant internal NATIVE_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public immutable ELEMENT_EX;
    address public immutable WETH;

    constructor(address elementEx, address weth) {
        ELEMENT_EX = elementEx;
        WETH = weth;
    }

    function checkERC721SellOrder(LibNFTOrder.NFTSellOrder calldata order, address taker)
        public
        view
        returns (ERC721SellOrderCheckInfo memory info, ERC20CheckInfo memory takerCheckInfo)
    {
        info.hashNonce = getHashNonce(order.maker);
        info.orderHash = getERC721SellOrderHash(order);
        info.makerCheck = checkMaker(order.maker);
        info.takerCheck = checkTaker(order.taker, taker);
        info.listingTimeCheck = checkListingTime(order.expiry);
        info.expireTimeCheck = checkExpiryTime(order.expiry);
        info.extraCheck = checkExtra(order.expiry);
        info.nonceCheck = !isERC721OrderNonceFilled(order.maker, order.nonce);
        info.feesCheck = checkFees(order.fees);
        info.erc20TotalAmount = calcERC20TotalAmount(order.erc20TokenAmount, order.fees);
        info.erc721OwnerCheck = checkERC721Owner(order.nft, order.nftId, order.maker);
        info.erc721ApprovedCheck = checkERC721Approved(order.nft, order.maker);
        info.erc20AddressCheck = checkERC20Address(true, address(order.erc20Token));
        info.erc721AddressCheck = checkERC721Address(order.nft);
        info.success = _isERC721SellOrderSuccess(info);

        if (taker != address(0)) {
            (takerCheckInfo.balanceCheck, takerCheckInfo.balance) =
                checkERC20Balance(true, taker, address(order.erc20Token), info.erc20TotalAmount);
            (takerCheckInfo.allowanceCheck, takerCheckInfo.allowance) =
                checkERC20Allowance(true, taker, address(order.erc20Token), info.erc20TotalAmount);
        }
        return (info, takerCheckInfo);
    }

    function checkERC721SellOrderEx(
        LibNFTOrder.NFTSellOrder calldata order,
        address taker,
        LibSignature.Signature calldata signature
    )
        public
        view
        returns (ERC721SellOrderCheckInfo memory info, ERC20CheckInfo memory takerCheckInfo, bool validSignature)
    {
        (info, takerCheckInfo) = checkERC721SellOrder(order, taker);
        validSignature = validateERC721SellOrderSignature(order, signature);
        return (info, takerCheckInfo, validSignature);
    }

    function checkERC721BuyOrder(LibNFTOrder.NFTBuyOrder calldata order, address taker, uint256 erc721TokenId)
        public
        view
        returns (ERC721BuyOrderCheckInfo memory info, ERC721CheckInfo memory takerCheckInfo)
    {
        info.hashNonce = getHashNonce(order.maker);
        info.orderHash = getERC721BuyOrderHash(order);
        info.makerCheck = checkMaker(order.maker);
        info.takerCheck = checkTaker(order.taker, taker);
        info.listingTimeCheck = checkListingTime(order.expiry);
        info.expireTimeCheck = checkExpiryTime(order.expiry);
        info.nonceCheck = !isERC721OrderNonceFilled(order.maker, order.nonce);
        info.feesCheck = checkFees(order.fees);
        info.propertiesCheck = checkProperties(order.nftProperties, order.nftId);
        info.erc20AddressCheck = checkERC20Address(false, address(order.erc20Token));
        info.erc721AddressCheck = checkERC721Address(order.nft);

        info.erc20TotalAmount = calcERC20TotalAmount(order.erc20TokenAmount, order.fees);
        (info.erc20BalanceCheck, info.erc20Balance) =
            checkERC20Balance(false, order.maker, address(order.erc20Token), info.erc20TotalAmount);
        (info.erc20AllowanceCheck, info.erc20Allowance) =
            checkERC20Allowance(false, order.maker, address(order.erc20Token), info.erc20TotalAmount);
        info.success = _isERC721BuyOrderSuccess(info);

        if (taker != address(0)) {
            takerCheckInfo.ecr721TokenIdCheck = checkNftIdIsMatched(order.nftProperties, order.nft, order.nftId, erc721TokenId);
            takerCheckInfo.erc721OwnerCheck = checkERC721Owner(order.nft, erc721TokenId, taker);
            takerCheckInfo.erc721ApprovedCheck = checkERC721Approved(order.nft, taker);
        }
        return (info, takerCheckInfo);
    }

    function checkERC721BuyOrderEx(
        LibNFTOrder.NFTBuyOrder calldata order,
        address taker,
        uint256 erc721TokenId,
        LibSignature.Signature calldata signature
    )
        public
        view
        returns (ERC721BuyOrderCheckInfo memory info, ERC721CheckInfo memory takerCheckInfo, bool validSignature)
    {
        (info, takerCheckInfo) = checkERC721BuyOrder(order, taker, erc721TokenId);
        validSignature = validateERC721BuyOrderSignature(order, signature);
        return (info, takerCheckInfo, validSignature);
    }

    function checkERC1155SellOrder(LibNFTOrder.ERC1155SellOrder calldata order, address taker, uint128 erc1155BuyAmount)
        public
        view
        returns (ERC1155SellOrderCheckInfo memory info, ERC1155SellOrderTakerCheckInfo memory takerCheckInfo)
    {
        LibNFTOrder.OrderInfo memory orderInfo = getERC1155SellOrderInfo(order);
        (uint256 balance, bool isApprovedForAll) = getERC1155Info(order.erc1155Token, order.erc1155TokenId, order.maker, ELEMENT_EX);

        info.hashNonce = getHashNonce(order.maker);
        info.orderHash = orderInfo.orderHash;
        info.erc1155RemainingAmount = orderInfo.remainingAmount;
        info.erc1155Balance = balance;
        info.status = orderInfo.status;
        info.makerCheck = checkMaker(order.maker);
        info.takerCheck = checkTaker(order.taker, taker);
        info.listingTimeCheck = checkListingTime(order.expiry);
        info.expireTimeCheck = checkExpiryTime(order.expiry);
        info.extraCheck = checkExtra(order.expiry);
        info.statusCheck = (orderInfo.status == LibNFTOrder.OrderStatus.FILLABLE);
        info.remainingAmountCheck = (info.erc1155RemainingAmount > 0);
        info.feesCheck = checkFees(order.fees);
        info.erc20TotalAmount = calcERC20TotalAmount(order.erc20TokenAmount, order.fees);
        info.erc1155BalanceCheck = (balance >= order.erc1155TokenAmount);
        info.erc1155ApprovedCheck = isApprovedForAll;
        info.erc20AddressCheck = checkERC20Address(true, address(order.erc20Token));
        info.erc1155AddressCheck = checkERC1155Address(order.erc1155Token);
        info.success = _isERC1155SellOrderSuccess(info);

        if (taker != address(0)) {
            if (order.erc1155TokenAmount > 0) {
                takerCheckInfo.erc20WillPayAmount = _ceilDiv(order.erc20TokenAmount * erc1155BuyAmount, order.erc1155TokenAmount);
                for (uint256 i = 0; i < order.fees.length; i++) {
                    takerCheckInfo.erc20WillPayAmount += order.fees[i].amount * erc1155BuyAmount / order.erc1155TokenAmount;
                }
            } else {
                takerCheckInfo.erc20WillPayAmount = type(uint128).max;
            }
            (takerCheckInfo.balanceCheck, takerCheckInfo.erc20Balance) = checkERC20Balance(true, taker, address(order.erc20Token), takerCheckInfo.erc20WillPayAmount);
            (takerCheckInfo.allowanceCheck, takerCheckInfo.erc20Allowance) = checkERC20Allowance(true, taker, address(order.erc20Token), takerCheckInfo.erc20WillPayAmount);
            takerCheckInfo.buyAmountCheck = (erc1155BuyAmount <= info.erc1155RemainingAmount);
        }
        return (info, takerCheckInfo);
    }

    function checkERC1155SellOrderEx(
        LibNFTOrder.ERC1155SellOrder calldata order,
        address taker,
        uint128 erc1155BuyAmount,
        LibSignature.Signature calldata signature
    )
        public
        view
        returns (ERC1155SellOrderCheckInfo memory info, ERC1155SellOrderTakerCheckInfo memory takerCheckInfo, bool validSignature)
    {
        (info, takerCheckInfo) = checkERC1155SellOrder(order, taker, erc1155BuyAmount);
        validSignature = validateERC1155SellOrderSignature(order, signature);
        return (info, takerCheckInfo, validSignature);
    }

    function checkERC1155BuyOrder(
        LibNFTOrder.ERC1155BuyOrder calldata order,
        address taker,
        uint256 erc1155TokenId,
        uint128 erc1155SellAmount
    )
        public
        view
        returns (ERC1155BuyOrderCheckInfo memory info, ERC1155BuyOrderTakerCheckInfo memory takerCheckInfo)
    {
        LibNFTOrder.OrderInfo memory orderInfo = getERC1155BuyOrderInfo(order);
        info.hashNonce = getHashNonce(order.maker);
        info.orderHash = orderInfo.orderHash;
        info.erc1155RemainingAmount = orderInfo.remainingAmount;
        info.status = orderInfo.status;
        info.makerCheck = checkMaker(order.maker);
        info.takerCheck = checkTaker(order.taker, taker);
        info.listingTimeCheck = checkListingTime(order.expiry);
        info.expireTimeCheck = checkExpiryTime(order.expiry);
        info.statusCheck = (orderInfo.status == LibNFTOrder.OrderStatus.FILLABLE);
        info.remainingAmountCheck = (info.erc1155RemainingAmount > 0);
        info.feesCheck = checkFees(order.fees);
        info.propertiesCheck = checkProperties(order.erc1155TokenProperties, order.erc1155TokenId);
        info.erc20AddressCheck = checkERC20Address(false, address(order.erc20Token));
        info.erc1155AddressCheck = checkERC1155Address(order.erc1155Token);
        info.erc20TotalAmount = calcERC20TotalAmount(order.erc20TokenAmount, order.fees);
        (info.erc20BalanceCheck, info.erc20Balance) = checkERC20Balance(false, order.maker, address(order.erc20Token), info.erc20TotalAmount);
        (info.erc20AllowanceCheck, info.erc20Allowance) = checkERC20Allowance(false, order.maker, address(order.erc20Token), info.erc20TotalAmount);
        info.success = _isERC1155BuyOrderSuccess(info);

        if (taker != address(0)) {
            takerCheckInfo.ecr1155TokenIdCheck = checkNftIdIsMatched(order.erc1155TokenProperties, order.erc1155Token, order.erc1155TokenId, erc1155TokenId);
            (takerCheckInfo.erc1155Balance, takerCheckInfo.erc1155ApprovedCheck) = getERC1155Info(order.erc1155Token, erc1155TokenId, taker, ELEMENT_EX);
            takerCheckInfo.erc1155BalanceCheck = (erc1155SellAmount <= takerCheckInfo.erc1155Balance);
            takerCheckInfo.sellAmountCheck = (erc1155SellAmount <= info.erc1155RemainingAmount);
        }
        return (info, takerCheckInfo);
    }

    function checkERC1155BuyOrderEx(
        LibNFTOrder.ERC1155BuyOrder calldata order,
        address taker,
        uint256 erc1155TokenId,
        uint128 erc1155SellAmount,
        LibSignature.Signature calldata signature
    )
        public
        view
        returns (ERC1155BuyOrderCheckInfo memory info, ERC1155BuyOrderTakerCheckInfo memory takerCheckInfo, bool validSignature)
    {
        (info, takerCheckInfo) = checkERC1155BuyOrder(order, taker, erc1155TokenId, erc1155SellAmount);
        validSignature = validateERC1155BuyOrderSignature(order, signature);
        return (info, takerCheckInfo, validSignature);
    }

    function getERC20Info(address erc20, address account, address allowanceAddress)
        public
        view
        returns (uint256 balance, uint256 allowance)
    {
        if (erc20 == address(0) || erc20 == NATIVE_TOKEN_ADDRESS) {
            balance = address(account).balance;
        } else {
            try IERC20(erc20).balanceOf(account) returns (uint256 _balance) {
                balance = _balance;
            } catch {}
            try IERC20(erc20).allowance(account, allowanceAddress) returns (uint256 _allowance) {
                allowance = _allowance;
            } catch {}
        }
        return (balance, allowance);
    }

    function getERC721Info(address erc721, uint256 tokenId, address account, address approvedAddress)
        public
        view
        returns (address owner, bool isApprovedForAll)
    {
        try IERC721(erc721).ownerOf(tokenId) returns (address _owner) {
            owner = _owner;
        } catch {}
        try IERC721(erc721).isApprovedForAll(account, approvedAddress) returns (bool _isApprovedForAll) {
            isApprovedForAll = _isApprovedForAll;
        } catch {}
        return (owner, isApprovedForAll);
    }

    function getERC1155Info(address erc1155, uint256 tokenId, address account, address approvedAddress)
        public
        view
        returns (uint256 balance, bool isApprovedForAll)
    {
        try IERC1155(erc1155).balanceOf(account, tokenId) returns (uint256 _balance) {
            balance = _balance;
        } catch {}
        try IERC1155(erc1155).isApprovedForAll(account, approvedAddress) returns (bool _isApprovedForAll) {
            isApprovedForAll = _isApprovedForAll;
        } catch {}
        return (balance, isApprovedForAll);
    }

    function validateERC721SellOrderSignature(LibNFTOrder.NFTSellOrder calldata order, LibSignature.Signature calldata signature)
        public
        view
        returns (bool valid)
    {
        try IERC721OrdersFeature(ELEMENT_EX).validateERC721SellOrderSignature(order, signature) {
            return true;
        } catch {}
        return false;
    }

    function validateERC721BuyOrderSignature(LibNFTOrder.NFTBuyOrder calldata order, LibSignature.Signature calldata signature)
        public
        view
        returns (bool valid)
    {
        try IERC721OrdersFeature(ELEMENT_EX).validateERC721BuyOrderSignature(order, signature) {
            return true;
        } catch {}
        return false;
    }

    function getERC721SellOrderHash(LibNFTOrder.NFTSellOrder calldata order) public view returns (bytes32) {
        try IERC721OrdersFeature(ELEMENT_EX).getERC721SellOrderHash(order) returns (bytes32 orderHash) {
            return orderHash;
        } catch {}
        return bytes32("");
    }

    function getERC721BuyOrderHash(LibNFTOrder.NFTBuyOrder calldata order) public view returns (bytes32) {
        try IERC721OrdersFeature(ELEMENT_EX).getERC721BuyOrderHash(order) returns (bytes32 orderHash) {
            return orderHash;
        } catch {}
        return bytes32("");
    }

    function isERC721OrderNonceFilled(address account, uint256 nonce) public view returns (bool filled) {
        uint256 bitVector = IERC721OrdersFeature(ELEMENT_EX).getERC721OrderStatusBitVector(account, uint248(nonce >> 8));
        uint256 flag = 1 << (nonce & 0xff);
        return (bitVector & flag) != 0;
    }

    function getHashNonce(address maker) public view returns (uint256) {
        return IERC721OrdersFeature(ELEMENT_EX).getHashNonce(maker);
    }

    function getERC1155SellOrderInfo(LibNFTOrder.ERC1155SellOrder calldata order)
        public
        view
        returns (LibNFTOrder.OrderInfo memory orderInfo)
    {
        try IERC1155OrdersFeature(ELEMENT_EX).getERC1155SellOrderInfo(order) returns (LibNFTOrder.OrderInfo memory _orderInfo) {
            orderInfo = _orderInfo;
        } catch {}
        return orderInfo;
    }

    function getERC1155BuyOrderInfo(LibNFTOrder.ERC1155BuyOrder calldata order)
        public
        view
        returns (LibNFTOrder.OrderInfo memory orderInfo)
    {
        try IERC1155OrdersFeature(ELEMENT_EX).getERC1155BuyOrderInfo(order) returns (LibNFTOrder.OrderInfo memory _orderInfo) {
            orderInfo = _orderInfo;
        } catch {}
        return orderInfo;
    }

    function validateERC1155SellOrderSignature(LibNFTOrder.ERC1155SellOrder calldata order, LibSignature.Signature calldata signature)
        public
        view
        returns (bool valid)
    {
        try IERC1155OrdersFeature(ELEMENT_EX).validateERC1155SellOrderSignature(order, signature) {
            return true;
        } catch {}
        return false;
    }

    function validateERC1155BuyOrderSignature(LibNFTOrder.ERC1155BuyOrder calldata order, LibSignature.Signature calldata signature)
        public
        view
        returns (bool valid)
    {
        try IERC1155OrdersFeature(ELEMENT_EX).validateERC1155BuyOrderSignature(order, signature) {
            return true;
        } catch {}
        return false;
    }

    function _isERC721SellOrderSuccess(ERC721SellOrderCheckInfo memory info) private pure returns (bool successAll) {
        return info.makerCheck &&
            info.takerCheck &&
            info.listingTimeCheck &&
            info.expireTimeCheck &&
            info.extraCheck &&
            info.nonceCheck &&
            info.feesCheck &&
            info.erc721OwnerCheck &&
            info.erc721ApprovedCheck &&
            info.erc20AddressCheck &&
            info.erc721AddressCheck;
    }

    function _isERC721BuyOrderSuccess(ERC721BuyOrderCheckInfo memory info) private pure returns (bool successAll) {
        return info.makerCheck &&
            info.takerCheck &&
            info.listingTimeCheck &&
            info.expireTimeCheck &&
            info.nonceCheck &&
            info.feesCheck &&
            info.propertiesCheck &&
            info.erc20BalanceCheck &&
            info.erc20AllowanceCheck &&
            info.erc20AddressCheck &&
            info.erc721AddressCheck;
    }

    function _isERC1155SellOrderSuccess(ERC1155SellOrderCheckInfo memory info) private pure returns (bool successAll) {
        return info.makerCheck &&
            info.takerCheck &&
            info.listingTimeCheck &&
            info.expireTimeCheck &&
            info.extraCheck &&
            info.statusCheck &&
            info.remainingAmountCheck &&
            info.feesCheck &&
            info.erc20AddressCheck &&
            info.erc1155AddressCheck &&
            info.erc1155BalanceCheck &&
            info.erc1155ApprovedCheck;
    }

    function _isERC1155BuyOrderSuccess(ERC1155BuyOrderCheckInfo memory info) private pure returns (bool successAll) {
        return info.makerCheck &&
            info.takerCheck &&
            info.listingTimeCheck &&
            info.expireTimeCheck &&
            info.statusCheck &&
            info.remainingAmountCheck &&
            info.feesCheck &&
            info.propertiesCheck &&
            info.erc20AddressCheck &&
            info.erc1155AddressCheck &&
            info.erc20BalanceCheck &&
            info.erc20AllowanceCheck;
    }

    function checkMaker(address maker) internal pure returns (bool success) {
        return (maker != address(0));
    }

    function checkTaker(address orderTaker, address taker) internal view returns (bool success) {
        if (taker == ELEMENT_EX) {
            return false;
        }
        return (orderTaker == address(0) || orderTaker == taker || taker == address(0));
    }

    function checkListingTime(uint256 expiry) internal pure returns (bool success) {
        uint256 listingTime = (expiry >> 32) & 0xffffffff;
        uint256 expiryTime = expiry & 0xffffffff;
        return listingTime < expiryTime;
    }

    function checkExpiryTime(uint256 expiry) internal view returns (bool success) {
        uint256 expiryTime = expiry & 0xffffffff;
        return expiryTime > block.timestamp;
    }

    function checkExtra(uint256 expiry) internal pure returns (bool success) {
        if (expiry >> 252 == 1) {
            uint256 extra = (expiry >> 64) & 0xffffffff;
            return (extra <= 100000000);
        }
        return true;
    }

    function checkERC721Owner(address nft, uint256 nftId, address owner) internal view returns (bool success) {
        try IERC721(nft).ownerOf(nftId) returns (address _owner) {
            success = (owner == _owner);
        } catch {
            success = false;
        }
        return success;
    }

    function checkERC721Approved(address nft, address owner) internal view returns (bool) {
        try IERC721(nft).isApprovedForAll(owner, ELEMENT_EX) returns (bool approved) {
            return approved;
        } catch {
        }
        return false;
    }

    function checkERC20Balance(bool buyNft, address buyer, address erc20, uint256 erc20TotalAmount)
        internal
        view
        returns
        (bool success, uint256 balance)
    {
        if (erc20 == address(0)) {
            return (false, 0);
        }
        if (erc20 == NATIVE_TOKEN_ADDRESS) {
            if (buyNft) {
                balance = buyer.balance;
                success = (balance >= erc20TotalAmount);
                return (success, balance);
            } else {
                return (false, 0);
            }
        }

        try IERC20(erc20).balanceOf(buyer) returns (uint256 _balance) {
            balance = _balance;
            success = (balance >= erc20TotalAmount);
        } catch {
            success = false;
            balance = 0;
        }
        return (success, balance);
    }

    function checkERC20Allowance(bool buyNft, address buyer, address erc20, uint256 erc20TotalAmount)
        internal
        view
        returns
        (bool success, uint256 allowance)
    {
        if (erc20 == address(0)) {
            return (false, 0);
        }
        if (erc20 == NATIVE_TOKEN_ADDRESS) {
            return (buyNft, 0);
        }

        try IERC20(erc20).allowance(buyer, ELEMENT_EX) returns (uint256 _allowance) {
            allowance = _allowance;
            success = (allowance >= erc20TotalAmount);
        } catch {
            success = false;
            allowance = 0;
        }
        return (success, allowance);
    }

    function checkERC20Address(bool sellOrder, address erc20) internal view returns (bool) {
        if (erc20 == address(0)) {
            return false;
        }
        if (erc20 == NATIVE_TOKEN_ADDRESS) {
            return sellOrder;
        }
        return erc20.isContract();
    }

    function checkERC721Address(address erc721) internal view returns (bool) {
        if (erc721 == address(0) || erc721 == NATIVE_TOKEN_ADDRESS) {
            return false;
        }

        try IERC165(erc721).supportsInterface(type(IERC721).interfaceId) returns (bool support) {
            return support;
        } catch {}
        return false;
    }

    function checkERC1155Address(address erc1155) internal view returns (bool) {
        if (erc1155 == address(0) || erc1155 == NATIVE_TOKEN_ADDRESS) {
            return false;
        }

        try IERC165(erc1155).supportsInterface(type(IERC1155).interfaceId) returns (bool support) {
            return support;
        } catch {}
        return false;
    }

    function checkFees(LibNFTOrder.Fee[] calldata fees) internal view returns (bool success) {
        for (uint256 i = 0; i < fees.length; i++) {
            if (fees[i].recipient == ELEMENT_EX) {
                return false;
            }
            if (fees[i].feeData.length > 0 && !fees[i].recipient.isContract()) {
                return false;
            }
        }
        return true;
    }

    function checkProperties(LibNFTOrder.Property[] calldata properties, uint256 nftId) internal view returns (bool success) {
        if (properties.length > 0) {
            if (nftId != 0) {
                return false;
            }
            for (uint256 i = 0; i < properties.length; i++) {
                address propertyValidator = address(properties[i].propertyValidator);
                if (propertyValidator != address(0) && !propertyValidator.isContract()) {
                    return false;
                }
            }
        }
        return true;
    }

    function checkNftIdIsMatched(LibNFTOrder.Property[] calldata properties, address nft, uint256 orderNftId, uint256 nftId)
        internal
        view
        returns (bool isMatched)
    {
        if (properties.length == 0) {
            return orderNftId == nftId;
        }
        for (uint256 i = 0; i < properties.length; i++) {
            LibNFTOrder.Property memory property = properties[i];
            if (address(property.propertyValidator) != address(0)) {
                try property.propertyValidator.validateProperty(nft, nftId, property.propertyData) {
                } catch {
                    return false;
                }
            }
        }
        return true;
    }

    function calcERC20TotalAmount(uint256 erc20TokenAmount, LibNFTOrder.Fee[] calldata fees) internal pure returns (uint256) {
        uint256 sum = erc20TokenAmount;
        for (uint256 i = 0; i < fees.length; i++) {
            sum += fees[i].amount;
        }
        return sum;
    }

    function _ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // ceil(a / b) = floor((a + b - 1) / b)
        return (a + b - 1) / b;
    }
}
