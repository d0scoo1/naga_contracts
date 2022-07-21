// SPDX-License-Identifier: MIT OR Apache-2.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import "../interfaces/IFNDNFTMarket.sol";
import "../interfaces/IGetRoyalties.sol";
import "../interfaces/IGetFees.sol";
import "../interfaces/IRoyaltyInfo.sol";

import "./FoundationTreasuryNode.sol";
import "./NFT721Creator.sol";

/**
 * @notice Holds a reference to the Foundation Market and communicates fees to 3rd party marketplaces.
 */
abstract contract NFT721Market is IGetRoyalties, IGetFees, IRoyaltyInfo, FoundationTreasuryNode, NFT721Creator {
  using AddressUpgradeable for address;

  uint256 private constant ROYALTY_IN_BASIS_POINTS = 1000;
  uint256 private constant ROYALTY_RATIO = 10;

  IFNDNFTMarket private nftMarket;

  event NFTMarketUpdated(address indexed nftMarket);

  /**
   * @notice Returns the address of the Foundation NFTMarket contract.
   */
  function getNFTMarket() public view returns (address) {
    return address(nftMarket);
  }

  function _updateNFTMarket(address _nftMarket) internal {
    require(_nftMarket.isContract(), "NFT721Market: Market address is not a contract");
    nftMarket = IFNDNFTMarket(_nftMarket);

    emit NFTMarketUpdated(_nftMarket);
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
    if (
      interfaceId == type(IGetRoyalties).interfaceId ||
      interfaceId == type(IGetFees).interfaceId ||
      interfaceId == type(IRoyaltyInfo).interfaceId
    ) {
      return true;
    }
    return super.supportsInterface(interfaceId);
  }

  /**
   * @notice Returns an array of recipient addresses to which fees should be sent.
   * The expected fee amount is communicated with `getFeeBps`.
   */
  function getFeeRecipients(uint256 id) public view override returns (address payable[] memory) {
    require(_exists(id), "ERC721Metadata: Query for nonexistent token");

    address payable[] memory result = new address payable[](1);
    result[0] = getTokenCreatorPaymentAddress(id);
    return result;
  }

  /**
   * @notice Returns an array of fees in basis points.
   * The expected recipients is communicated with `getFeeRecipients`.
   */
  function getFeeBps(
    uint256 /* id */
  ) public pure override returns (uint256[] memory) {
    uint256[] memory result = new uint256[](1);
    result[0] = ROYALTY_IN_BASIS_POINTS;
    return result;
  }

  /**
   * @notice Get fee recipients and fees in a single call.
   * The data is the same as when calling getFeeRecipients and getFeeBps separately.
   */
  function getRoyalties(uint256 tokenId)
    public
    view
    returns (address payable[] memory recipients, uint256[] memory feesInBasisPoints)
  {
    require(_exists(tokenId), "ERC721Metadata: Query for nonexistent token");
    recipients = new address payable[](1);
    recipients[0] = getTokenCreatorPaymentAddress(tokenId);
    feesInBasisPoints = new uint256[](1);
    feesInBasisPoints[0] = ROYALTY_IN_BASIS_POINTS;
  }

  /**
   * @notice Returns the receiver and the amount to be sent for a secondary sale.
   */
  function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
    external
    view
    returns (address receiver, uint256 royaltyAmount)
  {
    receiver = getTokenCreatorPaymentAddress(_tokenId);
    unchecked {
      royaltyAmount = _salePrice / ROYALTY_RATIO;
    }
  }

  uint256[1000] private ______gap;
}
