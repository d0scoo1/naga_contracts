// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

interface IUniswapV2Maker {
    function bakeDegen(address lpTaxReceiver, uint8 lpSplit, bool createLp) external returns (bool);
}