// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface CryptoadzInterface {
  function approve(address to, uint256 tokenId) external;

  function balanceOf(address owner) external view returns (uint256);

  function baseURI() external view returns (string memory);

  function contractURI() external view returns (string memory);

  function devMintLocked() external view returns (bool);

  function getApproved(uint256 tokenId) external view returns (address);

  function initializePaymentSplitter(
    address[] memory payees,
    uint256[] memory shares_
  ) external;

  function isApprovedForAll(address owner, address operator)
    external
    view
    returns (bool);

  function lockDevMint() external;

  function maxMintsPerTx() external view returns (uint256);

  function maxTokens() external view returns (uint256);

  function mint(uint256 quantity) external;

  function mintSpecial(address[] memory recipients, uint256[] memory specialId) external;

  function name() external view returns (string memory);

  function nextTokenId() external view returns (uint256);

  function owner() external view returns (address);

  function ownerOf(uint256 tokenId) external view returns (address);

  function payee(uint256 index) external view returns (address);

  function provenance() external view returns (string memory);

  function release(address account) external;

  function released(address account) external view returns (uint256);

  function renounceOwnership() external;

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) external;

  function setApprovalForAll(address operator, bool approved) external;

  function setBaseURI(string memory _baseURI) external;

  function setContractURI(string memory contractURI_) external;

  function setProvenance(string memory _provenance) external;

  function setStartingBlock(uint256 _startingBlock) external;

  function shares(address account) external view returns (uint256);

  function startingBlock() external view returns (uint256);

  function supportsInterface(bytes4 interfaceId) external view returns (bool);

  function symbol() external view returns (string memory);

  function tokenByIndex(uint256 index) external view returns (uint256);

  function tokenOfOwnerByIndex(address owner, uint256 index)
    external
    view
    returns (uint256);

  function tokenPrice() external view returns (uint256);

  function tokenURI(uint256 tokenId) external view returns (string memory);

  function totalReleased() external view returns (uint256);

  function totalShares() external view returns (uint256);

  function totalSupply() external view returns (uint256);

  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  function transferOwnership(address newOwner) external;
}
