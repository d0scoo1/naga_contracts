// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract ChubbiverseHonorary is ERC721A, ERC721AQueryable, ERC2981, Ownable {
    string public baseURI;

    constructor(address royaltyReceiver) ERC721A("Chubbiverse Honorary", "CHH") {
        baseURI = "https://app.chubbiverse.com/api/meta/honorary/";
        _setDefaultRoyalty(royaltyReceiver, 500); // 5% royalty
    }

    function setBaseURI(string memory uri) external onlyOwner {
        baseURI = uri;
    }

    function mint(address to, uint256 quantity) external onlyOwner {
        _safeMint(to, quantity);
    }

    /**
     * ERC2981
     */
    function setRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    /**
     * ERC721A
     */

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /**
     * Overrides
     */

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
