// SPDX-License-Identifier: MIT
pragma solidity =0.8.10;

import "./DSProxy.sol";

abstract contract DSProxyFactory {
    function build(address owner) public virtual returns (DSProxy proxy);
    function build() public virtual returns (DSProxy proxy);
    function isProxy(address proxy) public virtual view returns (bool);
}
