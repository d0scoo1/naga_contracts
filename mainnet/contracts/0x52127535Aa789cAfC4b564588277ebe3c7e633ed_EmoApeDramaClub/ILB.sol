// contracts/ICheeth.sol
// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0;

import "./IERC20.sol";


interface ILB is IERC20 {
    function burnFrom(address account, uint256 amount) external;
}