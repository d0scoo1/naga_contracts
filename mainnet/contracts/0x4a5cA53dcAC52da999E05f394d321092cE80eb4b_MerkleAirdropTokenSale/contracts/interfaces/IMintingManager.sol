// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../interfaces/ITokenMinter.sol";

/**
 * @notice This intreface provides a way for users to register addresses as permissioned minters, mint * burn, unregister, and reload the permissioned minter account.
 */
interface IMintingManager {

 function mint(address receiver, uint256 collectionId, uint256 id, uint256 amount) external;
 function burn(address target, uint256 id, uint256 amount) external;
 function minter(address _minter) external view returns (ITokenMinter.Minter memory __minter);
 function depositTokens(uint256 amount) external payable ;
 function makeHash(uint256 tokenId) external view returns (uint256);

}
