// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// the erc1155 base contract - the openzeppelin erc1155
import "../token/ERC721A/ERC721A.sol";
import "../royalties/ERC2981.sol";
import "../utils/AddressSet.sol";
import "../utils/UInt256Set.sol";

import "./ProxyRegistry.sol";
import "../access/Controllable.sol";

import "../interfaces/IMultiToken.sol";
import "../interfaces/IERC1155Mint.sol";
import "../interfaces/IERC1155Burn.sol";
import "../interfaces/IERC1155Multinetwork.sol";
import "../interfaces/IERC1155Bridge.sol";

import "../service/Service.sol";
import "../factories/FactoryElement.sol";

/**
 * @title MultiToken
 * @notice the multitoken contract. All tokens are printed on this contract. The token has all the capabilities
 * of an erc1155 contract, plus network transfer, royallty tracking and assignment and other features.
 */
contract MultiToken721 is
ERC721A,
ProxyRegistryManager,
IERC1155Multinetwork,
IMultiToken,
ERC2981,
Service,
Controllable,
Initializable,
FactoryElement
{

    // to work with token holder and held token lists
    using AddressSet for AddressSet.Set;
    using UInt256Set for UInt256Set.Set;
    using Strings for uint256;

    address internal masterMinter;
    string internal _uri;

    function initialize(address registry) public initializer {
        _addController(msg.sender);
        _serviceRegistry = registry;
    }

    function initToken(string memory symbol, string memory name) public {
        _initToken(symbol, name);
    }

    function setMasterController(address _masterMinter) public {
        require(masterMinter == address(0), "master minter must not be set");
        masterMinter = _masterMinter;
        _addController(_masterMinter);
    }

    function addDirectMinter(address directMinter) public {
        require(msg.sender == masterMinter, "only master minter can add direct minters");
        _addController(directMinter);
    }

    /// @notice only allow owner of the contract
    modifier onlyOwner() {
        require(_isController(msg.sender), "You shall not pass");
        _;
    }
    /// @notice only allow owner of the contract
    modifier onlyMinter() {
        require(_isController(msg.sender) || masterMinter == msg.sender, "You shall not pass");
        _;
    }

    /// @notice Mint a specified amount the specified token hash to the specified receiver
    /// @param recipient the address of the receiver
    /// @param amount the amount to mint
    function mint(
        address recipient,
        uint256,
        uint256 amount
    ) external override onlyMinter {

        _mint(recipient, amount, "", true);

    }

    /// @notice mint tokens of specified amount to the specified address
    /// @param recipient the mint target
    /// @param amount the amount to mint
    function mintWithCommonUri(
        address recipient,
        uint256,
        uint256 amount,
        uint256
    ) external onlyMinter {

        _mint(recipient, amount, "", true);

    }

    string internal baseUri;
    function setBaseURI(string memory value) external onlyMinter {

        baseUri = value;

    }

    function baseURI() external view returns (string memory) {

        return _baseURI();

    }

    function _baseURI() internal view virtual override returns (string memory) {

        return baseUri;

    }

    /// @notice burn a specified amount of the specified token hash from the specified target
    /// @param tokenHash the token id to burn
    function burn(
        address,
        uint256 tokenHash,
        uint256
    ) external override onlyMinter {
        _burn(tokenHash);
    }

    /// @notice override base functionality to check proxy registries for approvers
    /// @param _owner the owner address
    /// @param _operator the operator address
    /// @return isOperator true if the owner is an approver for the operator
    function isApprovedForAll(address _owner, address _operator)
    public
    view
    override
    returns (bool isOperator) {
        // check proxy whitelist
        bool _approved = _isApprovedForAll(_owner, _operator);
        return _approved || ERC721A.isApprovedForAll(_owner, _operator);
    }

    /// @notice See {IERC165-supportsInterface}. ERC165 implementor. identifies this contract as an ERC1155
    /// @param interfaceId the interface id to check
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC2981, ERC721A) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /// @notice perform a network token transfer. Transfer the specified quantity of the specified token hash to the destination address on the destination network.
    function networkTransferFrom(
        address from,
        address to,
        uint256 network,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external virtual override {

        address _bridge = IJanusRegistry(_serviceRegistry).get("MultiToken", "NetworkBridge");
        require(_bridge != address(0), "No network bridge found");

        // call the network transfer on the bridge
        IERC1155Multinetwork(_bridge).networkTransferFrom(from, to, network, id, amount, data);

    }

    mapping(uint256 => string) internal symbolsOf;
    mapping(uint256 => string) internal namesOf;

    function symbolOf(uint256 _tokenId) external view override returns (string memory out) {
        return symbolsOf[_tokenId];
    }

    function nameOf(uint256 _tokenId) external view override returns (string memory out) {
        return namesOf[_tokenId];
    }

    function setSymbolOf(uint256 _tokenId, string memory _symbolOf) external onlyMinter {
        symbolsOf[_tokenId] = _symbolOf;
    }

    function setNameOf(uint256 _tokenId, string memory _nameOf) external onlyMinter {
        namesOf[_tokenId] = _nameOf;
    }

    function setRoyalty(uint256 tokenId, address receiver, uint256 amount) external onlyOwner {
        royaltyReceiversByHash[tokenId] = receiver;
        royaltyFeesByHash[tokenId] = amount;
    }

}
