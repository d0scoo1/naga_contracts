// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

struct LibStorage {
    mapping(address => bool) dexAllowlist;
    address[] dexs;
}
