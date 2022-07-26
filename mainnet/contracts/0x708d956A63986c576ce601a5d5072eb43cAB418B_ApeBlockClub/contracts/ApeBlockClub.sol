// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721A.sol";
import "./context/Ownable.sol";
import "./ReentrancyGuard.sol";

contract ApeBlockClub is ERC721A, Ownable, ReentrancyGuard {
    using Strings for uint256;

    uint256 public MAX_SUPPLY = 10000;
    uint256 public PUBLIC_PRICE = 0.12 ether; 
    bool public SALE_IS_ACTIVE = false;

    string private _baseURIextended;

    constructor() ERC721A("ApeBlockClub", "ABC") {}

    function mint(uint256 nMints) external payable nonReentrant {
        require(SALE_IS_ACTIVE, "Minting is not active now");
        require(totalSupply() + nMints <= MAX_SUPPLY, "Exceeds max supply");
        require(PUBLIC_PRICE * nMints <= msg.value, "Sent incorrect ETH value");

        _safeMint(msg.sender, nMints);
    }

    function setBaseURI(string calldata baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    function changePrice(uint256 newPrice) external onlyOwner {
        PUBLIC_PRICE = newPrice;
    }

    function changeTotalSupply(uint256 newSupply) external onlyOwner {
        MAX_SUPPLY = newSupply;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length != 0
                ? string(abi.encodePacked(baseURI, (tokenId + 1).toString()))
                : "";
    }

    function withdrawAll() external onlyOwner {
        require(address(this).balance > 0, "No funds to withdraw");
        uint256 contractBalance = address(this).balance;
        _withdraw(msg.sender, contractBalance);
    }

    function _withdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }

    function flipSaleState() public onlyOwner {
        SALE_IS_ACTIVE = !SALE_IS_ACTIVE;
    }

    receive() external payable {}
}
