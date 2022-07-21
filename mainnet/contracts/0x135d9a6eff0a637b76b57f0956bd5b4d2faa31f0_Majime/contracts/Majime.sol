// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Majime is ERC721A, Ownable {
  using Strings for uint256;

  string public baseURI;
  string public baseExtension = ".json";
  string public notRevealedUri;
  uint256 public cost = 67000000000000000;
  uint256 public maxSupply = 7777;
  uint256 public maxOgMint = 3;
  uint256 public maxWhitelistMint = 2;
  uint256 public maxPublicSaleMint = 2;
  bool public revealed = false;
  bool public presale = false;
  bool public publicsale = false;
  mapping(address => uint256) public publicMintedBalance;
  mapping(address => uint256) public whitelistMintedBalance;
  mapping(address => uint256) public ogMintedBalance;

  bytes32 public whitelistRoot;
  bytes32 public ogRoot;

  constructor() ERC721A("Majime Official Collection", "MAJI") {
  }

  // ====== Settings ======
  modifier callerIsUser() {
    require(tx.origin == msg.sender, "cannot be called by a contract");
    _;
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }
  
  function _startTokenId() internal pure override returns (uint256){
    return 1;
  }
  //

  // ====== public ======
  function mint(uint256 _mintAmount) public payable callerIsUser {
    // Is publicsale active
    require(publicsale, "publicsale is not active");
    //

    // Amount and payment control
    uint256 supply = totalSupply();
    require(publicMintedBalance[msg.sender] + _mintAmount <= maxPublicSaleMint, "max NFT limit exceeded for this user");
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
    require(msg.value >= cost * _mintAmount, "insufficient funds");
    //

    // Increment balance before mint
    publicMintedBalance[msg.sender] += _mintAmount;
    //

    _safeMint(msg.sender, _mintAmount);
  }

  function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable callerIsUser {
    // Is presale active
    require(presale, "presale is not active");
    //

    // Whitelist Requires
    bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
    require(MerkleProof.verify(_merkleProof, whitelistRoot, leaf), "user is not whitelisted");
    require(whitelistMintedBalance[msg.sender] + _mintAmount <= maxWhitelistMint, "max NFT limit exceeded for this whitelist user");
    //

    // Amount and payments control
    uint256 supply = totalSupply();
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
    require(msg.value >= cost * _mintAmount, "insufficient funds");
    //
    
    // Increment balance before mint
    whitelistMintedBalance[msg.sender] += _mintAmount;
    //

    _safeMint(msg.sender, _mintAmount);
  }

  function ogMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable callerIsUser {
    // Is presale active
    require(presale, "presale is not active");
    //

    // Is user OG
    bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
    require(MerkleProof.verify(_merkleProof, ogRoot, leaf), "user is not OG");
    require(ogMintedBalance[msg.sender] + _mintAmount <= maxOgMint, "max NFT limit exceeded for this OG");
    //

    // Amount and payments control
    uint256 supply = totalSupply();
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
    require(msg.value >= cost * _mintAmount, "insufficient funds");
    //

    // Increment balance before mint
    ogMintedBalance[msg.sender] += _mintAmount;
    //

    _safeMint(msg.sender, _mintAmount);
  }

  function ownerMint(uint256 _mintAmount) public onlyOwner {
    // Amount Control
    uint256 supply = totalSupply();
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
    //

    _safeMint(msg.sender, _mintAmount);
  }

  // ====== View ======
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

  /// @dev Returns the tokenIds of the address. O(totalSupply) in complexity.
  function tokensOfOwner(address owner) external view returns (uint256[] memory) {
    unchecked {
        uint256[] memory a = new uint256[](balanceOf(owner)); 
        uint256 end = _currentIndex;
        uint256 tokenIdsIdx;
        address currOwnershipAddr;
        for (uint256 i; i < end; i++) {
            TokenOwnership memory ownership = _ownerships[i];
            if (ownership.burned) {
                continue;
            }
            if (ownership.addr != address(0)) {
                currOwnershipAddr = ownership.addr;
            }
            if (currOwnershipAddr == owner) {
                a[tokenIdsIdx++] = i;
            }
        }
        return a;    
    }
  }

  // ====== Only Owner ======
  function reveal() public onlyOwner {
    revealed = true;
  }

  // Whitelist and OG roots (presale)
  function setWhitelistRoot(bytes32 _whitelistRoot) public onlyOwner{
    whitelistRoot = _whitelistRoot;
  }

  function setOgRoot(bytes32 _ogRoot) public onlyOwner{
    ogRoot = _ogRoot;
  }
  //
  
  // Max Mint Amounts - Cost
  function setMaxOgMint(uint256 _newMaxOgMint) public onlyOwner {
    maxOgMint = _newMaxOgMint;
  }

  function setMaxWhitelistMint(uint256 _newMaxWhitelistMint) public onlyOwner {
    maxWhitelistMint = _newMaxWhitelistMint;
  }

  function setMaxPublicSaleMint(uint256 _newMaxPublicSaleMint) public onlyOwner {
     maxPublicSaleMint = _newMaxPublicSaleMint;
  }
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }
  //

  // Metadata
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }
  
  function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
    notRevealedUri = _notRevealedURI;
  }
  //

  // Sale states
  function setPresale() public onlyOwner {
    presale = !presale;
  }

  function setPublicsale() public onlyOwner {
    publicsale = !publicsale;
  }
  //
 
  function withdraw() public payable onlyOwner {
    // =============================================================================
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
    // =============================================================================
  }
}