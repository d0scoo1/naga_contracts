// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/TokenTimelock.sol";

contract TimeLock is TokenTimelock {
    constructor()
        TokenTimelock(
            IERC20(0xFAd4fbc137B9C270AE2964D03b6d244D105e05A6),
            0x17e0Ee36Ea754CDcf972A1dc43DDD6935D8c1728,
            1688083199
        )
    {}
}
