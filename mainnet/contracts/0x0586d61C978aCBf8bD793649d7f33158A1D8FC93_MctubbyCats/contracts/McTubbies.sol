//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../erc721a/contracts/ERC721A.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract MctubbyCats is Ownable, ERC721A {
    uint256 public constant MAX_SUPPLY = 10000;

    uint256 public publicPrice = 0.01 ether;

    uint256 public constant PUBLIC_MINT_LIMIT_TXN = 10;
    uint256 public constant PUBLIC_MINT_LIMIT = 1000;

    string public baseURI =
        "ipfs://bafybeiauxdbkmxzkqk2mfjlv6nnn53exrchmwlbrcypstmpop4vmtcy52e/";

    bool public freeSale = true;
    bool public publicSale = false;

    mapping(address => bool) public userMintedFree;
    mapping(address => uint256) public numUserMints;

    constructor() ERC721A("McTubby Cats", "McTbc") {}

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function freeMint(uint256 quantity)
        external
        payable
        mintCompliance(quantity)
    {
        require(freeSale, "Free sale inactive");
        require(msg.value == 0, "This phase is free");
        require(quantity <= 5, "Only 5 free");

        uint256 newSupply = totalSupply() + quantity;

        require(newSupply <= 2000, "Not enough free supply");

        require(!userMintedFree[msg.sender], "max free limit");

        userMintedFree[msg.sender] = true;

        if (newSupply == 2000) {
            freeSale = false;
            publicSale = true;
        }

        _safeMint(msg.sender, quantity);
    }

    function priceCheck(uint256 price) private {
        if (msg.value < price) {
            revert("Not enough ETH");
        }
    }

    function publicMint(uint256 quantity)
        external
        payable
        mintCompliance(quantity)
    {
        require(publicSale, "Public sale inactive");
        require(quantity <= PUBLIC_MINT_LIMIT_TXN, "Quantity too high");

        uint256 price = publicPrice;
        uint256 currMints = numUserMints[msg.sender];

        require(currMints + quantity <= PUBLIC_MINT_LIMIT, "maxmint limit");

        priceCheck(price * quantity);

        numUserMints[msg.sender] = (currMints + quantity);

        _safeMint(msg.sender, quantity);
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
        uint256 currentTokenId = 1;
        uint256 ownedTokenIndex = 0;

        while (
            ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY
        ) {
            address currentTokenOwner = ownerOf(currentTokenId);

            if (currentTokenOwner == _owner) {
                ownedTokenIds[ownedTokenIndex] = currentTokenId;

                ownedTokenIndex++;
            }

            currentTokenId++;
        }

        return ownedTokenIds;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return
            string(
                abi.encodePacked(baseURI, Strings.toString(_tokenId), ".json")
            );
    }

    function contractURI() public view returns (string memory) {
        return baseURI;
    }

    function setPublicPrice(uint256 _publicPrice) public onlyOwner {
        publicPrice = _publicPrice;
    }

    function setContractURI(string memory _contractURI) public onlyOwner {
        baseURI = _contractURI;
    }

    function setPublicEnabled(bool _state) public onlyOwner {
        publicSale = _state;
        freeSale = !_state;
    }

    function setFreeEnabled(bool _state) public onlyOwner {
        freeSale = _state;
        publicSale = !_state;
    }

    address private constant walletA = 0xC06434D66e1c01eB02b313ed0C4839188005ad8D;
    address private constant walletB = 0x4253Ef2F48A704796ECb77F863CFDCFECe20714b;
	address private constant walletC = 0x95AbEF9003200968FC01Ef7Fc70D3F61472CEbCC;

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;

		Address.sendValue(payable(walletA), (balance * 33) / 100);
		Address.sendValue(payable(walletB), (balance * 33) / 100);
		Address.sendValue(payable(walletC), (balance * 34) / 100);
    }

    modifier mintCompliance(uint256 quantity) {
        require(
            totalSupply() + quantity <= MAX_SUPPLY,
            "Not enough mints left"
        );
        require(tx.origin == msg.sender, "No contract minting");
        _;
    }
}
