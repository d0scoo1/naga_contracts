// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TokenSaleContract.sol";
// creates a Token Sale called Pre-Sale and initalizes the variables 
contract VSale is TokenSaleContract {
    constructor(
        uint256 _startUnixTime,
        uint256 _saleAmount,
        address _gpo,
        address payable _fundWallet,
        address _ethUsdAggregator
    )
        TokenSaleContract("VSale", _startUnixTime, _saleAmount, _gpo, _fundWallet, 25, _ethUsdAggregator)
    {
    }
}