// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./NftTrustedConsumers.sol";

contract MintPass is
    Ownable,
    ERC721,
    NftTrustedConsumers {

    constructor(string memory name_, string memory symbol_) ERC721 (name_, symbol_) {}

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view override(ERC721, NftTrustedConsumers) returns (bool) {
        return super._isApprovedOrOwner(spender, tokenId);
    }

}
