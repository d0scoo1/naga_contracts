// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import { TransparentUpgradeableProxy } from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import { DRIP } from "../token/DRIP.sol";

contract DRIPProxy is TransparentUpgradeableProxy {
  constructor() TransparentUpgradeableProxy(address(new DRIP()), address(0xEBfE0Fd21208DC2e1321ACeFeE93904Ba8AEf743), new bytes(0)) {}
}
    
