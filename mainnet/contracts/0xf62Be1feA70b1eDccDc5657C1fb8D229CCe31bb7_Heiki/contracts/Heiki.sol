// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/*
    ░▒█░▒█░▒█▀▀▀░▀█▀░▒█░▄▀░▀█▀
    ░▒█▀▀█░▒█▀▀▀░▒█░░▒█▀▄░░▒█░
    ░▒█░▒█░▒█▄▄▄░▄█▄░▒█░▒█░▄█▄

    卄乇丨Ҝ丨 / 2022 / V1.0
    ▬▬ι═══════ﺤ 
*/

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC721A.sol";

contract Heiki is Ownable, ERC721A, ReentrancyGuard {
    using MerkleProof for bytes32[];

    uint256 public constant MAX_SUPPLY = 3333;
    uint256 public constant MINT_LIMIT = 2;

    uint256 public constant PRESALE_MINT_PRICE = 0.065 ether;
    uint256 public constant PUBLIC_MINT_PRICE = 0.08 ether;

    /// @dev Inactive = 0; Presale = 1; Public = 2
    uint256 public saleFlag;

    bytes32 public merkleRoot;
    string public baseURI;
    
    mapping(address => uint256) private whitelistMints;

    constructor() ERC721A("Heiki", "HEIKI", 50, MAX_SUPPLY) {}

    function verifyProof(bytes32[] calldata _proof) internal view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        return _proof.verify(merkleRoot, leaf);
    }

    function getNMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    function setBaseURI(string calldata _base) external onlyOwner {
        baseURI = _base;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setSaleFlag(uint256 _flag) external onlyOwner {
        saleFlag = _flag;
    }

    function setMerkleRoot(bytes32 _new) external onlyOwner {
        merkleRoot = _new;
    }

    function mint(uint256 _quantity) external payable {
        require(totalSupply() + _quantity <= MAX_SUPPLY, "MINT_EXCEEDS_TOTAL_SUPPLY");

        require(saleFlag == 2, "MINTING_PAUSED");
        require(_quantity > 0 && _quantity <= MINT_LIMIT, "MINT_EXCEEDS_LIMIT_ALLOWED_PER_TRANSACTION");
        require(PUBLIC_MINT_PRICE * _quantity <= msg.value, "AMOUNT_TOO_LOW");
        require(tx.origin == msg.sender, "SENDER_IS_NOT_AN_EOA");

        _safeMint(msg.sender, _quantity);
    }

    function mintWhitelist(uint256 _quantity, bytes32[] calldata _proof) external payable {
        require(totalSupply() + _quantity <= MAX_SUPPLY, "MINT_EXCEEDS_TOTAL_SUPPLY");

        require(saleFlag == 1, "MINTING_PAUSED");
        require(verifyProof(_proof), "INVALID_MERKLE_PROOF");
        require(whitelistMints[msg.sender] + _quantity <= MINT_LIMIT, "MINT_EXCEEDS_LIMIT_ALLOWED_FOR_WHITELIST");
        require(_quantity > 0 && _quantity <= MINT_LIMIT, "MINT_EXCEEDS_LIMIT_ALLOWED_PER_TRANSACTION");
        require(PRESALE_MINT_PRICE * _quantity <= msg.value, "AMOUNT_TOO_LOW");

        whitelistMints[msg.sender] += _quantity;

        _safeMint(msg.sender, _quantity);
    }

    function mintOwner(uint256 _quantity, address _to) external onlyOwner {
        require(totalSupply() + _quantity <= MAX_SUPPLY, "MINT_EXCEEDS_TOTAL_SUPPLY");

        _safeMint(_to, _quantity);
    }

    /** @notice
     * ALLOCATIONS:
     *  - Community Multisig: 25% (Signers: Bitquence, sOwner1, sOwner2 / 2 of 2 signatures)
     *  - Owners: 50%
     *  - Developpers: 22.45%
     *  - Artist: 2.55%
     */
    function withdraw() external onlyOwner nonReentrant {        
        uint256 balanceDividend = address(this).balance / 100000;

        (bool sComm,) = address(0x005957b04Afa8A1B65C4632753d2C4dA6d84b64f).call{value: balanceDividend * 25000}("");
        (bool sOwner1,) = address(0xEC4f373A70d5Bb5371df8A33951B898B7219f82C).call{value: balanceDividend * 25000}("");
        (bool sOwner2,) = address(0x4494949245C3C432177C66adf32e272477D6aaFc).call{value: balanceDividend * 25000}("");
        (bool sDev1,) = address(0x6e1af0E043C18eAd53A5B9886D4901Dd6B67a22f).call{value: balanceDividend * 11225}("");
        (bool sDev2,) = address(0xe0C5123B0FD1A7D94bB8D84bBAF1026B699C6dC6).call{value: balanceDividend * 11225}("");
        (bool sArt,) = address(0xe8f46FaD3478EEa1c67eC027952B5120aA8848B2).call{value: balanceDividend * 2550}("");
    }
}
