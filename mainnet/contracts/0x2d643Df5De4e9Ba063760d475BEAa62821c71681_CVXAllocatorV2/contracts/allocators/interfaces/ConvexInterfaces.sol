// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

interface IConvex {
    function deposit(
        uint256 _pid,
        uint256 _amount,
        bool _stake
    ) external returns (bool);

    function depositAll(uint256 _pid, bool _stake) external returns (bool);

    function poolInfo(uint256)
        external
        view
        returns (
            address,
            address,
            address,
            address,
            address,
            bool
        );
}

interface IDelegation {
    function setDelegate(bytes32 _id, address _delegate) external;
}

interface IConvexRewards {
    function withdrawAndUnwrap(uint256 _amount, bool _claim) external returns (bool);

    function withdrawAllAndUnwrap(bool claim) external;

    function getReward() external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function earned(address _account) external view returns (uint256);

    function extraRewards(uint256) external view returns (address);

    function extraRewardsLength() external view returns (uint256);
}

interface IConvexVirtualBalanceRewards {
    function getReward() external returns (bool);

    function earned(address _account) external view returns (uint256);
}
