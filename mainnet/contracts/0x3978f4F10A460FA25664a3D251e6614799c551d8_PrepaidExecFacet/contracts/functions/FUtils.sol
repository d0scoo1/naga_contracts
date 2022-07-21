// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {NATIVE_TOKEN} from "../constants/CTokens.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

function _getBalance(address token, address user) view returns (uint256) {
    if (token == address(0)) return 0;
    return token == NATIVE_TOKEN ? user.balance : IERC20(token).balanceOf(user);
}
