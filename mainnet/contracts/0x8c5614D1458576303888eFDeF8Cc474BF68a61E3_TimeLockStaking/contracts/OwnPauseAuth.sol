// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract OwnPauseAuth is Ownable, Pausable {
    mapping(address => bool) internal _authorizedAddressList;

    event RevokeAuthorized(address auth_);
    event GrantAuthorized(address auth_);

    modifier isAuthorized() {
        require(
            msg.sender == owner() || _authorizedAddressList[msg.sender] == true,
            "OwnPauseAuth: unauthorized"
        );
        _;
    }

    modifier isOwner() {
        require(msg.sender == owner(), "OwnPauseAuth: not owner");
        _;
    }

    function grantAuthorized(address auth_) external isOwner {
        require(auth_ != address(0), "OwnPauseAuth: invalid auth_ address ");

        _authorizedAddressList[auth_] = true;

        emit GrantAuthorized(auth_);
    }

    function revokeAuthorized(address auth_) external isOwner {
        require(auth_ != address(0), "OwnPauseAuth: invalid auth_ address ");

        _authorizedAddressList[auth_] = false;

        emit RevokeAuthorized(auth_);
    }

    function checkAuthorized(address auth_) public view returns (bool) {
        require(auth_ != address(0), "OwnPauseAuth: invalid auth_ address ");

        return auth_ == owner() || _authorizedAddressList[auth_] == true;
    }

    function pause() external isOwner {
        _pause();
    }

    function unpause() external isOwner {
        _unpause();
    }
}
