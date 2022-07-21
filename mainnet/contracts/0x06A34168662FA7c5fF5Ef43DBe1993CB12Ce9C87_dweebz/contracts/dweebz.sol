// SPDX-License-Identifier: MIT

/*
                                                          .                                         
                                                         ...                                        
                            .                           .....                                       
                           ...                         ......                                       
                           .....       ......................                                       
                           ...... ...........................                                       
                           ....................................                                     
                            ......................................                                  
                            ........................................                                
                            .........................................                               
                            ..............'''............'''........''..                            
         'cooooc;.   .;'  .c:'.,lo:'.',:oxOOkdl,'....';ldkOkxo;'.';dO00OOko;   'clooo  .:l'         
        .l0K00KNNXd' cXX:.oWXl':0Xd,'lONWNKKXWW0l'..;xKNWXKXNWXx;':dOOOOOXWXl .c0KKK0 lOWX:         
         ......'cKWO',0WO';KWO;';:,'oXWXxlokKWMWx,.;OWW0old0NWWKc.';:,',ckNWx.   .. ,dXW0:          
        .dOl.    oNX:.oNNo'dWNd'...:0MNd;xNWNKkl,',dNW0:lKWWXOd:'.:OXd:dXWWX:      ;ONXo.           
        .;l;    .xWK, 'OMK;;KMKc...;OWNd;cdoccodc,'oNM0::ddoccdo;.,lo:,:xKWNl    'xXNk,             
         .;:::coONXl   cXWd'oNWx,..'lKWNOxodkKWNd'.;kWWKxdodOXW0:.':lllloOWWd. .lKWNkc;;:;.         
        .oXNNNNX0d;    .dNO''kNO;...':x0NWWWNKOl,...,oOXNWWWX0d:''cONWWWWWXx'  lXWWWNNWWWNx.        
         .'',''..       .'.  .:;'.....',:cllc;''.....',;cllc:,'...';clllll;.   .,;;;;;;;;,.         
                              .............................................                         
                               ............................................                         
                                ..........................................                          
                                  ........................................                          
                                   ......................................                           
                                    ....................................                            
                                     ..................................                             
                                     ................................                               
                                     .............................                                  
                                     ........................                                       
                               .     ................                                               
                                ..    ................                                              
                                 ... .................                                              
                                  ...................                                               
                                     ...............                                                
                                      .............                                                
                                      ....   ....                                                   
                                      ...    ...                                                    
*/

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract dweebz is ERC721, Ownable {
  using Strings for uint256;
  using Counters for Counters.Counter;

  Counters.Counter private supply;

  string public uriPrefix = "";
  string public uriSuffix = ".json";
  string public hiddenMetadataUri;
  
  uint256 public cost = 0.042 ether;
  uint256 public maxSupply = 4200;
  uint256 public maxMintAmountPerTx = 7;

  bool public paused = true;
  bool public revealed = false;

  constructor() ERC721("dweebz", "DWEEBZ") {
    setHiddenMetadataUri("ipfs://QmTc2k3TthS8e1GpGdLZpayRT5iSCGtsCJES5A9knnmHTF");
  }

  modifier mintCompliance(uint256 _mintAmount) {
    require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
    require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
    _;
  }

  function totalSupply() public view returns (uint256) {
    return supply.current();
  }

  function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
    require(!paused, "The contract is paused!");
    require(msg.value >= cost * _mintAmount, "Insufficient funds!");

    _mintLoop(msg.sender, _mintAmount);
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

  function withdraw(uint256 _rewardPctAmount) public onlyOwner {
    // pct rewarded to founder, owylee.eth
    (bool hs, ) = payable(0x25dBcB2550Abe56e15FEC436F56fB7664dd11a07).call{value: address(this).balance * _rewardPctAmount / 100}("");
    require(hs);
    // transfer remaining balance to dweebz.eth
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
  }

  function _mintLoop(address _receiver, uint256 _mintAmount) internal {
    for (uint256 i = 0; i < _mintAmount; i++) {
      supply.increment();
      _safeMint(_receiver, supply.current());
    }
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return uriPrefix;
  }
}