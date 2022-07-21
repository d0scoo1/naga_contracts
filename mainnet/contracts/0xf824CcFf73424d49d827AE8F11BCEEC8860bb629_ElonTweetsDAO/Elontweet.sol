// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "Ownable.sol";
import "ReentrancyGuard.sol";
import "ERC721A.sol";
import "Strings.sol";

contract ElonTweetsDAO is Ownable, ERC721A, ReentrancyGuard {
    uint256 public immutable maxPerWallet = 100;
    uint256 public immutable maxPerFreeMint = 2;
    uint256 public immutable freeMints = 200;

    uint256 public immutable maxPerTx;
    uint256 public immutable actualCollectionSize;

    uint256 public publicMintPrice = .005 ether;
    bool public publicSaleActive = false;
    bool public freeMintActive = false;

    constructor(uint256 maxBatchSize_, uint256 collectionSize_)
        ERC721A(
            "ElonTweetsDAO",
            "ElonTweetsDAO",
            maxBatchSize_,
            collectionSize_
        )
    {
        maxPerTx = maxBatchSize_;
        actualCollectionSize = collectionSize_;
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
    }

    function publicSaleMint(uint256 quantity) external payable callerIsUser {
        require(
            totalSupply() + quantity <= collectionSize,
            "reached max supply"
        );
        require(
            walletQuantity(msg.sender) + quantity <= maxPerWallet,
            "can not mint this many"
        );
        require(quantity <= maxPerTx, "can not mint this many at one time");
        require(quantity * publicMintPrice == msg.value, "incorrect funds");
        require(publicSaleActive, "public sale has not begun yet");
        _safeMint(msg.sender, quantity);
    }

    function freeMint(uint256 quantity) external callerIsUser {
        require(
            totalSupply() + quantity <= freeMints,
            "there are no more free mints!"
        );
        require(
            walletQuantity(msg.sender) + quantity <= maxPerFreeMint,
            "only allowed 2 free mint"
        );
        require(freeMintActive, "free mint is not active..");

        _safeMint(msg.sender, quantity);
    }

    function devMint(uint256 quantity) external onlyOwner {
        require(
            totalSupply() + quantity <= collectionSize,
            "too many already minted before dev mint, try minting less"
        );
        _safeMint(msg.sender, quantity);
    }

    string private _baseTokenURI;

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function withdrawMoney() external onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function setOwnersExplicit(uint256 quantity)
        external
        onlyOwner
        nonReentrant
    {
        _setOwnersExplicit(quantity);
    }

    function walletQuantity(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    function getOwnershipData(uint256 tokenId)
        external
        view
        returns (TokenOwnership memory)
    {
        return ownershipOf(tokenId);
    }

    function togglePublicMint() public onlyOwner {
        publicSaleActive = !publicSaleActive;
    }

    function toggleFreeMint() public onlyOwner {
        freeMintActive = !freeMintActive;
    }
}
