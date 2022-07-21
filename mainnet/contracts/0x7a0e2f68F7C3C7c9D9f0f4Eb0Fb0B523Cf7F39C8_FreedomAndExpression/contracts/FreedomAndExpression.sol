// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../libraries/LibRoyaltiesV2.sol";
import "./ERC721.sol";
import "./RaribleRoyaltyV2.sol";

contract FreedomAndExpression is ERC721, Pausable, RaribleRoyaltyV2, Ownable {
  using Strings for uint256;

  event Sale(uint256 indexed tokenId, address indexed to, uint256 indexed price, uint256 timestamp);
  event Withdrawal(address indexed to, uint256 indexed amount, uint256 indexed timestamp);

  uint256 private constant PRINT_SUPPLY = 20;
  uint256 private constant ORIGINALS_COUNT = 5;
  uint256 private constant MAX_SUPPLY = 105;

  uint256 public oneOfOnePrice = 1.62 ether;
  uint256 public oneOfTwentyPrice = 0.16 ether;

  address public withdrawWallet = 0x46AdB53F4DAc76422c618304Eb39E7b5f2d26bae;
  address public nftHolder = 0xfc39a5F7359F036236410B4BAA3824402a1c2c25;
  address public royaltyReceiver = 0x65Ce391F03833434B1D50A2E9bD5401790e66e8D;
  address public artist = 0xeA3f5dC4BFE8C575173F8A5cB04C72c527c17469;

  //  FLOWER_CHILD = 0;
  //  MY_PLEASURE = 1;
  //  PHANTOM_OF_THE_OPERA = 2;
  //  POETRY_IN_MOTION = 3;
  //  HURRICANE = 4;
  mapping(uint256 => uint256) private printSupply;

  uint256 private _totalSupply;

  constructor() ERC721("FreedomAndExpression", "RSFE") {
    _setDefaultRoyalty(royaltyReceiver, 800);
    _setBaseURI("https://ipfs.idea.tf/ipfs/QmT2C17HW7taBELWXPAoNdR223hCbQ6ELcvnavT77E2nuz/");

    _safeMint(artist, 6); // The first Flower child
    _safeMint(artist, 86); // The first Hurricane
    _safeMint(nftHolder, 7); // The second Flower child
    _safeMint(nftHolder, 26); // The first My Pleasure
    printSupply[0] = 2;
    printSupply[1] = 1;
    printSupply[4] = 1;

    _totalSupply = 4;
  }

  function _getNextId(uint256 editionId) internal view returns(uint256) {
    return ORIGINALS_COUNT + editionId * 20 + printSupply[editionId] + 1;
  }

  function rareMint(uint256 tokenId) public payable whenNotPaused {
    require(tokenId <= ORIGINALS_COUNT && tokenId > 0, "tokenId must be between 1 and 5");
    require(_owners[tokenId] == address(0), "That token was already minted");
    require(msg.value == oneOfOnePrice, "You must send the right amount");

    _totalSupply++;
    _safeMint(msg.sender, tokenId);
    emit Sale(tokenId, msg.sender, msg.value, block.timestamp);
  }

  function mint(uint256 editionId) public payable whenNotPaused {
    require(editionId < ORIGINALS_COUNT, "That edition doesn't exist");
    require(printSupply[editionId] < PRINT_SUPPLY, "That edition was minted out");
    require(msg.value == oneOfTwentyPrice, "You must send the right amount");
    uint256 tokenId = _getNextId(editionId);
    printSupply[editionId]++;

    _totalSupply++;
    _safeMint(msg.sender, tokenId);
    emit Sale(tokenId, msg.sender, msg.value, block.timestamp);
  }

  function setRoyalties(address receiver, uint96 part) public onlyOwner {
    _setDefaultRoyalty(receiver, part);
  }

  // The following functions are overrides required by Solidity.
  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
  internal
  override(ERC721)
  {
    super._beforeTokenTransfer(from, to, tokenId);
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  function isAvailable(uint256 tokenId) public view returns (bool) {
    require(tokenId > 0 && tokenId < MAX_SUPPLY, "That token doesn't exist");
    return (_owners[tokenId] == address(0));
  }

  function remainingSupply(uint256 editionId) public view returns (uint256) {
    require(editionId < 5, "That edition doesn't exist");
    return PRINT_SUPPLY - printSupply[editionId];
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

    return string(abi.encodePacked(_baseURI, tokenId.toString(), ".json"));
  }

  function setWithdrawWallet(address _wallet) public onlyOwner {
    withdrawWallet = _wallet;
  }

  function supportsInterface(bytes4 interfaceId)
  public
  view
  override(ERC721, RaribleRoyaltyV2)
  returns (bool)
  {
    if(interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
      return true;
    }
    return super.supportsInterface(interfaceId);
  }

  function pause() public onlyOwner {
    _pause();
  }

  function unpause() public onlyOwner {
    _unpause();
  }

  function setBaseURI(string memory _uri) public onlyOwner {
    _setBaseURI(_uri);
  }

  function setMintingPrices(uint256 _oneOfOne, uint256 _oneOfTwenty) public onlyOwner {
    oneOfOnePrice = _oneOfOne;
    oneOfTwentyPrice = _oneOfTwenty;
  }

  function withdraw() public {
    uint256 balance = address(this).balance;
    require(balance > 0, "No funds to withdraw");
    (bool success, ) = withdrawWallet.call{value: balance}("");
    require(success, "Could not process payment");
    emit Withdrawal(withdrawWallet, balance, block.timestamp);
  }
}
