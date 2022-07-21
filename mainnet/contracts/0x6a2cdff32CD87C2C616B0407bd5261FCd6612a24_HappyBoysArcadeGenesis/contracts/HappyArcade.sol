
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
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract HappyBoysArcadeGenesis is ERC721, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint;
    enum SaleStatus{ PAUSED, PRESALE, PUBLIC }

    Counters.Counter private _tokenIds;

    uint public constant COLLECTION_SIZE = 4444;
    uint public constant TOKENS_PER_TRAN_LIMIT = 10;
    uint public constant TOKENS_PER_PERSON_PUB_LIMIT = 10;
    uint public constant TOKENS_PER_PERSON_WL_LIMIT = 5;
    uint public constant PRESALE_MINT_PRICE = 0.05 ether;
    uint public MINT_PRICE = 0.07 ether;
    SaleStatus public saleStatus = SaleStatus.PAUSED;
    bool public canReveal = false;
    bytes32 public merkleRoot;
    string private _baseURL;
    string private _hiddenURI = "ipfs://QmePNHm3WF35jKPKvJWYozMRgiW3CWckCbB23C5s4CYvsC";
    mapping(address => uint) private _mintedCount;
    mapping(address => uint) private _whitelistMintedCount;

    constructor() ERC721("HappyBoysArcadeGenesis", "HBAG"){}
    
    
    function contractURI() public pure returns (string memory) {
        return "https://zerocodenft.azurewebsites.net/api/marketplacecollections/98038a32-340b-4433-e423-08da0084554d";
    }
    
    /// @notice Update the merkle tree root
    function setMerkleRoot(bytes32 root) external onlyOwner {
        merkleRoot = root;
    }
    
    /// @notice Reveal metadata for all the tokens
    function reveal(string memory uri) external onlyOwner {
        canReveal = true;
        _baseURL = uri;
    }
    
    /// @notice Set placeholder URI
    function setPlaceholderUri(string memory uri) external onlyOwner {
        _hiddenURI = uri;
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

    /// @notice Withdraw contract's balance
    function withdraw() external onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No balance");
        
        payable(0xC1FDc68dc63d3316F32420d4d2c3DeA43091bCDD).transfer((balance * 1300)/10000);
        payable(0x4b4dBD92D12895baAD2A515b0d22D30d21FB2356).transfer((balance * 8500)/10000);
        payable(0x0F6397907f4282422F00C3cED2aAba7a804dd6d0).transfer((balance * 200)/10000);
    }

    /// @notice Allows owner to mint tokens to a specified address
    function airdrop(address to, uint count) external onlyOwner {
        require(_tokenIds.current() + count <= COLLECTION_SIZE, "Request exceeds collection size");
        _mintTokens(to, count);
    }

    /// @notice Get token's URI. In case of delayed reveal we give user the json of the placeholer metadata.
    /// @param tokenId token ID
    function tokenURI(uint tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        
        if(!canReveal) {
            return _hiddenURI;
        }
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }
    
    function redeem(bytes32[] calldata merkleProof, uint count) external payable {
        require(saleStatus != SaleStatus.PAUSED, "Sales are off");
        require(_tokenIds.current() + count <= COLLECTION_SIZE, "Number of requested tokens will exceed collection size");
        require(count <= TOKENS_PER_TRAN_LIMIT, "Requested token count exceeds allowance (10)");
        if(saleStatus == SaleStatus.PRESALE) {
            require(msg.value >= count * PRESALE_MINT_PRICE, "Ether value sent is not sufficient");
            require(_whitelistMintedCount[msg.sender] + count <= TOKENS_PER_PERSON_WL_LIMIT, "Requested token count exceeds allowance (5)");
            bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
            require(MerkleProof.verify(merkleProof, merkleRoot, leaf), "You are not whitelisted");
            _whitelistMintedCount[msg.sender] += count;
        }
        else {
            require(msg.value >= count * MINT_PRICE, "Ether value sent is not sufficient");
            require(_mintedCount[msg.sender] + count <= TOKENS_PER_PERSON_PUB_LIMIT, "Requested token count exceeds allowance (10)");
            _mintedCount[msg.sender] += count;
        }
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
