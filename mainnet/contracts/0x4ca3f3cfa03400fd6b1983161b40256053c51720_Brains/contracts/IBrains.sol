// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.12;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IBrains is IERC20 {
    function mint(address holder, uint256 amount) external;
    function burn(address holder, uint256 amount) external;
}