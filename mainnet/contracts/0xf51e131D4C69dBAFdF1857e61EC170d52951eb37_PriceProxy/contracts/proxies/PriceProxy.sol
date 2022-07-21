pragma solidity 0.7.3;

import "@openzeppelin/contracts/proxy/TransparentUpgradeableProxy.sol";

contract PriceProxy is TransparentUpgradeableProxy {
    constructor(address _logic, address _proxyAdmin) public TransparentUpgradeableProxy(_logic, _proxyAdmin, "") {}
}
