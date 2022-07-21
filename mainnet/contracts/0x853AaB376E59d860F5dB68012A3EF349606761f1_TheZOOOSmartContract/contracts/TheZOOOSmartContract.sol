// SPDX-License-Identifier: MIT
/*
  _____   _                         ____    ___     ___     ___   
 |_   _| | |_      ___      o O O  |_  /   / _ \   / _ \   / _ \  
   | |   | ' \    / -_)    o        / /   | (_) | | (_) | | (_) | 
  _|_|_  |_||_|   \___|   TS__[O]  /___|   \___/   \___/   \___/  
_|"""""|_|"""""|_|"""""| {======|_|"""""|_|"""""|_|"""""|_|"""""| 
"`-0-0-'"`-0-0-'"`-0-0-'./o--000'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' 
*/
pragma solidity >=0.8.9 <0.9.0;

import 'erc721a/contracts/ERC721A.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/finance/PaymentSplitter.sol';
import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';

contract TheZOOOSmartContract is ERC721A, Ownable, ReentrancyGuard {
  using Strings for uint256;
  using EnumerableSet for EnumerableSet.AddressSet;
  string public uriPrefix;
  string public uriSuffix = '.json';

  uint256 public publicMintCost = 0.02 ether;
  uint256 public maxSupply = 10000;
  uint256 public rewardsAmount = 2000;

  bool public paused = true;
  mapping(address => uint256) public rewarderBalance;
  EnumerableSet.AddressSet private rewarderAddressSet;
  PaymentSplitter private _splitter;

  constructor(
    string memory _tokenName,
    string memory _tokenSymbol,
    uint256 _maxSupply,
    uint256 _rewardsAmount
  ) ERC721A(_tokenName, _tokenSymbol) {
    maxSupply = _maxSupply;
    rewardsAmount = _rewardsAmount;
  }

  modifier publicMintCompliance(uint256 _mintAmount) {
    require(_mintAmount > 0, 'Mint amount should be great than 0!');
    require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
    require(msg.value >= publicMintCost * _mintAmount, 'Insufficient funds!');
    _;
  }

  function publicMint(uint256 _mintAmount)
    public
    payable
    publicMintCompliance(_mintAmount)
  {
    require(!paused, 'Public mint not start');
    _safeMint(_msgSender(), _mintAmount);
  }

  function getRewardHolders()
    private
    returns (address[] memory, uint256[] memory)
  {
    uint256 rewardsCount = totalSupply() >= rewardsAmount
      ? rewardsAmount
      : totalSupply();
    for (
      uint256 i = _startTokenId();
      i < _startTokenId() + rewardsCount;
      i += 1
    ) {
      address ownershipAddress = ownerOf(i);
      if (ownershipAddress != address(0)) {
        rewarderBalance[ownershipAddress] += 1;
        EnumerableSet.add(rewarderAddressSet, ownershipAddress);
      }
    }

    uint256 count = EnumerableSet.length(rewarderAddressSet);
    address[] memory holdersAddress = new address[](count);
    uint256[] memory holdersCount = new uint256[](count);
    for (uint256 i = 0; i < count; i += 1) {
      holdersAddress[i] = EnumerableSet.at(rewarderAddressSet, i);
      holdersCount[i] = rewarderBalance[holdersAddress[i]];
    }
    return (holdersAddress, holdersCount);
  }

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
    uint256 currentTokenId = _startTokenId();
    uint256 ownedTokenIndex = 0;
    address latestOwnerAddress;

    while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
      TokenOwnership memory ownership = _ownerships[currentTokenId];

      if (!ownership.burned && ownership.addr != address(0)) {
        latestOwnerAddress = ownership.addr;
      }

      if (latestOwnerAddress == _owner) {
        ownedTokenIds[ownedTokenIndex] = currentTokenId;
        ownedTokenIndex++;
      }
      currentTokenId++;
    }
    return ownedTokenIds;
  }

  function _startTokenId() internal view virtual override returns (uint256) {
    return 1;
  }

  function tokenURI(uint256 _tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(_tokenId),
      'ERC721Metadata: URI query for nonexistent token'
    );

    string memory currentBaseURI = _baseURI();
    return
      bytes(currentBaseURI).length > 0
        ? string(
          abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)
        )
        : '';
  }

  function setPublicMintCost(uint256 _cost) public onlyOwner {
    publicMintCost = _cost;
  }

  function setUriPrefix(string memory _uriPrefix) public onlyOwner {
    uriPrefix = _uriPrefix;
  }

  function setUriSuffix(string memory _uriSuffix) public onlyOwner {
    uriSuffix = _uriSuffix;
  }

  function setPaused(bool _state) public onlyOwner {
    paused = _state;
  }

  function withdraw() public onlyOwner nonReentrant {
    (address[] memory payees, uint256[] memory sharesArr) = getRewardHolders();
    _splitter = new PaymentSplitter(payees, sharesArr);
    (bool os, ) = payable(owner()).call{
      value: (address(this).balance * 20) / 100
    }('');
    require(os);
    // Rewards first 2000 nft holders for last 8000 mint revenue
    (bool hs, ) = payable(_splitter).call{value: address(this).balance}('');
    require(hs);

    for (uint256 i = 0; i < payees.length; i += 1) {
      address currPayee = payees[i];
      release(payable(currPayee));
    }
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return uriPrefix;
  }

  function release(address payable account) private {
    _splitter.release(account);
  }

  function totalShares() public view virtual returns (uint256) {
    return _splitter.totalShares();
  }

  function shares(address account) public view virtual returns (uint256) {
    return _splitter.shares(account);
  }
}
