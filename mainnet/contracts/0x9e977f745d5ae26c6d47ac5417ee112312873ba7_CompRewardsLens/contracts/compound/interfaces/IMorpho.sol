// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

import "./IInterestRatesManager.sol";
import "./IRewardsManager.sol";
import "./IPositionsManager.sol";
import "./IIncentivesVault.sol";

import "../libraries/Types.sol";

// prettier-ignore
interface IMorpho {

    /// STORAGE ///

    function defaultMaxGasForMatching() external view returns (Types.MaxGasForMatching memory);
    function maxSortedUsers() external view returns (uint256);
    function dustThreshold() external view returns (uint256);
    function supplyBalanceInOf(address, address) external view returns (Types.SupplyBalance memory);
    function borrowBalanceInOf(address, address) external view returns (Types.BorrowBalance memory);
    function enteredMarkets(address) external view returns (address);
    function deltas(address) external view returns (Types.Delta memory);
    function marketsCreated() external view returns (address[] memory);
    function marketParameters(address) external view returns (Types.MarketParameters memory);
    function p2pDisabled(address) external view returns (bool);
    function p2pSupplyIndex(address) external view returns (uint256);
    function p2pBorrowIndex(address) external view returns (uint256);
    function lastPoolIndexes(address) external view returns (Types.LastPoolIndexes memory);
    function marketStatus(address) external view returns (Types.MarketStatus memory);
    function comptroller() external view returns (IComptroller);
    function interestRatesManager() external view returns (IInterestRatesManager);
    function rewardsManager() external view returns (IRewardsManager);
    function positionsManager() external view returns (IPositionsManager);
    function incentiveVault() external view returns (IIncentivesVault);
    function treasuryVault() external view returns (address);
    function cEth() external view returns (address);
    function wEth() external view returns (address);

    /// GETTERS ///

    function updateP2PIndexes(address _poolTokenAddress) external;
    function getEnteredMarkets(address _user) external view returns (address[] memory enteredMarkets_);
    function getAllMarkets() external view returns (address[] memory marketsCreated_);
    function getHead(address _poolTokenAddress, Types.PositionType _positionType) external view returns (address head);
    function getNext(address _poolTokenAddress, Types.PositionType _positionType, address _user) external view returns (address next);

    /// GOVERNANCE ///

    function setMaxSortedUsers(uint256 _newMaxSortedUsers) external;
    function setDefaultMaxGasForMatching(Types.MaxGasForMatching memory _maxGasForMatching) external;
    function setTreasuryVault(address _newTreasuryVaultAddress) external;
    function setIncentivesVault(address _newIncentivesVault) external;
    function setRewardsManager(address _rewardsManagerAddress) external;
    function setDustThreshold(uint256 _dustThreshold) external;
    function setP2PDisable(address _poolTokenAddress, bool _p2pDisabled) external;
    function setReserveFactor(address _poolTokenAddress, uint256 _newReserveFactor) external;
    function setP2PIndexCursor(address _poolTokenAddress, uint16 _p2pIndexCursor) external;
    function setPauseStatus(address _poolTokenAddress) external;
    function setPartialPauseStatus(address _poolTokenAddress) external;
    function claimToTreasury(address _poolTokenAddress, uint256 _amount) external;
    function createMarket(address _poolTokenAddress, Types.MarketParameters calldata _params) external;

    /// USERS ///

    function supply(address _poolTokenAddress, address _onBehalf, uint256 _amount) external;
    function supply(address _poolTokenAddress, address _onBehalf, uint256 _amount, uint256 _maxGasForMatching) external;
    function borrow(address _poolTokenAddress, uint256 _amount) external;
    function borrow(address _poolTokenAddress, uint256 _amount, uint256 _maxGasForMatching) external;
    function withdraw(address _poolTokenAddress, uint256 _amount) external;
    function repay(address _poolTokenAddress, address _onBehalf, uint256 _amount) external;
    function liquidate(address _poolTokenBorrowedAddress, address _poolTokenCollateralAddress, address _borrower, uint256 _amount) external;
    function claimRewards(address[] calldata _cTokenAddresses, bool _tradeForMorphoToken) external;
}
