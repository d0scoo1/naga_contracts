// SPDX-License-Identifier: MIT

/**
* Author: Lambdalf the White
*/

pragma solidity 0.8.10;

import "./IERC721Metadata.sol";
import "./IERC721Receiver.sol";
import "./Context.sol";

/**
* @dev Required interface of an ERC721 compliant contract.
*/
abstract contract ERC721Batch is Context, IERC721Metadata {
  /**
  * @dev See EIP2309 https://eips.ethereum.org/EIPS/eip-2309
  */
  event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);

  // Errors
  error IERC721_APPROVE_OWNER();
  error IERC721_APPROVE_CALLER();
  error IERC721_CALLER_NOT_APPROVED();
  error IERC721_NONEXISTANT_TOKEN();
  error IERC721_NULL_ADDRESS_BALANCE();
  error IERC721_NULL_ADDRESS_TRANSFER();
  error IERC721_NON_ERC721_RECEIVER();

  // Token name
  string private _name;

  // Token symbol
  string private _symbol;

  // Token Base URI
  string private _baseURI;

  // Token IDs
  uint256 private _numTokens;

  // List of owner addresses
  mapping( uint256 => address ) private _owners;

  // Mapping from token ID to approved address
  mapping( uint256 => address ) private _tokenApprovals;

  // Mapping from owner to operator approvals
  mapping( address => mapping( address => bool ) ) private _operatorApprovals;

  /**
  * @dev Ensures the token exist. 
  * A token exists if it has been minted and is not owned by the null address.
  * 
  * @param tokenId_ uint256 ID of the token to verify
  */
  modifier exists( uint256 tokenId_ ) {
    if ( ! _exists( tokenId_ ) ) {
      revert IERC721_NONEXISTANT_TOKEN();
    }
    _;
  }

  /**
  * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
  */
  function _initERC721BatchMetadata( string memory name_, string memory symbol_ ) internal {
    _name   = name_;
    _symbol = symbol_;
  }

  /**
  * @dev Mints `qty_` tokens into `to_`.
  * 
  * This internal function can be used to perform token minting.
  * 
  * Emits a {ConsecutiveTransfer} event.
  */
  function _mint( address to_, uint256 qty_ ) internal virtual {
    _owners[ _numTokens ] = to_;
    uint256 _lastToken_ = _numTokens + qty_ - 1;
    if ( _lastToken_ != _numTokens ) {
      _owners[ _lastToken_ ] = to_;
    }
    emit ConsecutiveTransfer( _numTokens, _lastToken_, address( 0 ), to_ );
    _numTokens = _lastToken_ + 1;
  }

  /**
  * @dev Internal function used to set the base URI of the collection.
  */
  function _setBaseURI( string memory baseURI_ ) internal virtual {
    _baseURI = baseURI_;
  }

  /**
  * @dev Transfers `tokenId_` from `from_` to `to_`.
  *
  * This internal function can be used to implement alternative mechanisms to perform 
  * token transfer, such as signature-based, or token burning.
  * 
  * Emits a {Transfer} event.
  */
  function _transfer( address from_, address to_, uint256 tokenId_ ) internal virtual {
    _tokenApprovals[ tokenId_ ] = address( 0 );
    uint256 _previousId_ = tokenId_ - 1;
    uint256 _nextId_     = tokenId_ + 1;
    bool _previousShouldUpdate_ = _exists( _previousId_ ) &&
                                  _owners[ _previousId_ ] == address( 0 );
    bool _nextShouldUpdate_ = _exists( _nextId_ ) &&
                              _owners[ _nextId_ ] == address( 0 );

    if ( _previousShouldUpdate_ ) {
      _owners[ _previousId_ ] = from_;
    }

    if ( _nextShouldUpdate_ ) {
      _owners[ _nextId_ ] = from_;
    }

    _owners[ tokenId_ ] = to_;

    emit Transfer( from_, to_, tokenId_ );
  }

  /**
  * @dev See {IERC721-approve}.
  */
  function approve( address to_, uint256 tokenId_ ) external virtual exists( tokenId_ ) {
    address _operator_ = _msgSender();
    address _tokenOwner_ = _ownerOf( tokenId_ );
    bool _isApproved_ = _isApprovedOrOwner( _tokenOwner_, _operator_, tokenId_ );

    if ( ! _isApproved_ ) {
      revert IERC721_CALLER_NOT_APPROVED();
    }

    if ( to_ == _tokenOwner_ ) {
      revert IERC721_APPROVE_OWNER();
    }

    _tokenApprovals[ tokenId_ ] = to_;
    emit Approval( _tokenOwner_, to_, tokenId_ );
  }

  /**
  * @dev See {IERC721-safeTransferFrom}.
  * 
  * Note: We can ignore `from_` as we can compare everything to the actual token owner, 
  * but we cannot remove this parameter to stay in conformity with IERC721
  */
  function safeTransferFrom( address from_, address to_, uint256 tokenId_ ) external virtual exists( tokenId_ ) {
    address _operator_ = _msgSender();
    address _tokenOwner_ = _ownerOf( tokenId_ );
    bool _isApproved_ = _isApprovedOrOwner( _tokenOwner_, _operator_, tokenId_ );

    if ( ! _isApproved_ ) {
      revert IERC721_CALLER_NOT_APPROVED();
    }

    if ( to_ == address( 0 ) ) {
      revert IERC721_NULL_ADDRESS_TRANSFER();
    }

    _transfer( _tokenOwner_, to_, tokenId_ );

    if ( ! _checkOnERC721Received( _tokenOwner_, to_, tokenId_, "" ) ) {
      revert IERC721_NON_ERC721_RECEIVER();
    }
  }

  /**
  * @dev See {IERC721-safeTransferFrom}.
  * 
  * Note: We can ignore `from_` as we can compare everything to the actual token owner, 
  * but we cannot remove this parameter to stay in conformity with IERC721
  */
  function safeTransferFrom( address from_, address to_, uint256 tokenId_, bytes calldata data_ ) external virtual exists( tokenId_ ) {
    address _operator_ = _msgSender();
    address _tokenOwner_ = _ownerOf( tokenId_ );
    bool _isApproved_ = _isApprovedOrOwner( _tokenOwner_, _operator_, tokenId_ );

    if ( ! _isApproved_ ) {
      revert IERC721_CALLER_NOT_APPROVED();
    }

    if ( to_ == address( 0 ) ) {
      revert IERC721_NULL_ADDRESS_TRANSFER();
    }

    _transfer( _tokenOwner_, to_, tokenId_ );

    if ( ! _checkOnERC721Received( _tokenOwner_, to_, tokenId_, data_ ) ) {
      revert IERC721_NON_ERC721_RECEIVER();
    }
  }

  /**
  * @dev See {IERC721-setApprovalForAll}.
  */
  function setApprovalForAll( address operator_, bool approved_ ) public virtual override {
    address _account_ = _msgSender();
    if ( operator_ == _account_ ) {
      revert IERC721_APPROVE_CALLER();
    }

    _operatorApprovals[ _account_ ][ operator_ ] = approved_;
    emit ApprovalForAll( _account_, operator_, approved_ );
  }

  /**
  * @dev See {IERC721-transferFrom}.
  * 
  * Note: We can ignore `from_` as we can compare everything to the actual token owner, 
  * but we cannot remove this parameter to stay in conformity with IERC721
  */
  function transferFrom( address from_, address to_, uint256 tokenId_ ) external virtual exists( tokenId_ ) {
    address _operator_ = _msgSender();
    address _tokenOwner_ = _ownerOf( tokenId_ );
    bool _isApproved_ = _isApprovedOrOwner( _tokenOwner_, _operator_, tokenId_ );

    if ( ! _isApproved_ ) {
      revert IERC721_CALLER_NOT_APPROVED();
    }

    if ( to_ == address( 0 ) ) {
      revert IERC721_NULL_ADDRESS_TRANSFER();
    }

    _transfer( _tokenOwner_, to_, tokenId_ );
  }

  /**
  * @dev Internal function returning the number of tokens in `tokenOwner_`'s account.
  */
  function _balanceOf( address tokenOwner_ ) internal view virtual returns ( uint256 balance ) {
    if ( tokenOwner_ == address( 0 ) ) {
      return 0;
    }

    uint256 _supplyMinted_ = _supplyMinted();
    uint256 _count_ = 0;
    address _currentTokenOwner_;
    for ( uint256 i; i < _supplyMinted_; i++ ) {
      if ( _exists( i ) ) {
        if ( _owners[ i ] != address( 0 ) ) {
          _currentTokenOwner_ = _owners[ i ];
        }
        if ( tokenOwner_ == _currentTokenOwner_ ) {
          _count_++;
        }
      }
    }
    return _count_;
  }

  /**
  * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
  * The call is not executed if the target address is not a contract.
  *
  * @param from_ address representing the previous owner of the given token ID
  * @param to_ target address that will receive the tokens
  * @param tokenId_ uint256 ID of the token to be transferred
  * @param data_ bytes optional data to send along with the call
  * @return bool whether the call correctly returned the expected magic value
  */
  function _checkOnERC721Received( address from_, address to_, uint256 tokenId_, bytes memory data_ ) internal virtual returns ( bool ) {
    // This method relies on extcodesize, which returns 0 for contracts in
    // construction, since the code is only stored at the end of the
    // constructor execution.
    // 
    // IMPORTANT
    // It is unsafe to assume that an address not flagged by this method
    // is an externally-owned account (EOA) and not a contract.
    //
    // Among others, the following types of addresses will not be flagged:
    //
    //  - an externally-owned account
    //  - a contract in construction
    //  - an address where a contract will be created
    //  - an address where a contract lived, but was destroyed
    uint256 _size_;
    assembly {
      _size_ := extcodesize( to_ )
    }

    // If address is a contract, check that it is aware of how to handle ERC721 tokens
    if ( _size_ > 0 ) {
      try IERC721Receiver( to_ ).onERC721Received( _msgSender(), from_, tokenId_, data_ ) returns ( bytes4 retval ) {
        return retval == IERC721Receiver.onERC721Received.selector;
      }
      catch ( bytes memory reason ) {
        if ( reason.length == 0 ) {
          revert IERC721_NON_ERC721_RECEIVER();
        }
        else {
          assembly {
            revert( add( 32, reason ), mload( reason ) )
          }
        }
      }
    }
    else {
      return true;
    }
  }

  /**
  * @dev Internal function returning whether a token exists. 
  * A token exists if it has been minted and is not owned by the null address.
  * 
  * @param tokenId_ uint256 ID of the token to verify
  * 
  * @return bool whether the token exists
  */
  function _exists( uint256 tokenId_ ) internal view virtual returns ( bool ) {
    return tokenId_ < _numTokens;
  }

  /**
  * @dev Internal function returning whether `operator_` is allowed 
  * to manage tokens on behalf of `tokenOwner_`.
  * 
  * @param tokenOwner_ address that owns tokens
  * @param operator_ address that tries to manage tokens
  * 
  * @return bool whether `operator_` is allowed to handle the token
  */
  function _isApprovedForAll( address tokenOwner_, address operator_ ) internal view virtual returns ( bool ) {
    return _operatorApprovals[ tokenOwner_ ][ operator_ ];
  }

  /**
  * @dev Internal function returning whether `operator_` is allowed to handle `tokenId_`
  * 
  * Note: To avoid multiple checks for the same data, it is assumed that existence of `tokeId_` 
  * has been verified prior via {_exists}
  * If it hasn't been verified, this function might panic
  * 
  * @param operator_ address that tries to handle the token
  * @param tokenId_ uint256 ID of the token to be handled
  * 
  * @return bool whether `operator_` is allowed to handle the token
  */
  function _isApprovedOrOwner( address tokenOwner_, address operator_, uint256 tokenId_ ) internal view virtual returns ( bool ) {
    bool _isApproved_ = operator_ == tokenOwner_ ||
                        operator_ == _tokenApprovals[ tokenId_ ] ||
                        _isApprovedForAll( tokenOwner_, operator_ );
    return _isApproved_;
  }

  /**
  * @dev Internal function returning the owner of the `tokenId_` token.
  * 
  * @param tokenId_ uint256 ID of the token to verify
  * 
  * @return address the address of the token owner
  */
  function _ownerOf( uint256 tokenId_ ) internal view virtual returns ( address ) {
    uint256 _tokenId_ = tokenId_;
    address _tokenOwner_ = _owners[ tokenId_ ];
    while ( _tokenOwner_ == address( 0 ) ) {
      _tokenId_ --;
      _tokenOwner_ = _owners[ _tokenId_ ];
    }

    return _tokenOwner_;
  }

  /**
  * @dev Internal function returning the total number of tokens minted
  * 
  * @return uint256 the number of tokens that have been minted so far
  */
  function _supplyMinted() internal view virtual returns ( uint256 ) {
    return _numTokens;
  }

  /**
  * @dev Converts a `uint256` to its ASCII `string` decimal representation.
  */
  function _toString( uint256 value ) internal pure returns ( string memory ) {
    // Inspired by OraclizeAPI's implementation - MIT licence
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
    if ( value == 0 ) {
      return "0";
    }
    uint256 temp = value;
    uint256 digits;
    while ( temp != 0 ) {
      digits ++;
      temp /= 10;
    }
    bytes memory buffer = new bytes( digits );
    while ( value != 0 ) {
      digits -= 1;
      buffer[ digits ] = bytes1( uint8( 48 + uint256( value % 10 ) ) );
      value /= 10;
    }
    return string( buffer );
  }

  /**
  * @dev Returns the number of tokens in `tokenOwner_`'s account.
  */
  function balanceOf( address tokenOwner_ ) external view virtual returns ( uint256 balance ) {
    return _balanceOf( tokenOwner_ );
  }

  /**
  * @dev Returns the account approved for `tokenId_` token.
  *
  * Requirements:
  *
  * - `tokenId_` must exist.
  */
  function getApproved( uint256 tokenId_ ) external view virtual exists( tokenId_ ) returns ( address operator ) {
    return _tokenApprovals[ tokenId_ ];
  }

  /**
  * @dev Returns if the `operator_` is allowed to manage all of the assets of `tokenOwner_`.
  *
  * See {setApprovalForAll}
  */
  function isApprovedForAll( address tokenOwner_, address operator_ ) external view virtual returns ( bool ) {
    return _isApprovedForAll( tokenOwner_, operator_ );
  }

  /**
  * @dev See {IERC721Metadata-name}.
  */
  function name() public view virtual override returns ( string memory ) {
    return _name;
  }

  /**
  * @dev Returns the owner of the `tokenId_` token.
  *
  * Requirements:
  *
  * - `tokenId_` must exist.
  */
  function ownerOf( uint256 tokenId_ ) external view virtual exists( tokenId_ ) returns ( address owner ) {
    return _ownerOf( tokenId_ );
  }

  /**
  * @dev See {IERC165-supportsInterface}.
  */
  function supportsInterface( bytes4 interfaceId_ ) public view virtual override returns ( bool ) {
    return 
      interfaceId_ == type( IERC721Metadata ).interfaceId ||
      interfaceId_ == type( IERC721 ).interfaceId ||
      interfaceId_ == type( IERC165 ).interfaceId;
  }

  /**
  * @dev See {IERC721Metadata-symbol}.
  */
  function symbol() public view virtual override returns ( string memory ) {
    return _symbol;
  }

  /**
  * @dev See {IERC721Metadata-tokenURI}.
  */
  function tokenURI( uint256 tokenId_ ) public view virtual override exists( tokenId_ ) returns ( string memory ) {
    return bytes( _baseURI ).length > 0 ? string( abi.encodePacked( _baseURI, _toString( tokenId_ ) ) ) : _toString( tokenId_ );
  }
}
