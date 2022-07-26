/**
 * Copyright 2017-2022, OokiDao. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0.
 */

pragma solidity >=0.5.0 <=0.8.4;
pragma experimental ABIEncoderV2;

interface IMasterChefSushi2 {

    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt;
    }

    function deposit(uint256 _pid, uint256 _amount, address to)
        external;

    function withdraw(uint256 _pid, uint256 _amount,  address to)
        external;

    function withdrawAndHarvest(uint256 pid, uint256 amount, address to)
        external;

    // Info of each user that stakes LP tokens.
    function userInfo(uint256, address)
        external
        view
        returns (UserInfo memory);


    function pendingSushi(uint256 _pid, address _user)
        external
        view
        returns (uint256);

    function harvest(uint256 pid, address to)
        external;

    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate)
        external;

    function updatePool(uint256 _pid)
        external;

    function owner()
        external
        view
        returns (address);
}