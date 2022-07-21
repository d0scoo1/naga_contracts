//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "../interfaces/ITokenMinter.sol";

/// @dev a contract which is permissioned to mint of the multitoken
interface IPermissionedMinter {

 function mint(address receiver, uint256 collectionId, uint256 id, uint256 amount) external;
 function burn(address target, uint256 id, uint256 amount) external;
 function depositTokens(uint256 amount) external payable;
 function minterBalance() external view returns (uint256);
 function minter(address _minter) external view returns (ITokenMinter.Minter memory __minter);

}
