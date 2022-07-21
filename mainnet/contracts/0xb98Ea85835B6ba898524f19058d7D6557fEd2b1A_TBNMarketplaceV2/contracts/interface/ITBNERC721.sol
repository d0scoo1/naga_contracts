pragma solidity ^0.8.2;

import "@openzeppelin/contracts-4.0.0/token/ERC721/IERC721.sol";

abstract contract ITBNERC721 is IERC721 {
  struct TokenData {
    address tokenAddress;
    uint256 tokenAmount;
  }

  mapping(uint256 => TokenData) public nftsToTokenData;

  function retrieve(uint256 tokenId) public {}

  function mint(
    address paymentTokenAddress,
    uint256 paymentTokenAmount,
    string memory tokenData
  ) public payable returns (uint256) {}

  function pause() public {}

  function unpause() public {}
}
