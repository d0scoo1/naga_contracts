//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

///
/// @notice interface for a collection of tokens. lists members of collection,
/// @notice allows for querying of collection members, and for minting and burning of tokens.
///
interface ICollection {

    /// @notice desscribes a containers basic information
    struct CollectionSettings {

        // the owner of the container contract
        address owner;

        // the owner of the container contract
        address serviceRegistry;

        // the address of the container contract
        address contractAddress;

        // the container hash
        uint256 id;

        // the container symbol
        string symbol;

        // the container name
        string name;

        // the container description
        string description;

        // the container total supply
        uint256 totalSupply;

    }

    /// @notice returns whether the given item is a member of the collection
    /// @param token the token hash
    /// @return _member true if the token is a member of the collection, false otherwise
    function isMemberOf(uint256 token) external view returns (bool _member);

    /// @notice returns all the tokens in the collection as an array
    /// @return _members the collection tokens
    function members() external view returns (uint256[] memory _members);

}
