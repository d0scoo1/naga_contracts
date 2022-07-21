// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

// import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

// is IERC721Receiver 
contract BulkTransfer {
    function bulkTransfer(address to, IERC721Enumerable nft) public {
        uint256 nftBalance = nft.balanceOf(msg.sender);
        require(nftBalance > 0, "No NFTs to transfer.");
        for (uint256 i = 0; i < nftBalance; i++) {
            uint256 tokenId = nft.tokenOfOwnerByIndex(msg.sender, 0);
            nft.transferFrom(msg.sender, to, tokenId);
        }
    }
}