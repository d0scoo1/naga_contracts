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

import { FiatTokenV2_2 } from "../../v2/FiatTokenV2_2.sol";
import { Ownable } from "../../v1/Ownable.sol";

/**
 * @title V2_2 Upgrader Helper
 * @dev Enables V2_2Upgrader to read some contract state before it renounces the
 * proxy admin role. (Proxy admins cannot call delegated methods.).
 */
contract V2_2UpgraderHelper is Ownable {
    address private _proxy;

    /**
     * @notice Constructor
     * @param fiatTokenProxy    Address of the FiatTokenProxy contract
     */
    constructor(address fiatTokenProxy) public Ownable() {
        _proxy = fiatTokenProxy;
    }

    /**
     * @notice The address of the FiatTokenProxy contract
     * @return Contract address
     */
    function proxy() external view returns (address) {
        return address(_proxy);
    }

    /**
     * @notice Call name()
     * @return name
     */
    function name() external view returns (string memory) {
        return FiatTokenV2_2(_proxy).name();
    }

    /**
     * @notice Call symbol()
     * @return symbol
     */
    function symbol() external view returns (string memory) {
        return FiatTokenV2_2(_proxy).symbol();
    }

    /**
     * @notice Call currency()
     * @return symbol
     */
    function currency() external view returns (string memory) {
        return FiatTokenV2_2(_proxy).currency();
    }

    /**
     * @notice Call decimals()
     * @return decimals
     */
    function decimals() external view returns (uint8) {
        return FiatTokenV2_2(_proxy).decimals();
    }

    /**
     * @notice Call masterMinter()
     * @return masterMinter
     */
    function masterMinter() external view returns (address) {
        return FiatTokenV2_2(_proxy).masterMinter();
    }

    /**
     * @notice Call owner()
     * @dev Renamed to fiatTokenOwner due to the existence of Ownable.owner()
     * @return owner
     */
    function fiatTokenOwner() external view returns (address) {
        return FiatTokenV2_2(_proxy).owner();
    }

    /**
     * @notice Call pauser()
     * @return pauser
     */
    function pauser() external view returns (address) {
        return FiatTokenV2_2(_proxy).pauser();
    }

    /**
     * @notice Call blacklister()
     * @return blacklister
     */
    function blacklister() external view returns (address) {
        return FiatTokenV2_2(_proxy).blacklister();
    }

    function updateNameSymbolCurrency(
        string memory name,
        string memory symbol,
        string memory currency
    ) external {
        FiatTokenV2_2(_proxy).updateNameSymbolCurrency(name, symbol, currency);
    }

    /**
     * @notice Tear down the contract (self-destruct)
     */
    function tearDown() external onlyOwner {
        selfdestruct(msg.sender);
    }
}
