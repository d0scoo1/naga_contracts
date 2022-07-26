// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "erc721a/contracts/extensions/ERC721APausable.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract BENDAO is ERC721A, ERC721AQueryable, ERC721APausable, ERC721ABurnable, Ownable, ReentrancyGuard {
    using Strings for uint;

    uint public PRICE;
    uint public MAX_SUPPLY;
    uint public MAX_MINT_AMOUNT_PER_TX;
    uint16 public MAX_FREE_MINTS_PER_WALLET;
    string private BASE_URI;
    bool public SALE_IS_ACTIVE;
    bool public METADATA_FROZEN;
    bool public DIFFERENT_METADATA_PER_TOKEN;

    uint public totalFreeMinted;

    constructor(uint price,
        uint maxSupply,
        uint maxMintPerTx,
        uint16 maxFreeMintsPerWallet,
        string memory baseUri) ERC721A("Ben DAO", "BENDAO") {
        PRICE = price;
        MAX_SUPPLY = maxSupply;
        MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
        MAX_FREE_MINTS_PER_WALLET = maxFreeMintsPerWallet;
        BASE_URI = baseUri;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return BASE_URI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory baseURI = _baseURI();
        if (!DIFFERENT_METADATA_PER_TOKEN) return baseURI;
        return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
    }


    function getFreeMints(address addy) external view returns (uint64) {
        return _getAux(addy);
    }

    /** SETTERS **/

    function setPrice(uint price) external onlyOwner {
        PRICE = price;
    }

    function setMaxSupply(uint newMaxSupply) external onlyOwner {
        require(newMaxSupply >= _currentIndex, "Invalid new max supply");
        require(newMaxSupply <= 10000, "Invalid new max supply");
        MAX_SUPPLY = newMaxSupply;
    }

    function setMaxMintPerTx(uint maxMint) external onlyOwner {
        MAX_MINT_AMOUNT_PER_TX = maxMint;
    }

    function setMaxFreeMintsPerWallet(uint16 maxFreeMintsPerWallet) external onlyOwner {
        MAX_FREE_MINTS_PER_WALLET = maxFreeMintsPerWallet;
    }

    function setBaseURI(string memory customBaseURI_) external onlyOwner {
        require(!METADATA_FROZEN, "Metadata frozen!");
        BASE_URI = customBaseURI_;
    }

    function setSaleState(bool state) external onlyOwner {
        SALE_IS_ACTIVE = state;
    }

    function setDifferentMetadata(bool state) external onlyOwner {
        DIFFERENT_METADATA_PER_TOKEN = state;
    }

    function freezeMetadata() external onlyOwner {
        METADATA_FROZEN = true;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    /** MINT **/

    modifier mintCompliance(uint _mintAmount) {
        require(_currentIndex + _mintAmount <= MAX_SUPPLY, "Max supply exceeded!");
        require(_mintAmount > 0, "Invalid mint amount!");
        _;
    }

    function mint(uint32 _mintAmount) public payable mintCompliance(_mintAmount) {
        uint64 usedFreeMints = _getAux(msg.sender);
        uint64 remainingFreeMints = MAX_FREE_MINTS_PER_WALLET - usedFreeMints;
        require(_mintAmount <= MAX_MINT_AMOUNT_PER_TX, "Mint limit exceeded!");
        require(_currentIndex >= 10, "First 10 mints are reserved for the owner!");
        require(SALE_IS_ACTIVE, "Sale not started");

        uint price = PRICE * _mintAmount;

        uint64 freeMinted = 0;

        if (remainingFreeMints > 0) {
            if (_mintAmount >= remainingFreeMints) {
                price -= remainingFreeMints * PRICE;
                freeMinted = remainingFreeMints;
                remainingFreeMints = 0;
            } else {
                price -= _mintAmount * PRICE;
                freeMinted = _mintAmount;
                remainingFreeMints -= _mintAmount;
            }
        }

        require(msg.value >= price, "Insufficient funds!");
        _safeMint(msg.sender, _mintAmount);

        totalFreeMinted += freeMinted;
        _setAux(msg.sender, usedFreeMints + freeMinted);
    }

    function mintOwner(address _to, uint _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
        _safeMint(_to, _mintAmount);
    }

    /** PAYOUT **/

    function withdraw() public onlyOwner nonReentrant {
        uint balance = address(this).balance;
        Address.sendValue(payable(owner()), balance);
    }

    function _beforeTokenTransfers(
        address from,
        address to,
        uint startTokenId,
        uint quantity
    ) internal virtual override(ERC721A, ERC721APausable) {
        super._beforeTokenTransfers(from, to, startTokenId, quantity);
    }
}
