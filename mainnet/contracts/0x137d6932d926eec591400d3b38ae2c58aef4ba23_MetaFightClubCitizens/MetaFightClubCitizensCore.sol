// SPDX-License-Identifier: BSD-3-Clause

pragma solidity ^0.8.0;

/****************************************
 * @author: squeebo_nft                 *
 * @team:   GoldenX                     *
 ****************************************
 *   Blimpie-ERC721 provides low-gas    *
 *           mints + transfers          *
 ****************************************/

import "./Signed.sol";
import "./PaymentSplitterMod.sol";
import "./IERC721Metadata.sol";
import "./Strings.sol";
import "./ERC165.sol";

abstract contract MetaFightClubCitizensCore is Signed, PaymentSplitterMod, ERC165, IERC721Metadata {

  using Strings for uint256;

  struct Token{
    uint32 baseHearts;
    uint32 epoch;
    address owner;
  }

  uint32 public HEARTS_PERIOD = 604800;

  uint public MAX_ORDER = 1;
  uint public MAX_WALLET = 1;
  uint public TOTAL_SUPPLY = 2500;

  uint public mintPrice = 0.69 ether;

  mapping(address => uint) public accessList;
  mapping(address => uint) public balances;
  mapping(uint => Token) public owners;

  bool public mintingOpen = false;

  uint public tokenIdCounter = 0;

  uint _offset = 1;
  string private _tokenURIPrefix = "";
  string private _tokenURISuffix;

    address[] private addressList = [
    0xBb54229bE98aE4dd54DAfBFaD52c3B5f799d31b3
  ];
  uint[] private shareList = [
    100
  ];

  constructor()
    Delegated()
    PaymentSplitterMod( addressList, shareList ){
  }


  //interface
  function _burn( uint tokenId ) internal virtual;
  function _mint( address to, uint tokenId ) internal virtual;
  function _transfer( address from, address to, uint tokenId ) internal virtual;
  

  //core
  fallback() external payable {}



  function getHearts( uint tokenId ) public view returns( uint32 hearts ){
    require(_exists(tokenId), "MFCC: query for nonexistent token");

    uint32 baseHearts = 10;
    if( owners[tokenId].baseHearts > 0 )
      baseHearts = owners[tokenId].baseHearts;

    uint32 extra = (uint32(block.timestamp) - owners[tokenId].epoch) / HEARTS_PERIOD;
    return baseHearts + extra;
  }


  //IERC165
  function supportsInterface(bytes4 interfaceId) public view virtual override( ERC165, IERC165 ) returns( bool ){
    return
      interfaceId == type(IERC721Metadata).interfaceId ||
      super.supportsInterface(interfaceId);
  }


  //IERC721Metadata
  function name() external pure override returns( string memory ){
    return "Meta Fight Club Citizens";
  }

  function symbol() external pure override returns( string memory ){
    return "MFCC";
  }

  function tokenURI(uint tokenId) external view override returns( string memory ){
    require(_exists(tokenId),"MFCC : query for nonexistent token");
    return string(abi.encodePacked(_tokenURIPrefix, tokenId.toString(), _tokenURISuffix));
  }


  //payable
  function mint(uint quantity , bytes calldata signature ) external payable {
    require( quantity <= MAX_ORDER, "Order too big" );
    require( balances[ msg.sender ] + quantity <= MAX_WALLET, "Passed the Limit, Can't mint more NFTs" );
    require(mintingOpen, "Sorry, Minting isn't Opened at this time");
    if(tokenIdCounter >= 20 ){
      require(quantity * mintPrice == msg.value, "Not Enough ETH sent");
    }
    require (tokenIdCounter + quantity < TOTAL_SUPPLY, "Not enought Supply" );
    if( signature.length > 0 ){
      verifySignature( quantity.toString(), signature );
    }
    else{
      require( accessList[ msg.sender ] >= quantity, "Verificaton failed" );
      accessList[ msg.sender ] -= quantity;
    }

    uint numberOfNftMinted = tokenIdCounter;
    for( uint i = 1; i <= quantity; ++i ){
      _mint( msg.sender, i + numberOfNftMinted );
    }
    tokenIdCounter = tokenIdCounter + quantity;
  }

    function mintTo(address[] calldata recipients, uint[] calldata quantities ) external payable onlyDelegates{
    for(uint i; i < recipients.length; ++i ){
      require(tokenIdCounter + quantities[i] <= TOTAL_SUPPLY, "Not Enough Supply");
      for( uint j; j < quantities[i]; ++j ){
        _mint( recipients[i], tokenIdCounter + j + 1 );
      }
      tokenIdCounter = tokenIdCounter + quantities[i];
    }
  }


  //delegated
  function burn( uint[] calldata tokenIds ) external onlyDelegates{
    for(uint i; i < tokenIds.length; ++i ){
      _burn( tokenIds[i] );
    }
  }


  function resurrect( uint[] calldata tokenIds, address[] calldata recipients ) external onlyDelegates{
    require(tokenIds.length == recipients.length,   "Must provide equal tokenIds and recipients" );
    for(uint i; i < tokenIds.length; ++i ){
      require( !_exists( tokenIds[i] ), "MFCC: can't resurrect existing token" );
      _mint( recipients[i], tokenIds[i] );
    }
  }


  function setAccessList(address[] calldata accounts, uint[] calldata quantities ) external onlyDelegates{
    require(accounts.length == quantities.length,   "Must provide equal accounts and quantities" );
    for(uint i; i < accounts.length; ++i ){
      accessList[ accounts[i] ] = quantities[i];
    }
  }

  function setBaseURI(string memory tokenURIPrefix, string memory tokenURISuffix) external onlyDelegates {
    _tokenURIPrefix = tokenURIPrefix;
    _tokenURISuffix = tokenURISuffix;
  }

  function setHearts(uint[] calldata tokenIds, uint32[] calldata hearts) external onlyDelegates{
    require(tokenIds.length == hearts.length,   "Must provide equal tokenIds and hearts" );
    for(uint i; i < tokenIds.length; ++i ){
      owners[ tokenIds[i] ].baseHearts = hearts[i];
    }
  }

  function setHeartsOptions( uint32 period ) external onlyDelegates{
    HEARTS_PERIOD = period;
  }

  function setMax(uint maxOrder, uint maxWallet) external onlyDelegates{
    MAX_ORDER = maxOrder;
    MAX_WALLET = maxWallet;
  }

  function setMintPrice(uint newPrice) external onlyDelegates {
    mintPrice = newPrice;
  }

  function resumeMinting () external onlyDelegates {
    mintingOpen = true;
  }

  function pauseMinting() external onlyDelegates {
    mintingOpen = false;
  }
  //internal
  function _exists(uint tokenId) internal view returns (bool) {
    return owners[tokenId].owner != address(0);
  }
}