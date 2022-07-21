// SPDX-License-Identifier: MIT OR Apache-2.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./Constants.sol";
import "./FoundationTreasuryNode.sol";
import "./SendValueWithFallbackWithdraw.sol";

/**
 * @title A mixin to distribute funds when an NFT is sold.
 */
abstract contract NFTMarketFees is Constants, Initializable, FoundationTreasuryNode, SendValueWithFallbackWithdraw {
  /**
   * @dev Removing old unused variables in an upgrade safe way. Was:
   * uint256 private _primaryFoundationFeeBasisPoints;
   * uint256 private _secondaryFoundationFeeBasisPoints;
   * uint256 private _secondaryCreatorFeeBasisPoints;
   * mapping(address => mapping(uint256 => bool)) private _nftContractToTokenIdToFirstSaleCompleted;
   */
  uint256[4] private __gap_was_fees;

  /// @notice The royalties sent to creator recipients on secondary sales.
  uint256 private constant CREATOR_ROYALTY_DENOMINATOR = BASIS_POINTS / 1000; // 10%
  /// @notice The fee collected by Foundation for sales facilitated by this market contract.
  uint256 private constant PROTOCOL_FEE_DENOMINATOR = BASIS_POINTS / 500; // 5%
  /// @notice The fee collected by the referrer for sales facilitated by this market contract.
  ///         This fee is deducted from the foundation fee (PROTOCOL_FEE_DENOMINATOR).
  uint256 private constant REFERRER_FEE_DENOMINATOR = BASIS_POINTS / 100; // 1% == 20% of FND Fee.

  /**
   * @notice Emitted when a NFT sold with a referrer.
   * @param nftContract The address of the NFT contract.
   * @param tokenId The id of the NFT.
   * @param buyReferrer The account which received the buy referral incentive.
   * @param buyReferrerProtocolFee The portion of the protocol fee collected by the buy referrer.
   * @param buyReferrerSellerFee The portion of the owner revenue collected by the buy referrer (not implemented).
   * @param sellReferrer The account which received the sell referral incentive (not implemented).
   * @param sellReferrerProtocolFee The portion of the protocol fee collected by the sell referrer (not implemented).
   */
  event ReferralPaid(
    address indexed nftContract,
    uint256 indexed tokenId,
    address buyReferrer,
    uint256 buyReferrerProtocolFee,
    uint256 buyReferrerSellerFee,
    address sellReferrer,
    uint256 sellReferrerProtocolFee
  );

  /**
   * @notice Distributes funds to foundation, creator recipients, and NFT owner after a sale.
   */
  // solhint-disable-next-line code-complexity
  function _distributeFunds(
    address nftContract,
    uint256 tokenId,
    address payable seller,
    uint256 price,
    address payable buyReferrer
  )
    internal
    returns (
      uint256 protocolFee,
      uint256 creatorFee,
      uint256 sellerRev
    )
  {
    address payable[] memory creatorRecipients;
    uint256[] memory creatorShares;

    address payable sellerRevTo;
    uint256 buyReferrerProtocolFee;
    (
      protocolFee,
      creatorRecipients,
      creatorShares,
      creatorFee,
      sellerRevTo,
      sellerRev,
      buyReferrerProtocolFee
    ) = _getFees(nftContract, tokenId, seller, price, buyReferrer);

    if (buyReferrerProtocolFee != 0) {
      // Use standard `send` to cap the gas and prevent consuming all available
      // gas to block a tx from completing successfully.
      // Fallsback to sending the referral fee to FND on failure.
      if (buyReferrer.send(buyReferrerProtocolFee)) {
        emit ReferralPaid(nftContract, tokenId, buyReferrer, buyReferrerProtocolFee, 0, address(0), 0);
      } else {
        // If we are unable to pay the referrer than the money is returned to the original protocolFee.
        unchecked {
          protocolFee += buyReferrerProtocolFee;
          buyReferrerProtocolFee = 0;
        }
      }
    }

    _sendValueWithFallbackWithdraw(getFoundationTreasury(), protocolFee, SEND_VALUE_GAS_LIMIT_SINGLE_RECIPIENT);

    // Keep the full fee total in protocolFee for backwards compat with events so that sum of params == sale amount.
    unchecked {
      protocolFee += buyReferrerProtocolFee;
    }

    if (creatorFee != 0) {
      if (creatorRecipients.length > 1) {
        uint256 maxCreatorIndex = creatorRecipients.length;
        unchecked {
          // maxCreatorIndex cannot underflow due to the if above
          --maxCreatorIndex;
        }

        if (maxCreatorIndex > MAX_ROYALTY_RECIPIENTS_INDEX) {
          maxCreatorIndex = MAX_ROYALTY_RECIPIENTS_INDEX;
        }

        // Determine the total shares defined so it can be leveraged to distribute below
        uint256 totalShares;
        unchecked {
          // The array length cannot overflow 256 bits.
          for (uint256 i = 0; i <= maxCreatorIndex; ++i) {
            if (creatorShares[i] > BASIS_POINTS) {
              // If the numbers are >100% we ignore the fee recipients and pay just the first instead
              maxCreatorIndex = 0;
              break;
            }
            // The check above ensures totalShares wont overflow.
            totalShares += creatorShares[i];
          }
        }
        if (totalShares == 0) {
          maxCreatorIndex = 0;
        }

        // Send payouts to each additional recipient if more than 1 was defined
        uint256 totalRoyaltiesDistributed;
        for (uint256 i = 1; i <= maxCreatorIndex; ) {
          uint256 royalty = (creatorFee * creatorShares[i]) / totalShares;
          totalRoyaltiesDistributed += royalty;
          _sendValueWithFallbackWithdraw(creatorRecipients[i], royalty, SEND_VALUE_GAS_LIMIT_MULTIPLE_RECIPIENTS);
          unchecked {
            ++i;
          }
        }

        // Send the remainder to the 1st creator, rounding in their favor
        _sendValueWithFallbackWithdraw(
          creatorRecipients[0],
          creatorFee - totalRoyaltiesDistributed,
          SEND_VALUE_GAS_LIMIT_MULTIPLE_RECIPIENTS
        );
      } else {
        _sendValueWithFallbackWithdraw(creatorRecipients[0], creatorFee, SEND_VALUE_GAS_LIMIT_MULTIPLE_RECIPIENTS);
      }
    }
    _sendValueWithFallbackWithdraw(sellerRevTo, sellerRev, SEND_VALUE_GAS_LIMIT_SINGLE_RECIPIENT);
  }

  /**
   * @notice Returns how funds will be distributed for a sale at the given price point.
   * @param nftContract The address of the NFT contract.
   * @param tokenId The id of the NFT.
   * @param price The sale price to calculate the fees for.
   * @return protocolFee How much will be sent to the Foundation treasury.
   * @return creatorRev How much will be sent across all the `creatorRecipients` defined.
   * @return creatorRecipients The addresses of the recipients to receive a portion of the creator fee.
   * @return creatorShares The percentage of the creator fee to be distributed to each `creatorRecipient`.
   * If there is only one `creatorRecipient`, this may be an empty array.
   * Otherwise `creatorShares.length` == `creatorRecipients.length`.
   * @return sellerRev How much will be sent to the owner/seller of the NFT.
   * If the NFT is being sold by the creator, this may be 0 and the full revenue will appear as `creatorRev`.
   * @return owner The address of the owner of the NFT.
   * If `sellerRev` is 0, this may be `address(0)`.
   */
  function getFeesAndRecipients(
    address nftContract,
    uint256 tokenId,
    uint256 price
  )
    external
    view
    returns (
      uint256 protocolFee,
      uint256 creatorRev,
      address payable[] memory creatorRecipients,
      uint256[] memory creatorShares,
      uint256 sellerRev,
      address payable owner
    )
  {
    address payable seller = _getSellerFor(nftContract, tokenId);
    // foundationProtocolFee == the full protocolFee since no referrers are defined here.
    (protocolFee, creatorRecipients, creatorShares, creatorRev, owner, sellerRev, ) = _getFees(
      nftContract,
      tokenId,
      seller,
      price,
      address(0)
    );
  }

  /**
   * @notice Calculates how funds should be distributed for the given sale details.
   * @dev When the NFT is being sold by the `tokenCreator`, all the seller revenue will
   * be split with the royalty recipients defined for that NFT.
   */
  function _getFees(
    address nftContract,
    uint256 tokenId,
    address payable seller,
    uint256 price,
    address buyReferrer
  )
    private
    view
    returns (
      uint256 foundationProtocolFee,
      address payable[] memory creatorRecipients,
      uint256[] memory creatorShares,
      uint256 creatorRev,
      address payable sellerRevTo,
      uint256 sellerRev,
      uint256 buyReferrerProtocolFee
    )
  {
    address creator;
    // lookup for tokenCreator
    try ITokenCreator(nftContract).tokenCreator{ gas: READ_ONLY_GAS_LIMIT }(tokenId) returns (
      address payable _creator
    ) {
      creator = _creator;
    } catch // solhint-disable-next-line no-empty-blocks
    {
      // Fall through
    }

    (creatorRecipients, creatorShares) = _getCreatorPaymentInfo(nftContract, tokenId);

    // Calculate the Foundation fee
    unchecked {
      // SafeMath is not required when dividing by a non-zero constant.
      foundationProtocolFee = price / PROTOCOL_FEE_DENOMINATOR;
    }

    if (creatorRecipients.length != 0) {
      if (seller == creator || (creatorRecipients.length == 1 && seller == creatorRecipients[0])) {
        // When sold by the creator, all revenue is split if applicable.
        unchecked {
          // protocolFee is always < price.
          creatorRev = price - foundationProtocolFee;
        }
      } else {
        // Rounding favors the owner first, then creator, and foundation last.
        unchecked {
          // SafeMath is not required when dividing by a non-zero constant.
          creatorRev = price / CREATOR_ROYALTY_DENOMINATOR;
        }
        sellerRevTo = seller;
        sellerRev = price - foundationProtocolFee - creatorRev;
      }
    } else {
      // No royalty recipients found.
      sellerRevTo = seller;
      unchecked {
        // protocolFee is always < price.
        sellerRev = price - foundationProtocolFee;
      }
    }

    // Calculate the buy referrer fee if defined and not a party that already has a vested interest in this sale.
    // This is done after the sellerRev calculations as a simplification (using the full protocol fee above).
    if (buyReferrer != address(0) && buyReferrer != msg.sender && buyReferrer != seller && buyReferrer != creator) {
      buyReferrerProtocolFee = price / REFERRER_FEE_DENOMINATOR;
      foundationProtocolFee -= buyReferrerProtocolFee;
    }
  }

  /**
   * @notice This empty reserved space is put in place to allow future versions to add new
   * variables without shifting down storage in the inheritance chain.
   * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
   */
  uint256[1000] private __gap;
}
