// SPDX-License-Identifier: MIT
pragma solidity ^0.5.8;

/**
 * @dev A standard for detecting smart contract interfaces.
 */
interface ERC165 {
  /**
   * @dev Checks if the smart contract includes a specific interface.
   * @notice This function uses less than 30,000 gas.
   * @param _interfaceID The interface identifier, as specified in ERC-165.
   */
  function supportsInterface(bytes4 _interfaceID) external view returns (bool);
}
