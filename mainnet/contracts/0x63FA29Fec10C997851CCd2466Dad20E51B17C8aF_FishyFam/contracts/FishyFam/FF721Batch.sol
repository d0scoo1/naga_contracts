
// SPDX-License-Identifier: BSD-3-Clause

pragma solidity ^0.8.0;

/****************************************
 * @author: squeebo_nft                 *
 ****************************************
 *   Blimpie-FF721 provides low-gas     *
 *       mints + transfers              *
 ****************************************/

import "../Blimpie/IERC721Batch.sol";
import "./FF721Enumerable.sol";

abstract contract FF721Batch is FF721Enumerable, IERC721Batch {
  function isOwnerOf( address account, uint[] calldata tokenIds ) external view override returns( bool ){
    for(uint i; i < tokenIds.length; ++i ){
      if( account != tokens[ tokenIds[i] ].owner )
        return false;
    }

    return true;
  }

  function transferBatch( address from, address to, uint[] calldata tokenIds, bytes calldata data ) external override{
    for(uint i; i < tokenIds.length; ++i ){
      safeTransferFrom( from, to, tokenIds[i], data );
    }
  }

  function walletOfOwner( address account ) public view override returns( uint[] memory wallet ){
    uint count;
    uint quantity = balanceOf( account );
    wallet = new uint[]( quantity );
    for( uint i; i < tokens.length; ++i ){
      if( account == tokens[i].owner ){
        wallet[ count++ ] = i;
        if( count == quantity )
          break;
      }
    }
    return wallet;
  }
}