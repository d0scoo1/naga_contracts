// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/TokenTimelock.sol";

contract TimeLock is TokenTimelock {
    constructor()
        TokenTimelock(
            IERC20(0xFAd4fbc137B9C270AE2964D03b6d244D105e05A6),
            0x9906fE1E18a4d91b9C04B8ac3Fe64de86E4D77dB,
            1693353599
        )
    {}
}
