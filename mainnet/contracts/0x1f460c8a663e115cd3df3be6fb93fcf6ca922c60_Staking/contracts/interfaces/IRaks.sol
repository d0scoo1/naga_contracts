//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

interface IRaks is IERC20Upgradeable {
    function mint(address account, uint256 amount) external;
}
