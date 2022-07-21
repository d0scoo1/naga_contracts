//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "./AdminManager.sol";

contract Strain is
    Initializable,
    ERC721Upgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable,
    AdminManagerUpgradable
{
    using Counters for Counters.Counter;

    struct CoreTraits {
        uint32 size;
        uint32 thc;
        uint32 terpenes;
        uint32 deathTime;
    }

    Counters.Counter private _idCounter;

    uint256 public ethCost;
    uint256 public genesisSupply;
    uint256 public maxGenesisSupply;
    bool public publicSaleEnabled;
    string private _uri;
    bytes32 private _merkleTreeRoot;
    uint256 private _publicMintLimit;
    address payable private _paymentSplitter;
    mapping(uint256 => CoreTraits) private _coreTraits;
    mapping(address => uint256) private _mintsByWhitelist;

    function initialize(string memory uri, bytes32 merkleTreeRoot)
        public
        initializer
    {
        __Context_init_unchained();
        __ERC165_init_unchained();
        __ERC721_init_unchained("WEEDGANG.GAME - STRAIN", "WG-S");
        __Pausable_init_unchained();
        __ReentrancyGuard_init();
        __AdminManager_init();
        _uri = uri;
        _merkleTreeRoot = merkleTreeRoot;
        ethCost = 0.8 ether;
        maxGenesisSupply = 9000;
        _publicMintLimit = 5;
    }

    function adminMint(uint256 amount) external onlyAdmin {
        _callMint(amount);
    }

    function whitelistMint(
        uint256 amount,
        uint256 places,
        bytes32[] calldata proof
    ) external payable whenNotPaused nonReentrant {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, places));
        require(
            MerkleProof.verify(proof, _merkleTreeRoot, leaf),
            "Not whitelisted"
        );
        require(
            _mintsByWhitelist[msg.sender] + amount <= places,
            "You can't mint so many tokens"
        );
        require(msg.value >= ethCost * amount, "Not enough ether");
        _callMint(amount);
        _mintsByWhitelist[msg.sender] += amount;
    }

    function breedMint(address account, CoreTraits memory traits)
        external
        onlyAdmin
        whenNotPaused
    {
        _breed(account, traits);
    }

    function mint(uint256 amount) external payable whenNotPaused nonReentrant {
        require(publicSaleEnabled, "Not enabled");
        require(amount <= _publicMintLimit, "You can't mint so many tokens");
        require(
            balanceOf(msg.sender) + amount <= _publicMintLimit,
            "Limit per address reached"
        );
        require(msg.value >= ethCost * amount, "Not enough ether");
        _callMint(amount);
    }

    function pause() external onlyAdmin {
        _pause();
    }

    function unpause() external onlyAdmin {
        _unpause();
    }

    function setEthCost(uint256 cost) external onlyAdmin {
        ethCost = cost;
    }

    function setMaxGenesisSupply(uint256 supply) external onlyAdmin {
        maxGenesisSupply = supply;
    }

    function setPublicSaleEnabled(bool publicSale) external onlyAdmin {
        publicSaleEnabled = publicSale;
    }

    function setUri(string memory uri) external onlyAdmin {
        _uri = uri;
    }

    function setMerkleTreeRoot(bytes32 root) external onlyAdmin {
        _merkleTreeRoot = root;
    }

    function setPublicMintLimit(uint256 limit) external onlyAdmin {
        _publicMintLimit = limit;
    }

    function paymentSplitter() external view onlyAdmin returns (address) {
        return _paymentSplitter;
    }

    function setPaymentSplitter(address payable contractAddress)
        external
        onlyAdmin
    {
        _paymentSplitter = contractAddress;
    }

    function coreTraits(uint256 id) external view returns (CoreTraits memory) {
        require(_exists(id), "Core traits query for nonexistent token");
        return _coreTraits[id];
    }

    function burn(uint256 id) external onlyAdmin {
        _burn(id);
    }

    function withdraw() external onlyAdmin {
        require(_paymentSplitter != address(0x0), "Payment splitter not set");
        (bool success, ) = _paymentSplitter.call{value: address(this).balance}(
            ""
        );
        require(success, "Founds transfer failed");
    }

    function _callMint(uint256 amount) private {
        require(amount > 0, "You can't mint 0 tokens");
        require(
            genesisSupply + amount <= maxGenesisSupply,
            "You can't mint so many tokens"
        );
        for (uint256 i = 1; i <= amount; i++) {
            _breed(msg.sender, CoreTraits(500, 500, 250, 0));
            genesisSupply++;
        }
    }

    function _breed(address account, CoreTraits memory traits) private {
        _idCounter.increment();
        uint256 id = _idCounter.current();
        _coreTraits[id] = traits;
        _safeMint(account, id);
    }

    function _baseURI() internal view override returns (string memory) {
        return _uri;
    }
}
