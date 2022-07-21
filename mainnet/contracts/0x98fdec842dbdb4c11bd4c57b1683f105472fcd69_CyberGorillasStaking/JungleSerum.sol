// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ERC1155.sol";
import "./Ownable.sol";
import "./Strings.sol";
import "./CyberGorillas.sol";
import "./CyberGorillaBabies.sol";
import "./CyberGorillasStaking.sol";
import "./GrillaToken.sol";

/*
   ______      __              ______           _ ____          
  / ____/_  __/ /_  ___  _____/ ____/___  _____(_) / /___ ______
 / /   / / / / __ \/ _ \/ ___/ / __/ __ \/ ___/ / / / __ `/ ___/
/ /___/ /_/ / /_/ /  __/ /  / /_/ / /_/ / /  / / / / /_/ (__  ) 
\____/\__, /_.___/\___/_/   \____/\____/_/  /_/_/_/\__,_/____/  
     /____/                                                     
*/

/// @title Jungle Serum
/// @author delta devs (https://twitter.com/deltadevelopers)
/// @dev Inspired by BoredApeChemistryClub.sol (https://etherscan.io/address/0x22c36bfdcef207f9c0cc941936eff94d4246d14a)
abstract contract JungleSerum is ERC1155, Ownable {
    using Strings for uint256;
    /*///////////////////////////////////////////////////////////////
                            EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted by `breed` function.
    /// @dev Event logging when breeding occurs.
    /// @param firstGorilla First Cyber Gorilla parent used for breeding.
    /// @param secondGorilla Second Cyber Gorilla parent used for breeding.
    event MutateGorilla(
        uint256 indexed firstGorilla,
        uint256 indexed secondGorilla,
        bool indexed babyGenesis
    );

    /*///////////////////////////////////////////////////////////////
                        METADATA STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice Keeps track of which gorilla adults have the genesis trait.
    mapping(uint256 => bool) private genesisTokens;

    /// @notice String pointing to Jungle Serum URI.
    string serumURI;
    /// @notice Set name as Jungle Serum.
    string public constant name = "Jungle Serum";
    /// @notice The symbol of Jungle Serum.
    string public constant symbol = "JS";

    /*///////////////////////////////////////////////////////////////
                            STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice The price of a Jungle Serum.
    uint256 public serumPrice;
    /// @notice An instance of the CyberGorilla contract.
    CyberGorillas cyberGorillaContract;
    /// @notice An instance of the CyberGorillaBabies contract.
    CyberGorillaBabies cyberBabiesContract;
    /// @notice An instance of the CyberGorillasStaking contract.
    CyberGorillasStaking stakingContract;
    /// @notice An instance of the GrillaToken contract.
    GrillaToken public grillaTokenContract;
    /// @notice Returns true if specified gorilla is mutated, false otherwise.
    mapping(uint256 => bool) mutatedGorillas;

    /*///////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        string memory _serumURI,
        uint256 _serumPrice,
        address _cyberGorillaContract,
        address _cyberBabiesContract,
        address _stakingContract
    ) {
        serumURI = _serumURI;
        serumPrice = _serumPrice;
        cyberGorillaContract = CyberGorillas(_cyberGorillaContract);
        cyberBabiesContract = CyberGorillaBabies(_cyberBabiesContract);
        stakingContract = CyberGorillasStaking(_stakingContract);
    }

    /*///////////////////////////////////////////////////////////////
                        STORAGE SETTERS
    //////////////////////////////////////////////////////////////*/

    /// @notice Set the URI pointing to Jungle Serum metadata.
    /// @param _serumURI the target URI.
    function setSerumURI(string memory _serumURI) public onlyOwner {
        serumURI = _serumURI;
    }

    /// @notice Set the price for a Jungle Serum.
    /// @param _serumPrice the price to set it to.
    function setSerumPrice(uint256 _serumPrice) public onlyOwner {
        serumPrice = _serumPrice;
    }

    /// @notice Sets the address of the GrillaToken contract.
    /// @param _grillaTokenContract The address of the GrillaToken contract.
    function setGrillaTokenContract(address _grillaTokenContract)
        public
        onlyOwner
    {
        grillaTokenContract = GrillaToken(_grillaTokenContract);
    }

    /// @notice Sets the address of the CyberGorilla contract.
    /// @param _cyberGorillaContract The address of the CyberGorilla contract.
    function setCyberGorillaContract(address _cyberGorillaContract)
        public
        onlyOwner
    {
        cyberGorillaContract = CyberGorillas(_cyberGorillaContract);
    }

    /// @notice Sets the address of the CyberGorillaBabies contract.
    /// @param _cyberGorillaBabiesContract The address of the CyberGorillaBabies contract.
    function setCyberBabiesContract(address _cyberGorillaBabiesContract)
        public
        onlyOwner
    {
        cyberBabiesContract = CyberGorillaBabies(_cyberGorillaBabiesContract);
    }

    /// @notice Sets the address of the CyberGorillasStaking contract.
    /// @param _stakingContract The address of the GrillaToken contract.
    function setStakingContract(address _stakingContract) public onlyOwner {
        stakingContract = CyberGorillasStaking(_stakingContract);
    }

    /*///////////////////////////////////////////////////////////////
                            ADMIN LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Allows the contract deployer to withdraw the GRILLA held by this contract to a specified address.
    /// @param receiver The address which receives the funds.
    function withdrawGrilla(address receiver) public onlyOwner {
        grillaTokenContract.transfer(
            receiver,
            grillaTokenContract.balanceOf(address(this))
        );
    }

    /// @notice Allows the contract deployer to specify which adult gorillas are to be considered of type genesis.
    /// @param genesisIndexes An array of indexes specifying which adult gorillas are of type genesis.
    function uploadGenesisArray(uint256[] memory genesisIndexes)
        public
        onlyOwner
    {
        for (uint256 i = 0; i < genesisIndexes.length; i++) {
            genesisTokens[genesisIndexes[i]] = true;
        }
    }

    /*///////////////////////////////////////////////////////////////
                        METADATA LOGIC
    //////////////////////////////////////////////////////////////*/

    function uri(uint256 id) public view override returns (string memory) {
        return
            bytes(serumURI).length > 0
                ? string(abi.encodePacked(serumURI, id.toString(), ".json"))
                : "";
    }

    /*///////////////////////////////////////////////////////////////
                            MINTING LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Allows the GrillaToken contract to mint a Jungle Serum for a specified address.
    /// @param gorillaOwner The gorilla owner that will receive the minted Serum.
    function mint(address gorillaOwner) public {
        require(msg.sender == address(grillaTokenContract), "Not authorized");
        _mint(gorillaOwner, 1, 1, "");
    }

    /*///////////////////////////////////////////////////////////////
                            BREEDING LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Allows a gorilla holder to breed a baby gorilla.
    /// @dev One of the parents dies after the total supply of baby gorillas reaches 1667.
    /// @param firstGorilla The tokenID of the first parent used for breeding.
    /// @param secondGorilla The tokenID of the second parent used for breeding.
    function breed(uint256 firstGorilla, uint256 secondGorilla) public virtual;

    /// @notice Psuedorandom number to determine which parent dies during breeding.
    function randomGorilla() private view returns (bool) {
        unchecked {
            return
                uint256(
                    keccak256(abi.encodePacked(block.timestamp, block.number))
                ) %
                    2 ==
                0;
        }
    }


    function supportsInterface(bytes4 interfaceId) public pure override(ERC1155, Ownable) returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
            interfaceId == 0x0e89341c || // ERC165 Interface ID for ERC1155MetadataURI
            interfaceId == 0x7f5828d0;   // ERC165 Interface ID for ERC173
    }
}
