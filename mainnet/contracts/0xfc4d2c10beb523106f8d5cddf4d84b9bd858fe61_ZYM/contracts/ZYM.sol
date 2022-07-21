// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/utils/Multicall.sol";
import "./extensions/ERC1363.sol";

contract ZYM is
    ERC20("ZYM", "ZYM"),
    ERC20Permit("ZYM"),
    ERC1363,
    Multicall
{
    constructor(address initialHolder) {
        _mint(initialHolder, 100_000_000_000 ether);
    }
}
