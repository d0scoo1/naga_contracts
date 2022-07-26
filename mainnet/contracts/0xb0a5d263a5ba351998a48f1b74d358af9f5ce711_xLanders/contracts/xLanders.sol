// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract xLanders is ERC721A, Ownable, ReentrancyGuard {
    using Strings for uint256;

    uint256 public PRICE;
    uint256 public MAX_SUPPLY;
    string private BASE_URI;
    uint256 public FREE_MINT_LIMIT_PER_WALLET;
    uint256 public MAX_MINT_AMOUNT_PER_TX;
    bool public IS_SALE_ACTIVE;
    uint256 public FREE_MINT_IS_ALLOWED_UNTIL;
    bool public METADATA_FROZEN;

    mapping(address => uint256) private freeMintCountMap;

    constructor(
        uint256 price,
        uint256 maxSupply,
        string memory baseUri,
        uint256 freeMintAllowance,
        uint256 maxMintPerTx,
        bool isSaleActive,
        uint256 freeMintIsAllowedUntil
    ) ERC721A("0xLanders", "0xLanders") {
        PRICE = price;
        MAX_SUPPLY = maxSupply;
        BASE_URI = baseUri;
        FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
        MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
        IS_SALE_ACTIVE = isSaleActive;
        FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
    }

    /** FREE MINT **/

    function updateFreeMintCount(address minter, uint256 count) private {
        freeMintCountMap[minter] += count;
    }

    /** GETTERS **/

    function _baseURI() internal view virtual override returns (string memory) {
        return BASE_URI;
    }

    /** SETTERS **/

    function setPrice(uint256 customPrice) external onlyOwner {
        PRICE = customPrice;
    }

    function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
        require(newMaxSupply < MAX_SUPPLY, "Invalid new max supply");
        require(newMaxSupply >= _currentIndex, "Invalid new max supply");
        MAX_SUPPLY = newMaxSupply;
    }

    function setBaseURI(string memory customBaseURI_) external onlyOwner {
        require(!METADATA_FROZEN, "Metadata frozen!");
        BASE_URI = customBaseURI_;
    }

    function setFreeMintAllowance(uint256 freeMintAllowance)
        external
        onlyOwner
    {
        FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
    }

    function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
        MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
    }

    function setSaleActive(bool saleIsActive) external onlyOwner {
        IS_SALE_ACTIVE = saleIsActive;
    }

    function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil)
        external
        onlyOwner
    {
        FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
    }

    function freezeMetadata() external onlyOwner {
        METADATA_FROZEN = true;
    }

    /** MINT **/

    modifier mintCompliance(uint256 _mintAmount) {
        require(
            _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
            "Invalid mint amount!"
        );
        require(
            _currentIndex + _mintAmount <= MAX_SUPPLY,
            "Max supply exceeded!"
        );
        _;
    }

    function mint(uint256 _mintAmount)
        public
        payable
        mintCompliance(_mintAmount)
    {
        require(IS_SALE_ACTIVE, "Sale is not active!");

        uint256 price = PRICE * _mintAmount;

        if (_currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
            uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET -
                freeMintCountMap[msg.sender];
            if (remainingFreeMint > 0) {
                if (_mintAmount >= remainingFreeMint) {
                    price -= remainingFreeMint * PRICE;
                    updateFreeMintCount(msg.sender, remainingFreeMint);
                } else {
                    price -= _mintAmount * PRICE;
                    updateFreeMintCount(msg.sender, _mintAmount);
                }
            }
        }

        require(msg.value >= price, "Insufficient funds!");

        _safeMint(msg.sender, _mintAmount);
    }

    function mintOwner(address _to, uint256 _mintAmount)
        public
        mintCompliance(_mintAmount)
        onlyOwner
    {
        _safeMint(_to, _mintAmount);
    }

    /** PAYOUT **/

    function withdraw() public onlyOwner nonReentrant {
        uint256 amount = address(this).balance;
        Address.sendValue(
            payable(0x5Eb6b53b12aca41E0765cDBDa8309c3EF0c9B9e6),
            amount
        );
    }
}
