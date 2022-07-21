// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "./Ownable.sol";
import "./Strings.sol";
import "./ERC721.sol";

/*
   ______      __              ______           _ ____          
  / ____/_  __/ /_  ___  _____/ ____/___  _____(_) / /___ ______
 / /   / / / / __ \/ _ \/ ___/ / __/ __ \/ ___/ / / / __ `/ ___/
/ /___/ /_/ / /_/ /  __/ /  / /_/ / /_/ / /  / / / / /_/ (__  ) 
\____/\__, /_.___/\___/_/   \____/\____/_/  /_/_/_/\__,_/____/  
     /____/                                                     

*/

/// @title Cyber Gorillas Babies
/// @author delta devs (https://twitter.com/deltadevelopers)
contract CyberGorillaBabies is ERC721, Ownable {
    using Strings for uint256;

    /// @notice The address which is allowed to breed Cyber Gorillas.
    address private gorillaBreeder;
    /// @notice Base URI pointing to CyberGorillaBabies metadata.
    string public baseURI;
    /// @notice Returns true if the requested gorilla baby has the genesis trait, false otherwise.
    mapping(uint256 => bool) public isGenesis;

    constructor(string memory initialBaseURI)
        ERC721("Cyber Gorilla Babies", "CyberGorillaBabies")
    {
        baseURI = initialBaseURI;
    }

    /// @notice Set the address which is allowed to breed gorillas.
    /// @param newGorillaBreeder The target address, authorized to breed.
    function setGorillaBreeder(address newGorillaBreeder) public onlyOwner {
        gorillaBreeder = newGorillaBreeder;
    }

    /// @notice Allows the contract deployer to set the Base URI for CyberGorillaBabies' metadata.
    /// @param newBaseURI The new Base URI.
    function setBaseURI(string memory newBaseURI) public onlyOwner {
        baseURI = newBaseURI;
    }

    /// @notice Allows the authorized breeder address to mint a gorilla baby to a specific address.
    /// @param to The address to receive the minted gorilla baby.
    /// @param _isGenesis Whether the baby to be minted has the genesis trait or not.
    function mintBaby(address to, bool _isGenesis) public {
        require(msg.sender == gorillaBreeder, "Not Authorized");
        isGenesis[totalSupply] = _isGenesis;
        _mint(to, totalSupply);
    }

    /// @notice Returns the token URI of a specific gorilla baby.
    /// @param tokenId The token ID of the requested gorilla baby.
    /// @return The full URI of the requested gorilla baby.
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
                : "";
    }


    function supportsInterface(bytes4 interfaceId) public pure override(ERC721, Ownable) returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f || // ERC165 Interface ID for ERC721Metadata
            interfaceId == 0x7f5828d0;   // ERC165 Interface ID for ERC173
    }
}
