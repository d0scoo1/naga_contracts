// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./interfaces/IChainLinkOracle.sol";
import "./interfaces/IXToken.sol";

contract ibBtcOracleHelper is IChainLinkOracle {
    IChainLinkOracle constant public btcFeed = IChainLinkOracle(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c);
    IXToken constant public ibBTC = IXToken(0xc4E15973E6fF2A35cC804c2CF9D2a1b817a8b40F);

    function latestAnswer() external override view returns (uint256 answer) {
        uint256 btcPrice = btcFeed.latestAnswer();
        answer = btcPrice * ibBTC.pricePerShare() / 1e18;
    }
}