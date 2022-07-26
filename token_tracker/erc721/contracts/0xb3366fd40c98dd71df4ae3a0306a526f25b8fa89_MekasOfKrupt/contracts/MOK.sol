// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MekasOfKrupt is ERC721, Ownable {
    uint internal constant TOKEN_LIMIT = 888;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;


    mapping(address => bool) public whitelist;
    mapping(address => bool) public hasMinted;
    uint256 internal _mintPrice = 0;

    address payable internal devTeam;

    string internal _baseTokenURI;
    bool internal saleStarted = false;
    bool internal openToPublic = false;
    bool internal URISet = false;
    Counters.Counter private _devSupplyAwarded;



    /// The sale has not started yet.
    error SaleNotStarted();
    /// Max tokens have been minted.
    error MaxTokensMinted();
    /// You are not on the whitelist
    error NotOnWhitelist();
    /// You have minted your allowance
    error MintedAllowance();
    /// msg.value too low
    error MintPayableTooLow();
    /// Sale has already started
    error SaleStarted();
    /// URI has not been set yet
    error URINotSet();
    /// Mint price set to low
    error MintPriceTooLow();
    /// Dev team award limit reached.
    error DevTeamAwardLimit();

    constructor(string memory name, string memory symbol, address devTeamAddress) ERC721(name, symbol) {
        devTeam = payable(devTeamAddress);
        _tokenIdCounter.increment(); // dev: starts tokens at id of 1
    }

    /**
     * @dev takes a list of addresses and gives each address a allocation of mints
     */
    function addToWhiteList(address[] memory whitelist_addresses) external onlyOwner {
        for (uint i = 0; i < whitelist_addresses.length; i++) {
            whitelist[whitelist_addresses[i]] = true;
        }
    }

    /**
     * @dev Creates a new token. Its token ID will be automatically
     * assigned (and available on the emitted {IERC721-Transfer} event), and the token
     * URI autogenerated based on the base URI passed at construction.
     *
     * See {ERC721-_mint}.
     *
     */
    function safeMint(address to) external payable {
        if (saleStarted == false)
            revert SaleNotStarted(); // dev: sale not started
        if (whitelist[msg.sender] == false && openToPublic == false)
            revert NotOnWhitelist(); // dev: not on the whitelist
        if (hasMinted[msg.sender] == true)
            revert MintedAllowance(); // dev: allowance minted
        uint256 tokenId = _tokenIdCounter.current();
        if (tokenId > TOKEN_LIMIT)
            revert MaxTokensMinted(); // dev: max token supply minted
        if (msg.value < _mintPrice)
            revert MintPayableTooLow(); // dev: msg.value too low
        hasMinted[msg.sender] = true;
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    /**
    * open mint up to the public
    */
    function openMintToPublic() external onlyOwner {
        openToPublic = true;
    }

    /**
    * Start the sale (cant be stopped later)
    */
    function startSale(uint256 mintPrice) external virtual onlyOwner {
        if (saleStarted == true)
            revert SaleStarted(); // dev: sale has already started
        if (URISet == false)
            revert URINotSet(); // dev: uri must be set
        if (mintPrice < 0.09 ether)
            revert MintPriceTooLow(); // dev: mint price too low
        _mintPrice = mintPrice;
        saleStarted = true;
    }
    
    /**
    * Can only be called twice. Gives 48 total Tokens to devs for giveaways, marketing purposes and team members.
    */
    function devAward() external onlyOwner {
        uint256 devSupplyAwarded = _devSupplyAwarded.current();
        if (devSupplyAwarded >= 2)
            revert DevTeamAwardLimit(); // dev: dev award limit reached

        for(uint i = 0; i < 24; i++){
            uint256 tokenId = _tokenIdCounter.current();
            if (tokenId > TOKEN_LIMIT)
                break;
            _tokenIdCounter.increment();
            _safeMint(devTeam, tokenId);
        }
        _devSupplyAwarded.increment();
    }

    /**
    * Withdraw contract funds to dev team address
    */
    function withdrawFunds() external virtual onlyOwner {
        devTeam.transfer(address(this).balance);
    }

    function setBaseURI(string memory baseTokenURI) external onlyOwner {
        _baseTokenURI = baseTokenURI;
        URISet = true;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
    */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function getMaxSupply() external pure returns (uint256) {
        return TOKEN_LIMIT;
    }

    function getMintPrice() external view returns (uint256) {
        return _mintPrice;
    }

    function getSaleStarted() external view returns (bool) {
        return saleStarted;
    }

    function getOpenToPublic() external view returns (bool) {
        return openToPublic;
    }

}