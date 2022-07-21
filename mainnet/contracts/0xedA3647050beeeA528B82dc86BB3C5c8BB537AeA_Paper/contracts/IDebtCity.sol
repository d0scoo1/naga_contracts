// contracts/IDebtCity.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


interface IDebtCity is IERC721 {
    function getPayForBanker(uint256 _tokenId) external view returns (uint8);
}
