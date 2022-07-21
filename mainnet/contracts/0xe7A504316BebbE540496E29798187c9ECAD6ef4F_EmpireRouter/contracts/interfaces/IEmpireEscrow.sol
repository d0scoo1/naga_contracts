// SPDX-License-Identifier: Unlicense

pragma solidity =0.6.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IEmpireEscrow {
    struct Escrow {
        uint256 amount;
        uint256 release;
    }

    function lockLiquidity(IERC20 token, address user, uint256 amount, uint256 duration) external;

    function releaseLiquidity(IERC20 token) external;
}