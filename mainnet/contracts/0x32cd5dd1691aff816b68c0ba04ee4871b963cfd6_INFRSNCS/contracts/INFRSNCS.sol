//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./ByteSwapping.sol";
import "./Royalty.sol";
import "./SVG.sol";
import "./Traversable.sol";
import "./WAVE.sol";

contract INFRSNCS is ERC721, Ownable, Traversable, Royalty {
    uint256 public chainSeed;
    uint256 public supplied;
    uint256 public startTokenId;
    uint256 public endTokenId;
    uint256 public mintPrice;

    constructor(
        address layerZeroEndpoint,
        uint256 chainSeed_,
        uint256 startTokenId_,
        uint256 endTokenId_,
        uint256 mintPrice_
    ) ERC721("INFRSNCS", "INFRSNCS") Traversable(layerZeroEndpoint) {
        chainSeed = chainSeed_;
        startTokenId = startTokenId_;
        endTokenId = endTokenId_;
        mintPrice = mintPrice_;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function mint(address to) public payable virtual {
        require(msg.value >= mintPrice, "INFRSNCS: msg value invalid");
        uint256 tokenId = startTokenId + supplied;
        require(tokenId <= endTokenId, "INFRSNCS: mint finished");
        _safeMint(to, tokenId);
        _registerTraversableSeeds(
            tokenId,
            chainSeed,
            uint256(
                keccak256(
                    abi.encodePacked(blockhash(block.number - 1), tokenId)
                )
            )
        );
        supplied++;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory tokenURI)
    {
        require(_exists(tokenId), "INFRSNCS: nonexistent token");
        (uint256 birthChainSeed, uint256 tokenIdSeed) = getTraversableSeeds(
            tokenId
        );
        uint256 sampleRate = WAVE.calculateSampleRate(chainSeed);
        uint256 dutyCycle = WAVE.calculateDutyCycle(birthChainSeed);
        uint256 hertz = WAVE.calculateHertz(tokenIdSeed);
        bytes memory wave = WAVE.generate(sampleRate, hertz, dutyCycle);
        bytes memory metadata = abi.encodePacked(
            '{"name":"INFRSNCS #',
            Strings.toString(tokenId),
            '","description": "A traversed generative infrasonic.","image_data":"',
            SVG.generate(wave),
            '","animation_url":"',
            wave,
            '","attributes":',
            abi.encodePacked(
                '[{"trait_type":"SAMPLE RATE","value":"',
                Strings.toString(sampleRate),
                '"},{"trait_type":"DUTY CYCLE","value":"',
                Strings.toString(dutyCycle),
                '"},{"trait_type":"HERTZ","value":"',
                WAVE.addDecimalPointToHertz(hertz),
                '"}]'
            ),
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(metadata)
                )
            );
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return
            interfaceId == type(IERC2981).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
