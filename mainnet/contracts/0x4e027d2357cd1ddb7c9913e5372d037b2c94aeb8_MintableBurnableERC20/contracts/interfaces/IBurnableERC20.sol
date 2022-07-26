//
// Made by: Omicron Blockchain Solutions
//          https://omicronblockchain.com
//



// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @notice ERC20-compliant interface with added
 *         function for burning tokens from addresses
 *
 * See {IERC20}
 */
interface IBurnableERC20 is IERC20 {
  /**
   * @dev Allows burning tokens from an address
   *
   * @dev Should have restricted access
   */
  function burn(address _from, uint256 _amount) external;
}
