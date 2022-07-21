// SPDX-License-Identifier: MIT

pragma solidity >=0.8.9 <0.9.0;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DoodlePoop is ERC721A, Ownable, ReentrancyGuard {
    using Strings for uint256;

    string public baseURI;

    uint256 public constant PRICE = 0.00069 ether;
    uint256 public constant MAX_SUPPLY = 10001;
    uint256 public constant MAX_PER_TX = 6;
    uint256 public constant MAX_PER_WALLET = 6;
    uint256 public constant RESERVES = 100;

    bool public paused = true;
    bool public reservesCollected = false;

    constructor(string memory _baseURI) ERC721A("DoodlePoop", "DPOOP") {
        baseURI = _baseURI;
    }

    function setBaseURI(string memory _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }

    modifier mintCompliance(uint256 _mintAmount) {
        require(
            _mintAmount > 0 && _mintAmount < MAX_PER_TX,
            "Invalid mint amount!"
        );
        require(
            totalSupply() + _mintAmount < MAX_SUPPLY,
            "Max supply exceeded!"
        );
        require(
            _numberMinted(msg.sender) + _mintAmount < MAX_PER_WALLET,
            "Wallet limit reached!"
        );
        _;
    }

    modifier mintPRICECompliance(uint256 _mintAmount) {
        require(msg.value >= _mintAmount * PRICE, "Insufficient funds!");
        _;
    }

    function mint(uint256 _mintAmount)
        public
        payable
        mintCompliance(_mintAmount)
        mintPRICECompliance(_mintAmount)
    {
        require(!paused, "The contract is paused!");
        _safeMint(_msgSender(), _mintAmount);
    }

    function collectReserves() external onlyOwner {
        require(!reservesCollected, "Reserves already taken.");
        _safeMint(_msgSender(), RESERVES);
        reservesCollected = true;
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(
                        baseURI,
                        _tokenId.toString(),
                        ".json"
                    )
                )
                : "";
    }

    function togglePaused() public onlyOwner {
        paused = !paused;
    }

    function withdraw() public onlyOwner nonReentrant {
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success, "Failed to withdraw balance.");
    }
}
