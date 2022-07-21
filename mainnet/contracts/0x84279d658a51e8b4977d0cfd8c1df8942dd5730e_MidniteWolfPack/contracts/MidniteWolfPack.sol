// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @author The Midnite Team
 * @title Handles Midnite Wolf minting
 */
contract MidniteWolfPack is ERC721, Pausable, AccessControl, ERC721Burnable {
    using Counters for Counters.Counter;

    // Set up our user roles to be required against logic
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant WHITELIST_ROLE = keccak256("WHITELIST_ROLE");

    // Keep a track of our token count
    Counters.Counter private _tokenIdCounter;

    // Set up events to be fired
    event WolfMinted(address to, uint tokenId);

    // Map our whitelist mints
    mapping (address => uint) private whitelistMints;

    // Set our mint price to 0.075eth in wei
    uint MINT_PRICE = 75000000000000000;

    // Set our token supply limit
    uint TOTAL_SUPPLY = 5000;

    // Set our limit for per-tx tokens in public sale
    uint MAX_TOKENS_PER_TX = 10;

    // Set the total number of tokens available for WL mint
    uint whitelistMintCount = 1;

    // Parameters of the minting availability. Times are passing in the
    // contract constructor as absolute unix timestamps.
    uint public preSaleStart;
    uint public preSaleEnd;
    uint public publicSaleStart;

    // Set our base URI for metadata referencing
    string baseURI;

    /**
     * @dev Initialises our MidniteWolfPack contract.
     * 
     * @param _preSaleStart Unix timestamp of when the presale starts
     * @param _preSaleEnd Unix timestamp of when the presale ends
     * @param _publicSaleStart Unix timestamp of when the public sale starts
     * @param _initialBaseURI Set the base URI for metadata
     */
    constructor(
        uint _preSaleStart,
        uint _preSaleEnd,
        uint _publicSaleStart,
        string memory _initialBaseURI
    ) ERC721("MidniteWolfPack", "WOLF") {
        // Set up our user roles against our message sender
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);

        // Register our presale and public sale times
        preSaleStart = _preSaleStart;
        preSaleEnd = _preSaleEnd;
        publicSaleStart = _publicSaleStart;

        // Set initial base URI
        baseURI = _initialBaseURI;
    }

    /**
     * @dev Used in calculation of our token metadata URI
     * 
     * @return string Base URI of our token metadata
     */
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /**
     * @dev Allows our PAUSER role to prevent minting process
     */
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /**
     * @dev Allows our PAUSER role to reactivate minting process
     */
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /**
     * @dev Allows an address on our whitelist to mint a single token.
     * 
     * @param to Address of minter. Will be recipient of token.
     * 
     * Emits a {WolfMinted} event.
     */
    function whitelistSafeMint(address to) public payable {
        uint tokenId = _tokenIdCounter.current();

        // Check that we are within pre-sale window
        require(block.timestamp >= preSaleStart, "Pre-sale has not started.");
        require(block.timestamp <= preSaleEnd, "Pre-sale has finished.");

        // We only want 5000 tokens to be minted in total
        require(tokenId <= TOTAL_SUPPLY, "Mint has ended.");

        // Confirm that the user's address is a whitelisted address
        require(hasRole(WHITELIST_ROLE, to), "Address not found in whitelist.");

        // We only want to allow a set number of mints per address in the pre-sale
        require(whitelistMints[to] < whitelistMintCount, "Maximum pre-sale tokens reached.");

        // Validate that our minting price is correct
        require(msg.value >= MINT_PRICE, "Incorrect amount sent.");

        // Increment our tokenId counter
        _tokenIdCounter.increment();

        // Mint our token and transfer it
        _mint(to, tokenId);

        // Increment our WL address mint count
        ++whitelistMints[to];

        // Emit our minting event
        emit WolfMinted(to, tokenId);
    }

    /**
     * @dev Allows an address to mint a token.
     * 
     * @param to Address of minter. Will be recipient of token.
     * @param amount Number of tokens requested to be minted.
     * 
     * Emits a {WolfMinted} event.
     */
    function safeMint(address to, uint amount) public payable {
        uint tokenId = _tokenIdCounter.current();

        // Check that our public minting has started
        require(block.timestamp >= publicSaleStart, "Public sale has not started.");

        // We only want 5000 tokens to be minted in total
        require(tokenId < TOTAL_SUPPLY, "Mint has ended.");

        // Validate the supply available for request
        require(amount <= MAX_TOKENS_PER_TX, "Too many tokens requested.");
        require((tokenId + amount) <= TOTAL_SUPPLY, "Too many tokens requested.");

        // Validate that our minting price is correct
        require(msg.value >= (MINT_PRICE * amount), "Incorrect amount sent.");

        // Iterate through our requested amount to mint tokens
        for (uint i; i < amount;) {
            // Increment our counter to preserve tokenId
            _tokenIdCounter.increment();

            // Get our current token position and mint
            uint mintTokenId = _tokenIdCounter.current() - 1;
            _mint(to, mintTokenId);
            emit WolfMinted(to, mintTokenId);

            unchecked { ++i; }
        }
    }


    /**
     * @dev Allow admin to mint tokens to be held internally by the team.
     * 
     * @param to Address of minter. Will be recipient of token.
     * @param amount Number of tokens requested to be minted.
     * 
     * Emits a {WolfMinted} event.
     */
    function internalMint(address to, uint amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        // Iterate through our requested amount to mint tokens
        for (uint i; i < amount;) {
            // Increment our counter to preserve tokenId
            _tokenIdCounter.increment();

            // Get our current token position and mint
            uint mintTokenId = _tokenIdCounter.current() - 1;
            _mint(to, mintTokenId);
            emit WolfMinted(to, mintTokenId);

            unchecked { ++i; }
        }
    }


    /**
     * @dev Adds addresses to the whitelist.
     * 
     * @param _whitelistedAddresses Array of addresses that can mint in the whitelist
     */
    function addWhitelistedAddresses(address[] memory _whitelistedAddresses) public onlyRole(DEFAULT_ADMIN_ROLE) {
        // Iterate through our whitelisted addresses and register them with
        // a whitelist role.
        uint addressCount = _whitelistedAddresses.length;
        for (uint i; i < addressCount;) {
            _grantRole(WHITELIST_ROLE, _whitelistedAddresses[i]);

            unchecked { ++i; }
        }
    }


    /**
     * @dev Allow check to see if user has the whitelist role.
     * 
     * @param _owner Address of user to check whitelist role.
     */
    function checkWhitelist(address _owner) public view returns(bool) {
        return hasRole(WHITELIST_ROLE, _owner);
    }


    /**
     * @dev Allow admin to update the base URI allowing for reveal.
     * 
     * @param _newBaseURI New base URI to be updated to.
     */
    function setBaseURI(string memory _newBaseURI) public onlyRole(DEFAULT_ADMIN_ROLE) {
        baseURI = _newBaseURI;
    }


    /**
     * @dev Allow admin to update the number of tokens a whitelist member can mint.
     * 
     * @param _newWhitelistMintCount New whitelist mint count to be updated to.
     */
    function setWhitelistMintCount(uint _newWhitelistMintCount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        whitelistMintCount = _newWhitelistMintCount;
    }


    /**
     * @dev Hook that is called before any token transfer. This includes minting and burning.
     * 
     * @param from Address token is being transferred from.
     * @param to Address token is being transferred to.
     * @param tokenId Unique ID of the token being transferred.
     */
    function _beforeTokenTransfer(address from, address to, uint tokenId)
        internal
        whenNotPaused
        override(ERC721)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev Allows that the beneficiary can receive deposited ETH.
     *
     * @param _withdrawal WEI amount to be withdrawn.
     * 
     * @return bool Returns true if withdrawal was successful.
     */
    function withdraw(uint _withdrawal) external returns (bool) {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));

        (bool success, ) = msg.sender.call{value: _withdrawal}("");
        require(success, "Unable to process withdrawal.");
        return true;
    }

    /**
     * @dev Fallback function executed on a call if no other functions matches.
     */
    fallback() external payable {
        revert();
    }

    /**
     * @dev Fallback function executed on a payable call if no other functions matches.
     */
    receive() external payable {
        revert();
    }

    /**
     * @dev Calculates the number of tokens minted on contract.
     * 
     * @return uint The current number of tokens minted.
     */
    function totalMinted() public view returns (uint) {
        return _tokenIdCounter.current();
    }

    /**
     * @dev Exposes the total number of tokens available for supply.
     * 
     * @return uint The total token supply.
     */
    function totalSupply() public view returns (uint) {
        return TOTAL_SUPPLY;
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
