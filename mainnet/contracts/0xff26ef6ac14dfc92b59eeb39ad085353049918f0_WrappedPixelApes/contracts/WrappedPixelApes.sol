pragma solidity >=0.8.12;

// SPDX-License-Identifier: CC0-1.0

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract WrappedPixelApes is ERC1155Holder, ERC721, Ownable {
    
    constructor(string memory _baseURI) ERC721("Wrapped PixelApes", "wApe24px") {
        deployedAt = block.number;
        baseURI = _baseURI;
    }

    address  private _24PX_DEPLOYER_ADDRESS = 0xEfE708e6Dd941e29965F34f4c5C6e78f0Ebe3F5b;
    IERC1155 private openSeaStorefront = IERC1155(0x495f947276749Ce646f68AC8c248420045cb7b5e);
    uint     private MIN_ID = 1;
    uint     private MAX_ID = 9900;
    uint     private UNKNOWN_INT = 1;
    uint     private deployedAt;
    string   private baseURI;

    function toOpenSeaId(uint id) external view returns (uint) {
        require(id >= MIN_ID, "id too low");
        require(id <= MAX_ID, "id too high");

        /* 
        ** We need to account for a few "ghost" tokens, which have been
        ** minted on the OS frontend and then subsequently deleted.
        ** These tokens technically no longer exist, but the ID counter
        ** for the author's creations has already been incremented,
        ** which breaks the sequentiality of the (undeleted) token IDs.
        ** In the case of weape24, the deleted tokens have the IDs
        ** 981, 982, 1165, 1258, 1831 and 6238.
        **
        ** The base offset here is 9903, to account for 9900 PixelCats
        ** and 3 additional deleted tokens.
        */

        uint offset = 9903;

        if (id > 980)
            offset += 2;

        if (id > 1164)
            offset += 1;

        if (id > 1257)
            offset += 1;

        if (id > 1830)
            offset += 1;

        if (id > 6237)
            offset += 1;

        /* 
        ** While the token IDs for OpenSea Shared Storefront-based tokens
        ** appear to be gibberish in Base10, they are pretty predictable
        ** in Base16, and use the following format:
        **
        **   efe708e6dd941e29965f34f4c5c6e78f0ebe3f5b 000000000026af 0000000001
        **   token creator address                    token ID       "1"
        **              (the example ID above is from PixelCat 9900)
        **
        ** I am not sure what the last part of the ID is supposed to indicate.
        ** At first, I thought it was the chain ID, but storefront tokens on Polygon
        ** also have just "1" in that part of the ID. ¯\_(ツ)_/¯
        */

        uint p1 = uint256(uint160(_24PX_DEPLOYER_ADDRESS)) << 96;
        uint p2 = (id + offset) << 40;
        uint p3 = UNKNOWN_INT;
        return p1 + p2 + p3;
    }


    function _wrap(uint _id, address _caller) internal {
        uint openSeaId = this.toOpenSeaId(_id);
        openSeaStorefront.safeTransferFrom(_caller, address(this), openSeaId, 1, "");
        _safeMint(_caller, _id);
    }

    function _unwrap(uint _id, address _caller) internal {
        require(ownerOf(_id) == _caller, "not the owner");
        _burn(_id);
        openSeaStorefront.safeTransferFrom(address(this), _caller, this.toOpenSeaId(_id), 1, "");
    }

    function _checkApproval(address _caller) internal view returns (bool) {
        return openSeaStorefront.isApprovedForAll(_caller, address(this));
    }

    function wrap(uint[] calldata ids) external {
        require(_checkApproval(_msgSender()), "Contract is not approved to transfer tokens");

        for(uint i = 0; i < ids.length; i++)
            _wrap(ids[i], _msgSender());
    }

    function unwrap(uint[] calldata ids) external {
        for(uint i = 0; i < ids.length; i++)
            _unwrap(ids[i], _msgSender());
    }

    function supportsInterface(bytes4 interfaceId) public pure override(ERC721, ERC1155Receiver) returns (bool) {
        return interfaceId == 0x01ffc9a7 || // ERC165
               interfaceId == 0x80ac58cd || // ERC721
               interfaceId == 0x5b5e139f || // ERC721Metadata
               interfaceId == 0x4e2312e0;   // ERC1155TokenReceiver
    }


    /* 
    ** I have added this function as a preventative measure
    ** in case there is something wrong with the metadata.
    ** The require() within the function ensures that the
    ** URI becomes uneditable after 172 800 blocks
    ** (very roughly +- 30 days) have passed since deployment.
    ** This is to prevent me (the author) or anyone from tampering
    ** with the base URI any time beyond the first 30 days,
    ** but still give me enough time to issue a fix in case 
    ** the metadata is broken or incorrect.
    */
    
    function updateTokenURI(string calldata _newURI) external onlyOwner {
        require(block.number < deployedAt + 172800, "URI is permanently locked");
        baseURI = _newURI;
    }

    function tokenURI(uint id) public view override returns (string memory) {
        return string(
            abi.encodePacked(
                baseURI, Strings.toString(id), ".json"
            )
        );
    }

}
