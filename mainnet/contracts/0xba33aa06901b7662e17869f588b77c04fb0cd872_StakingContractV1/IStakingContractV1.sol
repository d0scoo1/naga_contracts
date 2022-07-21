// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;


interface IStakingContractV1 {

    event StakeDeposited(
        address indexed staker,
        uint256 amount,
        string stakerPubKey,
        string validatorPubKey);

    event UnlockStake(
        address indexed staker,
        uint256 amount,
        string validatorPubKey);

    event ForceUnlockStake(
        address indexed staker,
        uint256 amount,
        string validatorPubKey);

    event StakeWithdrawn(
        address indexed staker,
        uint256 stake,
        uint256 rewards);

    function deposit(
        uint256 _amount, 
        string memory _stakerPubKey,
        string memory _validatorPubKey)
            external;

    function unlockStake(
        string memory _stakerPubKey, 
        uint256 _rewardAmount)
            external;

    function forceUnlockStake(
        string memory _stakerPubKey, 
        uint256 _rewardAmount)
            external;

    function withdraw()
            external;

    function getStatus(
        address _stakerEthAddress)
            external
            returns(uint currentStatus);

    function setRatio(
        uint256 _newRatio)
        external;

    function getRatio()
        external
        view
        returns (uint256 newRatio);

    function changeMinDeposit(
        uint256 _newAmount)
        external;

    function changeUnlockGasCost(
        uint256 _newGasCost)
        external;

    function changeRewardWallet(
        address _newRewardWallet)
        external;

    function pause()
        external;

    function unPause()
        external;
}
