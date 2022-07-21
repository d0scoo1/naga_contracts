// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TheHouse is ERC721, Ownable {
  using Strings for uint256;

  uint16 supply = 0;
  string public baseURI;
  string public baseExtension = ".json";
  string public notRevealedUri;
  uint256 public wlCost = 0.055 ether;
  uint256 public cost = 0.06 ether;
  uint256 public maxSupply = 10000;
  uint256 public maxMintAmount = 10;
  uint256 public nftPerAddressLimit = 3;
  bool public mintActive = true;
  bool public revealed = false;
  bool public onlyWhitelisted = true;
  mapping(address => bool) private whitelistedAddresses;

  mapping(address => uint256) public addressMintedBalance;

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI,
    string memory _initNotRevealedUri
  ) ERC721(_name, _symbol) {
    setBaseURI(_initBaseURI);
    setNotRevealedURI(_initNotRevealedUri);
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  // public
  function mint(uint256 _mintAmount) public payable {
    require(mintActive, "minting has not started yet.");
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
    require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");

    if (msg.sender != owner()) {
        if(onlyWhitelisted == true) {
            require(isWhitelisted(msg.sender), "user is not whitelisted");
            uint256 ownerMintedCount = addressMintedBalance[msg.sender];
            require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
            require(msg.value >= wlCost * _mintAmount, "insufficient funds");
        }
        else require(msg.value >= cost * _mintAmount, "insufficient funds");
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
      addressMintedBalance[msg.sender]++;
      _safeMint(msg.sender, supply + i);
      supply += 1;
    }
  }

  function getTotalSupply() public view returns (uint16) {
      return  supply; //_nextTokenId.current() - 1;
  }

  function isWhitelisted(address _user) public view returns (bool) {
      if (whitelistedAddresses[_user] == true) {
          return true;
      }
    
    return false;
  }

 

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    if(revealed == false) {
        return notRevealedUri;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  //only owner
  function reveal() public onlyOwner() {
      revealed = true;
  }
  
  function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
    nftPerAddressLimit = _limit;
  }
  
  function setCost(uint256 _newCost) public onlyOwner() {
    cost = _newCost;
  }

  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
    maxMintAmount = _newmaxMintAmount;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }
  
  function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
    notRevealedUri = _notRevealedURI;
  }

  function activateMint(bool _state) public onlyOwner {
    mintActive = _state;
  }
  
  function setOnlyWhitelisted(bool _state) public onlyOwner {
    onlyWhitelisted = _state;
  }

  function whitelistUsers(address[] calldata _user) external onlyOwner {
    for (uint256 i = 0; i < _user.length; i++) {
        whitelistedAddresses[_user[i]] = true;
    }
}
 
  function withdraw() public payable onlyOwner {
    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
    require(success);
  }
}