// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./ECDSA.sol";
import "./ERC721.sol";
import "./IERC20.sol";
import "./Ownable.sol";

contract TheSevensCompanions is ERC721, Ownable{
    using Strings for uint;
    using ECDSA for bytes32;

    constructor(IERC20 zeniContract_,string memory baseURI_) ERC721("The Sevens Companions","7COMP") payable {
        zeniContract = zeniContract_;
        baseURI = baseURI_;
        saleStartTime = 1640199600;
        _batchMint(msg.sender, 49);
    }


    // Constants

    uint constant zeniToClaim = 350e18;
    uint constant etherToMint = 0.049e18;

    uint constant maxSupply = 7000;

    uint constant maxPerTransaction = 21;

    address constant dead = address(0x000000000000000000000000000000000000dEaD);


    // Storage Variables

    uint public saleStartTime;
    uint public totalSupply = 0;

    string baseURI;

    IERC20 zeniContract;

    address stakingContract = address(0);
    address signer = 0x94382f4bcCD5c1Cb0B2B3A5CAA16B2909c0E494d;

    mapping(address => uint) public whitelistMintAmount;

    // Modifiers

    modifier mintChecks(uint amount, uint offset) {
        require(msg.sender == tx.origin, "No");
        
        require(amount <= maxPerTransaction,string(abi.encodePacked("You can only mint up to ", maxPerTransaction.toString() ," per transaction")));
        
        uint timeNow = block.timestamp;
        uint startTime = saleStartTime;
        require(startTime != 0, "Sale start time is not setup!");
        require(startTime + offset <= timeNow && timeNow <= startTime + 2 weeks,"Sale is not active!");
        _;
    }

    modifier etherMintChecks(uint amount) {
        require(msg.value == amount * etherToMint,"Invalid amount sent");
        _;
    }

    // Minting Functions

    function zeniMint(uint amount) external mintChecks(amount, 0) {
        zeniContract.transferFrom(msg.sender, dead, amount * zeniToClaim);

        _batchMint(msg.sender, amount);
    }


    function etherWhitelistMint(uint amount, uint maxMints, bytes calldata signature) external payable mintChecks(amount, 1 days) etherMintChecks(amount) {
        require(keccak256(abi.encode(msg.sender, maxMints)).toEthSignedMessageHash().recover(signature) == signer,"Invalid signature received");
        require(whitelistMintAmount[msg.sender] + amount <= maxMints, string(abi.encodePacked("You can only mint up to ", maxMints.toString(), " using your whitelist!")));
        whitelistMintAmount[msg.sender] += amount;

        _batchMint(msg.sender, amount);
    }

    function etherMint(uint amount) external payable mintChecks(amount, 2 days) etherMintChecks(amount) {
        _batchMint(msg.sender, amount);
    }


    function _batchMint(address to, uint amount) internal {
        uint nextId = totalSupply;
        require(nextId + amount <= maxSupply, "Mint would exceed supply");
        for(uint i = 1; i <= amount; i++) {
            _mint(to, nextId + i);
        }
        totalSupply += amount;
    }

    // View Only Functions

    function tokenURI(uint tokenId) public view override returns(string memory) {
        require(_exists(tokenId), string(abi.encodePacked("Token ", tokenId.toString(), " does not exist")));
        return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
    }

    // Owner Only

    function adminSetSaleStartTime(uint startTime) external onlyOwner {
        saleStartTime = startTime;
    }

    bool public metadataLocked = false;
    function adminLockMetadata() external onlyOwner {
        metadataLocked = true;
    }

    function adminSetBaseURI(string memory baseURI_) external onlyOwner {
        require(!metadataLocked);
        baseURI = baseURI_;
    }

    function adminSetZeni(IERC20 zeniContract_) external onlyOwner {
        zeniContract = zeniContract_;
    }

    function adminSetStaking(address stakingContract_) external onlyOwner {
        stakingContract = stakingContract_;
    }

    function adminSetSigner(address signer_) external onlyOwner {
        signer = signer_;
    }

    function withdraw() external onlyOwner {
        payable(0xE776DF26ac31C46a302F495c61b1fab1198C582a).transfer(address(this).balance);
    }

    // Staking

    function takeToken(address from,uint tokenId) external {
        require(msg.sender == stakingContract);
        _transfer(from,msg.sender,tokenId);
    }
}