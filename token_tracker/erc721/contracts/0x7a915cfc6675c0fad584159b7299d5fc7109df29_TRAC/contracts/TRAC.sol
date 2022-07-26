//  _________  _________   _______  __________
// /__     __\|    _____) /   .   \/    _____/
//    |___|   |___|\____\/___/ \___\________\

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";

import "./ITRACSerums.sol";
import "./ICREDIT.sol";

contract TRAC is ERC721EnumerableUpgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
  using AddressUpgradeable for address;

  uint16 constant public MAX_SUPPLY = 8888;

  bool public claimActive;
  ITRACSerums private _serums;

  uint16 public minted;

  struct TokenTime { uint16 token; uint48 timestamp; }
  struct OwnerTime { address owner; uint48 timestamp; }

  mapping(uint16 => OwnerTime) private _transfers;
  mapping(uint16 => OwnerTime) private _minters;
  mapping(address => uint16) private _balance;

  mapping(uint256 => address) private _tokenApprovals;

  mapping(uint256 => uint64[]) private __;
  ICREDIT private _credit;
  address private _verifier;
  mapping(uint256 => uint64[3]) private _metadataKeys;

  function initialize(address serums) public initializer {
    __ERC721_init("Teen Rebel Ape Club", "TRAC");
    __ERC721Enumerable_init_unchained();
    __Ownable_init_unchained();
    __ReentrancyGuard_init_unchained();

    _serums = ITRACSerums(serums);
  }

  function toggleClaims() external onlyOwner {
    claimActive = !claimActive;
  }

  /**
   * @dev Claim your milk serums!
   */
  function claim(uint256[] calldata ids, uint256[] calldata amounts) external nonReentrant {
    address to = msg.sender;
    require(tx.origin == to, "eos only");
    require(claimActive || to == owner(), "not active");
    require(ids.length == amounts.length, "invalid params");

    uint256 amount;
    for (uint8 i; i < amounts.length; i++) {
      amount += amounts[i];
    }

    uint256 tokenId = minted + 1;
    uint256 endTokenId = minted + amount;
    require(endTokenId <= MAX_SUPPLY, "supply exhausted");

    _minters[uint16(tokenId)] = OwnerTime(to, uint48(block.timestamp));
    _balance[to] += uint16(amount);
    minted = uint16(endTokenId);

    _serums.burnBatch(to, ids, amounts);

    for (; tokenId <= endTokenId; tokenId++) {
      emit Transfer(address(0), to, tokenId);
      require(
        __checkOnERC721Received(address(0), to, tokenId, ""),
        "ERC721A: transfer to non ERC721Receiver implementer"
      );
    }
  }

  /**
   * @dev Transfers `tokenId` from `from` to `to`.
   */
  function _transfer(address from, address to, uint256 tokenId) internal override {
    require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
    require(to != address(0), "ERC721: transfer to the zero address");

    // Clear approvals from the previous owner
    _approve(address(0), tokenId);

    _balance[from] -= 1;
    _balance[to] += 1;
    _transfers[uint16(tokenId)] = OwnerTime(to, uint48(block.timestamp));

    emit Transfer(from, to, tokenId);
  }

  /**
   * @dev Retrieve a list of owner and vesting start times for each token.
   */
  function ownerTimesOf(uint16[] memory tokens) public view returns (OwnerTime[] memory ownerTimes) {
    ownerTimes = new OwnerTime[](tokens.length);
    uint16 id;
    for (uint16 i; i < tokens.length; i++) {
      id = tokens[i];
      if (_transfers[id].owner != address(0)) {
        ownerTimes[i] = _transfers[id];
      } else {
        for (; id > 0; id--) {
          if (_minters[id].owner != address(0)) {
            ownerTimes[i] = _minters[id];
            break;
          }
        }
      }
    }
  }

  /**
   * @dev Retrieve the owner and vesting start times for the given token.
   */
  function _ownerTimeOf(uint16 token) private view returns (OwnerTime memory ownerTime) {
    if (_transfers[token].owner != address(0)) {
      return _transfers[token];
    } else {
      for (; token > 0; token--) {
        if (_minters[token].owner != address(0)) {
          return _minters[token];
        }
      }
    }
  }

  /**
   * @dev Helper method to serve both {tokensOf} and {tokenOfOwnerByIndex}
   */
  function _tokensOfOwnerUpToAmount(address account, uint256 amount) private view returns (TokenTime[] memory tokenTimes) {
    uint16 i;
    tokenTimes = new TokenTime[](amount);
    OwnerTime memory minterTime;
    for (uint16 token = 1; token <= minted; token++) {
      if (_minters[token].owner != address(0)) {
        minterTime = _minters[token];
      }
      if (_transfers[token].owner != address(0)) {
        if (_transfers[token].owner == account) {
          tokenTimes[i++] = TokenTime(token, _transfers[token].timestamp);
          if (i == amount) {
            return tokenTimes;
          }
        }
      } else if (minterTime.owner == account) {
        tokenTimes[i++] = TokenTime(token, minterTime.timestamp);
        if (i == amount) {
          return tokenTimes;
        }
      }
    }
  }

  /**
   * @dev Retrieve a list of owned tokens and vensting start times for each token.
   */
  function tokenTimesOf(address account) external view returns (TokenTime[] memory tokenTimes) {
    if (_balance[account] == 0) {
      tokenTimes = new TokenTime[](0);
    } else {
      return _tokensOfOwnerUpToAmount(account, _balance[account]);
    }
  }

  /**
   * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
   */
  function tokenOfOwnerByIndex(address account, uint256 index) public view override returns (uint256) {
    require(_balance[account] > 0, "no tokens");
    require(index < _balance[account], "exceeds boundary");
    return uint256(_tokensOfOwnerUpToAmount(account, index + 1)[index].token);
  }

  /**
   * @dev See {IERC721-ownerOf}.
   */
  function ownerOf(uint256 tokenId) public view override returns (address) {
    require(_exists(tokenId), "nonexistent");

    uint16 id = uint16(tokenId);
    address owner = _transfers[id].owner;
    if (owner != address(0)) {
      return owner;
    }
 
    for (; id > 0; id--) {
      owner = _minters[id].owner;
      if (owner != address(0)) {
        return owner;
      }
    }

    revert("unable to find owner");
  }

  /**
   * @dev See {IERC721-balanceOf}.
   */
  function balanceOf(address owner) public view override returns (uint256) {
    require(owner != address(0), "ERC721: transfer to the zero address");
    return uint256(_balance[owner]);
  }

  /**
   * @dev See {IERC721Enumerable-totalSupply}.
   */
  function totalSupply() public view override returns (uint256) {
    return minted;
  }

  /**
   * @dev See {IERC721-approve}.
   */
  function approve(address to, uint256 tokenId) public override {
    address owner = ownerOf(tokenId);
    require(to != owner, "ERC721: approval to current owner");

    require(
      _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
      "ERC721: approve caller is not owner nor approved for all"
    );

    _approve(to, tokenId);
  }

  /**
   * @dev See {IERC721-getApproved}.
   */
  function getApproved(uint256 tokenId) public view override returns (address) {
    require(_exists(tokenId), "ERC721: approved query for nonexistent token");

    return _tokenApprovals[tokenId];
  }

  /**
   * @dev Returns whether `spender` is allowed to manage `tokenId`.
   */
  function _isApprovedOrOwner(address spender, uint256 tokenId) internal view override returns (bool) {
    require(_exists(tokenId), "ERC721: operator query for nonexistent token");
    address owner = ownerOf(tokenId);
    return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
  }

  /**
   * @dev Approve `to` to operate on `tokenId`
   */
  function _approve(address to, uint256 tokenId) internal override {
    _tokenApprovals[tokenId] = to;
    emit Approval(ownerOf(tokenId), to, tokenId);
  }

  /**
   * @dev Returns whether `tokenId` exists.
   */
  function _exists(uint256 tokenId) internal view override returns (bool) {
    return tokenId > 0 && tokenId <= minted;
  }

  /**
   * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
   */
  function __checkOnERC721Received(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) internal returns (bool) {
    if (to.isContract()) {
      try IERC721ReceiverUpgradeable(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
        return retval == IERC721ReceiverUpgradeable.onERC721Received.selector;
      } catch (bytes memory reason) {
        if (reason.length == 0) {
          revert("ERC721: transfer to non ERC721Receiver implementer");
        } else {
          assembly {
            revert(add(32, reason), mload(reason))
          }
        }
      }
    } else {
      return true;
    }
  }

  /**
   * @dev Internal override for URI.
   */
  function _baseURI() internal pure override returns (string memory) {
    return "https://teenrebelapeclub.com/api/trac/metadata/";
  }

  /**
   * @dev Set $CREDIT address. Used to pay for metadata updates.
   */
  function setCreditAddress(address creditAddress) external onlyOwner {
    _credit = ICREDIT(creditAddress);
  }

  /**
   * @dev Set signature verifier address. Used to approve metadata update requests.
   */
  function setVerifier(address verifier) external onlyOwner {
    _verifier = verifier;
  }

  /**
   * @dev Publicly callable hash function to be used on and off-chain.
   */
  function metadataParamHash(address sender, uint256 token, uint8 key, uint64 id, uint256 cost) public pure returns (bytes32) {
    return keccak256(abi.encodePacked(sender, token, key, id, cost));
  }

  /**
   * @dev Set or update metadata identifiers to create and/or override specific trait values.
   */
  function setMetadata(uint256 token, uint8 key, uint64 id, uint256 cost, bytes memory signature) external {
    require(ownerOf(token) == msg.sender, "must be owner");
    require(ECDSAUpgradeable.recover(
      ECDSAUpgradeable.toEthSignedMessageHash(metadataParamHash(msg.sender, token, key, id, cost)),
      signature) == _verifier, "verification failure");
    _credit.burn(msg.sender, cost);
    _metadataKeys[token][key] = id;
  }

  /**
   * @dev Get existing metadata identifiers.
   */
  function getMetadataKeys(uint256 token) external view returns (uint64[3] memory keys) {
    return _metadataKeys[token];
  }
}
