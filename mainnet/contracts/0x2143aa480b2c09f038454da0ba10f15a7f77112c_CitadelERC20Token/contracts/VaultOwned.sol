// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import { Ownable } from "./Ownable.sol";

contract VaultOwned is Ownable {
    
  address internal _vault;

  function setVault( address vault_ ) public onlyOwner() returns ( bool ) {
    _vault = vault_;

    return true;
  }

  function vault() public view returns (address) {
    return _vault;
  }

  modifier onlyVault() {
    require( _vault == msg.sender, "VaultOwned: caller is not the Vault" );
    _;
  }

}