// SPDX-License-Identifier: MIT
// solhint-disable max-states-count

pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;

import "../interfaces/IStaking.sol";
import "../interfaces/IManager.sol";
import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import {SafeMathUpgradeable as SafeMath} from "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import {MathUpgradeable as Math} from "@openzeppelin/contracts-upgradeable/math/MathUpgradeable.sol";
import {IERC20Upgradeable as IERC20} from "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import {SafeERC20Upgradeable as SafeERC20} from "@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";
import {OwnableUpgradeable as Ownable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {EnumerableSetUpgradeable as EnumerableSet} from "@openzeppelin/contracts-upgradeable/utils/EnumerableSetUpgradeable.sol";
import {PausableUpgradeable as Pausable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import {ReentrancyGuardUpgradeable as ReentrancyGuard} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "../interfaces/events/Destinations.sol";
import "../interfaces/events/BalanceUpdateEvent.sol";
import "../interfaces/IDelegateFunction.sol";
import "../interfaces/events/IEventSender.sol";

contract Staking is IStaking, Initializable, Ownable, Pausable, ReentrancyGuard, IEventSender {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using EnumerableSet for EnumerableSet.UintSet;

    IERC20 public tokeToken;
    IManager public manager;

    address public treasury;

    uint256 public withheldLiquidity; // DEPRECATED
    //userAddress -> withdrawalInfo
    mapping(address => WithdrawalInfo) public requestedWithdrawals; // DEPRECATED

    //userAddress -> -> scheduleIndex -> staking detail
    mapping(address => mapping(uint256 => StakingDetails)) public userStakings;

    //userAddress -> scheduleIdx[]
    mapping(address => uint256[]) public userStakingSchedules;

    //Schedule id/index counter
    uint256 public nextScheduleIndex;
    //scheduleIndex/id -> schedule
    mapping(uint256 => StakingSchedule) public schedules;
    //scheduleIndex/id[]
    EnumerableSet.UintSet private scheduleIdxs;

    //Can deposit into a non-public schedule
    mapping(address => bool) public override permissionedDepositors;

    bool public _eventSend;
    Destinations public destinations;

    IDelegateFunction public delegateFunction; //DEPRECATED

    // ScheduleIdx => notional address
    mapping(uint256 => address) public notionalAddresses;
    // address -> scheduleIdx -> WithdrawalInfo
    mapping(address => mapping(uint256 => WithdrawalInfo)) public withdrawalRequestsByIndex;

    modifier onlyPermissionedDepositors() {
        require(_isAllowedPermissionedDeposit(), "CALLER_NOT_PERMISSIONED");
        _;
    }

    modifier onEventSend() {
        if (_eventSend) {
            _;
        }
    }

    function initialize(
        IERC20 _tokeToken,
        IManager _manager,
        address _treasury,
        address _scheduleZeroNotional
    ) public initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
        __Pausable_init_unchained();

        require(address(_tokeToken) != address(0), "INVALID_TOKETOKEN");
        require(address(_manager) != address(0), "INVALID_MANAGER");
        require(_treasury != address(0), "INVALID_TREASURY");

        tokeToken = _tokeToken;
        manager = _manager;
        treasury = _treasury;

        //We want to be sure the schedule used for LP staking is first
        //because the order in which withdraws happen need to start with LP stakes
        _addSchedule(
            StakingSchedule({
                cliff: 0,
                duration: 1,
                interval: 1,
                setup: true,
                isActive: true,
                hardStart: 0,
                isPublic: true
            }),
            _scheduleZeroNotional
        );
    }

    function addSchedule(StakingSchedule memory schedule, address notional)
        external
        override
        onlyOwner
    {
        _addSchedule(schedule, notional);
    }

    function setPermissionedDepositor(address account, bool canDeposit)
        external
        override
        onlyOwner
    {
        permissionedDepositors[account] = canDeposit;

        emit PermissionedDepositorSet(account, canDeposit);
    }

    function setUserSchedules(address account, uint256[] calldata userSchedulesIdxs)
        external
        override
        onlyOwner
    {
        userStakingSchedules[account] = userSchedulesIdxs;

        emit UserSchedulesSet(account, userSchedulesIdxs);
    }

    function getSchedules()
        external
        view
        override
        returns (StakingScheduleInfo[] memory retSchedules)
    {
        uint256 length = scheduleIdxs.length();
        retSchedules = new StakingScheduleInfo[](length);
        for (uint256 i = 0; i < length; i++) {
            retSchedules[i] = StakingScheduleInfo(
                schedules[scheduleIdxs.at(i)],
                scheduleIdxs.at(i)
            );
        }
    }

    function getStakes(address account)
        external
        view
        override
        returns (StakingDetails[] memory stakes)
    {
        stakes = _getStakes(account);
    }

    function setNotionalAddresses(uint256[] calldata scheduleIdxArr, address[] calldata addresses)
        external
        override
        onlyOwner
    {
        require(scheduleIdxArr.length == addresses.length, "MISMATCH_LENGTH");
        for (uint256 i = 0; i < scheduleIdxArr.length; i++) {
            uint256 currentScheduleIdx = scheduleIdxArr[i];
            address currentAddress = addresses[i];
            require(scheduleIdxs.contains(currentScheduleIdx), "INDEX_DOESNT_EXIST");
            require(currentAddress != address(0), "INVALID_ADDRESS");

            notionalAddresses[currentScheduleIdx] = currentAddress;
        }
        emit NotionalAddressesSet(scheduleIdxArr, addresses);
    }

    function balanceOf(address account) public view override returns (uint256 value) {
        value = 0;
        uint256 scheduleCount = userStakingSchedules[account].length;
        for (uint256 i = 0; i < scheduleCount; i++) {
            uint256 remaining = userStakings[account][userStakingSchedules[account][i]].initial.sub(
                userStakings[account][userStakingSchedules[account][i]].withdrawn
            );
            uint256 slashed = userStakings[account][userStakingSchedules[account][i]].slashed;
            if (remaining > slashed) {
                value = value.add(remaining.sub(slashed));
            }
        }
    }

    function availableForWithdrawal(address account, uint256 scheduleIndex)
        external
        view
        override
        returns (uint256)
    {
        return _availableForWithdrawal(account, scheduleIndex);
    }

    function unvested(address account, uint256 scheduleIndex)
        external
        view
        override
        returns (uint256 value)
    {
        value = 0;
        StakingDetails memory stake = userStakings[account][scheduleIndex];

        value = stake.initial.sub(_vested(account, scheduleIndex));
    }

    function vested(address account, uint256 scheduleIndex)
        external
        view
        override
        returns (uint256 value)
    {
        return _vested(account, scheduleIndex);
    }

    function deposit(uint256 amount, uint256 scheduleIndex) external override {
        _depositFor(msg.sender, amount, scheduleIndex);
    }

    function deposit(uint256 amount) external override {
        _depositFor(msg.sender, amount, 0);
    }

    function depositFor(
        address account,
        uint256 amount,
        uint256 scheduleIndex
    ) external override onlyPermissionedDepositors {
        _depositFor(account, amount, scheduleIndex);
    }

    function depositWithSchedule(
        address account,
        uint256 amount,
        StakingSchedule calldata schedule,
        address notional
    ) external override onlyPermissionedDepositors {
        uint256 scheduleIx = nextScheduleIndex;
        _addSchedule(schedule, notional);
        _depositFor(account, amount, scheduleIx);
    }

    function requestWithdrawal(uint256 amount, uint256 scheduleIdx) external override {
        require(amount > 0, "INVALID_AMOUNT");
        require(scheduleIdxs.contains(scheduleIdx), "INVALID_SCHEDULE");
        uint256 availableAmount = _availableForWithdrawal(msg.sender, scheduleIdx);
        require(availableAmount >= amount, "INSUFFICIENT_AVAILABLE");

        withdrawalRequestsByIndex[msg.sender][scheduleIdx].amount = amount;
        if (manager.getRolloverStatus()) {
            withdrawalRequestsByIndex[msg.sender][scheduleIdx].minCycleIndex = manager
                .getCurrentCycleIndex()
                .add(2);
        } else {
            withdrawalRequestsByIndex[msg.sender][scheduleIdx].minCycleIndex = manager
                .getCurrentCycleIndex()
                .add(1);
        }

        bytes32 eventSig = "Withdrawal Request";
        StakingDetails memory userStake = userStakings[msg.sender][scheduleIdx];
        uint256 voteTotal = userStake.initial.sub((userStake.slashed.add(userStake.withdrawn))).sub(
            amount
        );
        encodeAndSendData(eventSig, msg.sender, scheduleIdx, voteTotal);

        emit WithdrawalRequested(msg.sender, scheduleIdx, amount);
    }

    function withdraw(uint256 amount, uint256 scheduleIdx)
        external
        override
        nonReentrant
        whenNotPaused
    {
        require(amount > 0, "NO_WITHDRAWAL");
        require(scheduleIdxs.contains(scheduleIdx), "INVALID_SCHEDULE");
        _withdraw(amount, scheduleIdx);
    }

    function withdraw(uint256 amount) external override whenNotPaused nonReentrant {
        require(amount > 0, "INVALID_AMOUNT");
        _withdraw(amount, 0);
    }

    function slash(
        address[] calldata accounts,
        uint256[] calldata amounts,
        uint256 scheduleIndex
    ) external override onlyOwner whenNotPaused {
        require(accounts.length == amounts.length, "LENGTH_MISMATCH");
        StakingSchedule storage schedule = schedules[scheduleIndex];
        require(schedule.setup, "INVALID_SCHEDULE");

        for (uint256 i = 0; i < accounts.length; i++) {
            address account = accounts[i];
            uint256 amount = amounts[i];

            require(amount > 0, "INVALID_AMOUNT");
            require(account != address(0), "INVALID_ADDRESS");

            StakingDetails memory userStake = userStakings[account][scheduleIndex];
            require(userStake.initial > 0, "NO_VESTING");

            uint256 availableToSlash = 0;
            uint256 remaining = userStake.initial.sub(userStake.withdrawn);
            if (remaining > userStake.slashed) {
                availableToSlash = remaining.sub(userStake.slashed);
            }

            require(availableToSlash >= amount, "INSUFFICIENT_AVAILABLE");

            userStake.slashed = userStake.slashed.add(amount);
            userStakings[account][scheduleIndex] = userStake;

            uint256 totalLeft = userStake.initial.sub((userStake.slashed.add(userStake.withdrawn)));

            if (withdrawalRequestsByIndex[account][scheduleIndex].amount > totalLeft) {
                withdrawalRequestsByIndex[account][scheduleIndex].amount = totalLeft;
            }

            uint256 voteAmount = totalLeft.sub(
                withdrawalRequestsByIndex[account][scheduleIndex].amount
            );
            bytes32 eventSig = "Slashed";

            encodeAndSendData(eventSig, account, scheduleIndex, voteAmount);

            tokeToken.safeTransfer(treasury, amount);

            emit Slashed(account, amount, scheduleIndex);
        }
    }

    function setScheduleStatus(uint256 scheduleId, bool activeBool) external override onlyOwner {
        StakingSchedule storage schedule = schedules[scheduleId];
        schedule.isActive = activeBool;

        emit ScheduleStatusSet(scheduleId, activeBool);
    }

    function pause() external override onlyOwner {
        _pause();
    }

    function unpause() external override onlyOwner {
        _unpause();
    }

    function setDestinations(address _fxStateSender, address _destinationOnL2)
        external
        override
        onlyOwner
    {
        require(_fxStateSender != address(0), "INVALID_ADDRESS");
        require(_destinationOnL2 != address(0), "INVALID_ADDRESS");

        destinations.fxStateSender = IFxStateSender(_fxStateSender);
        destinations.destinationOnL2 = _destinationOnL2;

        emit DestinationsSet(_fxStateSender, _destinationOnL2);
    }

    function setEventSend(bool _eventSendSet) external override onlyOwner {
        require(destinations.destinationOnL2 != address(0), "DESTINATIONS_NOT_SET");

        _eventSend = _eventSendSet;

        emit EventSendSet(_eventSendSet);
    }

    function _availableForWithdrawal(address account, uint256 scheduleIndex)
        private
        view
        returns (uint256)
    {
        StakingDetails memory stake = userStakings[account][scheduleIndex];
        uint256 vestedWoWithdrawn = _vested(account, scheduleIndex).sub(stake.withdrawn);
        if (stake.slashed > vestedWoWithdrawn) return 0;

        return vestedWoWithdrawn.sub(stake.slashed);
    }

    function _depositFor(
        address account,
        uint256 amount,
        uint256 scheduleIndex
    ) private nonReentrant whenNotPaused {
        StakingSchedule memory schedule = schedules[scheduleIndex];
        require(amount > 0, "INVALID_AMOUNT");
        require(schedule.setup, "INVALID_SCHEDULE");
        require(schedule.isActive, "INACTIVE_SCHEDULE");
        require(account != address(0), "INVALID_ADDRESS");
        require(schedule.isPublic || _isAllowedPermissionedDeposit(), "PERMISSIONED_SCHEDULE");

        StakingDetails memory userStake = _updateStakingDetails(scheduleIndex, account, amount);

        bytes32 eventSig = "Deposit";
        uint256 voteTotal = userStake.initial.sub((userStake.slashed.add(userStake.withdrawn))).sub(
            withdrawalRequestsByIndex[account][scheduleIndex].amount
        );
        encodeAndSendData(eventSig, account, scheduleIndex, voteTotal);

        tokeToken.safeTransferFrom(msg.sender, address(this), amount);

        emit Deposited(account, amount, scheduleIndex);
    }

    function _withdraw(uint256 amount, uint256 scheduleIdx) private {
        WithdrawalInfo memory request = withdrawalRequestsByIndex[msg.sender][scheduleIdx];
        require(amount <= request.amount, "INSUFFICIENT_AVAILABLE");
        require(request.minCycleIndex <= manager.getCurrentCycleIndex(), "INVALID_CYCLE");

        StakingDetails memory userStake = userStakings[msg.sender][scheduleIdx];
        userStake.withdrawn = userStake.withdrawn.add(amount);
        userStakings[msg.sender][scheduleIdx] = userStake;

        request.amount = request.amount.sub(amount);
        withdrawalRequestsByIndex[msg.sender][scheduleIdx] = request;

        if (request.amount == 0) {
            delete withdrawalRequestsByIndex[msg.sender][scheduleIdx];
        }

        tokeToken.safeTransfer(msg.sender, amount);

        emit WithdrawCompleted(msg.sender, scheduleIdx, amount);
    }

    function _vested(address account, uint256 scheduleIndex) private view returns (uint256) {
        // solhint-disable-next-line not-rely-on-time
        uint256 timestamp = block.timestamp;
        uint256 value = 0;
        StakingDetails memory stake = userStakings[account][scheduleIndex];
        StakingSchedule memory schedule = schedules[scheduleIndex];

        uint256 cliffTimestamp = stake.started.add(schedule.cliff);
        if (cliffTimestamp <= timestamp) {
            if (cliffTimestamp.add(schedule.duration) <= timestamp) {
                value = stake.initial;
            } else {
                uint256 secondsStaked = Math.max(timestamp.sub(cliffTimestamp), 1);
                //Precision loss is intentional. Enables the interval buckets
                uint256 effectiveSecondsStaked = (secondsStaked.div(schedule.interval)).mul(
                    schedule.interval
                );
                value = stake.initial.mul(effectiveSecondsStaked).div(schedule.duration);
            }
        }

        return value;
    }

    function _addSchedule(StakingSchedule memory schedule, address notional) private {
        require(schedule.duration > 0, "INVALID_DURATION");
        require(schedule.interval > 0, "INVALID_INTERVAL");
        require(notional != address(0), "INVALID_ADDRESS");

        schedule.setup = true;
        uint256 index = nextScheduleIndex;
        schedules[index] = schedule;
        notionalAddresses[index] = notional;
        require(scheduleIdxs.add(index), "ADD_FAIL");
        nextScheduleIndex = nextScheduleIndex.add(1);

        emit ScheduleAdded(
            index,
            schedule.cliff,
            schedule.duration,
            schedule.interval,
            schedule.setup,
            schedule.isActive,
            schedule.hardStart,
            notional
        );
    }

    function _getStakes(address account) private view returns (StakingDetails[] memory stakes) {
        uint256 stakeCnt = userStakingSchedules[account].length;
        stakes = new StakingDetails[](stakeCnt);

        for (uint256 i = 0; i < stakeCnt; i++) {
            stakes[i] = userStakings[account][userStakingSchedules[account][i]];
        }
    }

    function _isAllowedPermissionedDeposit() private view returns (bool) {
        return permissionedDepositors[msg.sender] || msg.sender == owner();
    }

    function encodeAndSendData(
        bytes32 _eventSig,
        address _user,
        uint256 _scheduleIdx,
        uint256 _userBalance
    ) private onEventSend {
        require(address(destinations.fxStateSender) != address(0), "ADDRESS_NOT_SET");
        require(destinations.destinationOnL2 != address(0), "ADDRESS_NOT_SET");
        address notionalAddress = notionalAddresses[_scheduleIdx];

        bytes memory data = abi.encode(
            BalanceUpdateEvent({
                eventSig: _eventSig,
                account: _user,
                token: notionalAddress,
                amount: _userBalance
            })
        );

        destinations.fxStateSender.sendMessageToChild(destinations.destinationOnL2, data);
    }

    function _updateStakingDetails(
        uint256 scheduleIdx,
        address account,
        uint256 amount
    ) private returns (StakingDetails memory) {
        StakingDetails memory stake = userStakings[account][scheduleIdx];
        if (stake.started == 0) {
            userStakingSchedules[account].push(scheduleIdx);
            StakingSchedule memory schedule = schedules[scheduleIdx];
            if (schedule.hardStart > 0) {
                stake.started = schedule.hardStart;
            } else {
                //solhint-disable-next-line not-rely-on-time
                stake.started = block.timestamp;
            }
        }
        stake.initial = stake.initial.add(amount);
        stake.scheduleIx = scheduleIdx;
        userStakings[account][scheduleIdx] = stake;

        return stake;
    }

    function depositWithdrawEvent(
        address withdrawUser,
        uint256 withdrawAmount,
        uint256 withdrawScheduleIdx,
        address depositUser,
        uint256 depositAmount,
        uint256 depositScheduleIdx
    ) private {
        bytes32 withdrawEvent = "Withdraw";
        bytes32 depositEvent = "Deposit";
        encodeAndSendData(withdrawEvent, withdrawUser, withdrawScheduleIdx, withdrawAmount);
        encodeAndSendData(depositEvent, depositUser, depositScheduleIdx, depositAmount);
    }
}
