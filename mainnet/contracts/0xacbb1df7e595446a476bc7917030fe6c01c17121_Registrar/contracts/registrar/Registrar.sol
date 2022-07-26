// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

// This is only kept for backward compatability / upgrading
import {OwnableUpgradeable} from "../oz/access/OwnableUpgradeable.sol";
import {EnumerableMapUpgradeable, ERC721PausableUpgradeable, IERC721Upgradeable, ERC721Upgradeable} from "../oz/token/ERC721/ERC721PausableUpgradeable.sol";
import {IRegistrar} from "../interfaces/IRegistrar.sol";
import {StorageSlot} from "../oz/utils/StorageSlot.sol";
import {BeaconProxy} from "../oz/proxy/beacon/BeaconProxy.sol";
import {IZNSHub} from "../interfaces/IZNSHub.sol";

contract Registrar is
  IRegistrar,
  OwnableUpgradeable,
  ERC721PausableUpgradeable
{
  using EnumerableMapUpgradeable for EnumerableMapUpgradeable.UintToAddressMap;

  // Data recorded for each domain
  struct DomainRecord {
    address minter;
    bool metadataLocked;
    address metadataLockedBy;
    address controller;
    uint256 royaltyAmount;
    uint256 parentId;
    address subdomainContract;
  }

  // A map of addresses that are authorised to register domains.
  mapping(address => bool) public controllers;

  // A mapping of domain id's to domain data
  // This essentially expands the internal ERC721's token storage to additional fields
  mapping(uint256 => DomainRecord) public records;

  /**
   * @dev Storage slot with the admin of the contract.
   */
  bytes32 internal constant _ADMIN_SLOT =
    0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

  // The beacon address
  address public beacon;

  // If this is a subdomain contract these will be set
  uint256 public rootDomainId;
  address public parentRegistrar;

  // The event emitter
  IZNSHub public zNSHub;
  uint8 private test; // ignore
  uint256 private gap; // ignore

  function _getAdmin() internal view returns (address) {
    return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
  }

  modifier onlyController() {
    if (!controllers[msg.sender] && !zNSHub.isController(msg.sender)) {
      revert("ZR: Not controller");
    }
    _;
  }

  modifier onlyOwnerOf(uint256 id) {
    require(ownerOf(id) == msg.sender, "ZR: Not owner");
    _;
  }

  function initialize(
    address parentRegistrar_,
    uint256 rootDomainId_,
    string calldata collectionName,
    string calldata collectionSymbol,
    address zNSHub_
  ) public initializer {
    // __Ownable_init(); // Purposely not initializing ownable since we override owner()

    if (parentRegistrar_ == address(0)) {
      // create the root domain
      _createDomain(0, 0, msg.sender, address(0));
    } else {
      rootDomainId = rootDomainId_;
      parentRegistrar = parentRegistrar_;
    }

    zNSHub = IZNSHub(zNSHub_);

    __ERC721Pausable_init();
    __ERC721_init(collectionName, collectionSymbol);
  }

  // Used to upgrade existing registrar to new registrar
  function upgradeFromNormalRegistrar(address zNSHub_) public {
    require(msg.sender == _getAdmin(), "Not Proxy Admin");
    zNSHub = IZNSHub(zNSHub_);
  }

  function owner() public view override returns (address) {
    return zNSHub.owner();
  }

  /*
   * External Methods
   */

  /**
   * @notice Authorizes a controller to control the registrar
   * @param controller The address of the controller
   */
  function addController(address controller) external {
    require(
      msg.sender == owner() || msg.sender == parentRegistrar,
      "ZR: Not authorized"
    );
    require(!controllers[controller], "ZR: Controller is already added");
    controllers[controller] = true;
    emit ControllerAdded(controller);
  }

  /**
   * @notice Unauthorizes a controller to control the registrar
   * @param controller The address of the controller
   */
  function removeController(address controller) external override onlyOwner {
    require(
      msg.sender == owner() || msg.sender == parentRegistrar,
      "ZR: Not authorized"
    );
    require(controllers[controller], "ZR: Controller does not exist");
    controllers[controller] = false;
    emit ControllerRemoved(controller);
  }

  /**
   * @notice Pauses the registrar. Can only be done when not paused.
   */
  function pause() external onlyOwner {
    _pause();
  }

  /**
   * @notice Unpauses the registrar. Can only be done when not paused.
   */
  function unpause() external onlyOwner {
    _unpause();
  }

  /**
   * @notice Registers a new (sub) domain
   * @param parentId The parent domain
   * @param label The label of the domain
   * @param minter the minter of the new domain
   * @param metadataUri The uri of the metadata
   * @param royaltyAmount The amount of royalty this domain pays
   * @param locked Whether the domain is locked or not
   */
  function registerDomain(
    uint256 parentId,
    string memory label,
    address minter,
    string memory metadataUri,
    uint256 royaltyAmount,
    bool locked
  ) external override onlyController returns (uint256) {
    return
      _registerDomain(
        parentId,
        label,
        minter,
        metadataUri,
        royaltyAmount,
        locked
      );
  }

  function registerDomainAndSend(
    uint256 parentId,
    string memory label,
    address minter,
    string memory metadataUri,
    uint256 royaltyAmount,
    bool locked,
    address sendToUser
  ) external override onlyController returns (uint256) {
    // Register the domain
    uint256 id = _registerDomain(
      parentId,
      label,
      minter,
      metadataUri,
      royaltyAmount,
      locked
    );

    // immediately send domain to user
    _safeTransfer(minter, sendToUser, id, "");

    return id;
  }

  function registerSubdomainContract(
    uint256 parentId,
    string memory label,
    address minter,
    string memory metadataUri,
    uint256 royaltyAmount,
    bool locked,
    address sendToUser
  ) external onlyController returns (uint256) {
    // Register domain, `minter` is the minter
    uint256 id = _registerDomain(
      parentId,
      label,
      minter,
      metadataUri,
      royaltyAmount,
      locked
    );

    // Create subdomain contract as a beacon proxy
    address subdomainContract = address(
      new BeaconProxy(zNSHub.registrarBeacon(), "")
    );

    // More maintainable instead of using `data` in constructor
    Registrar(subdomainContract).initialize(
      address(this),
      id,
      "Zer0 Name Service",
      "ZNS",
      address(zNSHub)
    );

    // Indicate that the subdomain has a contract
    records[id].subdomainContract = subdomainContract;

    zNSHub.addRegistrar(id, subdomainContract);

    // immediately send the domain to the user (from the minter)
    _safeTransfer(minter, sendToUser, id, "");

    return id;
  }

  function _registerDomain(
    uint256 parentId,
    string memory label,
    address minter,
    string memory metadataUri,
    uint256 royaltyAmount,
    bool locked
  ) internal returns (uint256) {
    require(bytes(label).length > 0, "ZR: Empty name");
    // subdomain cannot be minted on domains which are subdomain contracts
    require(
      records[parentId].subdomainContract == address(0),
      "ZR: Parent is subcontract"
    );
    if (parentId != rootDomainId) {
      // Domain parents must exist
      require(_exists(parentId), "ZR: No parent");
    }

    // Create the child domain under the parent domain
    uint256 labelHash = uint256(keccak256(bytes(label)));
    address controller = msg.sender;

    // Calculate the new domain's id and create it
    uint256 domainId = uint256(
      keccak256(abi.encodePacked(parentId, labelHash))
    );
    _createDomain(parentId, domainId, minter, controller);
    _setTokenURI(domainId, metadataUri);

    if (locked) {
      records[domainId].metadataLockedBy = minter;
      records[domainId].metadataLocked = true;
    }

    if (royaltyAmount > 0) {
      records[domainId].royaltyAmount = royaltyAmount;
    }

    zNSHub.domainCreated(
      domainId,
      label,
      labelHash,
      parentId,
      minter,
      controller,
      metadataUri,
      royaltyAmount
    );

    return domainId;
  }

  /**
   * @notice Sets the domain royalty amount
   * @param id The domain to set on
   * @param amount The royalty amount
   */
  function setDomainRoyaltyAmount(uint256 id, uint256 amount)
    external
    override
    onlyOwnerOf(id)
  {
    require(!isDomainMetadataLocked(id), "ZR: Metadata locked");

    records[id].royaltyAmount = amount;
    zNSHub.royaltiesAmountChanged(id, amount);
  }

  /**
   * @notice Both sets and locks domain metadata uri in a single call
   * @param id The domain to lock
   * @param uri The uri to set
   */
  function setAndLockDomainMetadata(uint256 id, string memory uri)
    external
    override
    onlyOwnerOf(id)
  {
    require(!isDomainMetadataLocked(id), "ZR: Metadata locked");
    _setDomainMetadataUri(id, uri);
    _setDomainLock(id, msg.sender, true);
  }

  /**
   * @notice Sets the domain metadata uri
   * @param id The domain to set on
   * @param uri The uri to set
   */
  function setDomainMetadataUri(uint256 id, string memory uri)
    external
    override
    onlyOwnerOf(id)
  {
    require(!isDomainMetadataLocked(id), "ZR: Metadata locked");
    _setDomainMetadataUri(id, uri);
  }

  /**
   * @notice Locks a domains metadata uri
   * @param id The domain to lock
   * @param toLock whether the domain should be locked or not
   */
  function lockDomainMetadata(uint256 id, bool toLock) external override {
    _validateLockDomainMetadata(id, toLock);
    _setDomainLock(id, msg.sender, toLock);
  }

  /*
   * Public View
   */

  function ownerOf(uint256 tokenId)
    public
    view
    virtual
    override(ERC721Upgradeable, IERC721Upgradeable)
    returns (address)
  {
    // Check if the token is in this contract
    if (_tokenOwners.contains(tokenId)) {
      return
        _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
    }

    return zNSHub.ownerOf(tokenId);
  }

  /**
   * @notice Returns whether or not an account is a a controller registered on this contract
   * @param account Address of account to check
   */
  function isController(address account) external view override returns (bool) {
    bool accountIsController = controllers[account];
    return accountIsController;
  }

  /**
   * @notice Returns whether or not a domain is exists
   * @param id The domain
   */
  function domainExists(uint256 id) public view override returns (bool) {
    bool domainNftExists = _exists(id);
    return domainNftExists;
  }

  /**
   * @notice Returns the original minter of a domain
   * @param id The domain
   */
  function minterOf(uint256 id) public view override returns (address) {
    address minter = records[id].minter;
    return minter;
  }

  /**
   * @notice Returns whether or not a domain's metadata is locked
   * @param id The domain
   */
  function isDomainMetadataLocked(uint256 id)
    public
    view
    override
    returns (bool)
  {
    bool isLocked = records[id].metadataLocked;
    return isLocked;
  }

  /**
   * @notice Returns who locked a domain's metadata
   * @param id The domain
   */
  function domainMetadataLockedBy(uint256 id)
    public
    view
    override
    returns (address)
  {
    address lockedBy = records[id].metadataLockedBy;
    return lockedBy;
  }

  /**
   * @notice Returns the controller which created the domain on behalf of a user
   * @param id The domain
   */
  function domainController(uint256 id) public view override returns (address) {
    address controller = records[id].controller;
    return controller;
  }

  /**
   * @notice Returns the current royalty amount for a domain
   * @param id The domain
   */
  function domainRoyaltyAmount(uint256 id)
    public
    view
    override
    returns (uint256)
  {
    uint256 amount = records[id].royaltyAmount;
    return amount;
  }

  /**
   * @notice Returns the parent id of a domain.
   * @param id The domain
   */
  function parentOf(uint256 id) public view override returns (uint256) {
    require(_exists(id), "ZR: Does not exist");

    uint256 parentId = records[id].parentId;
    return parentId;
  }

  /*
   * Internal Methods
   */

  function _transfer(
    address from,
    address to,
    uint256 tokenId
  ) internal virtual override {
    super._transfer(from, to, tokenId);
    // Need to emit transfer events on event emitter
    zNSHub.domainTransferred(from, to, tokenId);
  }

  function _setDomainMetadataUri(uint256 id, string memory uri) internal {
    _setTokenURI(id, uri);
    zNSHub.metadataChanged(id, uri);
  }

  function _validateLockDomainMetadata(uint256 id, bool toLock) internal view {
    if (toLock) {
      require(ownerOf(id) == msg.sender, "ZR: Not owner");
      require(!isDomainMetadataLocked(id), "ZR: Metadata locked");
    } else {
      require(isDomainMetadataLocked(id), "ZR: Not locked");
      require(domainMetadataLockedBy(id) == msg.sender, "ZR: Not locker");
    }
  }

  // internal - creates a domain
  function _createDomain(
    uint256 parentId,
    uint256 domainId,
    address minter,
    address controller
  ) internal {
    // Create the NFT and register the domain data
    _mint(minter, domainId);
    records[domainId] = DomainRecord({
      parentId: parentId,
      minter: minter,
      metadataLocked: false,
      metadataLockedBy: address(0),
      controller: controller,
      royaltyAmount: 0,
      subdomainContract: address(0)
    });
  }

  function _setDomainLock(
    uint256 id,
    address locker,
    bool lockStatus
  ) internal {
    records[id].metadataLockedBy = locker;
    records[id].metadataLocked = lockStatus;

    zNSHub.metadataLockChanged(id, locker, lockStatus);
  }

  function adminBurnToken(uint256 tokenId) external onlyOwner {
    _burn(tokenId);
    delete (records[tokenId]);
  }

  function adminTransfer(
    address from,
    address to,
    uint256 tokenId
  ) external onlyOwner {
    _transfer(from, to, tokenId);
  }

  function adminSetMetadataUri(uint256 id, string memory uri)
    external
    onlyOwner
  {
    _setDomainMetadataUri(id, uri);
  }

  function registerDomainAndSendBulk(
    uint256 parentId,
    uint256 namingOffset, // e.g., the IPFS node refers to the metadata as x. the zNS label will be x + namingOffset
    uint256 startingIndex,
    uint256 endingIndex,
    address minter,
    string memory folderWithIPFSPrefix, // e.g., ipfs://Qm.../
    uint256 royaltyAmount,
    bool locked
  ) external onlyController {
    require(endingIndex - startingIndex > 0, "Invalid number of domains");
    uint256 result;
    for (uint256 i = startingIndex; i < endingIndex; i++) {
      result = _registerDomain(
        parentId,
        uint2str(i + namingOffset),
        minter,
        string(abi.encodePacked(folderWithIPFSPrefix, uint2str(i))),
        royaltyAmount,
        locked
      );
    }
  }

  function uint2str(uint256 _i)
    internal
    pure
    returns (string memory _uintAsString)
  {
    if (_i == 0) {
      return "0";
    }
    uint256 j = _i;
    uint256 len;
    while (j != 0) {
      len++;
      j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint256 k = len;
    while (_i != 0) {
      k = k - 1;
      uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
      bytes1 b1 = bytes1(temp);
      bstr[k] = b1;
      _i /= 10;
    }
    return string(bstr);
  }
}
