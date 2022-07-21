// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @author: manifold.xyz (Thank you @yungwknd for the guidance and support)
/// @artist: Dmitri Cherniak

import "@manifoldxyz/libraries-solidity/contracts/access/AdminControl.sol";
import "@manifoldxyz/creator-core-solidity/contracts/core/IERC1155CreatorCore.sol";
import "@manifoldxyz/creator-core-solidity/contracts/extensions/ICreatorExtensionTokenURI.sol";
import "./ILazyDelivery.sol";
import "./ILazyDeliveryMetadata.sol";

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
 * Ringers is dead, long live Ringers
 */
contract DeadRingersEdition is AdminControl, ICreatorExtensionTokenURI, ILazyDelivery, ILazyDeliveryMetadata {

    using Strings for uint256;
    using Strings for uint16;

    address private _creator;
    address private _marketplace;
    string private _image;
    uint256 private _mintCount = 0;
    uint public constant maxMints = 16**40;

    uint _listingId;

    mapping(address => bool) minters;

    constructor(address creator) {
        _creator = creator;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(AdminControl, IERC165) returns (bool) {
        return interfaceId == type(ICreatorExtensionTokenURI).interfaceId || interfaceId == type(ILazyDelivery).interfaceId || AdminControl.supportsInterface(interfaceId) || super.supportsInterface(interfaceId);
    }

    function setListing(uint listingId, address marketplace) public adminRequired {
        _listingId = listingId;
        _marketplace = marketplace;
    }

    function deliver(address, uint256 listingId, uint256 assetId, address to, uint256, uint256 index) external override returns(uint256) {
        require(msg.sender == _marketplace &&
                    listingId == _listingId &&
                    assetId == 1 && index == 0,
            "Invalid call data");
        
        require(IERC1155(_creator).balanceOf(to, 1) < 1, "You can't mint one if you already have one.");
        
        require(!minters[to], "You can only mint once.");

        require(_mintCount < maxMints, "There can only ever exist one for each possible address.");

        minters[to] = true;
        _mintCount++;

        address[] memory addressToSend = new address[](1);
        addressToSend[0] = to;
        uint[] memory tokenToSend = new uint[](1);
        tokenToSend[0] = 1;
        uint[] memory numToSend = new uint[](1);
        numToSend[0] = 1;

        if (_mintCount == 1) {
            string[] memory uris = new string[](1);
            uris[0] = this.assetURI(assetId);
            IERC1155CreatorCore(_creator).mintExtensionNew(addressToSend, tokenToSend, uris);
        } else {
            IERC1155CreatorCore(_creator).mintExtensionExisting(addressToSend, tokenToSend, numToSend);
        }

        return 1;
    }

    function setImage(string memory image) public adminRequired {
        _image = image;
    }

    function assetURI(uint256) external view override returns(string memory) {
        return string(abi.encodePacked('data:application/json;utf8,',
        '{"name":"Dead Ringers: Edition","created_by":"Dmitri Cherniak","description":"Dead Ringers: Edition\\n\\nEvery day in January 2022 I generated a new output from an algorithm, generated a random wallet address, and sent the work to that address. On the final day, January 31st, all the previous Dead Ringers were placed in a 5 by 6 grid and minted to a generated address.\\n\\nIt was almost guaranteed none of the wallets that received Dead Ringers would ever be accessible given there are 16 to power of 40 available addresses. I hoped it would help observers appreciate the vastness of the address space and the underlying security it provides to the network used to distribute the work.\\n\\nWhile the distribution of individual Dead Ringers was extremely fair, as it protected against bots and ballot stuffing, it was also extremely unlikely that they would ever be collected. For that reason, observers ascribed value to their scarcity and the odds of receiving one.\\n\\nThe Dead Ringers: Edition flips that notion on its head. Now an edition of January 31, 2022, colloquially known as the Dead Ringers grid, is available to all wallets as a 24-hour timed edition, capped at the size of 16 to the power of 40. That is the total number of possible wallets, and each wallet is entitled to own one if they should wish.\\n\\nThe ERC1155 token points to the same PNG file on Arweave that the original January 31, 2022 referenced, meaning the underlying artwork is exactly the same file as the sought after original.\\n\\nEach wallet is only eligible to mint one edition, and if a wallet already has one it cannot mint another. There is a 24 hour minting period and the edition size is capped at 16 to the power of 40, the number of all possible Ethereum addresses.\\n\\n30 Dead Ringers in a 5 by 6 grid\\n\\nSVG generated by javascript as SVG, and rendered to PNG.\\n\\n14400px by 21600px",',
        '"image":"',
        _image,
        '","image_url":"',
        _image,
        '"}'));
    }

    function tokenURI(address creator, uint256 tokenId) external view override returns (string memory) {
        require(creator == _creator, "Invalid token");
        return this.assetURI(tokenId);
    }
}
