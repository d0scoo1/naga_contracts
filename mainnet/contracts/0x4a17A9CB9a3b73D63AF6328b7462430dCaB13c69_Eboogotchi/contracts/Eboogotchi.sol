// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";

contract Eboogotchi is ERC721A, Ownable {
    constructor(string memory baseURI, address[] memory to)
        ERC721A("Eboogotchi", "EBOOGOTCHI")
    {
        for (uint256 i = 0; i < to.length; i++) {
            _safeMint(to[i], 1);
        }
        _baseTokenURI = baseURI;
    }

    // // metadata URI
    string private _baseTokenURI;

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }
}
