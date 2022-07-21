// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/*
   ______      __              ______           _ ____          
  / ____/_  __/ /_  ___  _____/ ____/___  _____(_) / /___ ______
 / /   / / / / __ \/ _ \/ ___/ / __/ __ \/ ___/ / / / __ `/ ___/
/ /___/ /_/ / /_/ /  __/ /  / /_/ / /_/ / /  / / / / /_/ (__  ) 
\____/\__, /_.___/\___/_/   \____/\____/_/  /_/_/_/\__,_/____/  
     /____/                                                     

*/

/// @title Reward Boost Provider
/// @author delta devs (https://twitter.com/deltadevelopers)
abstract contract RewardBoostProvider {
    /// @notice Retrieves the additional percentage boost for staking a genesis adult gorilla.
    /// @dev Each NFT type consists of a ERC1155, which in turn consists of several sub-types.
    /// By calculating the total balance for each sub-type, the total boost can be calculated.
    /// @param account The address of the account to which the boost is eligible.
    /// @return Returns the total boost.
    function getPercentBoostAdultGenesis(address account)
        public
        view
        virtual
        returns (uint256)
    {
        return 0;
    }

    /// @notice Retrieves the additional percentage boost for staking a normal adult gorilla.
    /// @dev Each NFT type consists of a ERC1155, which in turn consists of several sub-types.
    /// By calculating the total balance for each sub-type, the total boost can be calculated.
    /// @param account The address of the account to which the boost is eligible.
    /// @return Returns the total boost.
    function getPercentBoostAdultNormal(address account)
        public
        view
        virtual
        returns (uint256)
    {
        return 0;
    }

    /// @notice Retrieves the additional percentage boost for staking a genesis baby gorilla.
    /// @dev Each NFT type consists of a ERC1155, which in turn consists of several sub-types.
    /// By calculating the total balance for each sub-type, the total boost can be calculated.
    /// @param account The address of the account to which the boost is eligible.
    /// @return Returns the total boost.
    function getPercentBoostBabyGenesis(address account)
        public
        view
        virtual
        returns (uint256)
    {
        return 0;
    }

    /// @notice Retrieves the additional percentage boost for staking a normal baby gorilla.
    /// @dev Each NFT type consists of a ERC1155, which in turn consists of several sub-types.
    /// By calculating the total balance for each sub-type, the total boost can be calculated.
    /// @param account The address of the account to which the boost is eligible.
    /// @return Returns the total boost.
    function getPercentBoostBabyNormal(address account)
        public
        view
        virtual
        returns (uint256)
    {
        return 0;
    }
}
