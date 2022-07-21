// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../interfaces/IFactory.sol";

contract FactoryElement is IFactoryElement {

    address internal _factory;
    address internal _owner;

    modifier onlyFactory() {
        require(_factory == address(0) || _factory == msg.sender, "Only factory can call this function");
        _;
    }

    modifier onlyFactoryOwner() {
        require(_factory == address(0) ||_owner == msg.sender, "Only owner can call this function");
        _;
    }

    function factoryCreated(address factory_, address owner_) external override {
        require(_owner == address(0), "already created");
        _factory = factory_;
        _owner = owner_;
    }

    function factory() external view override returns(address) {
        return _factory;
    }

    function owner() external view override  returns(address) {
        return _owner;
    }

}
