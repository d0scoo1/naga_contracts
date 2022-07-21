// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IHeroData {
    function uploadData(
        uint256 tokenID,
        string[] calldata strParam,
        uint32[] calldata param,
        uint256 deadline
    ) external;
}
