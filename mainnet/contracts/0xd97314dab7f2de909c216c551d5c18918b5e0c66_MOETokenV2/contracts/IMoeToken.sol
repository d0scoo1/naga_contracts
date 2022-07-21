// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <= 0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

interface IMoeToken is IERC20Upgradeable {
    function mint(address user, uint256 amount) external;
}