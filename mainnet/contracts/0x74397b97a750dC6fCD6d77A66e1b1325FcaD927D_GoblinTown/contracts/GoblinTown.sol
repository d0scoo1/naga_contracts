// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GoblinTown is ERC721A, Ownable {
    uint256 constant public GBT_MAX = 2001;
    uint256 constant public GBT_MAX_PER_TX = 10;

    bool public isOpen;

    mapping(address => uint256) public minted;

    constructor() ERC721A("GoblinTown", "GBT", GBT_MAX_PER_TX, GBT_MAX) {
    }

    function mint(uint256 quantity) external payable {
        require(isOpen, "Contract is close");
        require(totalSupply() + quantity <= GBT_MAX, "More than available");
        require(minted[msg.sender] + quantity <= GBT_MAX_PER_TX, "Max minted");
        require(quantity <= GBT_MAX_PER_TX, "Max per tx");

        minted[msg.sender] += quantity;
        _safeMint(msg.sender, quantity);

    }

    function setIsOpen() external onlyOwner {
		isOpen = !isOpen;
	}

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }


    string private _contractURI = "ipfs://bafkreigaugt3lwiem5tc23fsfvbmbetksc2zfgf336aok6zoljj35m62c4";

    function setContractURI(string calldata uri) external onlyOwner {
        _contractURI = uri;
    }

    function contractURI() public view returns (string memory) {
        return _contractURI;
    }


    string private baseURI = "ipfs://bafybeigkwnu3kla4soalbeiahm5xdgiyfom47kgqpkxpwj35d5r6suntsi/";

    function setBaseURI(string calldata uri) external onlyOwner {
        baseURI = uri;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}
