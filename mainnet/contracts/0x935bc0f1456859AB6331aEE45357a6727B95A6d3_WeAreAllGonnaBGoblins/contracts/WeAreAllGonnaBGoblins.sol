/*
 /$$$$$$$$                                /$$$$$$                  /$$           /$$   /$$ /$$$$$$$$ /$$$$$$$$
|_____ $$                                /$$__  $$                | $$          | $$$ | $$| $$_____/|__  $$__/
     /$$/   /$$$$$$   /$$$$$$   /$$$$$$ | $$  \__/  /$$$$$$   /$$$$$$$  /$$$$$$ | $$$$| $$| $$         | $$
    /$$/   /$$__  $$ /$$__  $$ /$$__  $$| $$       /$$__  $$ /$$__  $$ /$$__  $$| $$ $$ $$| $$$$$      | $$
   /$$/   | $$$$$$$$| $$  \__/| $$  \ $$| $$      | $$  \ $$| $$  | $$| $$$$$$$$| $$  $$$$| $$__/      | $$
  /$$/    | $$_____/| $$      | $$  | $$| $$    $$| $$  | $$| $$  | $$| $$_____/| $$\  $$$| $$         | $$
 /$$$$$$$$|  $$$$$$$| $$      |  $$$$$$/|  $$$$$$/|  $$$$$$/|  $$$$$$$|  $$$$$$$| $$ \  $$| $$         | $$
|________/ \_______/|__/       \______/  \______/  \______/  \_______/ \_______/|__/  \__/|__/         |__/

Drop Your NFT Collection With ZERO Coding Skills at https://zerocodenft.com
*/
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract WeAreAllGonnaBGoblins is ERC721, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint;
    enum SaleStatus{ PAUSED, PRESALE, PUBLIC
    }

    Counters.Counter private _tokenIds;

    uint public constant COLLECTION_SIZE = 5555;
    uint public constant FIRSTXFREE = 2;
    uint public constant TOKENS_PER_TRAN_LIMIT = 75;
    uint public constant TOKENS_PER_PERSON_PUB_LIMIT = 250;
    
    
    uint public MINT_PRICE = 0.002 ether;
    SaleStatus public saleStatus = SaleStatus.PAUSED;
    
    string private _baseURL;
    string private _hiddenURI = "ipfs://Qme8QL7UBWsf1dudwYDu9wh4uD5dbTnrWLsCSb59yC3rqC";
    mapping(address => uint) private _mintedCount;
    

    constructor() ERC721("WeAreAllGonnaBGoblins",
    "WAGBG"){}
    /// @notice Reveal metadata for all the tokens
    function reveal(string memory uri) external onlyOwner {
        _baseURL = uri;
    }
    /// @notice Set Pre Reveal URL
    function setPreRevealUri(string memory url) external onlyOwner {
        _hiddenURI = url;
    }
    

    function totalSupply() external view returns (uint) {
        return _tokenIds.current();
    }
    /// @dev override base uri. It will be combined with token ID
    function _baseURI() internal view override returns (string memory) {
        return _baseURL;
    }
    /// @notice Update current sale stage
    function setSaleStatus(SaleStatus status) external onlyOwner {
        saleStatus = status;
    }
    /// @notice Update public mint price
    function setPublicMintPrice(uint price) external onlyOwner {
        MINT_PRICE = price;
    }
    /// @notice Withdraw contract balance
    function withdraw() external onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0,
        "No balance");
        payable(owner()).transfer(balance);
    }
    /// @notice Allows owner to mint tokens to a specified address
    function airdrop(address to, uint count) external onlyOwner {
        require(_tokenIds.current() + count <= COLLECTION_SIZE,
        "Request exceeds collection size");
        _mintTokens(to, count);
    }
    /// @notice Get token URI. In case of delayed reveal we give user the json of the placeholer metadata.
    /// @param tokenId token ID
    function tokenURI(uint tokenId) public view override returns (string memory) {
        require(_exists(tokenId),
        "ERC721Metadata: URI query for nonexistent token");
        string memory baseURI = _baseURI();

        return bytes(baseURI).length > 0 
            ? string(abi.encodePacked(baseURI, tokenId.toString(),
        ".json")) 
            : _hiddenURI;
    }
    /// @notice Mints specified amount of tokens
    /// @param count How many tokens to mint
    function mint(uint count) external payable {
        require(saleStatus != SaleStatus.PAUSED,
        "ZeroCodeNFT: Sales are off");
        require(_tokenIds.current() + count <= COLLECTION_SIZE,
        "ZeroCodeNFT: Number of requested tokens will exceed collection size");
        require(count <= TOKENS_PER_TRAN_LIMIT,
        "ZeroCodeNFT: Number of requested tokens exceeds allowance (75)");
        require(_mintedCount[msg.sender
        ] + count <= TOKENS_PER_PERSON_PUB_LIMIT,
        "ZeroCodeNFT: Number of requested tokens exceeds allowance (250)");
        uint payForCount = count;
        
        if(FIRSTXFREE > _tokenIds.current()) {
            uint freeLeft = FIRSTXFREE - _tokenIds.current();
            if(count > freeLeft) {
                // just pay the difference
                payForCount = count - freeLeft;
            }
            else {
                payForCount = 0;
            }
        }
        require(msg.value >= payForCount * MINT_PRICE,
        "ZeroCodeNFT: Ether value sent is not sufficient");
        _mintedCount[msg.sender
        ] += count;
        _mintTokens(msg.sender, count);
    }
    /// @dev Perform actual minting of the tokens
    function _mintTokens(address to, uint count) internal {
        for(uint index = 0; index < count; index++) {

            _tokenIds.increment();
            uint newItemId = _tokenIds.current();

            _safeMint(to, newItemId);
        }
    }
}