// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@solidstate/contracts/token/ERC721/ERC721.sol";
import {ERC721BaseStorage} from "@solidstate/contracts/token/ERC721/base/ERC721BaseStorage.sol";
import {ERC721MetadataStorage} from "@solidstate/contracts/token/ERC721/metadata/ERC721MetadataStorage.sol";
import {OwnableInternal} from "@solidstate/contracts/access/OwnableInternal.sol";

contract ChonkySpecial is ERC721, OwnableInternal {
    using ERC721BaseStorage for ERC721BaseStorage.Layout;
    using ERC721MetadataStorage for ERC721MetadataStorage.Layout;

    function mint(address to, string memory ipfsHash) external onlyOwner {
        ERC721MetadataStorage.Layout storage l = ERC721MetadataStorage.layout();
        uint256 tokenId = _totalSupply();

        l.tokenURIs[tokenId] = ipfsHash;
        _mint(to, tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            ERC721BaseStorage.layout().exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        ERC721MetadataStorage.Layout storage l = ERC721MetadataStorage.layout();

        return string(abi.encodePacked("ipfs://", l.tokenURIs[tokenId]));
    }
}
