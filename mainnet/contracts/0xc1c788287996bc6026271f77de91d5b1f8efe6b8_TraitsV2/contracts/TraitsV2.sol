// SPDX-License-Identifier: MIT LICENSE


/**
       .     '     ,      '     ,     .     '   .    
      _________        _________       _________    
   _ /_|_____|_\ _  _ /_|_____|_\ _ _ /_|_____|_\ _ 
     '. \   / .'      '. \   / .'     '. \   / .'   
       '.\ /.'          '.\ /.'         '.\ /.'     
         '.'              '.'             '.'
 
 ██████╗ ██╗ █████╗ ███╗   ███╗ ██████╗ ███╗   ██╗██████╗  
 ██╔══██╗██║██╔══██╗████╗ ████║██╔═══██╗████╗  ██║██╔══██╗ 
 ██║  ██║██║███████║██╔████╔██║██║   ██║██╔██╗ ██║██║  ██║ 
 ██║  ██║██║██╔══██║██║╚██╔╝██║██║   ██║██║╚██╗██║██║  ██║ 
 ██████╔╝██║██║  ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██████╔╝ 
 ╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝  
           ██╗  ██╗███████╗██╗███████╗████████╗
           ██║  ██║██╔════╝██║██╔════╝╚══██╔══╝   <'l    
      __   ███████║█████╗  ██║███████╗   ██║       ll    
 (___()'`; ██╔══██║██╔══╝  ██║╚════██║   ██║       llama~
 /,    /`  ██║  ██║███████╗██║███████║   ██║       || || 
 \\"--\\   ╚═╝  ╚═╝╚══════╝╚═╝╚══════╝   ╚═╝       '' '' 

*/

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./interfaces/ITraits.sol";
import "./interfaces/IDiamondHeist.sol";

