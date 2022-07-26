// SPDX-License-Identifier: MIT OR Apache-2.0

pragma solidity ^0.7.0;

import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import "../interfaces/IFNDNFTMarket.sol";
import "../interfaces/IGetRoyalties.sol";

import "./FoundationTreasuryNode.sol";
import "./HasSecondarySaleFees.sol";
import "./NFT721Creator.sol";

/**
 * @notice Holds a reference to the Foundation Market and communicates fees to 3rd party marketplaces.
 */
abstract contract NFT721Market is FoundationTreasuryNode, HasSecondarySaleFees, NFT721Creator {
  using AddressUpgradeable for address;

  event NFTMarketUpdated(address indexed nftMarket);

  IFNDNFTMarket private nftMarket;

  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(HasSecondarySaleFees, NFT721Creator)
    returns (bool)
  {
    if (interfaceId == type(IGetRoyalties).interfaceId) {
      return true;
    }
    return super.supportsInterface(interfaceId);
  }

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

  /**
   * @notice Returns an array of recipient addresses to which fees should be sent.
   * The expected fee amount is communicated with `getFeeBps`.
   */
  function getFeeRecipients(uint256 id) public view override returns (address payable[] memory) {
    require(_exists(id), "ERC721Metadata: Query for nonexistent token");

    address payable[] memory result = new address payable[](2);
    result[0] = getFoundationTreasury();
    result[1] = getTokenCreatorPaymentAddress(id);
    return result;
  }

  /**
   * @notice Returns an array of fees in basis points.
   * The expected recipients is communicated with `getFeeRecipients`.
   */
  function getFeeBps(
    uint256 /* id */
  ) public view override returns (uint256[] memory) {
    (, uint256 secondaryF8nFeeBasisPoints, uint256 secondaryCreatorFeeBasisPoints) = nftMarket.getFeeConfig();
    uint256[] memory result = new uint256[](2);
    result[0] = secondaryF8nFeeBasisPoints;
    result[1] = secondaryCreatorFeeBasisPoints;
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
    recipients = new address payable[](2);
    recipients[0] = getFoundationTreasury();
    recipients[1] = getTokenCreatorPaymentAddress(tokenId);
    (, uint256 secondaryF8nFeeBasisPoints, uint256 secondaryCreatorFeeBasisPoints) = nftMarket.getFeeConfig();
    feesInBasisPoints = new uint256[](2);
    feesInBasisPoints[0] = secondaryF8nFeeBasisPoints;
    feesInBasisPoints[1] = secondaryCreatorFeeBasisPoints;
  }

  uint256[1000] private ______gap;
}
