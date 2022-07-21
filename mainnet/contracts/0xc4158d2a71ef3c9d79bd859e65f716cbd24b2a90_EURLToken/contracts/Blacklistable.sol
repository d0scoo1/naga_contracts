/**
 * SPDX-License-Identifier: MIT
 *
 * Copyright (c) 2020-2021 SCEME SAS
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/**
 * @title Blacklistable Token
 * @dev Allows accounts to be blacklisted by a "blacklister" role
 */
contract Blacklistable is OwnableUpgradeable {
    address public blacklister;
    mapping(address => bool) internal blacklisted;

    event Blacklisted(address indexed _account);
    event UnBlacklisted(address indexed _account);
    event BlacklisterChanged(address indexed newBlacklister);

    /**
     * @dev Throws if called by any account other than the blacklister
     */
    modifier onlyBlacklister() {
        require(
            msg.sender == blacklister,
            "Blacklistable: caller is not the blacklister"
        );
        _;
    }

    /**
     * @dev Throws if argument account is blacklisted
     * @param account The address to check
     */
    modifier notBlacklisted(address account) {
        require(
            !blacklisted[account],
            "Blacklistable: account is blacklisted"
        );
        _;
    }

    /**
     * @dev Checks if account is blacklisted
     * @param account The address to check
     */
    function isBlacklisted(address account) external view returns (bool) {
        return blacklisted[account];
    }

    /**
     * @dev Adds account to blacklist
     * @param account The address to blacklist
     */
    function blacklist(address account) external onlyBlacklister {
        blacklisted[account] = true;
        emit Blacklisted(account);
    }

    /**
     * @dev Removes account from blacklist
     * @param account The address to remove from the blacklist
     */
    function unBlacklist(address account) external onlyBlacklister {
        blacklisted[account] = false;
        emit UnBlacklisted(account);
    }

    function updateBlacklister(address newBlacklister) internal {
        require(
            newBlacklister != address(0),
            "Blacklistable: new blacklister is the zero address"
        );
        blacklister = newBlacklister;
        emit BlacklisterChanged(blacklister);
    }
}
