// contracts/bibiz.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./erc721a/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Bibiz is ERC721A, ReentrancyGuard {
    string _baseTokenURI;

    address public owner;

    uint constant public MAX_SUPPLY = 6900;
    uint constant public mintCost = 0.03 ether;
    uint constant public maxMintPerTx = 10;
    uint public maxPerWallet = 20;

    // external counter instead of ERC721Enumerable:totalSupply()
    uint256 public publicMinted;

    uint256 public reserveMinted;
    uint256 public teamReserved = 30;

    // amount of tokens minted by wallet
    mapping(address => uint) private walletToMinted;

    bool public mintAllowed;
    bool public claimAllowed;
    bool public revealed;

    constructor() ERC721A("Bibiz", "BBZ", 10) {
        owner=msg.sender;
        _baseTokenURI = "https://cloudflare-ipfs.com/ipfs/QmRaFK9xEkHxgcehoB23TzpSYngLxNNKsxUqKeXiGFV3NV";
    }

    /// @dev mint tokens at public sale
    /// @param amount_ amount of tokens to mint
    function mintPublic(uint amount_) external payable onlyMintAllowed nonReentrant {
        require(msg.value >= mintCost * amount_, "Invalid tx value!");                              //NOTE: check payment amount
        require(publicMinted + amount_ <= MAX_SUPPLY - teamReserved, "No public mint available"); 
        require(amount_ > 0 && amount_ <= maxMintPerTx, "Wrong mint amount");                      //NOTE: check if amount is correct
        require(walletToMinted[msg.sender] + amount_ <= maxPerWallet, "Wallet limit reached");      //NOTE: check max per wallet limit

        mintRandomInternal(amount_, msg.sender, false);

        publicMinted+=amount_;

    }

    /// @dev mint tokens reserved for the team
    /// @param wallet wallet to mint tokens
    /// @param amount_ amount of tokens to mint
    function mintReserve(address wallet, uint amount_) external onlyOwner nonReentrant {
        require(reserveMinted + amount_ <= teamReserved);

        mintRandomInternal(amount_,wallet, true);

        reserveMinted+=amount_;
    }

    /// @dev pick the random type (0-2) and mint it to specific address
    /// @param amount_ amount of tokens to be minted
    /// @param receiver wallet to get minted tokens
    function mintRandomInternal(uint amount_, address receiver, bool ignoreWalletRestriction) internal {
        _safeMint(receiver, amount_);
    }

    //
    //  VIEW
    //

    /// @dev return the metadata URI for specific token
    /// @param _tokenId token to get URI for
    function tokenURI(uint _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "Token does not exist");
        if (!revealed) {
            return _baseTokenURI;
        }
        return string(abi.encodePacked(_baseTokenURI, '/', _tokenId)); 
    }

    //
    // ONLY OWNER
    //

    /// @dev reveal the real links to metadata
    function reveal() external onlyOwner {
        revealed=true;
    }

    /// @dev switch mint allowed status
    function switchMintAllowed() external onlyOwner {
        mintAllowed=!mintAllowed;
    }

    /// @dev switch claim allowed status
    function switchClaimAllowed() external onlyOwner {
        claimAllowed=!claimAllowed;
    }

    /// @dev Set base URI for tokenURI
    function setBaseTokenURI(string memory baseURI_) external onlyOwner {
        _baseTokenURI=baseURI_;
    }

    /// @dev transfer ownership
    /// @param owner_ new contract owner
    function transferOwnership(address owner_) external onlyOwner {
        owner=owner_;
    }

    /// @dev withdraw all ETH accumulated, 10% share goes to solidity dev
    function withdrawEther() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    //
    //  MODIFIERS
    //

    /// @dev allow execution when mint allowed only
    modifier onlyMintAllowed() {
        require(mintAllowed, 'Mint not allowed');
        _;
    }

    /// @dev allow execution when caller is owner only
    modifier onlyOwner() {
        require(owner == msg.sender, "You are not the owner");
        _;
    }
}
