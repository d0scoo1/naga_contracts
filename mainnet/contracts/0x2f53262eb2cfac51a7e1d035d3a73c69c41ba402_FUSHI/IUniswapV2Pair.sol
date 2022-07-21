// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

interface IUniswapV2Pair {
    function updateTotalFee(uint totalFee) external returns (bool);
    function setBaseToken(address _baseToken) external;
}