//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
import './ERC721X.sol';

contract Streetsof is ERC721X, Ownable {
    using ECDSA for bytes32;
    using Strings for uint256;

    event SaleStateUpdate(bool active);

    string public baseURI = "ipfs://none";
    string public unrevealedURI = 'ipfs://QmNzkKAghuoi9ydUEPvrU5brHevpc98pkjX5g3kGM2oaMi/Streetsof.json';

    bool public publicSaleActive;

    uint256 public totalSupply;
    uint256 public MAX_SUPPLY = 420;
    uint256 public constant PREMINT_AMOUNT = 1;
    uint256 public RESERVED_AMOUNT = 0;

    uint256 public price = 0 ether;
    uint256 public purchaseLimit = 1;

    mapping(address => uint256) public _publicMinted;

    address private _signerAddress = 0x90BCD83a41425Cf0DFbcaa3Eb9b21627568dd6E2;

    bool public revealed = false;

    constructor() ERC721X('Streetsof', 'STREETSOF') {
        _mintBatch(msg.sender, PREMINT_AMOUNT);
    }

    // ------------- External -------------

    function mint(uint256 amount) external payable whenPublicSaleActive noContract {
        require(_publicMinted[msg.sender] + amount <= purchaseLimit, 'EXCEEDS_LIMIT');
        require(msg.value == price * amount, 'INCORRECT_VALUE');
       
        _publicMinted[msg.sender] = _publicMinted[msg.sender] + amount;
        _mintBatch(msg.sender, amount);
    }

    function ownMint(uint256 amount) external onlyOwner {
        _mintBatch(msg.sender, amount);
    } 

    function reduceSupply(uint256 newMaxSupply) external onlyOwner {
            MAX_SUPPLY = newMaxSupply;
        }
    // ------------- Private -------------

    function _mintBatch(address to, uint256 amount) private {
        uint256 tokenId = totalSupply;
        require(tokenId + amount <= MAX_SUPPLY - RESERVED_AMOUNT, 'MAX_SUPPLY_REACHED');
        require(amount > 0, 'MUST_BE_GREATER_0');

        for(uint256 i=1; i <= amount; i++)_mint(to, tokenId + i);
        totalSupply += amount;
    }

    function _validSignature(bytes memory signature, bytes32 data) private view returns (bool) {
        bytes32 msgHash = keccak256(abi.encode(address(this), data, msg.sender));
        return msgHash.toEthSignedMessageHash().recover(signature) == _signerAddress;
    }

    // ------------- View -------------

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');

        if (!revealed) return unrevealedURI;
        return string(abi.encodePacked(baseURI, tokenId.toString(), '.json'));
    }

    // ------------- Admin -------------
    
        
    function setReserve(uint256 value) external onlyOwner {
        RESERVED_AMOUNT = value;
    }

    function reveal(bool value) external onlyOwner {
        revealed = value;
    }

    function setPrice(uint256 price_) external onlyOwner {
        price = price_;
    }

    function setPurchaseLimit(uint256 limit) external onlyOwner {
        purchaseLimit = limit;
    }

    function setSignerAddress(address address_) external onlyOwner {
        _signerAddress = address_;
    }

    function setPublicSaleActive(bool active) external onlyOwner {
        publicSaleActive = active;
        emit SaleStateUpdate(active);
    }

    function setBaseURI(string memory _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }

    function setUnrevealedURI(string memory _uri) external onlyOwner {
        unrevealedURI = _uri;
    }

    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

    function recoverToken(IERC20 token) external onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        token.transfer(owner(), balance);
    }

    modifier whenPublicSaleActive() {
        require(publicSaleActive, 'PUBLIC_SALE_NOT_ACTIVE');
        _;
    }

    modifier noContract() {
        require(tx.origin == msg.sender, 'CONTRACT_CALL');
        _;
    }

    function tokenIdsOf(address owner) external view returns (uint256[] memory) {
        uint256[] memory ids = new uint256[](balanceOf(owner));
        uint256 count;
        for (uint256 i; i < balanceOf(owner); ++i) ids[count++] = tokenOfOwnerByIndex(owner, i);
        return ids;
    }
}