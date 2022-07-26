// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Pausable.sol";

/**
 * @dev {ERC721} token, including:
 *
 *  - ability for holders to burn (destroy) their tokens
 *  - a minter role that allows for token minting (creation)
 *  - a pauser role that allows to stop all token transfers
 *
 * This contract uses {AccessControl} to lock permissioned functions using the
 * different roles - head to its documentation for details.
 *
 * The account that deploys the contract will be granted the minter and pauser
 * roles, as well as the default admin role, which will let it grant both minter
 * and pauser roles to other accounts.
 */
contract UpshotCollection is AccessControl, ERC721Burnable, ERC721Pausable {
    using Counters for Counters.Counter;

    event BaseURIUpdated(string indexed baseURI);
    event TokenURIUpdaterSet(uint256 indexed tokenId, address indexed updater);
    event TokenURISet(uint256 indexed tokenId, string indexed tokenURI);

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant URI_UPDATER_ROLE = keccak256("URI_UPDATER_ROLE");

    Counters.Counter private _tokenIdTracker;

    mapping(uint256 => address) public tokenUriUpdaters;

    /**
     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
     * account that deploys the contract.
     */
    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI
    ) ERC721(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(URI_UPDATER_ROLE, msg.sender);

        _setBaseURI(baseURI);
    }

    /**
     * @dev Creates a new token for `to`. Its token ID will be automatically
     * assigned (and available on the emitted {IERC721-Transfer} event), and the token
     * URI autogenerated based on the base URI passed at construction.
     *
     * See {ERC721-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */
    function mint(address to, string memory tokenURI) public {
        require(hasRole(MINTER_ROLE, msg.sender), "UpshotCollection: must have minter role to mint");

        // We cannot just use balanceOf to create the new tokenId because tokens
        // can be burned (destroyed), so we need a separate counter.
        _mint(to, _tokenIdTracker.current());
        _setTokenURI(_tokenIdTracker.current(), tokenURI);
        _tokenIdTracker.increment();
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC721Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public {
        require(hasRole(PAUSER_ROLE, msg.sender), "UpshotCollection: must have pauser role to pause");
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * See {ERC721Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public {
        require(hasRole(PAUSER_ROLE, msg.sender), "UpshotCollection: must have pauser role to unpause");
        _unpause();
    }

    function setBaseURI(string memory baseURI) public {
        require(
            hasRole(URI_UPDATER_ROLE, msg.sender),
            "UpshotCollection: must have uri_updater role to update base uri"
        );
        _setBaseURI(baseURI);

        emit BaseURIUpdated(baseURI);
    }

    function setTokenUriUpdater(uint256 tokenId, address updater) public {
        require(
            hasRole(URI_UPDATER_ROLE, msg.sender),
            "UpshotCollection: must have uri_updater role to set token uri updater"
        );
        require(_exists(tokenId), "UpshotCollection: token uri updater set for nonexistent token");
        tokenUriUpdaters[tokenId] = updater;

        emit TokenURIUpdaterSet(tokenId, updater);
    }

    function setTokenURI(uint256 tokenId, string memory tokenURI) public {
        require(msg.sender == tokenUriUpdaters[tokenId], "UpshotCollection: insufficient permissions");
        _setTokenURI(tokenId, tokenURI);

        emit TokenURISet(tokenId, tokenURI);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
