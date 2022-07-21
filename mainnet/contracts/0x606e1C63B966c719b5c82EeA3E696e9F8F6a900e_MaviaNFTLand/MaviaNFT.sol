// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "./interfaces/IMaviaNFT.sol";
import "./interfaces/IMaviaCreator.sol";
import "./utils/OpenseaDelegate.sol";

/**
 * @title Mavia NFT
 * @notice This contract contains base implementation of Mavia NFT contracts
 * @dev This contract will have all the base functions related to ERC721 NFT
 * @author mavia.com, reviewed by King
 * Copyright (c) 2021 Mavia
 */
contract MaviaNFT is ERC721Upgradeable, OwnableUpgradeable, AccessControlUpgradeable, IMaviaNFT, IMaviaCreator {
  bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
  bytes32 public constant APPROVER_ROLE = keccak256("APPROVER_ROLE");

  mapping(uint256 => address) private _creators;
  mapping(uint256 => uint256) private _ownTime;

  string public uri;

  address public proxyRegistryAddress;
  bool public isOpenSeaProxyActive;

  mapping(uint256 => uint256) public typeIds;

  bytes32 public constant EDITOR_ROLE = keccak256("EDITOR_ROLE");
  event SetURI(string _uri);

  /**
   * @dev See {IERC165-supportsInterface}.
   */
  function supportsInterface(bytes4 _interfaceId)
    public
    view
    virtual
    override(ERC721Upgradeable, AccessControlUpgradeable)
    returns (bool)
  {
    return
      _interfaceId == type(IMaviaNFT).interfaceId ||
      _interfaceId == type(IMaviaCreator).interfaceId ||
      super.supportsInterface(_interfaceId);
  }

  /**
   * @dev Upgradable initializer
   * @param _pName Token name
   * @param _pSymbol Token symbol
   * @param _pUri URI string
   */
  function __MaviaNFT_init(
    string memory _pName,
    string memory _pSymbol,
    string memory _pUri
  ) internal initializer {
    __Ownable_init();
    __AccessControl_init();
    __ERC721_init(_pName, _pSymbol);
    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    uri = _pUri;
  }

  /**
   * @dev Return of base uri
   */
  function _baseURI() internal view virtual override returns (string memory) {
    return uri;
  }

  /**
   * @notice Active opensea proxy - Emergency case
   * @dev This function is only callable by owner
   * @param _pProxyRegistryAddress Address of opensea proxy
   * @param _pIsOpenSeaProxyActive Active opensea proxy by assigning true value
   */
  function fActiveOpenseaProxy(address _pProxyRegistryAddress, bool _pIsOpenSeaProxyActive)
    external
    onlyRole(EDITOR_ROLE)
  {
    proxyRegistryAddress = _pProxyRegistryAddress;
    isOpenSeaProxyActive = _pIsOpenSeaProxyActive;
  }

  /**
   * @dev Sets a new URI for all token types, by relying on the token type ID
   * @dev This function is only callable by owner
   * @param _pUri String of uri
   */
  function fSetURI(string memory _pUri) external onlyRole(EDITOR_ROLE) {
    uri = _pUri;

    emit SetURI(_pUri);
  }

  /**
   * @notice Set nft type
   * @dev Set NFT type by the contract owner
   * @param _pTypeId Type id: 0 common, 1 rare, 2 legendary
   * @param _pIds Token ids
   * Required Statements
   * - MaviaNFT:01 Invalid ids
   */
  function fSetTypeIds(uint256 _pTypeId, uint256[] memory _pIds) external onlyRole(EDITOR_ROLE) {
    require(_pIds.length > 0, "MaviaNFT:01");

    for (uint i = 0; i < _pIds.length; i++) {
      typeIds[_pIds[i]] = _pTypeId;
    }
  }

  /**
   * @dev Transfer multi NFTs
   * @param _pTo Address of the token owner
   * @param _pIds Token ids
   * Required Statements
   * - MaviaNFT:01 Invalid ids
   */
  function fBulkTransfer(address _pTo, uint256[] memory _pIds) external {
    require(_pIds.length > 0, "MaviaNFT:01");

    for (uint i = 0; i < _pIds.length; i++) {
      transferFrom(_msgSender(), _pTo, _pIds[i]);
    }
  }

  /**
   * @dev Revoke NFT ownership
   * @param _pOwner Address of the token owner
   * @param _pIds Token ids
   * Required Statements
   * - MaviaNFT:01 Invalid ids
   */
  function fRevokeNFTOwnership(address _pOwner, uint256[] memory _pIds) external onlyRole(EDITOR_ROLE) {
    require(_pIds.length > 0, "MaviaNFT:01");

    for (uint i = 0; i < _pIds.length; i++) {
      _transfer(_pOwner, _msgSender(), _pIds[i]);
    }
  }

  /**
   * @dev Mint a new NFT
   * @param _pTo Address of the token owner
   * @param _pId Token id
   */
  function fMint(address _pTo, uint256 _pId) external override onlyRole(MINTER_ROLE) {
    _mint(_pTo, _pId);
    typeIds[_pId] = 0;
  }

  /**
   * @dev Mint a new NFT
   * @param _pTo Address of the token owner
   * @param _pId Token id
   * @param _pType Token type
   */
  function fMintType(
    address _pTo,
    uint256 _pId,
    uint256 _pType
  ) external override onlyRole(MINTER_ROLE) {
    _mint(_pTo, _pId);
    typeIds[_pId] = _pType;
  }

  /**
   * @dev Mint a Bulk NFT
   * @param _pTo Address of the token owner
   * @param _pFromId Token id from
   * @param _pToId Token id to
   */
  function fBulkMint(
    address _pTo,
    uint256 _pFromId,
    uint256 _pToId
  ) external override onlyRole(MINTER_ROLE) {
    for (uint256 id_ = _pFromId; id_ <= _pToId; id_++) {
      _mint(_pTo, id_);
      typeIds[id_] = 0;
    }
  }

  /**
   * @dev Mint a Bulk NFT
   * @param _pTo Address of the token owner
   * @param _pFromId token id from
   * @param _pToId token id to
   * @param _pType Token type
   */
  function fBulkMintType(
    address _pTo,
    uint256 _pFromId,
    uint256 _pToId,
    uint256 _pType
  ) external override onlyRole(MINTER_ROLE) {
    for (uint256 id_ = _pFromId; id_ <= _pToId; id_++) {
      _mint(_pTo, id_);
      typeIds[id_] = _pType;
    }
  }

  /**
   * @notice Burn an NFT
   * @dev Burn an NFT by the token owner and Burner role
   * @param _pId Token id
   * Required Statements
   * - MaviaNFT:01 Only owner of NFT or whoever has burner role can burn
   */
  function fBurn(uint256 _pId) external override {
    require(ownerOf(_pId) == _msgSender() || hasRole(BURNER_ROLE, _msgSender()), "MaviaNFT:01");
    _burn(_pId);
  }

  /**
   * @notice Burn a Bulk NFT
   * @dev Burn an NFT by the token owner and Burner role
   * @param _pFromId Token id
   * @param _pToId Token id
   */
  function fBulkBurn(uint256 _pFromId, uint256 _pToId) external override onlyRole(BURNER_ROLE) {
    for (uint256 id_ = _pFromId; id_ <= _pToId; id_++) {
      _burn(id_);
    }
  }

  /**
   * @notice Set creator
   * @dev Whoever has creator role, can change creator
   * @param _pId Token ID
   * @param _pAccount Token creator
   */
  function fSetCreator(uint256 _pId, address _pAccount) external override onlyRole(CREATOR_ROLE) {
    _creators[_pId] = _pAccount;
  }

  /**
   * @dev Get creator
   * @param _pId token ID
   */
  function fGetCreator(uint256 _pId) external view override returns (address) {
    return _creators[_pId];
  }

  /**
   * @dev Get own Time
   * @param _pId token ID
   */
  function fGetOwnTime(uint256 _pId) external view returns (uint256) {
    return _ownTime[_pId];
  }

  /**
   * @dev See {IERC721-isApprovedForAll}.
   * @param _pAccount Address of Owner
   * @param _pOperator Address of operator
   */
  function isApprovedForAll(address _pAccount, address _pOperator) public view override returns (bool) {
    ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
    if (isOpenSeaProxyActive && address(proxyRegistry.proxies(_pAccount)) == _pOperator) {
      return true;
    }

    return hasRole(APPROVER_ROLE, _pOperator) || super.isApprovedForAll(_pAccount, _pOperator);
  }

  /**
   * @dev Transfers `tokenId` from `from` to `to`.
   *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
   *
   * Requirements:
   *
   * - `to` cannot be the zero address.
   * - `tokenId` token must be owned by `from`.
   *
   * Emits a {Transfer} event.
   */
  function _transfer(
    address _pFrom,
    address _pTo,
    uint256 _pTokenId
  ) internal override {
    _ownTime[_pTokenId] = block.timestamp;
    super._transfer(_pFrom, _pTo, _pTokenId);
  }

  /**
   * @dev Mints `tokenId` and transfers it to `to`.
   *
   * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
   *
   * Requirements:
   *
   * - `tokenId` must not exist.
   * - `to` cannot be the zero address.
   *
   * Emits a {Transfer} event.
   */
  function _mint(address _pTo, uint256 _pTokenId) internal override {
    _creators[_pTokenId] = _pTo;
    _ownTime[_pTokenId] = block.timestamp;
    super._mint(_pTo, _pTokenId);
  }

  /**
   * @dev Destroys `tokenId`.
   * The approval is cleared when the token is burned.
   *
   * Requirements:
   *
   * - `tokenId` must exist.
   *
   * Emits a {Transfer} event.
   */
  function _burn(uint256 _pTokenId) internal override {
    _ownTime[_pTokenId] = block.timestamp;
    super._burn(_pTokenId);
  }
}
