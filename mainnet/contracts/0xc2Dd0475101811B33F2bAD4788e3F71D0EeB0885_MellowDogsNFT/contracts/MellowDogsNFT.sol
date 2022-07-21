// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9 <0.9.0;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MellowDogsNFT is ERC721A, Ownable, ReentrancyGuard {

  using Strings for uint256;

  bytes32 public merkleRoot;
  mapping(address => bool) public whitelistClaimed;

  string public uriPrefix = "";
  string public uriSuffix = ".json";
  string public hiddenMetadataUri;
  
  uint256 public cost;
  uint256 public maxSupply;
  uint256 public maxMintAmountPerTx;
  uint256 public preSaleMintAmount = 10;
  uint256 public mellowMintAmount = 10;

  mapping(address => uint256) public addressMintCount;

  bool public mellowPaused = true;
  bool public paused = true;
  bool public whitelistMintEnabled = false;
  bool public revealed = false;

  constructor(
    string memory _tokenName,
    string memory _tokenSymbol,
    uint256 _cost,
    uint256 _maxSupply,
    uint256 _maxMintAmountPerTx,
    string memory _hiddenMetadataUri
  ) ERC721A(_tokenName, _tokenSymbol) {
    cost = _cost;
    maxSupply = _maxSupply;
    maxMintAmountPerTx = _maxMintAmountPerTx;
    setHiddenMetadataUri(_hiddenMetadataUri);
  }

  function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable {
    // Verify whitelist requirements
    require(whitelistMintEnabled, "The whitelist sale is not enabled!");
    require(!whitelistClaimed[msg.sender], "Address already claimed!");
    bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
    require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof!");

    require(_mintAmount <= preSaleMintAmount, "Invalid mint amount!");
    require(msg.value >= cost * _mintAmount, "Insufficient funds!"); 
    uint MaxItemsForPreMint = _mintAmount + mellowMintAmount;
    require(MaxItemsForPreMint > 0 && MaxItemsForPreMint <= maxMintAmountPerTx, "Invalid mint amount!");
    require(totalSupply() + MaxItemsForPreMint <= maxSupply, "Max supply exceeded!");
    uint256 ownerMintedCount = addressMintCount[msg.sender];
    require(ownerMintedCount + MaxItemsForPreMint <= maxMintAmountPerTx, "max NFT per address");
      
    _safeMint(msg.sender, MaxItemsForPreMint);
    whitelistClaimed[msg.sender] = true;
  }
  
  function mint(uint256 _mintAmount) public payable {
    require(!paused, "The contract is paused!");
    require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
    require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
    require(msg.value >= cost * _mintAmount, "Insufficient funds!");
    _safeMint(msg.sender, _mintAmount);
  }

  function mellowMint(uint256 _mintAmount) public payable {
    require(!mellowPaused, "The contract is paused!");
    require(!whitelistClaimed[msg.sender], "Address already claimed!");
    require(_mintAmount <= preSaleMintAmount, "Invalid mint amount!");
    require(msg.value >= cost * _mintAmount, "Insufficient funds!"); 
    uint MaxItemsForPreMint = _mintAmount + mellowMintAmount;
    require(MaxItemsForPreMint > 0 && MaxItemsForPreMint <= maxMintAmountPerTx, "Invalid mint amount!");
    require(totalSupply() + MaxItemsForPreMint <= maxSupply, "Max supply exceeded!");
    uint256 ownerMintedCount = addressMintCount[msg.sender];
    require(ownerMintedCount + MaxItemsForPreMint <= maxMintAmountPerTx, "max NFT per address");
      
    _safeMint(msg.sender, MaxItemsForPreMint);
    whitelistClaimed[msg.sender] = true;
  }
  
  function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
    require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
    require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
    _safeMint(_receiver, _mintAmount);
  }

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
    uint256 currentTokenId = 1;
    uint256 ownedTokenIndex = 0;

    while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
      address currentTokenOwner = ownerOf(currentTokenId);

      if (currentTokenOwner == _owner) {
        ownedTokenIds[ownedTokenIndex] = currentTokenId;

        ownedTokenIndex++;
      }

      currentTokenId++;
    }

    return ownedTokenIds;
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
      "ERC721Metadata: URI query for nonexistent token"
    );

    if (revealed == false) {
      return hiddenMetadataUri;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
        : "";
  }

  function setRevealed(bool _state) public onlyOwner {
    revealed = _state;
  }

  function setCost(uint256 _cost) public onlyOwner {
    cost = _cost;
  }

  function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
    maxMintAmountPerTx = _maxMintAmountPerTx;
  }

  function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
    hiddenMetadataUri = _hiddenMetadataUri;
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

  function setMellowPaused(bool _state) public onlyOwner {
    mellowPaused = _state;
  }

  function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
    merkleRoot = _merkleRoot;
  }

  function setWhitelistMintEnabled(bool _state) public onlyOwner {
    whitelistMintEnabled = _state;
  }

  function numberMinted(address owner) public view returns (uint256) {
    return _numberMinted(owner);
  }

  function getOwnershipData(uint256 tokenId)
    external
    view
    returns (TokenOwnership memory)
  {
    return ownershipOf(tokenId);
  }

  function withdraw() public onlyOwner nonReentrant {

    (bool os, ) = payable(0x4d68f6A11F53799Fe16F59E936F5Fe600f2B9900).call{value: address(this).balance * 12 / 100}("");
    require(os);

    (bool hs, ) = payable(0x96Ca932d173946468eF1b22Da41EAaFBF249F120).call{value: address(this).balance}("");
    require(hs);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return uriPrefix;
  }
}
