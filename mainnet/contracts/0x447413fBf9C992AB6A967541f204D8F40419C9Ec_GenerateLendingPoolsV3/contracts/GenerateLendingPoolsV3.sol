// SPDX-License-Identifier: UNLICENSED
/* 

  _                          _   _____   _                       
 | |       ___   _ __     __| | |  ___| | |   __ _   _ __    ___ 
 | |      / _ \ | '_ \   / _` | | |_    | |  / _` | | '__|  / _ \
 | |___  |  __/ | | | | | (_| | |  _|   | | | (_| | | |    |  __/
 |_____|  \___| |_| |_|  \__,_| |_|     |_|  \__,_| |_|     \___|
                                                                 
LendFlare.finance
*/

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "./convex/IConvexBoosterV2.sol";
import "./supply/ISupplyBooster.sol";

interface ISupplyRewardFactory {
    function createReward(
        address _rewardToken,
        address _virtualBalance,
        address _owner
    ) external returns (address);
}

interface ILendingMarket {
    function addMarketPool(
        uint256 _convexBoosterPid,
        uint256[] calldata _supplyBoosterPids,
        int128[] calldata _curveCoinIds,
        uint256 _lendingThreshold,
        uint256 _liquidateThreshold
    ) external;
}

interface ISupplyRewardFactoryExtra is ISupplyRewardFactory {
    function addOwner(address _newOwner) external;
}

contract GenerateLendingPoolsV3 {
    address public convexBooster;
    address public lendingMarket;
    address public supplyBooster;
    address public supplyRewardFactory;
    address public deployer;

    constructor(address _deployer) public {
        deployer = _deployer;
    }

    function setLendingContract(
        address _supplyBooster,
        address _convexBooster,
        address _lendingMarket,
        address _supplyRewardFactory
    ) public {
        require(deployer == msg.sender, "!authorized auth");

        supplyBooster = _supplyBooster;
        convexBooster = _convexBooster;
        lendingMarket = _lendingMarket;
        supplyRewardFactory = _supplyRewardFactory;
    }

    function addConvexBoosterPool(uint256 _originConvexPid) public {
        require(deployer == msg.sender, "!authorized auth");

        require(supplyBooster != address(0), "!supplyBooster");
        require(convexBooster != address(0), "!convexBooster");
        require(lendingMarket != address(0), "!lendingMarket");
        require(supplyRewardFactory != address(0), "!supplyRewardFactory");

        IConvexBoosterV2(convexBooster).addConvexPool(_originConvexPid);
    }

    function addConvexBoosterPool(
        uint256 _originConvexPid,
        address _curveSwapAddress,
        address _curveZapAddress,
        address _basePoolAddress,
        bool _isMeta,
        bool _isMetaFactory
    ) public {
        require(deployer == msg.sender, "!authorized auth");

        require(supplyBooster != address(0), "!supplyBooster");
        require(convexBooster != address(0), "!convexBooster");
        require(lendingMarket != address(0), "!lendingMarket");
        require(supplyRewardFactory != address(0), "!supplyRewardFactory");

        IConvexBoosterV2(convexBooster).addConvexPool(
            _originConvexPid,
            _curveSwapAddress,
            _curveZapAddress,
            _basePoolAddress,
            _isMeta,
            _isMetaFactory
        );
    }

    function addLendingMarketPool(
        uint256 _convexBoosterPid,
        uint256[] calldata _supplyBoosterPids,
        int128[] calldata _curveCoinIds
    ) public {
        require(deployer == msg.sender, "!authorized auth");

        require(supplyBooster != address(0), "!supplyBooster");
        require(convexBooster != address(0), "!convexBooster");
        require(lendingMarket != address(0), "!lendingMarket");
        require(supplyRewardFactory != address(0), "!supplyRewardFactory");

        ILendingMarket(lendingMarket).addMarketPool(
            _convexBoosterPid,
            _supplyBoosterPids,
            _curveCoinIds,
            100,
            50
        );
    }

    function addSupplyPool(address _underlyToken, address _supplyTreasuryFund)
        public
    {
        _addSupplyPool(_underlyToken, _supplyTreasuryFund);
    }

    function _addSupplyPool(address _underlyToken, address _supplyTreasuryFund)
        internal
    {
        require(deployer == msg.sender, "!authorized auth");

        require(supplyBooster != address(0), "!supplyBooster");
        require(convexBooster != address(0), "!convexBooster");
        require(lendingMarket != address(0), "!lendingMarket");
        require(supplyRewardFactory != address(0), "!supplyRewardFactory");

        ISupplyRewardFactoryExtra(supplyRewardFactory).addOwner(
            _supplyTreasuryFund
        );

        ISupplyBooster(supplyBooster).addSupplyPool(
            _underlyToken,
            _supplyTreasuryFund
        );
    }
}
