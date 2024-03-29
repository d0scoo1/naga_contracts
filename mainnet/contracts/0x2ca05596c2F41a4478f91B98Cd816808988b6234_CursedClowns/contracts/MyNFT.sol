// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract CursedClowns is ERC721A, Ownable {
    uint256 public MAX_SUPPLY = 1997;
    uint256 public MAX_PER_WALLET = 10;
    uint256 public MAX_PER_TX = 5;
    uint256 public _price = 0 ether;

    bool public activated;

    string public baseURI = "";

    mapping(uint256 => string) private _tokenURIs;

    address private _ownerWallet = 0x063643c37cCa9634e9fE2E95612C3D03Af3c1736;

    constructor(
        string memory name,
        string memory symbol,
        address ownerWallet
    ) ERC721A(name, symbol) {
        _ownerWallet = ownerWallet;
    }

    ////  OVERIDES
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return string(abi.encodePacked(baseURI, _toString(tokenId), ".json"));
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    ////  MINT
    function mint(uint256 numberOfTokens) external payable {
        require(activated, "Inactive");
        require(totalSupply() + numberOfTokens <= MAX_SUPPLY, "All minted");
        require(numberOfTokens <= MAX_PER_TX, "Too many for Tx");
        require(
            _numberMinted(msg.sender) + numberOfTokens <= MAX_PER_WALLET,
            "Too many for address"
        );
        _safeMint(msg.sender, numberOfTokens);
    }

    ////  SETTERS
    function setTokenURI(string calldata newURI) external onlyOwner {
        baseURI = newURI;
    }

    function setIsActive(bool _isActive) external onlyOwner {
        activated = _isActive;
    }
}
