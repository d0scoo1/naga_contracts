//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ICurvePoolPricable.sol';

interface ICurvePool2 is ICurvePoolPricable {
    function add_liquidity(
        uint256[2] memory amounts,
        uint256 minMintAmount
    ) external returns (uint256);

    function remove_liquidity(
        uint256 burnAmount,
        uint256[2] memory minAmounts
    ) external returns (uint256[2] memory);

    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 input,
        uint256 minOutput
    ) external returns (uint256);

    function calc_token_amount(
        uint256[2] memory amounts,
        bool isDeposit
    ) external view returns (uint256);
}
