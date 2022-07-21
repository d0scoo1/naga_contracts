// SPDX-License-Identifier: GPL-3.0

import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import "erc721a/contracts/ERC721A.sol";

pragma solidity ^0.8.0;
interface ITubbies is IERC721{
        function mintFromSale(uint tubbiesToMint) external payable;
}