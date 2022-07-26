// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ERC721X.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract ZelenskiyNFT is ERC721X, Ownable {

    enum RevealStatus{
        MINT,
        REVEAL,
        REVEALED
    }

    struct PayableAddress {
        address payable addr;
        uint256 share;
    }

    event Paid(address indexed _from, uint256 _value, uint8 _whitelist);
    event Charity(address indexed _to, uint256 _value, bytes data);
    event Withdrawal(address indexed _to, uint256 _value, bytes data);
    event UriChange(string newURI);
    event WhitelistStatusChange(bool status);
    event MintStopped(bool status);
    event NewRoot(bytes32 root);
    event Payout(uint256 amount);
    event Refund(address indexed _to, uint256 amount, bytes data);
    event MintTimeSet(uint _start, uint _end);
    event LockTimerStarted(uint _start, uint _end);
    event AdminMinted(uint256 amount);
    event Distribution(uint256 _value, address _to, uint256 _amount);
    event Deposit(uint256 _value, address _from);

    uint256 public constant priceDefault = 0.2 ether;
    uint256 public constant priceWhitelist = 0.15 ether;

    uint256 public constant amountWhitelist = 1;
    uint256 public constant amountDefault = 3;

    uint256 public constant maxTotalSupply = 1000;
    uint256 public constant communityMintSupply = 500;
    uint256 private communitySold = 0;

    string private theBaseURI = "https://zelenskiynft.mypinata.cloud/ipfs/QmVHUj9uM7HxK5xSi2vbip9ySXYkLBEPWecQeJcbVKzBmH/";

    uint256 private charitySum = 0;
    uint256 private teamSum = 0;
    uint256 private saleSum = 0;

    mapping(address => uint256) private mints;
    mapping(address => bool) private whitelistClaimed;
    mapping(address => bool) private communityWhitelistClaimed;

    bytes32 private root;
    bytes32 private communityRoot;
    bool private communityRootIsSet = false;
    bool private rootIsSet = false;

    RevealStatus private revealStatus = RevealStatus.REVEAL;

    uint public constant whitelistStartTime = 1653598800;
    uint public constant whitelistEndTime = 1653600600;
    uint public constant publicMintStartTime = 1653601500;
    uint public constant whitelist2StartTime = 1654189200;

    address public constant communityWallet = 0xb03a143afdC5bc8735903743001fd4698BEEafe6;
    address public constant multisigOwnerWallet = 0x15E6733Be8401d33b4Cf542411d400c823DF6187;

    bool private mintStopped = false;

    bool private adminMinted = false;

    uint private functionLockTime = 0;

    bool private lockReturns = false;

    address public constant charityUA   = 0x3A0106911013eca7A0675d8F1ba7F404eD973cAb;
    address public constant charityEU   = 0x78042877DF422a9769E0fE1748FEf35d4A4718a0;
    address public constant liquidity   = 0x7A6B855D613C136098de4FEd8725DF7A7c2f7F5c;
    address public constant marketing   = 0x777C680b055cF6E97506B42DDeF4063061d7a5b4;
    address public constant development = 0xaE987CfFaf8149EFff92546ca399D41b4Da6c57B;
    address public constant team        = 0xBedc8cDC12047465690cbc358C69b2ea671217ac;

    constructor() ERC721X("Zelenskiy NFT", "ZFT") {}

    modifier ownerIsMultisig() {
        require(owner() == multisigOwnerWallet, "Owner is not multisignature wallet");
        _;
    }

    modifier whitelist2Started(){
        require(block.timestamp >= whitelist2StartTime, "Whitelist2 not started yet");
        _;
    }

    modifier whitelistActive() {
        require(whitelistStartTime != 0 && whitelistEndTime != 0, "Mint start time is not set");
        require(block.timestamp >= whitelistStartTime && block.timestamp <= whitelistEndTime, "Mint not started yet");
        _;
    }

    modifier whitelistEnded() {
        require(whitelistStartTime != 0 && whitelistEndTime != 0, "Mint start time is not set");
        require(block.timestamp >= whitelistEndTime, "Public mint not started yet");
        _;
    }

    modifier publicMintStarted() {
        require(block.timestamp >= publicMintStartTime, "Public mint not started yet");
        _;
    }

    // Mint remainder of collection to list on opensea
    function mintRemainder(uint256 amount) public {
        _mintRemainder(amount);
    }

    function buy(uint256 amount, bytes32[] calldata _proof) public payable whitelistActive {
        require(msg.sender == tx.origin, "payment not allowed from contract");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_proof, root, leaf), "Address not in whitelist");
        require(whitelistClaimed[msg.sender] == false, "Whitelist already claimed");
        
        require(amount <= amountWhitelist, "too much for whitelist");
        require(mints[msg.sender] + amount <= amountWhitelist, "too much for whitelist");
        
        require(nextId + amount <= maxTotalSupply, "Maximum supply reached");
        uint256 price;
        price = priceWhitelist;

        require(msg.value >= price * amount, "Not enough eth");

        if(msg.value > price * amount){
            uint256 refundAmount = msg.value - price * amount;
            (bool sent, bytes memory data) = msg.sender.call{value: refundAmount}("refund");
            require(sent, "Refund failed");
            emit Refund(msg.sender, refundAmount, data);
        }
        
        mints[msg.sender] += amount;

        saleSum += price * amount;

        whitelistClaimed[msg.sender] = true;

        _mint(msg.sender, amount);
    }

    function buyDefault(uint256 amount) public payable whitelistEnded {
        require(mintStopped == true, "Mint is stopped");
        require(msg.sender == tx.origin, "payment not allowed from this contract");
        require(mints[msg.sender] + amount <= amountDefault, "too much mints for this wallet");

        require(nextId + amount <= maxTotalSupply - communityMintSupply, "Maximum supply reached");
        uint256 price;
        price = priceDefault;

        require(msg.value >= price * amount, "Not enough eth");

        if(msg.value > price * amount){
            uint256 refundAmount = msg.value - price * amount;
            (bool sent, bytes memory data) = msg.sender.call{value: refundAmount}("refund");
            require(sent, "Refund failed");
            emit Refund(msg.sender, refundAmount, data);
        }

        mints[msg.sender] += amount;

        saleSum += price * amount;

        _mint(msg.sender, amount);
    }

    function communityClaim(bytes32[] calldata _proof) public payable whitelist2Started {
        require(msg.sender == tx.origin, "payment not allowed from this contract");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_proof, communityRoot, leaf), "Address not in whitelist");
        require(communityWhitelistClaimed[msg.sender] == false, "Whitelist already claimed");

        require(communitySold <= 500, "Maximum community mint reached");

        mints[msg.sender] += 1;
        communityWhitelistClaimed[msg.sender] = true;

        communitySold += 1;

        _mint(msg.sender, 1);
    }

    function setCommunityRoot(bytes32 _newRoot) public onlyOwner ownerIsMultisig {
        communityRoot = _newRoot;
        emit NewRoot(_newRoot);
    }

    function getCommunitySold() public view returns(uint256) {
        return communitySold;
    }

    // Mint to previous contract buyers
    function distribution(address to, uint256 amount, uint256 value) public payable onlyOwner {
        require(lockReturns == false, "Return locked");
        emit Distribution(value, to, amount);
       _mint(to, amount);
    }

    function setLockReturns() public onlyOwner {
        lockReturns = true; 
    }

    function setBaseURI(string memory newBaseURI) public onlyOwner {
        require(revealStatus != RevealStatus.REVEALED, "URI modifications after reveal are prohibited");
        theBaseURI = newBaseURI;
        emit UriChange(newBaseURI);
        if(revealStatus == RevealStatus.MINT){
            revealStatus = RevealStatus.REVEAL;
        }else{
            revealStatus = RevealStatus.REVEALED;
        }
    }

    function _baseURI() internal view override returns (string memory) {
        return theBaseURI;
    }

    function sendEther(address payable addr, uint256 amount, bool isCharity) private {
        (bool sent, bytes memory data) = addr.call{value: amount}("");
        require(sent, "Failed to send ether");
        if(isCharity){
            emit Charity(addr, amount, data);
            charitySum += amount;
        }else{
            emit Withdrawal(addr, amount, data);
            teamSum += amount;
        }
    }

    function pay() public onlyOwner whitelistEnded ownerIsMultisig {
        if(functionLockTime == 0){
            functionLockTime = block.timestamp;
            emit LockTimerStarted(functionLockTime, functionLockTime + 48 hours);
            return;
        }else{
            require(block.timestamp >= functionLockTime + 48 hours, "48 hours not passed yet");
            functionLockTime = 0;
        }
        uint256 balance = address(this).balance;
        emit Payout(balance);
        

        sendEther(payable(charityUA), balance/2, true);
        sendEther(payable(charityEU), balance/10, true);
        
        sendEther(payable(liquidity), balance*5/100, false);
        sendEther(payable(marketing), balance/5, false);
        sendEther(payable(development), balance/10, false);
        sendEther(payable(team), balance*5/100, false);
    }

    function getEthOnContract() public view returns (uint256) {
        return address(this).balance;
    }

    function checkAddressInWhiteList(bytes32[] calldata _proof) view public returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        return MerkleProof.verify(_proof, root, leaf);
    }

    function getWhitelistStatus() view public returns (bool) {
        return block.timestamp >= whitelistStartTime && block.timestamp <= whitelistEndTime;
    }

    function getCharitySum() view public returns (uint256) {
        return charitySum;
    }

    function getTeamSum() view public returns (uint256) {
        return teamSum;
    }

    function setRoot(bytes32 _newRoot) public onlyOwner ownerIsMultisig {
        require(rootIsSet == false, "Root already set");
        rootIsSet = true;
        root = _newRoot;
        emit NewRoot(_newRoot);
    }

    function storeEth() public payable {
        require(msg.sender == communityWallet, "Wrong address");
    }

    function checkWallet(address _from) private pure returns (bool) {
        return _from == charityUA ||
            _from == charityEU ||
            _from == liquidity ||
            _from == marketing ||
            _from == development ||
            _from == team;
    }

    fallback() external payable {
        if(checkWallet(msg.sender)){
            emit Deposit(msg.value, msg.sender);
            return;
        }
        require(!mintStopped, "Mint stopped");
        require(msg.value >= 0.2 ether, "Not enough ether");
        uint256 amount = 0;

        if(msg.value == priceDefault){
            amount = 1;
        }else if(msg.value > priceDefault*2 && msg.value <= priceDefault*3){
            amount = 2;
        }else if(msg.value >= priceDefault*3){
            amount = 3;
        }
        buyDefault(amount);
    }

    receive() external payable {
        if(checkWallet(msg.sender)){
            emit Deposit(msg.value, msg.sender);
            return;
        }
        require(!mintStopped, "Mint stopped");
        require(msg.value >= priceDefault, "Not enough ether");
        uint256 amount = 0;

        if(msg.value == priceDefault){
            amount = 1;
        }else if(msg.value > priceDefault*2 && msg.value <= priceDefault*3){
            amount = 2;
        }else if(msg.value >= priceDefault*3){
            amount = 3;
        }
        buyDefault(amount);
    }

    function stopMint() public onlyOwner ownerIsMultisig {
        if(functionLockTime == 0){
            functionLockTime = block.timestamp;
            emit LockTimerStarted(functionLockTime, functionLockTime + 1 hours);
            return;
        }else{
            require(block.timestamp >= functionLockTime + 1 hours, "Hour not passed yet");
            mintStopped = true;
            functionLockTime = 0;
            emit MintStopped(true);
        }
    }

    function getCommunityMintAmount() public view returns(uint256) {
        return communitySold;
    }
}