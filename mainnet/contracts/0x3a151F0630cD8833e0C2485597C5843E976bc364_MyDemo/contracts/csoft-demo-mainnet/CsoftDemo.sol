// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./EIP712Whitelist.sol";


contract MyDemo is ERC721, ERC721Enumerable, Ownable,  ERC721Burnable, ERC721Royalty, EIP712Whitelist{
    using Strings for uint256;
    using Counters for Counters.Counter;

    uint256 private constant PRICE = 0.001 ether;   //development
    uint256 private constant MAX_SUPPLY = 30;   //development
    uint256 private constant MAX_PRIVATE_SUPPLY = 10;    //development
    uint256 private constant MAX_PER_MINT = 20;
    address private constant WALLET_ADDRESS = 0x6471DAC705f93593893c268FaB33186Eaf5591cd;   //development
    uint96 private constant SELLER_FEE = 500;
    
    bool public publicSale;
    bool public privateSale; 
    bool public locked;
    mapping(uint256=>bool) public usedNonce;
    string private baseURI_ = "ipfs://QmUCE9Ltt8dKb7BBBkFEqJ337ic1vfRtdEtXkfFWst2Lts/";
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("MyDemo", "DM") {
        _setDefaultRoyalty(WALLET_ADDRESS, SELLER_FEE);
    }

    /**
        @notice change base uri to reveal blind box 
        @param newBaseURI the new uri
    */
    function setBaseURI(string calldata newBaseURI) external onlyOwner {
        require(!locked, "URI is Locked");
        baseURI_ = newBaseURI;
    }

    /**
        @notice lock uri after blind box is revealed
    */
    function lockURI() external onlyOwner{
        locked = true;
    }

    /**
        @notice get the total supply including burned token
    */
    function tokenIdCurrent() external view returns(uint256) {
        return _tokenIdCounter.current();
    }

    function _safeMint(address to) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    /**
        @notice air drop tokens to recievers
        @param recievers each account will receive one token
    */
    function airDrop(address[] calldata recievers) external onlyOwner {
        require(recievers.length <= MAX_PER_MINT, "High Quntity");
        require(_tokenIdCounter.current() + recievers.length <= MAX_SUPPLY,  "Out of Stock");

        for (uint256 i = 0; i < recievers.length; i++) {
            _safeMint(recievers[i]);
        }
    }

    /**
        @notice  mint with valid signature 
        @param tokenQuantity number of token to be minted
        @param signature signature of typed data TicketSigner
    */
    function privateMint(uint256 tokenQuantity, bytes calldata signature) external payable{
        require(privateSale, "Private Sale Not Allowed");
        require(tokenQuantity <= MAX_PER_MINT, "High Quntity");
        require(tokenQuantity > 0, "Mint at least one");
        require(_tokenIdCounter.current() + tokenQuantity <= MAX_PRIVATE_SUPPLY,  "Out of Stock");
        require(PRICE * tokenQuantity <= msg.value,  "INSUFFICIENT_ETH");
        require(simpleVerify(signature), "Invalid Signature");

        for (uint256 i = 0; i < tokenQuantity; i++) {
            _safeMint(msg.sender);
        }
    }
    
    /**
        @notice  mint one token with a one-time discount signature
        @param signature signature of typed data Ticket
    */
    function whitelistMint(uint256 nonce, uint256 price, uint256 startAt, uint256 endAt, bytes calldata signature) external payable {
        require(_tokenIdCounter.current() <= MAX_SUPPLY,  "Out of Stock");
        require(block.timestamp < endAt, "Signature Expired");
        require(block.timestamp > startAt, "Cannot buy before startAt");
        require(price <= msg.value,  "INSUFFICIENT_ETH");

        // verify signature
        require(!usedNonce[nonce], "Used Nonce"); 
        require(verify(msg.sender, nonce, price, startAt, endAt, signature), "Invalid signatrue");
        usedNonce[nonce] = true;

        // mint token
        _safeMint(msg.sender);
    }

    /**
        @notice mint tokens if publicSale is true
        @param tokenQuantity number of token to be minted
    */
    function publicMint(uint256 tokenQuantity) external payable{
        require(publicSale, "Public Sale Not Allowed");
        require(tokenQuantity <= MAX_PER_MINT, "High Quntity");
        require(tokenQuantity > 0, "Mint at least one");
        require(_tokenIdCounter.current() + tokenQuantity <= MAX_SUPPLY,  "Out of Stock");
        require(PRICE * tokenQuantity <= msg.value,  "INSUFFICIENT_ETH");
        
        for (uint256 i = 0; i < tokenQuantity; i++) {
            _safeMint(msg.sender);
        }
    }
    
    /**
        @notice enable/disable publicMint
    */
    function togglePublicSaleStatus() external onlyOwner {
        publicSale = !publicSale;
    }

    /**
        @notice enable/disable privateMint 
    */
    function togglePrivateSaleStatus() external onlyOwner {
        privateSale = !privateSale;
    }

    /**
        @notice transfer all contract balance to wallet 
    */
    function withdraw() external {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance");
        payable(WALLET_ADDRESS).transfer(address(this).balance);
    }


    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, tokenId.toString(), ".json")) : "";
    }

    function _burn(uint256 tokenId) internal override (ERC721, ERC721Royalty){
        super._burn(tokenId);
    }
}
