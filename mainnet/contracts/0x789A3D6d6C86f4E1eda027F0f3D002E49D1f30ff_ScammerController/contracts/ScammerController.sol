pragma solidity ^0.5.0;

/**
 * The ScammerController is an upgradeable endpoint for controlling Scammer.sol
 */

import "./Scammer.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract ScammerController is Ownable {

    event newCollection(uint256 collectionId, uint256 editions, uint256 price, bool paused);
    event updatedCollection(uint256 collectionId, uint256 editions, uint256 price, CollectionMode mode);
    event editionBought(uint256 collectionId, uint256 editionId, uint256 tokenId, address recipient, uint256 paid, uint256 artistReceived, uint256 adminReceived);

    using SafeMath for uint256;

    uint256 constant MAX_EDITIONS = 1000000;
    uint256 public latestCollectionId;

    mapping (address => uint) public vouchers;

    enum CollectionMode { PAUSED, VOUCHER_ONLY_MODE, UNPAUSED }

    mapping (uint256 => Collection) public collections;
    struct Collection {
        bool exists;
        CollectionMode mode;
        bool voucherOnlyMode;
        uint256 editions;
        uint256 price;
    }

    uint256 public adminSplit = 20;

    address payable public adminWallet;
    address payable public artistWallet;
    bool public paused;
    Scammer public scammer;

    modifier notPaused() {
        require(!paused, "Must not be paused");
        _;
    }

    constructor(
        Scammer _scammer,
        address payable _adminWallet,
        address payable _artistWallet,
        address[] memory voucherRecipients
    ) public {
        scammer = _scammer;
        adminWallet = _adminWallet;
        artistWallet = _artistWallet;

        for (uint i = 0; i < voucherRecipients.length; i++) {
            uint numVouchers = vouchers[voucherRecipients[i]].add(1);
            vouchers[voucherRecipients[i]] = numVouchers;
        }
    }

    function addCollection(uint256 editions, uint256 price, bool _paused) public onlyOwner {
        require(editions < MAX_EDITIONS, "MAX_EDITIONS_EXCEEDED");

        latestCollectionId += 1;

        collections[latestCollectionId].exists = true;
        collections[latestCollectionId].editions = editions;
        collections[latestCollectionId].price = price;
        if (_paused) {
            collections[latestCollectionId].mode = CollectionMode.PAUSED;
        } else {
            collections[latestCollectionId].mode = CollectionMode.UNPAUSED;
        }
        emit newCollection(latestCollectionId, editions, price, _paused);
    }

    function getAllTokenIds() external view returns (uint256[] memory) {
        uint totalSupply = scammer.totalSupply();

        uint256[] memory tokenIds = new uint256[](totalSupply);

        for (uint i = 0; i < totalSupply; i++) {
            tokenIds[i] = scammer.tokenByIndex(i);
        }

        return tokenIds;
    }

    function setVoucherOnlyMode(uint256 collectionId) public onlyOwner {
        require(collections[collectionId].exists, "COLLECTION_DOES_NOT_EXIST");
        collections[collectionId].mode = CollectionMode.VOUCHER_ONLY_MODE;
        emit updatedCollection(collectionId, collections[collectionId].editions, collections[collectionId].price, collections[collectionId].mode);
    }

    function updateCollectionPaused(uint256 collectionId, bool _paused) public onlyOwner {
        require(collections[collectionId].exists, "COLLECTION_DOES_NOT_EXIST");
        if (_paused) {
            collections[collectionId].mode = CollectionMode.PAUSED;
        } else {
            collections[collectionId].mode = CollectionMode.UNPAUSED;
        }
        emit updatedCollection(collectionId, collections[collectionId].editions, collections[collectionId].price, collections[collectionId].mode);
    }

    function updateCollectionEditions(uint256 collectionId, uint256 _editions) public onlyOwner {
        require(collections[collectionId].exists, "COLLECTION_DOES_NOT_EXIST");
        require(collections[collectionId].editions < _editions, "EDITIONS_MUST_INCREASE");
        collections[collectionId].editions = _editions;
        emit updatedCollection(collectionId, collections[collectionId].editions, collections[collectionId].price, collections[collectionId].mode);
    }

    function updateCollectionPrice(uint256 collectionId, uint256 _price) public onlyOwner {
        require(collections[collectionId].exists, "COLLECTION_DOES_NOT_EXIST");
        collections[collectionId].price = _price;
        emit updatedCollection(collectionId, collections[collectionId].editions, collections[collectionId].price, collections[collectionId].mode);
    }

    function redeem(address recipient, uint256 tokenId) public notPaused returns (bool) {
        uint256 collectionId = tokenId.div(MAX_EDITIONS);
        uint256 editionId = tokenId.mod(MAX_EDITIONS);

        require(collections[collectionId].mode == CollectionMode.UNPAUSED || collections[collectionId].mode == CollectionMode.VOUCHER_ONLY_MODE, "REDEEM_NOT_ENABLED");
        require(collections[collectionId].exists, "INVALID_TOKEN_ID");
        require(editionId < collections[collectionId].editions, "INVALID_TOKEN_ID");
        require(vouchers[msg.sender] > 0 , "USER_HAS_NO_VOUCHERS");

        scammer.mint(recipient, tokenId);

        uint numVouchers = vouchers[msg.sender].sub(1);
        vouchers[msg.sender] = numVouchers;
        
        emit editionBought(collectionId, editionId, tokenId, recipient,  0, 0, 0);
    }

    function buy(address recipient, uint256 tokenId) public payable notPaused returns (bool) {
        uint256 collectionId = tokenId.div(MAX_EDITIONS);
        uint256 editionId = tokenId.mod(MAX_EDITIONS);

        require(collections[collectionId].mode == CollectionMode.UNPAUSED, "BUY_NOT_ENABLED");
        require(collections[collectionId].exists, "INVALID_TOKEN_ID");
        require(editionId < collections[collectionId].editions, "INVALID_TOKEN_ID");
        require(msg.value == collections[collectionId].price , "DID_NOT_SEND_PRICE");

        scammer.mint(recipient, tokenId);
        
        uint256 adminReceives = msg.value.mul(adminSplit).div(100);
        uint256 artistReceives = msg.value.sub(adminReceives);

        adminWallet.transfer(adminReceives);
        artistWallet.transfer(artistReceives);

        emit editionBought(collectionId, editionId, tokenId, recipient,  collections[collectionId].price, artistReceives, adminReceives);
    }

    function mintVoucher(address recipient) public onlyOwner {
        uint numVouchers = vouchers[recipient].add(1);
        vouchers[recipient] = numVouchers;
    }

    function updateNumVouchers(address recipient, uint numVouchers) public onlyOwner {
        vouchers[recipient] = numVouchers;
    }

    function burnAllVouchers(address recipient) public onlyOwner {
        vouchers[recipient] = 0;
    }

    function numVouchers(address recipient) external view returns (uint) {
        return vouchers[recipient];
    }

    function updateAdminSplit(uint256 _adminSplit) public onlyOwner {
        require(_adminSplit <= 100, "SPLIT_MUST_BE_LTE_100");
        adminSplit = _adminSplit;
    }

    function updateAdminWallet(address payable _adminWallet) public onlyOwner {
        adminWallet = _adminWallet;
    }

    function updateArtistWallet(address payable _artistWallet) public onlyOwner {
        artistWallet = _artistWallet;
    }

    function updatePaused(bool _paused) public onlyOwner {
        paused = _paused;
    }
}