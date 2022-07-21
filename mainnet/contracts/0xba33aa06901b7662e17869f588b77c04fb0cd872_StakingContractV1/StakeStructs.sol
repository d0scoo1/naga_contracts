// SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.11;

/// GENERAL STAKING DATA
///     └─ StakingOpsInfo
/// STAKER
///     └─ StakeInfo

contract StakeStructs {

    enum StakeStatus { NeverStaked, Deposited, Unstaked, Withdrawn }

    /// General Staking Info & Parameters
    struct StakingOpsInfo {
        uint256 stakeCount;             // Total number of stakers, activated and not activated
        uint256 totalStaked;            // The total amount of POWR tokens staked regardless of the status
        uint256 minPowrDeposit;         // The min amount of POWR tokens required for staking
        uint256 maxPowrPerValidator;     // The max amount of POWR to be delegated to each validator
        uint256 powrRatio;              // From 0 to 100000, respresenting a mulplier of 0.00% - 1000.00%
        address powrEthPool;            // address of the uniswap v2 POWR-ETH pool
        uint256 unlockGasCost;         // gas price of unlock transaction
        address rewardWallet;          // wallet POWR rewards are paid from
    }

    /// Stake information. Per Staker.
    struct StakeInfo {
        uint256 stake;                              // The amount of POWR tokens staked
        uint256 stakeRewards;                       // Amount of POWR tokens rewards
        string registeredStaker;                   // Address of the wallet used for staking
        string registeredStakerValidatorPubKey;    // The public key of the PLChain Node to delegate to
        StakeStatus stakeStatus;                     // Enum storing status of stake Stake
        uint256 ethFee;                                   // eth fee charged to subsidize unlock stake tx
        uint256 unstakeTimestamp;                    //timestamp for storing when the user requested an unstake
    }
}
