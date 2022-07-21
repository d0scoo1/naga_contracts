// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../Dependencies/IERC20.sol";

interface IBurnableERC20 is IERC20 {
    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;
}
