/*
 * This file is part of the artèQ Technologies contracts (https://github.com/arteq-tech/contracts).
 * Copyright (c) 2022 artèQ Technologies (https://arteq.tech)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
// SPDX-License-Identifier: GNU General Public License v3.0

pragma solidity 0.8.1;

/// @author Kam Amini <kam@arteq.io>
///
/// @notice Use at your own risk
abstract contract ETHVault {

    bool private _enableDeposit;

    event DepositEnabled();
    event DepositDisabled();
    event ETHTransferred(address to, uint256 amount);

    constructor() {
        _enableDeposit = false;
    }

    function _isDepositEnabled() internal view returns (bool) {
        return _enableDeposit;
    }

    function _setEnableDeposit(bool enableDeposit) internal {
        _enableDeposit = enableDeposit;
        if (_enableDeposit) {
            emit DepositEnabled();
        } else {
            emit DepositDisabled();
        }
    }

    function _ETHTransfer(
        address to,
        uint256 amount
    ) internal {
        require(to != address(0), "ETHVault: cannot transfer to zero");
        require(amount > 0, "ETHVault: amount is zero");
        require(amount <= address(this).balance, "ETHVault: transfer more than balance");

        (bool success, ) = to.call{value: amount}(new bytes(0));
        require(success, "ETHVault: failed to transfer");
        emit ETHTransferred(to, amount);
    }
}
