// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "../../../common/proxies/ProxyRegistry.sol";
import "../../../common/meta_transactions/ContentMixin.sol";
import "../../../common/meta_transactions/NativeMetaTransaction.sol";
import "./ICryptopiaEarlyAccessToken.sol";


/// @title CryptopiaEarlyAccess Token
/// @dev Non-fungible token (ERC721)
/// @author Frank Bonnet - <frankbonnet@outlook.com>
contract CryptopiaEarlyAccessToken is ICryptopiaEarlyAccessToken, ERC721Enumerable, ContextMixin, NativeMetaTransaction, Ownable {
    using SafeMath for uint;

    /**
     *  Storage
     */
    string private _contractURI;
    string private _baseTokenURI;
    uint private _currentTokenId = 0; 

    /// @dev tokenId => faction
    mapping (uint => uint8) public factions;

    /// @dev tokenId => referrer
    mapping (uint => uint) public referrers;

    /// Refs
    ProxyRegistry public proxyRegistry;


    /**
     * Modifiers
     */
    /// @dev Throw if not initialized
    modifier onlyWhenInitialized() {
        require(inited);
        _;
    }


    /// @dev Contract constructor
    constructor() 
        ERC721("Cryptopia Early-Access", "SHIP") {}


    /**
     * Public functions
     */
    /// @dev Initializes the token contract
    /// @param _proxyRegistry Whitelist for easy trading
    /// @param _initialContractURI Location to contract info
    /// @param _initialBaseTokenURI Base of location where token data is stored. To be postfixed with tokenId
    function initialize(
        address _proxyRegistry, 
        string calldata _initialContractURI, 
        string calldata _initialBaseTokenURI) public override {
        _initializeEIP712(name()); // <-- Initializer
        
        proxyRegistry = ProxyRegistry(_proxyRegistry);
        _contractURI = _initialContractURI;
        _baseTokenURI = _initialBaseTokenURI;
    }


    /// @dev Get contract URI
    /// @return Location to contract info
    function getContractURI() override public view returns (string memory) {
        return _contractURI;
    }


    /// @dev Set contract URI
    /// @param _uri Location to contract info
    function setContractURI(string memory _uri) override public onlyOwner {
        _contractURI = _uri;
    }


    /// @dev Get base token URI 
    /// @return Base of location where token data is stored. To be postfixed with tokenId
    function getBaseTokenURI() override public view returns (string memory) {
        return _baseTokenURI;
    }


    /// @dev Set base token URI 
    /// @param _uri Base of location where token data is stored. To be postfixed with tokenId
    function setBaseTokenURI(string memory _uri) override public onlyOwner {
        _baseTokenURI = _uri;
    }


    /// @dev getTokenURI() postfixed with the token ID baseTokenURI(){tokenID}
    /// @param _tokenId Token ID
    /// @return Location where token data is stored
    function getTokenURI(uint _tokenId) override public view returns (string memory) {
        if (_tokenId == 1)
        {
            return string(abi.encodePacked(getBaseTokenURI(), "special"));
        }

        return string(abi.encodePacked(getBaseTokenURI(), Strings.toString(referrers[_tokenId]), "/", Strings.toString(factions[_tokenId])));
    }


    /// @dev tokenURI() postfixed with the token ID baseTokenURI(){tokenID}
    /// @param _tokenId Token ID
    /// @return Location where token data is stored
    function tokenURI(uint _tokenId) override public view returns (string memory) {
        return getTokenURI(_tokenId);
    }


    /// @dev Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings
    /// @param _owner Token owner
    /// @param _operator Operator to check
    function isApprovedForAll(address _owner, address _operator)override public view returns (bool) {
        if (address(proxyRegistry.proxies(_owner)) == _operator) {
            return true; // Whitelist OpenSea proxy contract for easy trading
        }

        return super.isApprovedForAll(_owner, _operator);
    }


    /// @dev Mints a token to an address.
    /// @param _to address of the future owner of the token
    /// @param _referrer referrer that's added to the token uri
    /// @param _faction faction that's added to the token uri
    function mintTo(address _to, uint _referrer, uint8 _faction) public override onlyOwner onlyWhenInitialized {
        uint newTokenId = _getNextTokenId();
        _incrementTokenId();
        _mint(_to, newTokenId);
        if (_referrer > 0)
        {
            referrers[newTokenId] = _referrer;
        }
        
        factions[newTokenId] = _faction; 
    }


    /**
     * Private functions
     */
    /// @dev calculates the next token ID based on value of _currentTokenId
    /// @return uint for the next token ID
    function _getNextTokenId() private view returns (uint) {
        return _currentTokenId.add(1);
    }


    /// @dev increments the value of _currentTokenId
    function _incrementTokenId() private {
        _currentTokenId++;
    }


    /// @dev This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea
    function _msgSender() internal override view returns (address sender) {
        return ContextMixin.msgSender();
    }
}