// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./interfaces/ITokenManager.sol";
import "./TokenManagerMarketplace.sol";

contract TokenManagerERC721 is ERC721Holder, ITokenManager, TokenManagerMarketplace {
    function deposit(
        address from,
        address tokenAddress,
        uint256 tokenId,
        uint256
    ) external onlyAllowedMarketplaces returns (uint256) {
        IERC721(tokenAddress).safeTransferFrom(from, address(this), tokenId);
        return uint256(0);
    }

    function withdraw(
        address to,
        address tokenAddress,
        uint256 tokenId,
        uint256
    ) external onlyAllowedMarketplaces returns (uint256) {
        IERC721(tokenAddress).safeTransferFrom(address(this), to, tokenId);
        return uint256(0);
    }
}