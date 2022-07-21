// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// import {ERC721DropMinterInterface} from "./ERC721DropMinterInterface.sol";
// import {ERC721OwnerInterface} from "./ERC721OwnerInterface.sol";
import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";
import {ERC721Drop} from "zora-drops-contracts/ERC721Drop.sol";
import {IMetadataRenderer} from "zora-drops-contracts/interfaces/IMetadataRenderer.sol";
import {MetadataRenderAdminCheck} from "zora-drops-contracts/metadata/MetadataRenderAdminCheck.sol";
import {SharedNFTLogic} from "zora-drops-contracts/utils/SharedNFTLogic.sol";

/// @notice Exchanges one drop for another through burn mechanism
contract NounsVisionExchangeMinterModule is
    IMetadataRenderer,
    MetadataRenderAdminCheck
{
    struct ColorInfo {
        uint128 claimedCount;
        uint128 maxCount;
        string animationURI;
        string imageURI;
    }

    struct ColorSetting {
        string color;
        uint128 maxCount;
        string animationURI;
        string imageURI;
    }

    event ExchangedTokens(
        address indexed sender,
        uint256 indexed resultChunk,
        uint256 targetLength,
        uint256[] fromIds
    );

    event UpdatedColor(string color, ColorSetting settings);
    event UpdatedDescription(string newDescription);

    ERC721Drop public immutable source;
    ERC721Drop public sink;
    SharedNFTLogic private immutable sharedNFTLogic;

    string description;
    string public contractURI;

    mapping(string => ColorInfo) public colors;
    mapping(uint256 => string) public idToColor;

    constructor(
        IERC721Drop _source,
        SharedNFTLogic _sharedNFTLogic,
        string memory _description
    ) {
        source = ERC721Drop(payable(address(_source)));
        sharedNFTLogic = _sharedNFTLogic;
        description = _description;
    }

    uint128 public maxCount;

    function setDescription(string memory newDescription)
        public
        requireSenderAdmin(address(source))
    {
        description = newDescription;
        emit UpdatedDescription(newDescription);
    }

    function setContractURI(string memory newContractURI)
        public
        requireSenderAdmin(address(source))
    {
        contractURI = newContractURI;
    }

    // This is called along with the create callcode in the deployer contract as one
    // function call allowing the init to be a public function since it's within one transaction.
    function initializeWithData(bytes memory) external {
        require(address(sink) == address(0x0), "Can only be initialized once");
        sink = ERC721Drop(payable(msg.sender));
    }

    function setColorLimits(ColorSetting[] calldata colorSettings)
        external
        requireSenderAdmin(address(sink))
    {
        uint128 maxCountCache = maxCount;
        for (uint256 i = 0; i < colorSettings.length; ) {
            string memory color = colorSettings[i].color;
            require(
                colors[color].claimedCount <= colorSettings[i].maxCount,
                "Cannot decrease beyond claimed"
            );
            maxCountCache -= colors[color].maxCount;
            maxCountCache += colorSettings[i].maxCount;
            colors[color].maxCount = colorSettings[i].maxCount;
            colors[color].animationURI = colorSettings[i].animationURI;
            colors[color].imageURI = colorSettings[i].imageURI;

            emit UpdatedColor(color, colorSettings[i]);

            unchecked {
                ++i;
            }
        }
        maxCount = maxCountCache;
    }

    function exchange(uint256[] calldata fromIds, string memory color)
        external
    {
        require(
            source.isApprovedForAll(msg.sender, address(this)),
            "Exchange module is not approved to manage tokens"
        );
        uint128 targetLength = uint128(fromIds.length);
        require(
            colors[color].claimedCount + targetLength <= colors[color].maxCount,
            "Ran out of color"
        );
        colors[color].claimedCount += targetLength;

        uint256 resultChunk = sink.adminMint(msg.sender, targetLength);
        for (uint256 i = 0; i < targetLength; ) {
            // If the user (account) is able to burn then they also are able to exchange.
            // If they are not allowed, the burn call will fail.
            source.burn(fromIds[i]);
            unchecked {
                idToColor[resultChunk - i] = color;
                ++i;
            }
        }

        emit ExchangedTokens({
            sender: msg.sender,
            resultChunk: resultChunk,
            targetLength: targetLength,
            fromIds: fromIds
        });
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        string memory color = idToColor[tokenId];
        ColorInfo storage colorInfo = colors[color];

        return
            sharedNFTLogic.createMetadataEdition({
                name: string(abi.encodePacked(sink.name(), " ", color)),
                description: description,
                imageUrl: colorInfo.imageURI,
                animationUrl: colorInfo.animationURI,
                tokenOfEdition: tokenId,
                editionSize: maxCount
            });
    }
}
