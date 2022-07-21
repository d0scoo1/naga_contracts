// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface ITokenStake is IERC721 {
    function isTokenStaked(uint256 tokenId) external returns (bool);

    function stakeToken(uint256 tokenId) external;

    function unstakeToken(uint256 tokenId) external;
}
