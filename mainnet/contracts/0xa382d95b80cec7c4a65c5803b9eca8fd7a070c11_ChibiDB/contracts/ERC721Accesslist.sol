// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title ERC721Accesslist
 * ERC721Accesslist - ERC721 contract that has a Merkle based accesslist - which could also be used as a raffle
 */
abstract contract ERC721Accesslist is ERC721, Ownable {
    using SafeMath for uint256;

    uint256 public totalSupply;
    bytes32 public accesslistRoot;
    bool public accesslistSaleActive;
    mapping(address => uint) public accesslistMinted;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {

    }


    function baseTokenURI() virtual public view returns (string memory);

    function tokenURI(uint256 _tokenId) override public view returns (string memory) {
        return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId), ".json"));
    }


    // get a list of tokens owned by someone
    function tokensOfOwner(address _owner) external view returns(uint256[] memory ownerTokens) {
        uint256 tokenCount = balanceOf(_owner);

        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 totalItems = totalSupply;
            uint256 resultIndex = 0;

            // We count on the fact that all items have IDs starting at 1 and increasing
            // sequentially up to the totalItems count.
            uint256 itemId;

            for (itemId = 1; itemId <= totalItems; itemId++) {
                if (ownerOf(itemId) == _owner) {
                    result[resultIndex] = itemId;
                    resultIndex++;
                }
            }

            return result;
        }
    }
        
   // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }        

    // get and set the accesslist sale state
    function setAccesslistSale(bool _setSaleState) public onlyOwner{
        accesslistSaleActive = _setSaleState;
    }    

    // set the accesslist root
    function setAccesslistRoot(bytes32 _accesslistRoot) external onlyOwner {
        accesslistRoot = _accesslistRoot;
    }
            
}
