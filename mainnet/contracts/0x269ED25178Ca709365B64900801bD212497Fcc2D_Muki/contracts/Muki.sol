// SPDX-License-Identifier: UNLICENSED

/*



 __       __  __    __  __    __  ______ 
|  \     /  \|  \  |  \|  \  /  \|      \
| $$\   /  $$| $$  | $$| $$ /  $$ \$$$$$$
| $$$\ /  $$$| $$  | $$| $$/  $$   | $$  
| $$$$\  $$$$| $$  | $$| $$  $$    | $$  
| $$\$$ $$ $$| $$  | $$| $$$$$\    | $$  
| $$ \$$$| $$| $$__/ $$| $$ \$$\  _| $$_ 
| $$  \$ | $$ \$$    $$| $$  \$$\|   $$ \
 \$$      \$$  \$$$$$$  \$$   \$$ \$$$$$$
                                         
                                                                              

*/

pragma solidity ^0.8.10;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Muki is ERC721A, Ownable {
    bool public saleEnabled;
    uint256 public price;
    string public metadataBaseURL;

    uint256 public MAX_TXN = 10;
    uint256 public MAX_TXN_GLOBAL = 6666;
    uint256 public constant MAX_SUPPLY = 6666;
    mapping(address => bool) public freeClaims;

    constructor() ERC721A("Muki", "MUKI", MAX_TXN_GLOBAL) {
        saleEnabled = false;
        price = 0.005 ether;
    }

    function setBaseURI(string memory baseURL) external onlyOwner {
        metadataBaseURL = baseURL;
    }

    function toggleSaleStatus() external onlyOwner {
        saleEnabled = !(saleEnabled);
    }

    function setMaxTxn(uint256 _maxTxn) external onlyOwner {
        MAX_TXN = _maxTxn;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return metadataBaseURL;
    }

    function withdraw() external onlyOwner {
        uint256 _balance = address(this).balance;
        address payable _sender = payable(_msgSender());
        _sender.transfer(_balance);
    }

    function reserve(uint256 num) external onlyOwner {
        require((totalSupply() + num) <= MAX_SUPPLY, "Exceed max supply");
        _safeMint(msg.sender, num);
    }

    function freeClaimCheck(address add) public view returns (bool) {
        return freeClaims[add];
    }

    function mint(uint256 numOfTokens) external payable {
        require(saleEnabled, "Sale must be active.");
        require(totalSupply() + numOfTokens <= MAX_SUPPLY, "Exceed max supply");
        require(numOfTokens > 0, "Must mint at least 1 token");
        require(numOfTokens <= MAX_TXN, "Cant mint more than 10");
        require(
            (price * numOfTokens) <= msg.value,
            "Insufficient funds to claim."
        );

        _safeMint(msg.sender, numOfTokens);
    }

    function freeMint(uint256 numOfTokens) external payable {
        require(!freeClaims[msg.sender], "Already claimed free mint.");
        require(saleEnabled, "Sale must be active.");
        require(totalSupply() + numOfTokens <= MAX_SUPPLY, "Exceed max supply");
        require(numOfTokens == 1, "Must mint 1 token");

        freeClaims[msg.sender] = true;
        _safeMint(msg.sender, numOfTokens);
    }
}
