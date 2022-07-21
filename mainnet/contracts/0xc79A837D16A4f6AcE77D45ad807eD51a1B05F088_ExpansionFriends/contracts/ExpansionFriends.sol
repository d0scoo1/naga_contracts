// SPDX-License-Identifier: MIT
/**
 _______      ___    ___ ________  ________  ________   ________  ___  ________  ________           ________ ________  ___  _______   ________   ________  ________      
|\  ___ \    |\  \  /  /|\   __  \|\   __  \|\   ___  \|\   ____\|\  \|\   __  \|\   ___  \        |\  _____\\   __  \|\  \|\  ___ \ |\   ___  \|\   ___ \|\   ____\     
\ \   __/|   \ \  \/  / | \  \|\  \ \  \|\  \ \  \\ \  \ \  \___|\ \  \ \  \|\  \ \  \\ \  \       \ \  \__/\ \  \|\  \ \  \ \   __/|\ \  \\ \  \ \  \_|\ \ \  \___|_    
 \ \  \_|/__  \ \    / / \ \   ____\ \   __  \ \  \\ \  \ \_____  \ \  \ \  \\\  \ \  \\ \  \       \ \   __\\ \   _  _\ \  \ \  \_|/_\ \  \\ \  \ \  \ \\ \ \_____  \   
  \ \  \_|\ \  /     \/   \ \  \___|\ \  \ \  \ \  \\ \  \|____|\  \ \  \ \  \\\  \ \  \\ \  \       \ \  \_| \ \  \\  \\ \  \ \  \_|\ \ \  \\ \  \ \  \_\\ \|____|\  \  
   \ \_______\/  /\   \    \ \__\    \ \__\ \__\ \__\\ \__\____\_\  \ \__\ \_______\ \__\\ \__\       \ \__\   \ \__\\ _\\ \__\ \_______\ \__\\ \__\ \_______\____\_\  \ 
    \|_______/__/ /\ __\    \|__|     \|__|\|__|\|__| \|__|\_________\|__|\|_______|\|__| \|__|        \|__|    \|__|\|__|\|__|\|_______|\|__| \|__|\|_______|\_________\
             |__|/ \|__|                                  \|_________|                                                                                       \|_________|
                                                                                                                                                                         
                                                                                                                                                                         
*/

pragma solidity >=0.8.9 <0.9.0;

import 'erc721a/contracts/ERC721A.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

contract ExpansionFriends is ERC721A, Ownable, ReentrancyGuard {

  using Strings for uint256;

  bytes32 public merkleRoot;
  mapping(address => bool) public whitelistClaimed;

  string public uriPrefix = '';
  string public uriSuffix = '.json';
  string public hiddenMetadataUri;
  
  uint256 public cost;
  uint256 public maxSupply;
  uint256 public maxMintAmountPerTx;

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
    setCost(_cost);
    maxSupply = _maxSupply;
    setMaxMintAmountPerTx(_maxMintAmountPerTx);
    setHiddenMetadataUri(_hiddenMetadataUri);
  }

  modifier mintCompliance(uint256 _mintAmount) {
    require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
    require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
    _;
  }

  modifier mintPriceCompliance(uint256 _mintAmount) {
    require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
    _;
  }

  function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
    // Verify whitelist requirements
    require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
    require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
    bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
    require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');

    whitelistClaimed[_msgSender()] = true;
    _safeMint(_msgSender(), _mintAmount);
  }

  function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
    require(!paused, 'The contract is paused!');

    _safeMint(_msgSender(), _mintAmount);
  }
  
  function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
    _safeMint(_receiver, _mintAmount);
  }

  function walletOfOwner(address _owner) public view returns (uint256[] memory) {
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

  function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
    require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');

    if (revealed == false) {
      return hiddenMetadataUri;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
        : '';
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

  function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
    merkleRoot = _merkleRoot;
  }

  function setWhitelistMintEnabled(bool _state) public onlyOwner {
    whitelistMintEnabled = _state;
  }

  function withdraw() public onlyOwner nonReentrant {
    (bool hs, ) = payable(0x18dc11ca5c6f939C690F803bB1C842393BE270e8).call{value: address(this).balance * 10 / 100}('');
    require(hs);
    
    (bool hs1, ) = payable(0xa3Dc3885f2BE46e4d6BEFE8D6CaDcec652d77765).call{value: address(this).balance * 15 / 100}('');
    require(hs1); 

    (bool hs2, ) = payable(0xA967F16E1eAc256D738544eF2d50Fc811e0d5Cc0).call{value: address(this).balance * 25 / 100}('');
    require(hs2);
    
    (bool hs3, ) = payable(0x1feA2abD9F34294EccF5c0aCd43C7B1187578936).call{value: address(this).balance * 2 / 100}('');
    require(hs3);

    (bool hs4, ) = payable(0x4307A8a0753bcFbeAAcCBF52834797aCE137de4F).call{value: address(this).balance * 8 / 100}('');
    require(hs4);

    (bool hs5, ) = payable(0xB20aac851aAE1c05FacE119B42F9561dbb51da20).call{value: address(this).balance * 10 / 100}('');
    require(hs5); 

    (bool hs6, ) = payable(0x46766aB7181ba7825b268BA3c45EB81f708e503d).call{value: address(this).balance * 15 / 100}('');
    require(hs6); 

    (bool hs7, ) = payable(0x8663A47cD2b5C1310DC6D8CaD776CdbE9a1259C2).call{value: address(this).balance * 15 / 100}('');
    require(hs7); 

    (bool os, ) = payable(owner()).call{value: address(this).balance}('');
    require(os);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return uriPrefix;
  }
}
