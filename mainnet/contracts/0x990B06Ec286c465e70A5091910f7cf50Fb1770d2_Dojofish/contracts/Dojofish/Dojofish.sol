// SPDX-License-Identifier: MIT

/**
    IMPORTANT NOTICE:
    This smart contract was written and deployed by the software engineers at 
    https://highstack.co in a contractor capacity.
    
    Highstack is not responsible for any malicious use or losses arising from using 
    or interacting with this smart contract.

    THIS CONTRACT IS PROVIDED ON AN “AS IS” BASIS. USE THIS SOFTWARE AT YOUR OWN RISK.
    THERE IS NO WARRANTY, EXPRESSED OR IMPLIED, THAT DESCRIBED FUNCTIONALITY WILL 
    FUNCTION AS EXPECTED OR INTENDED. PRODUCT MAY CEASE TO EXIST. NOT AN INVESTMENT, 
    SECURITY OR A SWAP. TOKENS HAVE NO RIGHTS, USES, PURPOSE, ATTRIBUTES, 
    FUNCTIONALITIES OR FEATURES, EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, ANY
    USES, PURPOSE OR ATTRIBUTES. TOKENS MAY HAVE NO VALUE. PRODUCT MAY CONTAIN BUGS AND
    SERIOUS BREACHES IN THE SECURITY THAT MAY RESULT IN LOSS OF YOUR ASSETS OR THEIR 
    IMPLIED VALUE. ALL THE CRYPTOCURRENCY TRANSFERRED TO THIS SMART CONTRACT MAY BE LOST.
    THE CONTRACT DEVLOPERS ARE NOT RESPONSIBLE FOR ANY MONETARY LOSS, PROFIT LOSS OR ANY
    OTHER LOSSES DUE TO USE OF DESCRIBED PRODUCT. CHANGES COULD BE MADE BEFORE AND AFTER
    THE RELEASE OF THE PRODUCT. NO PRIOR NOTICE MAY BE GIVEN. ALL TRANSACTION ON THE 
    BLOCKCHAIN ARE FINAL, NO REFUND, COMPENSATION OR REIMBURSEMENT POSSIBLE. YOU MAY 
    LOOSE ALL THE CRYPTOCURRENCY USED TO INTERACT WITH THIS CONTRACT. IT IS YOUR 
    RESPONSIBILITY TO REVIEW THE PROJECT, TEAM, TERMS & CONDITIONS BEFORE USING THE 
    PRODUCT.

**/

pragma solidity ^0.8.4;

