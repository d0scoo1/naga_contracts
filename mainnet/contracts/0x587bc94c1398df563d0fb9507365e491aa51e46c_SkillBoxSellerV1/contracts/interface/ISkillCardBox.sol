// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface ISkillCardBox is IERC721 {
    function safeMint(address to) external returns (uint256);
    function forceBurn(uint256 tokenId) external;
}