/*
 * Copyright (c) 2022, Circle Internet Financial Trading Company Limited.
 * All rights reserved.
 *
 * Circle Internet Financial Trading Company Limited CONFIDENTIAL
 *
 * This file includes unpublished proprietary source code of Circle Internet
 * Financial Trading Company Limited, Inc. The copyright notice above does not
 * evidence any actual or intended publication of such source code. Disclosure
 * of this source code or any related proprietary information is strictly
 * prohibited without the express written permission of Circle Internet Financial
 * Trading Company Limited.
 */

pragma solidity 0.6.12;

import { Ownable } from "../../v1/Ownable.sol";
import { FiatTokenV2_1 } from "../FiatTokenV2_1.sol";
import { FiatTokenV2_2 } from "../FiatTokenV2_2.sol";
import { FiatTokenProxy } from "../../v1/FiatTokenProxy.sol";
import { V2_2UpgraderHelper } from "./V2_2UpgraderHelper.sol";

/**
 * @title V2.2 Upgrader
 */
contract V2_2Upgrader is Ownable {

    FiatTokenProxy private _proxy;
    FiatTokenV2_1 private _implementation;
    FiatTokenV2_2 private _tempImplementation;
    address private _newProxyAdmin;
    string private _name;
    string private _symbol;
    string private _currency;
    V2_2UpgraderHelper private _helper;

    /**
     * @notice Constructor
     * @param proxy               FiatTokenProxy contract
     * @param tempImplementation  FiatTokenV2_2 implementation contract
     * @param newProxyAdmin       Grantee of proxy admin role after upgrade
     * @param name                the name
     * @param symbol              the symbol
     * @param currency            the currency
     */
    constructor(
        FiatTokenProxy proxy,
        FiatTokenV2_2 tempImplementation,
        address newProxyAdmin,
        string memory name,
        string memory symbol,
        string memory currency
    ) public Ownable() {
        _proxy = proxy;
        _implementation = FiatTokenV2_1(proxy.implementation());
        _tempImplementation = tempImplementation;
        _newProxyAdmin = newProxyAdmin;
        _name = name;
        _symbol = symbol;
        _currency = currency;
        _helper = new V2_2UpgraderHelper(address(proxy));
    }

    function helper() external view returns (address) {
        return address(_helper);
    }

    function proxy() external view returns (address) {
        return address(_proxy);
    }

    function implementation() external view returns (address) {
        return address(_implementation);
    }

    function tempImplementation() external view returns (address) {
        return address(_tempImplementation);
    }

    function newProxyAdmin() external view returns (address) {
        return _newProxyAdmin;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function currency() external view returns (string memory) {
        return _currency;
    }

    /**
     * @notice Upgrade, transfer proxy admin role to a given address.
     */
    function upgrade() external onlyOwner {
        // Keep original contract metadata
        uint8 decimals = _helper.decimals();
        address masterMinter = _helper.masterMinter();
        address owner = _helper.fiatTokenOwner();
        address pauser = _helper.pauser();
        address blacklister = _helper.blacklister();

        // Change implementation contract address
        _proxy.upgradeTo(address(_tempImplementation));

        // The helper needs to be used to read contract state because
        // AdminUpgradeabilityProxy does not allow the proxy admin to make
        // proxy calls.
        _helper.updateNameSymbolCurrency(_name, _symbol, _currency);

        // Change implementation contract address
        _proxy.upgradeTo(address(_implementation));

        // Transfer proxy admin role
        _proxy.changeAdmin(_newProxyAdmin);

        require(
            keccak256(bytes(_name)) == keccak256(bytes(_helper.name())) &&
            keccak256(bytes(_symbol)) == keccak256(bytes(_helper.symbol())) &&
            keccak256(bytes(_currency)) == keccak256(bytes(_helper.currency())),
            "V2_2Upgrader: name, symbol, currency update failed"
        );

        FiatTokenV2_1 v2_1 = FiatTokenV2_1(address(_proxy));

        // Sanity test
        // Check metadata
        require(
            decimals == v2_1.decimals() &&
            masterMinter == v2_1.masterMinter() &&
            owner == v2_1.owner() &&
            pauser == v2_1.pauser() &&
            blacklister == v2_1.blacklister(),
            "V2_2Upgrader: metadata test failed"
        );

        // Tear down
        _helper.tearDown();
        selfdestruct(msg.sender);
    }

    /**
     * @notice Transfer proxy admin role to newProxyAdmin, and self-destruct
     */
    function abortUpgrade() external onlyOwner {
        // Transfer proxy admin role
        _proxy.changeAdmin(_newProxyAdmin);

        // Tear down
        _helper.tearDown();
        selfdestruct(msg.sender);
    }
}