import "./ControlledAccess.sol";
import "./ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract Dojofish is
    ERC721Enumerable,
    Ownable,
    ReentrancyGuard,
    ControlledAccess
{
    // Initialize Packages
    using ECDSA for bytes32;
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    using Strings for *;
    Counters.Counter private _tokenIdTracker;

    // Constants
    string private EMPTY_STRING = "";

    // Settings
    uint256 public MAX_ELEMENTS = 5000; // 280 reserved. To be updated later
    uint256 public whitelistStart = 1647187200; // March 11th 9am Pacific - round 2 is 1647208800
    uint256 public publicStart = 1647219600; // March 11th 6pm Pacific	
    bool public isPublicLive = false;
    bool public isWhitelistLive = false;
    uint256 public maxWhitelistMintPerTx = 6;
    uint256 public defaultPricePerUnit = 0.1 ether;

    address vaultAddress;

    // Data Structures
    struct BaseTokenUriById {
        uint256 startId;
        uint256 endId;
        string baseURI;
    }
    BaseTokenUriById[] public baseTokenUris;

    // Pricing version control.
    /** 
      qtyPricing = {
        [pricingVersionCount] : {
          [qty] : price
        }
      }
    **/
    mapping(uint256 => mapping(uint256 => uint256)) public qtyPricing;
    uint256 public pricingVersionCount = 1;

    // Keep track of addresses that have claimed whitelist mints.
    /** 
      whitelistMintClaimed = {
        [currentWhitelistNonce] : {
			[address] : boolean
        }
      }
    **/
    mapping(uint256 => mapping(address => bool)) public whitelistMintClaimed;
    uint256 currentWhitelistNonce = 1;

    constructor(
        string memory name,
        string memory ticker,
        uint256 reservedAmount, // 56
        address _vaultAddress
    ) ERC721(name, ticker) {
        vaultAddress = _vaultAddress;
        _mintAmount(1, msg.sender);
        _mintAmount(reservedAmount, vaultAddress);
        
    }

    /***********************/
    /***********************/
    /***********************/
    /*** ADMIN FUNCTIONS ***/
    /***********************/
    /***********************/
    /***********************/
    /***********************/

    function setMaxElements(uint256 maxElements) public onlyOwner {
        require(maxElements >= totalSupply(), "Cannot decrease under existing supply");
        MAX_ELEMENTS = maxElements;
    }

    function setMintPrices(
        uint256 _defaultPricePerUnit,
        uint256[] memory qty,
        uint256[] memory prices
    ) public onlyOwner {
        require(
            qty.length == prices.length,
            "Qty input vs price length mismatch"
        );
        defaultPricePerUnit = _defaultPricePerUnit;
        pricingVersionCount = pricingVersionCount.add(1);

        bool containsMaxWhitelistMintPerTx = false;
        for (uint256 i = 0; i < qty.length; i++) {
            if (qty[i] == maxWhitelistMintPerTx) {
                containsMaxWhitelistMintPerTx = true;
            }
            qtyPricing[pricingVersionCount][qty[i]] = prices[i];
        }
        require(
            containsMaxWhitelistMintPerTx,
            "prices do not include the max mint price"
        );
    }

    function setStartTimes(uint256 _whitelistStart, uint256 _publicStart)
        public
        onlyOwner
    {
        publicStart = _publicStart;
        whitelistStart = _whitelistStart;
    }

    function setIsLive(bool _isPublicLive, bool _isWhitelistLive)
        public
        onlyOwner
    {
        isPublicLive = _isPublicLive;
        isWhitelistLive = _isWhitelistLive;
    }

    function clearBaseUris() public onlyOwner {
        delete baseTokenUris;
    }

    function setBaseURI(
        string memory baseURI,
        uint256 startId,
        uint256 endId
    ) public onlyOwner {
        require(
            keccak256(bytes(tokenURI(startId))) ==
                keccak256(bytes(EMPTY_STRING)),
            "Start ID Overlap"
        );
        require(
            keccak256(bytes(tokenURI(endId))) == keccak256(bytes(EMPTY_STRING)),
            "End ID Overlap"
        );
        baseTokenUris.push(
            BaseTokenUriById({startId: startId, endId: endId, baseURI: baseURI})
        );
    }

    function setMaxWhitelistMintPerTx(uint256 limit) public onlyOwner {
        maxWhitelistMintPerTx = limit;
    }

    function withdrawGasReimbusement(uint256 amount) public onlyOwner{	
        uint256 balance = address(this).balance;	
        require(balance > amount, "Insufficient Balance");	
        _withdraw(owner(), amount);	
    }	

    function withdrawAll(address addr) public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "nothing to withdraw");
        _withdraw(addr, address(this).balance);
    }

    function adminMint(uint256 _amount, address _address) public onlyOwner nonReentrant {
        require(totalSupply().add(_amount) <= MAX_ELEMENTS, "Max limit");
        _mintAmount(_amount, _address);
    }

    function setWhitelistNonce(uint256 _nonce) public onlyOwner {
        currentWhitelistNonce = _nonce;
    }

    /************************/
    /************************/
    /************************/
    /*** PUBLIC FUNCTIONS ***/
    /************************/
    /************************/
    /************************/
    /************************/

    function mint(uint256 _amount) public payable nonReentrant {
        require(
            block.timestamp > publicStart && isPublicLive == true,
            "Public mint not open yet"
        );
        uint256 total = totalSupply();
        require(total + _amount <= MAX_ELEMENTS, "Sold Out!");
        require(msg.value >= price(_amount), "Value below price");
        _mintAmount(_amount, msg.sender);
    }

    function whitelistMint(
        uint256 amount,
        uint256 whitelistNonce,
        bytes32 msgHash,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public payable nonReentrant {
        require(
            block.timestamp > whitelistStart && isWhitelistLive,
            "Whitelist mint not open yet"
        );
        require(
            amount <= maxWhitelistMintPerTx,
            "Requested amount exceeds max per mint"
        );
        uint256 total = totalSupply();
        require(total + amount <= MAX_ELEMENTS, "Sold Out!");
        require(msg.value >= price(amount), "Value below price");
        require(
            whitelistNonce == currentWhitelistNonce,
            "Whitelist Nonce Invalid"
        );

        // Security check.
        bytes32 calculatedMsgHash = keccak256(
            abi.encodePacked(msg.sender, whitelistNonce)
        );

        address signer = ecrecover(
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", msgHash)
            ),
            _v,
            _r,
            _s
        );

        require(calculatedMsgHash == msgHash, "Invalid hash");
        require(owner() == signer, "Access denied");
        require(
            !whitelistMintClaimed[whitelistNonce][msg.sender],
            "Already claimed!"
        );

        // Let's mint!
        whitelistMintClaimed[whitelistNonce][msg.sender] = true;
        _mintAmount(amount, msg.sender);
    }

    function reserveMint(
        uint256 amount,
        uint256 whitelistNonce,
        bytes32 msgHash,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public payable nonReentrant {
        uint256 total = totalSupply();
        require(total + amount <= MAX_ELEMENTS, "Sold Out!");
        require(
            whitelistNonce == currentWhitelistNonce,
            "Whitelist Nonce Invalid"
        );

        // Security check.
        bytes32 calculatedMsgHash = keccak256(
            abi.encodePacked(msg.sender, amount, whitelistNonce)
        );

        address signer = ecrecover(
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", msgHash)
            ),
            _v,
            _r,
            _s
        );

        require(calculatedMsgHash == msgHash, "Invalid hash");
        require(owner() == signer, "Access denied");
        require(
            !whitelistMintClaimed[whitelistNonce][msg.sender],
            "Already claimed!"
        );

        // Let's mint!
        whitelistMintClaimed[whitelistNonce][msg.sender] = true;
        _mintAmount(amount, msg.sender);
    }

    function getUnsoldTokens(uint256 offset, uint256 limit)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory tokens = new uint256[](limit);
        for (uint256 i = 0; i < limit; i++) {
            uint256 key = i + offset;
            if (rawOwnerOf(key) == address(0)) {
                tokens[i] = key;
            }
        }
        return tokens;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        uint256 length = baseTokenUris.length;
        for (uint256 interval = 0; interval < length; ++interval) {
            BaseTokenUriById storage baseTokenUri = baseTokenUris[interval];
            if (
                baseTokenUri.startId <= tokenId && baseTokenUri.endId >= tokenId
            ) {
                return
                    string(
                        abi.encodePacked(
                            baseTokenUri.baseURI,
                            tokenId.toString(),
                            ".json"
                        )
                    );
            }
        }
        return "";
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIdTracker.current();
    }

    function price(uint256 _count) public view returns (uint256) {
        uint256 pricePerUnit = qtyPricing[pricingVersionCount][_count];
        // Mint more than max discount reverts to max discount
        if (_count > maxWhitelistMintPerTx) {
            pricePerUnit = qtyPricing[pricingVersionCount][
                maxWhitelistMintPerTx
            ];
        }
        // Minting an undefined discount price uses defaults price
        if (pricePerUnit == 0) {
            pricePerUnit = defaultPricePerUnit;
        }
        return pricePerUnit.mul(_count);
    }

    function _mintAmount(uint256 amount, address wallet) private {
        _withdraw(vaultAddress, msg.value.div(16));
        for (uint8 i = 0; i < amount; i++) {
            while (
                !(rawOwnerOf(_tokenIdTracker.current().add(1)) == address(0))
            ) {
                _tokenIdTracker.increment();
            }
            _mintAnElement(wallet);
        }
    }

    function _mintAnElement(address _to) private {
        _tokenIdTracker.increment();
        _safeMint(_to, _tokenIdTracker.current());
    }

    function walletOfOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(_owner);

        uint256[] memory tokensId = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensId;
    }

    function _withdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }
}
