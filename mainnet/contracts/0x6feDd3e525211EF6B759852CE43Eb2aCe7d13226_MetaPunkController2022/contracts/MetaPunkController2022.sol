// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "hardhat/console.sol";

import "./IMetaPunk2018.sol";
import "./IPunk.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Ownable, reentrancyguard, ERC721 interface

interface IDAOTOKEN {
    function safeMint(address) external;

    function transferOwnership(address) external;
}

contract MetaPunkController2022 is Ownable, ReentrancyGuard {
    using Address for address payable;

    // connected contracts
    IMetaPunk2018 public metaPunk;

    uint256 public mintFee;

    address payable public vault;

    bool public paused = false;

    uint256 public tokenId;

    string public baseUri;

    // white list members
    mapping(address => bool) public whiteList;
    uint256 public whiteListMintFee;
    uint256 public whiteListMintLimit;

    // White list
    bool public isWhiteListOpen = false;
    bool public isWhiteListMintOpen = false;

    // DAO Token
    IDAOTOKEN public DAOToken;
    address public pridePunkTreasury;

    event MetaPunk2022Created(uint256 tokenId);

    // events
    // event PunkClaimed(uint256 punkId, address claimer);
    event PausedState(bool paused);
    event FeeUpdated(uint256 mintFee);
    event WhiteListFeeUpdated(uint256 mintFee);

    modifier whenNotPaused() {
        require(!paused, "Err: Contract is paused");
        _;
    }

    modifier whileTokensRemain() {
        require(tokenId < 10000, "err: all pride punks minted");
        _;
    }

    // Set the MetaPunk2018 contracts' Punk Address to address(this)
    // Set the v1 Wrapped Punk Address
    // Set the v2 CryptoPunk Address
    function setup(
        uint256 _mintFee,
        uint256 _whiteListMintFee,
        uint256 _whiteListMintLimit,
        string memory _baseUri,
        IMetaPunk2018 _metaPunk,
        address payable _vault,
        IDAOTOKEN _DAOToken,
        address _pridePunkTreasury
    ) public onlyOwner {
        metaPunk = _metaPunk;
        mintFee = _mintFee;
        whiteListMintFee = _whiteListMintFee;
        whiteListMintLimit = _whiteListMintLimit;
        baseUri = _baseUri;
        vault = _vault;
        DAOToken = _DAOToken;
        metaPunk.Existing(address(this));
        pridePunkTreasury = _pridePunkTreasury;

        // Set Token ID to the next in line.
        // Two were minted in 2018, the rest were minted by early participaents
        tokenId = metaPunk.totalSupply() - 2;

        emit FeeUpdated(mintFee);
    }

    // DAO Token

    // Update DAO Token Ownership
    function transferDAOTokenOwnership(address newOwner) public onlyOwner {
        DAOToken.transferOwnership(newOwner);
    }

    // White List //
    function addToWhitelist() public nonReentrant {
        require(isWhiteListOpen, "err: whitelist isn't open");
        whiteList[msg.sender] = true;
    }

    function toggleWhiteList(bool _isWhiteListOpen, bool _isWhiteListMintOpen) public onlyOwner {
        isWhiteListOpen = _isWhiteListOpen;
        isWhiteListMintOpen = _isWhiteListMintOpen;
    }

    // Mint new Token
    function mint(uint256 _requestedAmount) public payable nonReentrant whenNotPaused whileTokensRemain {
        require(_requestedAmount < 10000, "err: requested amount too high");
        require(msg.value >= _requestedAmount * mintFee, "err: not enough funds sent");

        // send msg.value to vault
        vault.sendValue(msg.value);

        for (uint256 x = 0; x < _requestedAmount; x++) {
            _mint(msg.sender);
        }
    }

    // List of folks who helped get project off the ground
    mapping(address => uint256) public bootstrapList;
    mapping(address => bool) public receivedDAOToken;
    event BootStrappersAdded(address[] Users, uint256[] Amounts);

    function addTeamMember(address[] memory _users, uint256[] memory _amounts) public onlyOwner {
        require(_users.length == _amounts.length, "err: array length mismatch");

        for (uint256 x; x < _users.length; x++) {
            // add user to the list
            bootstrapList[_users[x]] = _amounts[x];
        }
        emit BootStrappersAdded(_users, _amounts);
    }

    function teamMint(uint256 _requestedAmount) public payable nonReentrant whenNotPaused whileTokensRemain {
        // Require that they are on the list
        require(bootstrapList[msg.sender] > 0, "err: Address has no allocation");

        // Can not request more than their allocation
        require(bootstrapList[msg.sender] >= _requestedAmount, "err: requested amount too high");

        // subtract their amount
        bootstrapList[msg.sender] = bootstrapList[msg.sender] - _requestedAmount;

        // if they haven't gotten a DAO token yet, give them one
        if (!receivedDAOToken[msg.sender]) {
            receivedDAOToken[msg.sender] = true;
            DAOToken.safeMint(msg.sender);
        }

        // mint
        for (uint256 x = 0; x < _requestedAmount; x++) {
            _mint(msg.sender);
        }
    }

    uint256 public whiteListTotalMintLimit = 5000;

    function updateWhiteListTotalMintLimit(uint256 _limit) public onlyOwner {
        whiteListTotalMintLimit = _limit;
    }

    function whiteListMint(uint256 _requestedAmount) public payable nonReentrant whenNotPaused whileTokensRemain {
        require(_requestedAmount <= whiteListMintLimit, "err: requested amount too high");
        require(isWhiteListMintOpen, "err: white list mint is closed");
        require(msg.value >= _requestedAmount * whiteListMintFee, "err: not enough funds sent");
        require(whiteList[msg.sender], "err: not on the white list");

        // check there are still whitelistmintsleft
        require(whiteListTotalMintLimit > 0, "err: no more whitelistMintsLeft");
        // decrement the amount
        whiteListTotalMintLimit--;

        // Remove user from WhiteList
        whiteList[msg.sender] = false;

        // send msg.value to vault
        vault.sendValue(msg.value);

        // Mint them a DAO Voting Token
        DAOToken.safeMint(msg.sender);

        // Mint a PridePunk to the DAO
        _mint(pridePunkTreasury);

        // Mint the whitelist holder
        for (uint256 x = 0; x < _requestedAmount; x++) {
            _mint(msg.sender);
        }
    }

    function ownerMultiMint(address[] memory recipients, uint256[] memory amounts)
        public
        onlyOwner
        nonReentrant
        whileTokensRemain
    {
        require(recipients.length == amounts.length, "err: array length mismatch");

        for (uint256 x = 0; x < recipients.length; x++) {
            // for each recipient, mint them (amounts) of tokens
            for (uint256 y = 0; y < amounts[x]; y++) {
                _mint(recipients[x]);
            }
        }
    }

    function ownerMintById(uint256 _tokenId) public onlyOwner {
        require(!metaPunk.exists(_tokenId), "err: token already exists");
        metaPunk.makeToken(_tokenId, _tokenId);
        metaPunk.seturi(_tokenId, string(abi.encodePacked(baseUri, Strings.toString(_tokenId))));
        emit MetaPunk2022Created(_tokenId);

        // transfer metaPunk to msg.sender
        metaPunk.safeTransferFrom(address(this), msg.sender, _tokenId);
    }

    function togglePause() public onlyOwner {
        paused = !paused;
        emit PausedState(paused);
    }

    function updateMintFee(uint256 _mintFee) public onlyOwner {
        mintFee = _mintFee;
        emit FeeUpdated(mintFee);
    }

    function updateWhiteListMintFee(uint256 _mintFee) public onlyOwner {
        whiteListMintFee = _mintFee;
        emit WhiteListFeeUpdated(mintFee);
    }

    // MetaPunk2018 Punk Contract replacement
    // Must be implemented for the 2018 version to work
    function punkIndexToAddress(uint256) external returns (address) {
        // Return the address of the MetaPunk Contract
        return address(metaPunk);
    }

    function balanceOf(address _user) external returns (uint256) {
        return metaPunk.balanceOf(_user);
    }

    // This is needed in case this contract doesn't work and we need to transfer it again
    function transferOwnershipUnderlyingContract(address _newOwner) public onlyOwner {
        metaPunk.transferOwnership(_newOwner);
    }

    function sendToVault() public {
        vault.sendValue(address(this).balance);
    }

    function _mint(address _recipient) internal {
        require(tokenId < 10000, "err: all pride punks minted");

        _findNextToken();

        metaPunk.makeToken(tokenId, tokenId);
        metaPunk.seturi(tokenId, string(abi.encodePacked(baseUri, Strings.toString(tokenId))));
        emit MetaPunk2022Created(tokenId);

        // transfer metaPunk to msg.sender
        metaPunk.safeTransferFrom(address(this), _recipient, tokenId);

        // increment the tokenId
        tokenId++;
    }

    // recursive
    function _findNextToken() internal {
        if (metaPunk.exists(tokenId)) {
            tokenId++;
            return _findNextToken();
        }
    }
}
