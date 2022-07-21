// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;
interface IERC20 {
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function decimals()
        external
        view
        returns (uint8);
}