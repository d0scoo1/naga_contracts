// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity =0.8.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IcCRV is IERC20 {
    function mint(address to, uint amount) external;
}
