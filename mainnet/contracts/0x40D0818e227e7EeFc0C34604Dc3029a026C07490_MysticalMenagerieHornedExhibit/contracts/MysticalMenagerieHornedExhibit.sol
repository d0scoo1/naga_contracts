// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";

contract MysticalMenagerieHornedExhibit is ERC721A, Ownable {

    string  public baseURI;
    bytes32 private merkleRoot;

    address public proxyRegistryAddress = 0x1E525EEAF261cA41b809884CBDE9DD9E1619573A;
    address public lead;

    bool public paused = true;
    bool public presale = true;

    uint8 public maxPerTX = 3;
    uint8 public maxWLAllowed = 3;
    uint256 public cost = 0.08 ether;
    uint256 public maxSupply = 2500;

    mapping(address => uint) public addressMintedBalance;
    
    constructor(
        string memory _baseURI,
        bytes32 _merkleRoot,
        address _lead
    ) ERC721A ("MysticalMenagerieHornedExhibit", "MMHE") 
    {
        baseURI = _baseURI;
        merkleRoot = _merkleRoot;
        lead = _lead;
    }

    modifier notPaused() {
        require(!paused, "Contract is Paused");
        _;
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, 'The caller is another contract.');
        _;
    }

    modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
        require(
            MerkleProof.verify(
                merkleProof,
                root,
                keccak256(abi.encodePacked(msg.sender))
            ),
            "Address does not exist in list"
        );
        _;
    }

    modifier isPresale() {
        require(presale == true, "Presale not active");
        _;
    }

    modifier isPublicSale() {
        require(!presale, "Sale not Public");
        _;
    }

    modifier isCorrectPayment(uint256 price, uint256 quantity) {
        require(
            cost * quantity == msg.value,
            "Incorrect ETH value sent"
        );
        _;
    }

    function setBaseURI(string memory _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "Token does not exist.");
        return string(abi.encodePacked(baseURI, Strings.toString(_tokenId),".json"));
    }

    function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyOwner {
        proxyRegistryAddress = _proxyRegistryAddress;
    }

    function setWLMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }
    
    function togglePaused(bool _state) external onlyOwner {
        paused = _state;
    }

    function togglePresale(bool _state) external onlyOwner {
        presale = _state;
    }

    function presaleMint(
        bytes32[] calldata proof,
        uint256 _quantity
    )
        public 
        payable 
        notPaused() 
        callerIsUser()
        isPresale()
        isValidMerkleProof(proof, merkleRoot)
        isCorrectPayment(cost, _quantity)
    {
        uint256 supply = totalSupply();
        require(_quantity + addressMintedBalance[msg.sender] <= maxWLAllowed, "Max 3 per Whitelist");
        require(_quantity + supply <= maxSupply, "Soldout");


        addressMintedBalance[msg.sender] += _quantity;
        _safeMint(msg.sender, _quantity);
        
    } 

    function publicSale(
        uint256 _quantity
    ) 
        public 
        payable 
        notPaused() 
        callerIsUser() 
        isPublicSale() 
        isCorrectPayment(cost, _quantity)
    {
        uint256 supply = totalSupply();
        require(_quantity <= maxPerTX, "Limit 3 per Tx");
        require(_quantity + supply <= maxSupply, "SoldOut");

        _safeMint(msg.sender, _quantity);
    }

    function reserveTokens(uint256 _quanitity) public onlyOwner {        
        uint256 supply = totalSupply();
        require(_quanitity + supply <= maxSupply);
        _safeMint(msg.sender, _quanitity);
    }

    function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
        OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(proxyRegistryAddress);
        if (address(proxyRegistry.proxies(_owner)) == operator) return true;
        return super.isApprovedForAll(_owner, operator);
    }
    
    // function _preMint(uint256 _quantity) private {
    //     _safeMint(msg.sender, _quantity);
    // }

    function withdraw() public onlyOwner {
        (bool success, ) = lead.call{value: address(this).balance}("");
        require(success, "Failed to send to lead.");
    }

}

contract OwnableDelegateProxy { }
contract OpenSeaProxyRegistry {
    mapping(address => OwnableDelegateProxy) public proxies;
}