contract TraitsV2 is Ownable, ITraits {
  using Strings for uint256;

  // struct to store each trait's data for metadata and rendering
  struct Trait {
    string name;
    string png;
  }

  // mapping from trait type (index) to its name
  string[9] _traitTypes = [
    "Body",
    "Hat",
    "Eye",
    "Mouth",
    "Clothes",
    "Tail",
    "Alpha"
  ];

  // storage of each traits name and base64 PNG data
  mapping(uint8 => mapping(uint8 => Trait)) public traitData;
  // mapping from alphaIndex to its score
  string[4] _alphas = [
    "8",
    "7",
    "6",
    "5"
  ];

  IDiamondHeist public diamondheist;

  string private llamaDescription;
  string private dogDescription;

  constructor() {}

  /** ADMIN */

  function setGame(address _diamondheist) external onlyOwner {
    diamondheist = IDiamondHeist(_diamondheist);
  }

  /**
   * administrative to upload the names and images associated with each trait
   * @param traitType the trait type to upload the traits for (see traitTypes for a mapping)
   * @param traits the names and base64 encoded PNGs for each trait
   */
  function uploadTraits(uint8 traitType, uint8[] calldata traitIds, Trait[] calldata traits) external onlyOwner {
    require(traitIds.length == traits.length, "Mismatched inputs");
    for (uint i = 0; i < traits.length; i++) {
      traitData[traitType][traitIds[i]] = Trait(
        traits[i].name,
        traits[i].png
      );
    }
  }

  /** RENDER */

  /**
   * generates an <image> element using base64 encoded PNGs
   * @param trait the trait storing the PNG data
   * @return the <image> element
   */
  function drawTrait(Trait memory trait) internal pure returns (string memory) {
    return string(abi.encodePacked(
      '<image x="4" y="4" width="32" height="32" image-rendering="pixelated" preserveAspectRatio="xMidYMid" xlink:href="data:image/png;base64,',
      trait.png,
      '"/>'
    ));
  }

  /**
   * generates an entire SVG by composing multiple <image> elements of PNGs
   * @param tokenId the ID of the token to generate an SVG for
   * @return a valid SVG of the Llama / Dog
   */
  function drawSVG(uint256 tokenId) public view returns (string memory) {
    IDiamondHeist.LlamaDog memory s = diamondheist.getTokenTraits(tokenId);
    uint8 shift = s.isLlama ? 0 : 7;

    string memory svgString = string(abi.encodePacked(
      drawTrait(traitData[0 + shift][s.body]),
      drawTrait(traitData[1 + shift][s.hat]),
      drawTrait(traitData[2 + shift][s.eye]),
      drawTrait(traitData[3 + shift][s.mouth]),
      drawTrait(traitData[4 + shift][s.clothes]),
      drawTrait(traitData[5 + shift][s.tail])
    ));

    return string(abi.encodePacked(
      '<svg id="diamondheist" width="100%" height="100%" version="1.1" viewBox="0 0 40 40" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">',
      svgString,
      "</svg>"
    ));
  }

  /**
   * generates an attribute for the attributes array in the ERC721 metadata standard
   * @param traitType the trait type to reference as the metadata key
   * @param value the token's trait associated with the key
   * @return a JSON dictionary for the single attribute
   */
  function attributeForTypeAndValue(string memory traitType, string memory value) internal pure returns (string memory) {
    return string(abi.encodePacked(
      '{"trait_type":"',
      traitType,
      '","value":"',
      value,
      '"}'
    ));
  }

  /**
   * generates an attribute for the attributes array in the ERC721 metadata standard
   * @param traitType the trait type to reference as the metadata key
   * @param value the token's trait associated with the key
   * @return a JSON dictionary for the single attribute
   */
  function attributeForTypeAndValueNumber(string memory traitType, string memory value) internal pure returns (string memory) {
    return string(abi.encodePacked(
      '{"display_type": "number", "trait_type":"',
      traitType,
      '","value":',
      value,
      '}'
    ));
  }

  function getGen(uint256 tokenId) internal pure returns (string memory) {
        if (tokenId <= 7500) return "Gen 0";
        if (tokenId <= 15000) return "Gen 1";
        if (tokenId <= 22500) return "Gen 2";
        if (tokenId <= 30000) return "Gen 3";
        return "Gen 4";
    }

  /**
   * generates an array composed of all the individual traits and values
   * @param tokenId the ID of the token to compose the metadata for
   * @return a JSON array of all of the attributes for given token ID
   */
  function compileAttributes(uint256 tokenId) public view returns (string memory) {
    IDiamondHeist.LlamaDog memory s = diamondheist.getTokenTraits(tokenId);
    string memory traits;
    if (s.isLlama) {
      traits = string(abi.encodePacked(
        attributeForTypeAndValue(_traitTypes[0], traitData[0][s.body].name),",",
        attributeForTypeAndValue(_traitTypes[1], traitData[1][s.hat].name),",",
        attributeForTypeAndValue(_traitTypes[2], traitData[2][s.eye].name),",",
        attributeForTypeAndValue(_traitTypes[3], traitData[3][s.mouth].name),",",
        attributeForTypeAndValue(_traitTypes[4], traitData[4][s.clothes].name),",",
        attributeForTypeAndValue(_traitTypes[5], traitData[5][s.tail].name),","
        // traitData 6 = alpha score, but not visible
      ));
    } else {
      traits = string(abi.encodePacked(
        attributeForTypeAndValue(_traitTypes[0], traitData[7][s.body].name),",",
        attributeForTypeAndValue(_traitTypes[1], traitData[8][s.hat].name),",",
        attributeForTypeAndValue(_traitTypes[2], traitData[9][s.eye].name),",",
        attributeForTypeAndValue(_traitTypes[3], traitData[10][s.mouth].name),",",
        attributeForTypeAndValue(_traitTypes[4], traitData[11][s.clothes].name),",",
        attributeForTypeAndValue(_traitTypes[5], traitData[12][s.tail].name),",",
        attributeForTypeAndValueNumber("Sneaky Score", _alphas[s.alphaIndex]),","
      ));
    }
    return string(abi.encodePacked(
      '[',
      traits,
      '{"trait_type":"Generation","value":"',
      getGen(tokenId),
      '"},{"trait_type":"Type","value":',
      s.isLlama ? '"Llama"' : '"Dog"',
      '}]'
    ));
  }

  /**
   * generates a base64 encoded metadata response without referencing off-chain content
   * @param tokenId the ID of the token to generate the metadata for
   * @return a base64 encoded JSON dictionary of the token's metadata and SVG
   */
  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    IDiamondHeist.LlamaDog memory s = diamondheist.getTokenTraits(tokenId);

    string memory metadata = string(abi.encodePacked(
      '{"name": "',
      s.isLlama ? 'Llama #' : 'Dog #',
      tokenId.toString(),
      '", "description": "',
      s.isLlama ? llamaDescription : dogDescription,
      '", "image": "data:image/svg+xml;base64,',
      base64(bytes(drawSVG(tokenId))),
      '", "attributes":',
      compileAttributes(tokenId),
      "}"
    ));

    return string(abi.encodePacked(
      "data:application/json;base64,",
      base64(bytes(metadata))
    ));
  }

  function setDescription(string memory _llama, string memory _dog) external onlyOwner {
    llamaDescription = _llama;
    dogDescription = _dog;
  }

  /** BASE 64 - Written by Brech Devos */
  
  string internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

  function base64(bytes memory data) internal pure returns (string memory) {
    if (data.length == 0) return "";
    
    // load the table into memory
    string memory table = TABLE;

    // multiply by 4/3 rounded up
    uint256 encodedLen = 4 * ((data.length + 2) / 3);

    // add some extra buffer at the end required for the writing
    string memory result = new string(encodedLen + 32);

    assembly {
      // set the actual output length
      mstore(result, encodedLen)
      
      // prepare the lookup table
      let tablePtr := add(table, 1)
      
      // input ptr
      let dataPtr := data
      let endPtr := add(dataPtr, mload(data))
      
      // result ptr, jump over length
      let resultPtr := add(result, 32)
      
      // run over the input, 3 bytes at a time
      for {} lt(dataPtr, endPtr) {}
      {
          dataPtr := add(dataPtr, 3)
          
          // read 3 bytes
          let input := mload(dataPtr)
          
          // write 4 characters
          mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
          resultPtr := add(resultPtr, 1)
          mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
          resultPtr := add(resultPtr, 1)
          mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
          resultPtr := add(resultPtr, 1)
          mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
          resultPtr := add(resultPtr, 1)
      }
      
      // padding with '='
      switch mod(mload(data), 3)
      case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
      case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
    }
    
    return result;
  }
}