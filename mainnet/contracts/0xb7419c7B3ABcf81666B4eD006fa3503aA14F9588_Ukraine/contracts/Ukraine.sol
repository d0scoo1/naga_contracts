// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Ukraine is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public totalEditions = 0;
    bool public canUpdateEditions = true;
    bool public canUpdateURI = true;
    string public _uri =
        "https://gateway.pinata.cloud/ipfs/QmWwVMFUm6bdbRez26BUJUqLoizR6Prmn3zP5u2m7YzRUy/";
    uint256 public price = 0.05 ether;

    constructor() ERC721("Seeds of Ukraine", "SOU") {
        totalEditions = 10000;
        _transferOwnership(address(0x7735b940d673344845aC239CdDddE1D73b5d5627));
    }

    function updateEditions(uint256 newMax) public onlyOwner {
        require(newMax >= totalEditions, "new max must be greater");
        require(canUpdateEditions == true, "can no longer update editions");
        totalEditions = newMax;
    }

    function burnEditionUpdates() public onlyOwner {
        require(canUpdateEditions == true, "burn updates already happened");
        canUpdateEditions = false;
    }

    function mint(uint256 _amount) public payable {
        require(
            Counters.current(_tokenIds) <= totalEditions,
            "minting has reached its max"
        );
        require(msg.value >= price * _amount, "Not enough eth");
        for (uint256 i; i <= _amount - 1; i++) {
            uint256 newNFT = _tokenIds.current();
            _safeMint(msg.sender, newNFT);
            _tokenIds.increment();
        }
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _uri;
    }

    function setURI(string memory newuri) public onlyOwner {
        require(canUpdateURI == true, "can no longer update URI");
        _uri = newuri;
    }

    function burnURIUpdates() public onlyOwner {
        require(canUpdateURI == true, "burn URI already happened");
        canUpdateURI = false;
    }

    // Withdraw
    function withdraw(address payable withdrawAddress)
        external
        payable
        nonReentrant
        onlyOwner
    {
        require(
            withdrawAddress != address(0),
            "Withdraw address cannot be zero"
        );
        require(address(this).balance >= 0, "Not enough eth");
        (bool sent, bytes memory data) = withdrawAddress.call{value:address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}
