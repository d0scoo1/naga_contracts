// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface INarwhallousSubmission {
    /**
     * @dev Called by Narwhallous when submitting a project to give our nft holders one of the new NFT's
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function memberMint(address to) external returns (uint256);
}