//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/// @title  - INFINITE PRESSURE - 99 Digital Works by Chuck Anderson (NoPattern Studio)
/// @author - ediv === Chain/Saw

/**
 *
 * INNNNNNNNNNNI TNNNNN     NN INNNNNNNNNNNI TNNNNNNNNNNNN  NN        SNT INNNNNNNNNNNI   NNNNNNNNN   INNNNNNNNNNNI 
 * NFFFFFFFFFFFN EFFFFF     FF NFFFFFFFFFFFR TFFFFFFFFFFFF  FF        IFT NFFFFFFFFFFFN   FFFFFFFFF   NFFFFFFFFFFFN 
 * NFFFFFFFFFFFN EFFFFF     FF NFFFTUUUUUUNR TFFFFFFFFFUUU  FFR       IFT UPFFFFFFFFRUU RRFFFFFFFFFRT NFFFFFFFFFFFN 
 * NFFFFFFFFFFFN TFFFFF     FF NFFFPPPT   IR USSSSSFFFR     FFFPP     IFT  EFFFFFFFFR   FFFFFFFFFFFFE NFISSSSSSSSSP 
 * NFFFFFFFFFFFN TFFFFF     FF NFFFFFFP   IR       FFFR     FFFFF     IFT  EFFFFFFFFR   FFFFFFFFFFFFT NFU           
 * NFFFFFFFFFFFN EFFFFFPP   FF NFFFFFFP   EP       FFFR     FFFFFPP   IFT  EFFFFFFFFR   FFFFFFFFFFFFE NFSPPPPT      
 * NFFFFFFFFFFFN EFFFFFFF   FF NFFFFFFP            FFFR     FFFFFFF   IFT  EFFFFFFFFR   FFFFFFFFFFFFE NFFFFFFP      
 * NFFFFFFFFFFFN EFFFFFFFS  FF NFFFFFFNSSSSP       FFPP     FFFFFFFSE IFT  EFFFFFFFFR   FFFFFFFFFFFFE NFSPPPPT      
 * NFFFFFFFFFFFN TFFFFFFFF  FF NFFFFFFFFFFFR       FFFF     FFFFFFFFS IFT  EFFFFFFFFR   FFFFFFFFFFFFT NFU           
 * NFFFFFFFFFFFN TFFFFFTTFFFFF NFFFFFFFFFFFR TFFFFFFFFFFFF  FFFFFFFFFFFFT  EFFFFFFFFR   FFFFFFFFFFFFT NFU           
 * NFFFFFFFFFFFN EFFFFF  FFFFF NFFFFFFFFFFFR TFFFFFFFFFFFF  FFFFFFFFFFFFT  EFFFFFFFFR   FFFFFFFFFFFFE NFTUUUUUUUU   
 * NFFFFFFFFFFFN EFFFFF  FFFFF NFFFFFFFFFFFR TFFFFFFFFFFFF  FFFFFFFFFFFFT  EFFFFFFFFR   FFFFFFFFFFFFE NFFFFFFFFFR   
 * NFFFFFFFFFFFN TFFFFF  NNNFF NFFFFFFFFFFFR TFFFFFFFFFFFF  FFFFFFFFFFFFT UPFFFFFFFFRTU FFFFNFFNNFFFT NFFFFFFFFFRTU 
 * NFFFFFFFFFFFN TFFFFF     FF NFFFFFFFFFFFR TFFFFFFFFFFFF  FFFFFFFFFFFFT NFFFFFFFFFFFN FFFF FF  FFFT NFFFFFFFFFFFN 
 * NFFFFFFFFFFFN TNNNNN     NN NFNNNNNNNNNNS TNNNNNNNNNNNN  FFFFFFFFFFFFT SNNNNNNNNNNNS FFFF FF  FFFE SNNNNNNNNNNNS 
 * NFFFFFFFFFFFN               NFU                          FFFFFFFFFFFFT               FFFF FF  FFFE               
 *       PFP      TFFFFFFFFFF  NFU FFFFFFFFR   EFFFFFFFFU   FFFFFFFFFFFFT NI      FFFFFN     FF       NFFFFFFFFFFFN 
 *       PFP      TFFFFFFFFFF  NFU FFFFFFFFR  EEFFFFFFFFU   FFFFFFFFFFFFT NI      FFFFFN     FF       NFFFFFFFFFFFN 
 *       PFP      EFT    FFFFF NFU FFFFFFFFR TFI     FFFFF  FF   FFFFFFFT NI      FFFFFN     FF      NFFFFS    SFFN 
 *       PFP      EFT    FFFFF NFU FFFFFFFFR TFI     FFFFF  FF   FFFFFFFT NI      FFFFFN     FF      NFFFFS    SFFN 
 *       PFP     EFFFFF  FFFFF NFU FFFFFFFFR TFFF    FFFFF  FF   FFFFFFFT NI      FFFFFN     FF     IFFFFI     SFFN 
 * NFFFFFFFFFFFN EFFFFF  FFFFF NFU FFFFFFFFR TFFFF   FFFFF  FF    UUUIFFFT NI     FFFFFN     FF     IFFFFI     SFFN 
 * NFFFFFFFFFFFN EFFFFF  FFFFF NFU FFFFFFFFR TFFFF   FFFFF  FF       SFFFT NI     FFFFFN     FF     IFFFFI     SFFN 
 * NFFFFFFFFFFFN EFFFFF  FFFFF NFU FFFFFFFFR TFFFF   FFFFF  FF         IFT NI     FFFFFN     FF     NFFFFI     SFFN 
 * NFFFFFFFFFFFN EFFFFF  FFFFF NFU FFFFFFFFR TFFFF   FFFFF  FF         IFT NI     FFFFFN     FF     IFFFFI     SFFN 
 *               EFFFFF  FFFFF     FFFFFFFFR TFFFFF                        NI     FFFFFN             IFFFFI    SFFN 
 *   UUUUUUUUU   EFFFFF  FFFFF UUFFFFFFFFRT  TFFFFF      UUUUUUUUUUUU      NI    UFFFFFN   UU UUUUUU IFFFFIU   SFFN 
 * NFFFFFFFFEUFN EFFFFF  FFFF  NFFFFFFFFFFFR TFFFFF   FFFFFFFFFFFFFFFFE    NI   PFFFFFFN FFFFFFFFFFF NFFFFFFS SFFNN 
 * NFFFFFFFFRRFN EFFFFF  FFF  NFFFFFFFSTTTTU TFFFFF  NNNFFFFFFFFFTTTTTSNT  NI   PFFFFFFN FFTTTTTTTTTNETRFFFFRNNNRFFN 
 * NFFFF  FFFFFN EFFFFF  FFF  FFFFFFFFP      TFFFFF  FFFFFFFFFFFF     IFT  NI   PFFFFFFN FF         FE NFFFFFFFFFFFN 
 * NFFFF  PPPTFN EFFFFF  FFF  FFFFFFFFP      TFFFFF  FFFFFFFFFFFF     UU   NI   PFFFFFFN FFRRRRRRRRRFE NFFFFFFFFPUUU 
 * NFFFF  EEEUFN EFFFFF  FFF  FFFFFFFFP      TFFFFF  FFFFFFFFFFFF          NI   PFFFFFFN FFFFFFFFFFFFE NFFFFFFFFP    
 * NFFFF  UUSFFN EFFFFF  FFF   NFFFFFFFFFFFN  PPFFFFF       FFFFFFFFFFE    NI   PFFFFFFN FFFFFFFFFFFFE NFFFFSU       
 * PSFFFPPNFSP EFFFFFPPFFF     PRFISSSSSSSSS   SSPPPPPPP  FFFFFFFFFFE      NI   PFFFFFFN FFFFSSSSSSSFE PSFRSE        
 * PRFFFFFFFRRR  EFFFFFFFFFF  FFFU                 FFFFFFF  FFFFFFFFFFE    NI   PFFFFFFN FFFF       FE   RI          
 * PSFRPPPPPPP   EFSPFFFFFFF  FFFU                 FFFFFFF  PPPPPPPFFFISU  NI   PFFFFFFN FFPPSSS    PU   RI          
 * NFFN          EFT FFFFFFF  FFFU                 FFFFFFF         FFFFFT  NI   PFFFFFFN FF  FFF         RI          
 * NFFN          EFT PPPPFFF  FFFISSSSSSSST  USE   FFFFFFF  SS     FFFFFT  NI   PFFFFFFN FF  PPPSSSS   PSFRSE     SP 
 * NFFN          EFT     FFFUU FFFFFFFFFFFFEUUEFI   FFFFFFF  FFU UUUFFFFFT  NIUUUSFFFFFFN FF     FFFF   NFFFFSUUU TFN 
 * NFFN          EFT     FFFRRT RFFFFFFFFFFFRRITPRRRFFFFFET  TTRRRRRFFFPT   UPRRRFFFFFRTU FF   RRFFFFRT NFFFFFRRRRRFN 
 * INNS          TNT     NNNNN  INNNNNNNNNNNNNS TNNNNNNNNU     NNNNNNNNT     TNNNNNNNNI   NN   NNNNNNNT INNNNNNNNNNNI 
 *
 * 
 * NOPATTERN STUDIO & CHAIN/SAW ARE PLEASED TO PRESENT INFINITE PRESSURE: AN NFT EXHIBITION OF 99 NEW DIGITAL ARTWORKS 
 * BY CHUCK ANDERSON FEATURING 90 SOLO WORKS + 9 COLLABORATIONS:
 *  
 *   GREMPLIN...................(TOKENID: 10)
 *   CASE SIMMONS...............(TOKENID: 20)
 *   MALAAVIDAA.................(TOKENID: 30)
 *   OSEANWORLD.................(TOKENID: 40) 
 *   EZRA MILLER................(TOKENID: 50)
 *   JEN STARK..................(TOKENID: 60)
 *   CHRISTIAN REX VAN MINNEN...(TOKENID: 70)
 *   JOSHUA DAVIS...............(TOKENID: 80)  
 *   IX SHELLS..................(TOKENID: 90)
 */

