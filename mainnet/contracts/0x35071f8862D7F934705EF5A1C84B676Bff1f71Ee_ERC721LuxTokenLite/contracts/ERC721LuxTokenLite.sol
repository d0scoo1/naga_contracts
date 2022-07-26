// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./extensions/ERC721Infusable.sol";
import "./extensions/ERC721BusinessAdditions.sol";
import "./extensions/Owner.sol";

/**
 * @title ARTM Technologies ERC721 Lux Token Lite contract (v1.0)
 * @author Ryan Farley <ryan@artmtoken.com>
 * @dev {ERC721} token, including:
 *
 *  - Ability for holders to burn (destroy) their tokens
 *  - A minter role that allows for token minting (creation)
 *  - A royalty admin role that allows for modifying token royalty data
 *  - Token ID and URI autogeneration
 *  - Custom addition of business state values
 *  - Infusion and withdraw of ERC20 tokens (withdraw time lock capable)
 *  - On-chain calculation of royalty payments (EIP 2981 support)
 *
 * The account that deploys the contract will be granted the minter, and royalty 
 * admin roles, as well as the default admin role which will let it grant roles 
 * to additional accounts.
 */
contract ERC721LuxTokenLite is
    Context,
    AccessControlEnumerable,
    ERC721Enumerable,
    ERC721Burnable,
    ERC721URIStorage,
    ERC721Royalty,
    Owner,
    ERC721BusinessAdditions,
    ERC721Infusable {

    using Counters for Counters.Counter;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant ROYALTY_ADMIN_ROLE = keccak256("ROYALTY_ADMIN_ROLE");

    Counters.Counter private _tokenIdTracker;

    string private _baseTokenURI;

    // Contract max royalty of 15% in basis points
    uint256 private _maxRoyaltyAllowed = 1500;

    /**
     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE`, `ROYALTY_ADMIN_ROLE`, 
     * and the `_owner` to the account that deploys the contract.
     *
     * Sets the initial contract URI, the address of the infusable ERC20, the
     * maximum withdraw lock time in weeks, as well as the maximum basis points
     * this contract supports for use with royalties.
     *
     * Requirements:
     *
     * - `defaultRoyaltyFee` cannot exceed `_maxRoyaltyAllowed`
     *
     * Token URIs can be autogenerated based on `baseURI` and their token IDs.
     * See {ERC721-tokenURI}.
     */
    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI,
        string memory contractURI,
        IERC20 infuseToken,
        uint256 maxWithdrawLockWeeks_,
        address defaultRoyaltyReceiver,
        uint96 defaultRoyaltyFee
    )
        ERC721(name, symbol)
        ERC721Infusable(infuseToken, maxWithdrawLockWeeks_)
        ERC721BusinessAdditions(contractURI) {
            require(defaultRoyaltyFee <= _maxRoyaltyAllowed, "ERC721Royalty: royalty fee exceeds maximum");

            _baseTokenURI = baseTokenURI;

            _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
            _setupRole(MINTER_ROLE, _msgSender());
            _setupRole(ROYALTY_ADMIN_ROLE, _msgSender());

            _transferOwnership(_msgSender());

            _setDefaultRoyalty(defaultRoyaltyReceiver, defaultRoyaltyFee);
        }

    /**
     * @dev Creates a new token for `to`. Its token ID will be automatically
     * assigned (and available on the emitted {IERC721-Transfer} event), and
     * the token URI autogenerated based on the base URI passed at construction.
     *
     * This function allows for specifying the token URI, terms and conditions
     * URI, serial number, and transfer restriction state at minting.
     *
     * See {ERC721-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */
    function mint(
        address to,
        string memory _tokenURI,
        string memory _tokenTermsConditionURI,
        string memory _tokenSerialNumber
    ) external virtual returns (bool) {
        require(hasRole(MINTER_ROLE, _msgSender()), "ERC721LuxToken: must have minter role to mint");

        // We cannot just use balanceOf to create the new tokenId because tokens
        // can be burned (destroyed), so we need a separate counter.
        _mint(to, _tokenIdTracker.current());

        _setTokenURI(_tokenIdTracker.current(), _tokenURI);

        _setTokenSerialNumber(_tokenIdTracker.current(), _tokenSerialNumber);

        _setTokenTermsConditionsURI(_tokenIdTracker.current(), _tokenTermsConditionURI);

        _tokenIdTracker.increment();

        return true;
    }

    /**
     * @dev Returns the maximum royalty value for the contract
     */
    function maxRoyaltyAllowed() external view virtual returns (uint256) {
        return _maxRoyaltyAllowed;
    }

    /**
     * @dev Sets the royalty information for a specific token id, overriding the global default.
     *
     * Requirements:
     *
     * - Must have ROYALTY_ADMIN_ROLE to set
     * - `tokenId` must be already minted.
     * - `receiver` cannot be the zero address.
     * - `feeNumerator` cannot be greater than the fee denominator.
     */
    function setTokenRoyalty(
        uint256 tokenId,
        address receiver,
        uint96 feeNumerator
    ) external virtual {
        require(hasRole(ROYALTY_ADMIN_ROLE, _msgSender()), "ERC721Royalty: must have permission to update");
        require(feeNumerator <= _maxRoyaltyAllowed, "ERC721Royalty: royalty fee exceeds maximum");
        require(_exists(tokenId), "ERC721Royalty: nonexistent token");
        _setTokenRoyalty(tokenId, receiver, feeNumerator);
    }

    /**
     * @dev Sets the royalty information that all ids in this contract will default to.
     *
     * Requirements:
     *
     * - Must have ROYALTY_ADMIN_ROLE to set
     * - `receiver` cannot be the zero address.
     * - `feeNumerator` cannot be greater than the fee denominator.
     */
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external virtual {
        require(hasRole(ROYALTY_ADMIN_ROLE, _msgSender()), "ERC721Royalty: must have permission to update");
        require(feeNumerator <= _maxRoyaltyAllowed, "ERC721Royalty: royalty fee exceeds maximum");
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    /**
     * @dev Removes default royalty information.
     *
     * Requirements:
     *
     * - Must have ROYALTY_ADMIN_ROLE to call
     */
    function deleteDefaultRoyalty() external virtual {
        require(hasRole(ROYALTY_ADMIN_ROLE, _msgSender()), "ERC721Royalty: must have permission to update");
        _deleteDefaultRoyalty();
    }

    /**
     * @dev Transfers "ownership" of the contract to a new account (`newOwner`).  Please note
     * that in this implementation the owner does not actually "own" the contract.  The inclusion
     * of {Owner} in this contract aids in configuring this collection on third-party marketplaces.
     *
     * Requirements:
     *
     * - `newOwner` cannot be the zero address.
     * - Can only be called by account with DEFAULT_ADMIN_ROLE
     */
    function transferOwnership(address newOwner) external virtual {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Owner: must have permission to update");
        require(newOwner != address(0), "Owner: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory)
    {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
        return super.tokenURI(tokenId);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(
            AccessControlEnumerable,
            ERC721,
            ERC721Enumerable,
            ERC721Royalty,
            ERC721BusinessAdditions,
            ERC721Infusable
        )
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
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
    function _burn(uint256 tokenId)
        internal
        virtual
        override(
            ERC721,
            ERC721URIStorage,
            ERC721Royalty,
            ERC721BusinessAdditions,
            ERC721Infusable
        )
    {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");

        super._burn(tokenId);
    }

    /**
     * @dev See {ERC721-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(
        ERC721,
        ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }


    /**
     * @dev Hook to allow adding access control constraints to {ERC721BusinessAdditions}
     */
    function _updateBusinessAdditionsAccess() internal virtual override returns(bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, _msgSender()) || super._updateBusinessAdditionsAccess();
    }
}
