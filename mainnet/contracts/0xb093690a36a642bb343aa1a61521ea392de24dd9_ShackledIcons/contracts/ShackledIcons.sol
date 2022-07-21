// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ShackledStructs.sol";
import "./ShackledRenderer.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract ShackledIcons is ERC721Enumerable, Ownable {
    string public currentBaseURI;

    mapping(uint256 => bytes32) public tokenHashes;

    constructor() ERC721("ShackledIcons", "ICON") {}

    /**
     * @dev Mint token ids to a particular address
     */
    function mint(address to, uint256 tokenId) public onlyOwner {
        require(
            tokenHashes[tokenId] != 0x0,
            "Cannot mint a token that doesn't exist"
        );
        _safeMint(to, tokenId);
    }

    function storeTokenHash(uint256 tokenId, bytes32 tokenHash)
        public
        onlyOwner
    {
        tokenHashes[tokenId] = tokenHash;
    }

    function getRenderParamsHash(
        ShackledStructs.RenderParams calldata renderParams
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    abi.encodePacked(
                        renderParams.faces,
                        renderParams.verts,
                        renderParams.cols
                    ),
                    abi.encodePacked(
                        renderParams.objPosition,
                        renderParams.objScale,
                        renderParams.backgroundColor,
                        renderParams.perspCamera,
                        renderParams.backfaceCulling,
                        renderParams.invert,
                        renderParams.wireframe
                    ),
                    _getLightingParamsHash(renderParams.lightingParams)
                )
            );
    }

    function _getLightingParamsHash(
        ShackledStructs.LightingParams calldata lightingParams
    ) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    lightingParams.applyLighting,
                    lightingParams.lightAmbiPower,
                    lightingParams.lightDiffPower,
                    lightingParams.lightSpecPower,
                    lightingParams.inverseShininess,
                    lightingParams.lightPos,
                    lightingParams.lightColSpec,
                    lightingParams.lightColDiff,
                    lightingParams.lightColAmbi
                )
            );
    }

    function render(
        uint256 tokenId,
        int256 canvasDim_,
        ShackledStructs.RenderParams calldata renderParams
    ) public view returns (string memory) {
        bytes32 tokenHash = getRenderParamsHash(renderParams);
        require(tokenHash == tokenHashes[tokenId], "Token hash mismatch");
        return ShackledRenderer.render(renderParams, canvasDim_, true);
    }

    function setBaseURI(string memory baseURI_) public onlyOwner {
        currentBaseURI = baseURI_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return currentBaseURI;
    }
}
