// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';

contract MultiSend {
    IERC721 vans;

    constructor(address a) {
        vans = IERC721(a);
    }

    function batchTransfer(address recipient, uint256[] calldata tokenIds) external {
        for (uint256 index; index < tokenIds.length; index++) {
            vans.safeTransferFrom(msg.sender, recipient, tokenIds[index]);
        }
    }
}