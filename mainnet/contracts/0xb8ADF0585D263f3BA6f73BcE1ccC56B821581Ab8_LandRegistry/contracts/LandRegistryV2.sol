// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "./interfaces/ILandRegistry.sol";

contract LandRegistry is
    ILandRegistry,
    Initializable,
    ERC721Upgradeable,
    ERC721EnumerableUpgradeable,
    AccessControlUpgradeable,
    UUPSUpgradeable
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant METADATA_SETTER_ROLE =
        keccak256("METADATA_SETTER_ROLE");

    uint32 constant clearLow = 0xffff0000;
    uint32 constant clearHigh = 0x0000ffff;
    uint32 constant factor = 0x10000;

    string public baseURI;
    mapping(uint32 => string) private _name;

    address private _owner;

    event LogNameChanged(
        int16 x,
        int16 y,
        uint32 indexed tokenId,
        string newName
    );

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function encode(int16 x, int16 y) external pure returns (uint32) {
        return _encodeTokenId(x, y);
    }

    function decode(uint32 value) external pure returns (int16 x, int16 y) {
        return _decodeTokenId(value);
    }

    function exists(uint256 tokenId) external view returns (bool) {
        return _exists(tokenId);
    }

    function exists(int16 x, int16 y) external view returns (bool) {
        return _exists(_encodeTokenId(x, y));
    }

    function nameOf(uint32 tokenId) external view returns (string memory) {
        return _name[tokenId];
    }

    function nameOf(int16 x, int16 y) external view returns (string memory) {
        return _name[_encodeTokenId(x, y)];
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function setBaseURI(string calldata uri)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        baseURI = uri;
    }

    function mint(
        address user,
        int16 x,
        int16 y
    ) external onlyRole(MINTER_ROLE) {
        _safeMint(user, _encodeTokenId(x, y));
    }

    function setName(
        int16 x,
        int16 y,
        string memory newName
    ) external onlyRole(METADATA_SETTER_ROLE) {
        uint32 tokenId = _encodeTokenId(x, y);
        require(_exists(tokenId), "ERR_TOKEN_DOES_NOT_EXIST");
        _name[tokenId] = newName;
        emit LogNameChanged(x, y, tokenId, newName);
    }

    function transferOwnership(address newOwner)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function renounceOwnership() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _transferOwnership(address(0));
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {}

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function _encodeTokenId(int16 x, int16 y) internal pure returns (uint32) {
        return
            ((uint32(uint16(x)) * factor) & clearLow) |
            (uint32(uint16(y)) & clearHigh);
    }

    function _decodeTokenId(uint32 value)
        internal
        pure
        returns (int16 x, int16 y)
    {
        x = _expandNegative16BitCast((value & clearLow) >> 16);
        y = _expandNegative16BitCast(value & clearHigh);
    }

    function _expandNegative16BitCast(uint32 value)
        internal
        pure
        returns (int16)
    {
        if (value & (1 << 15) != 0) {
            return int16(int32(value | clearLow));
        }
        return int16(int32(value));
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(
            ERC721Upgradeable,
            ERC721EnumerableUpgradeable,
            AccessControlUpgradeable
        )
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
