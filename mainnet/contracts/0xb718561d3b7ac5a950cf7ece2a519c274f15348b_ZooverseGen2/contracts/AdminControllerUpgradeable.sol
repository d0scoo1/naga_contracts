// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./IAdminController.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

abstract contract AdminControllerUpgradeable is IAdminController, Initializable, OwnableUpgradeable, PausableUpgradeable {
    mapping(address => bool) public _admins;

    function __AdminController__init() internal onlyInitializing {
        __Ownable_init();
        __Pausable_init();
    }

    function isAdmin(address to) public view returns (bool) {
        return _admins[to];
    }

    modifier adminOnly() {
        require(_admins[msg.sender] || msg.sender == owner(), "Not authorised");
        _;
    }

    function setPaused(bool value) public adminOnly {
        if(value) {
            _pause();
        } else {
            _unpause();
        }
    }

    function setAdmins(address to, bool value) public adminOnly {
        _admins[to] = value;
    }
}