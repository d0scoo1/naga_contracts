// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.7.6;

import '@openzeppelin/contracts/proxy/TransparentUpgradeableProxy.sol';

contract MirrorPoolFactoryProxy is TransparentUpgradeableProxy {
  constructor(address _logic, address _proxyAdmin)
    public
    TransparentUpgradeableProxy(_logic, _proxyAdmin, '')
  {}
}
