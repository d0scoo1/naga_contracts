// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/// @author: @props

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

/**
 * @dev 
 */
interface IRoyalty is IERC165 {

    /**
    * @dev add share to royalty contract for address
    */
    function addShare(address _account) external;

    /**
    * @dev remove share from royalty contract for address
    */
    function removeShare(address _account) external;

     /**
    * @dev toggle shares to royalty contract for to/from addresses
    */
    function toggleShares(address from, address to) external;

}