error MetadataFrozen();

contract InfinitePressure is ERC721, Ownable {    
  using Strings for uint256;

  string public _ipfsCID;
  string public _baseTokenURI = "ipfs://";
  bool public _metadataFrozen = false;  

  event PermanentURI(string _value, uint256 indexed _id);
  
  constructor(string memory ipfsCID, address auctionHouseAddress) 
    ERC721("INFINITE PRESSURE by Chuck Anderson", "INFPSR") 
  {    
    _ipfsCID = ipfsCID;
    for (uint8 i = 1; i <= 99; i++) {
      _safeMint(msg.sender, i);
    }    
    // Authorize CHAIN/SAW AuctionHouse
    setApprovalForAll(auctionHouseAddress, true);
  }

  function tokenURI(uint256 tokenId)
      public
      view
      override(ERC721)
      returns (string memory)
  {
    return string(abi.encodePacked(_baseTokenURI, _ipfsCID, "/", tokenId.toString(), ".json"));
  }

  function _baseURI() 
    internal 
    view 
    virtual 
    override 
    returns (string memory) 
  {
    return _baseTokenURI;
  }

  function setBaseURI(string calldata baseTokenURI) public onlyOwner {
    _baseTokenURI = baseTokenURI;
  }

  function updateCID(string calldata newCID) public onlyOwner {
    if (_metadataFrozen) revert MetadataFrozen();
      _ipfsCID = newCID;
  }

  /// @dev - Irrevocably freeze metadata and emit event to tell the world
  function freezeMetadata () public onlyOwner {
    _metadataFrozen = true;
    for (uint i = 1; i <= 99; i++) {
      emit PermanentURI(tokenURI(i), i);
    }
  }

  function burn(uint256 tokenId) public virtual {
    require(_isApprovedOrOwner(msg.sender, tokenId), "caller is not owner nor approved");
    _burn(tokenId);
  }
}