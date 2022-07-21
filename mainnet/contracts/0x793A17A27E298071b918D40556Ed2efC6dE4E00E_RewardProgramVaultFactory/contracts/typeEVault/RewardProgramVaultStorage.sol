//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;


import "../interfaces/IERC20Minimal.sol";
import "../interfaces/IUniswapV3Pool.sol";
import "../interfaces/IUniswapV3Staker.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract RewardProgramVaultStorage is ReentrancyGuard {

    struct IncentiveProgram {
        IUniswapV3Staker.IncentiveKey key;
        uint256 reward;
        bool end;
    }

    IERC20Minimal public token;  // project token

    IUniswapV3Pool public pool;
    IUniswapV3Staker public staker;

    mapping(uint256 => IncentiveProgram) public programs;
    uint256 public totalProgramCount;
    uint256 public startWaitTime;

    bool settingCheck;
}
