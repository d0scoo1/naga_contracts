// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../interfaces/IDreamersRenderer.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DeepDreamRenderer is IDreamersRenderer, Ownable {
    string baseURI;
    using Strings for uint256;

    constructor(string memory _baseURI) {
        baseURI = _baseURI;
    }

    function setBaseURI(string memory _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }

    function tokenURI(uint256 tokenId, uint8)
        external
        view
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    bytes(baseURI),
                    tokenId.toString(),
                    "/metadata"
                )
            );
    }
}
