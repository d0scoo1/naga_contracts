// SPDX-License-Identifier: MIT

pragma solidity >=0.8.9 <0.9.0;

import "https://github.com/chiru-labs/ERC721A/blob/v4.0.0/contracts/ERC721A.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/security/ReentrancyGuard.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/utils/Strings.sol";


contract PixieTown is ERC721A, Ownable, ReentrancyGuard {

  using Strings for uint256;

  string public uriPrefix = '';
  string public uriSuffix = '.json';
  
  uint256 public cost = 0 ether;
  uint256 public maxSupply = 10000;
  uint256 public maxMintAmount = 3;
  bool public hasCostBeenUpdatedDynamically = false;

  bool public paused = true;

  constructor(
    string memory _tokenName,
    string memory _tokenSymbol
  ) ERC721A(_tokenName, _tokenSymbol) {
    setCost(cost);
    maxSupply = maxSupply;
    setMaxMintAmount(maxMintAmount);
  }

  modifier mintCompliance(uint256 _mintAmount) {
    require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
    require(tx.origin == msg.sender, "The caller is another contract");
    require(
      _mintAmount > 0 && _mintAmount <= maxMintAmount && numberMinted(msg.sender) + _mintAmount <= maxMintAmount,
       "Invalid mint amount!"
    );
    _;
  }

  modifier mintPriceCompliance(uint256 _mintAmount) {
    require(msg.value >= cost * _mintAmount, "Insufficient funds!");
    _;
  }

  function updateCostDynamically(uint256 _supply) internal {
      if (_supply >= 2000) {
          cost = 0.0035 ether;
          hasCostBeenUpdatedDynamically = true;
      }
  }  

  function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
    require(!paused, "The contract is paused!");

    _safeMint(_msgSender(), _mintAmount);

    if (!hasCostBeenUpdatedDynamically) {
      uint256 newSupply = totalSupply();
      updateCostDynamically(newSupply);
    }
  }
  
  function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
    require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");

    _safeMint(_receiver, _mintAmount);
  }

  function _startTokenId() internal view virtual override returns (uint256) {
    return 1;
  }

  function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
    require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
        : '';
  }

  function setCost(uint256 _cost) public onlyOwner {
    cost = _cost;
  }

  function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
    maxMintAmount = _maxMintAmount;
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
    (bool artistSuccess, ) = payable(0xF1F7BF74bBe6DeE2E9331B2b03c9c02D1eFE9705).call{value: address(this).balance * 50 / 100}('');
    require(artistSuccess);

    (bool devSuccess, ) = payable(owner()).call{value: address(this).balance}('');
    require(devSuccess);
  }

  function numberMinted(address owner) public view returns (uint256) {
    return _numberMinted(owner);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return uriPrefix;
  }
}