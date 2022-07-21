// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

abstract contract IERC20Burnable is IERC20 {
    function burn(uint256 amount) public virtual;

    function burnFrom(address account, uint256 amount) public virtual;
}
