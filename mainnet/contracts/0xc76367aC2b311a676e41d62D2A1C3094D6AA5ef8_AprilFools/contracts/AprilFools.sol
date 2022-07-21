//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error MintIsPaused();
error MintMoreThanMaxSupply();
error MintMoreThanTxnLimit();
error MintEthValueNotEnough();
error WithdrawFailed();
error MintMoreThanWalletLimit();

contract AprilFools is ERC721A, Ownable {

    uint256 public constant MINT_COST = 0.00 ether;
    uint256 public constant MAX_SUPPLY = 1422;
    uint256 public constant MAX_MINT_AMOUNT_PER_TX = 3;
    uint256 public constant MAX_MINT_AMOUNT_PER_WALLET = 6;

    bool public paused = true;
    bool public revealed = false;

    // must be a form <protocol>://<path>/, i.e. it needs the trailing slash 
    string private _hiddenMetadataURI;
    string private _revealedMetadataBaseURI;

    constructor(string memory hiddenMetadataURI) ERC721A("April Fools", "FOOLS") {
        _hiddenMetadataURI = hiddenMetadataURI;
    }

    function mint(uint256 quantity) external payable {
        if (paused) revert MintIsPaused();
        if (quantity <= 0) revert MintZeroQuantity();
        if (quantity > MAX_MINT_AMOUNT_PER_TX) revert MintMoreThanTxnLimit();
        if (_currentIndex + quantity - _startTokenId() > MAX_SUPPLY) revert MintMoreThanMaxSupply();
        if (this.balanceOf(msg.sender) + quantity > MAX_MINT_AMOUNT_PER_WALLET) revert MintMoreThanWalletLimit();

        // _safeMint's second argument now takes in a quantity, not a tokenId.
        _safeMint(msg.sender, quantity);
    }

    function premint(uint256 quantity) external payable onlyOwner {
        if (quantity <= 0) revert MintZeroQuantity();
        if (_currentIndex + quantity - _startTokenId() > MAX_SUPPLY) revert MintMoreThanMaxSupply();

        // _safeMint's second argument now takes in a quantity, not a tokenId.
        _safeMint(msg.sender, quantity);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        return (revealed) ? super.tokenURI(tokenId) : _hiddenMetadataURI;
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`.
     */
    function _baseURI() internal view override returns (string memory) {
        return _revealedMetadataBaseURI;
    }

    function setRevealedMetadataBaseURI(string memory revealedMetadataBaseURI) external onlyOwner {
        _revealedMetadataBaseURI = revealedMetadataBaseURI;
    }

    function setRevealed(bool revealed_) external onlyOwner {
        revealed = revealed_;
    }

    function setPaused(bool paused_) external onlyOwner {
        paused = paused_;
    }

    function withdraw() external onlyOwner {
        // transfer the full value of the contract to the vault
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");

        if (!success) revert WithdrawFailed();
    }
}
