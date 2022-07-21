//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "../interfaces/IPermissionedMinter.sol";
import "../interfaces/IJanusRegistry.sol";
import "../interfaces/IMintingManager.sol";
import "../interfaces/IBank.sol";
import "../service/Service.sol";

/// @dev a contract which is permissioned to mint of the multitoken
contract PermissionedMinter is Service, IPermissionedMinter {


  function _initialize(address serviceRegistry) internal {
    //
  }

  function _getMintingManager() internal view returns (address manager) {
    manager = IJanusRegistry(_serviceRegistry).get("GemPool", "MintingManager");
  }

  function mint(address receiver, uint256 collectionId, uint256 id, uint256 amount) external override {
      address manager = _getMintingManager();
      IMintingManager(manager).mint(receiver, collectionId, id, amount);
  }

  function burn(address target, uint256 id, uint256 amount) external virtual override {
      address manager = _getMintingManager();
      IMintingManager(manager).burn(target, id, amount);
  }

  function minter(address _minter) external view override returns (ITokenMinter.Minter memory __minter) {
    address manager = _getMintingManager();
    return IMintingManager(manager).minter(_minter);
  }

  function depositTokens(uint256 amount) external payable override {
    address manager = _getMintingManager();
    IMintingManager(manager).depositTokens{value: amount}(amount);
  }

  function minterBalance() external view override returns (uint256) {
    address manager = _getMintingManager();
    return IBank(manager).balance(address(this), 0);
  }

}
