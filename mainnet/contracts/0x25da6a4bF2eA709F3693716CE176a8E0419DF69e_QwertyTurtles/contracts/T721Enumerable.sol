// SPDX-License-Identifier: BSD-3-Clause

pragma solidity ^0.8.0;

/********************************
 * @author: squeebo_nft         *
 *   Blimpie provides low-gas   *
 *       mints + transfers      *
 ********************************/

import "../openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "../contracts/T721.sol";

abstract contract T721Enumerable is T721, IERC721Enumerable {
  function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, T721) returns( bool isSupported ){
    return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
  }

  function tokenOfOwnerByIndex(address owner, uint index) external view override returns( uint tokenId ){
    uint count;
    for( uint i; i < tokens.length; ++i ){
      if( owner == tokens[i].owner ){
        if( count == index )
          return i;
        else
          ++count;
      }
    }

    revert( "T721Enumerable: owner index out of bounds" );
  }

  //TODO: skip burned
  function tokenByIndex(uint index) external view override returns( uint tokenId ){
    require(index < tokens.length, "T721Enumerable: query for nonexistent token");
    return index;
  }
}
