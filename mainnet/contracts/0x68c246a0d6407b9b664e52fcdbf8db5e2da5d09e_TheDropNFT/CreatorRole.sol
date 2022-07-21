// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Context.sol";
import "./Roles.sol";

/**
 * @title CreatorRole
 * @dev Creators are responsible for administering other roles, or contracts
 */
contract CreatorRole is Context {
    using Roles for Roles.Role;

    event CreatorAdded(address indexed account);
    event CreatorRemoved(address indexed account);

    Roles.Role private _admins;

    constructor () {
        _addCreator(_msgSender());
    }

    modifier onlyCreator() {
        require(isCreator(_msgSender()), "CreatorRole: caller does not have the Creator role");
        _;
    }

    function isCreator(address account) public view returns (bool) {
        return _admins.has(account);
    }

    function addCreator(address account) public onlyCreator {
        _addCreator(account);
    }

    function renounceCreator() public {
        _removeCreator(_msgSender());
    }

    function _addCreator(address account) internal {
        _admins.add(account);
        emit CreatorAdded(account);
    }

    function _removeCreator(address account) internal {
        _admins.remove(account);
        emit CreatorRemoved(account);
    }
}