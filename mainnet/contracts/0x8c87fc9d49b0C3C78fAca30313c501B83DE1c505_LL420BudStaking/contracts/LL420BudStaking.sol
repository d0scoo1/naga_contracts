//
//  __   __      _____    ______
// /__/\/__/\   /_____/\ /_____/\
// \  \ \: \ \__\:::_:\ \\:::_ \ \
//  \::\_\::\/_/\   _\:\| \:\ \ \ \
//   \_:::   __\/  /::_/__ \:\ \ \ \
//        \::\ \   \:\____/\\:\_\ \ \
//         \__\/    \_____\/ \_____\/
//
// 420.game Bud / Game Key Staking
//
// by LOOK LABS
//
// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "./interfaces/ILL420HighToken.sol";

/**
 * @title LL420BudStaking
 * @dev NFT staking contract that can stake/unstake NFTs and calculate the reward.
 *
 */
contract LL420BudStaking is Initializable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    using EnumerableSet for EnumerableSet.UintSet;
    using AddressUpgradeable for address;

    IERC721Upgradeable public BUD_CONTRACT;
    IERC721Upgradeable public GAME_KEY_CONTRACT;

    bool public stakingLaunched;
    bool public depositPaused;
    /// @dev Initial amount of reward within lock period.
    uint16 public INITIAL_REWARD;
    /// @dev Total amount of staked bud in this contract.
    uint16 public totalBudStaked;
    /// @dev Total amount of staked gamekey in this contract.
    uint16 public totalGameKeyStaked;

    uint16[6] public thcInfo;
    uint32 public constant SECONDS_IN_DAY = 1 days;
    uint256 public LOCK_PERIOD;
    uint256 public startTimestamp;

    /// @dev Address of reward token address which should be set by LL420.
    address public rewardTokenAddress;
    /// Address of bud reveal contract address
    address public revealContractAddress;

    /// @dev Information of each staker.
    struct UserInfo {
        uint256 reward; /// Reward debt.
        uint256 lastCheckpoint; /// timestamp of calc the pending reward.
        uint128 budCount;
        uint128 gameKeyCount;
    }

    /// Information of each bud with timestamp and thc.
    struct BudInfo {
        uint256 timestamp;
        uint256 thc;
    }

    /// address => userInfo structure
    mapping(address => UserInfo) public _userInfo;
    /// game key id => user bud id array
    mapping(uint256 => EnumerableSet.UintSet) private _userBudInfo;
    /// address => set of game key ids
    mapping(address => EnumerableSet.UintSet) private _gameKeyInfo;
    /// bud id => Bud Info
    mapping(uint256 => BudInfo) public _budInfo;
    /// bud id => bonus id
    mapping(uint256 => bool) public _startBonus;

    /* ==================== EVENTS ==================== */

    event Deposit(address indexed user, uint256 indexed id);
    event DepositGameKey(address indexed user, uint256 indexed id);
    event Withdraw(address indexed user, uint256 indexed id);
    event WithdrawGameKey(address indexed user, uint256 indexed id);
    event ClaimReward(address indexed user, uint256 amount);
    event EmergencyWithdraw(address indexed user);
    event SetBudTHC(uint256 indexed id, uint256 indexed thc);

    /* ==================== MODIFIERS ==================== */

    modifier onlyStarted() {
        require(
            (block.timestamp >= startTimestamp && startTimestamp != 0) || stakingLaunched,
            "LL420BudStaking: Staking is not launched yet"
        );
        _;
    }

    /* ==================== METHODS ==================== */

    /**
     * @dev Initializes a staking contract.
     * @param _budContract address of the bud contract.
     * @param _gameKeyContract address of the GameKey contract.
     */
    function initialize(address _budContract, address _gameKeyContract) external initializer {
        __Context_init();
        __Ownable_init();
        __ReentrancyGuard_init();

        require(_budContract != address(0), "LL420BudStaking: Wrong BUDS address");
        require(_gameKeyContract != address(0), "LL420BudStaking: Wrong GAMEKEY address");

        BUD_CONTRACT = IERC721Upgradeable(_budContract);
        GAME_KEY_CONTRACT = IERC721Upgradeable(_gameKeyContract);
        thcInfo = [420, 520, 620, 720, 1020, 1420];
        LOCK_PERIOD = 14 days;
        INITIAL_REWARD = 200;
    }

    /**
     * @dev Returns the two arrays of BUD and Game Key
     */
    function userInfo(address _user)
        external
        view
        returns (
            UserInfo memory,
            uint256[] memory,
            uint256[] memory
        )
    {
        require(_user != address(0), "LL420BudStaking: user address can't be zero");

        UserInfo memory user = _userInfo[_user];
        uint256[] memory userBuds = _getUserBuds(_user);
        uint256[] memory gameKeys = _getUserGKs(_user);

        return (user, gameKeys, userBuds);
    }

    /**
     * @dev returns the bud connected to game key.
     * @param _id The id of Game Key.
     * @param _user The address of user.
     */
    function getGKBuds(uint256 _id, address _user) external view returns (uint256[] memory) {
        require(_gameKeyInfo[_user].contains(_id), "LL420BudStaking: Game key is not belong to this user");
        uint256 length = _userBudInfo[_id].length();
        uint256[] memory buds = new uint256[](length);

        for (uint256 i; i < length; i++) {
            buds[i] = _userBudInfo[_id].at(i);
        }

        return buds;
    }

    /**
     * @param _id The id of Game Key.
     * @param _ids The ids of Buds to deposit.
     */
    function deposit(uint256 _id, uint256[] memory _ids) external nonReentrant onlyStarted {
        require(!depositPaused, "LL420BudStaking: Deposit Paused");
        require(_ids.length > 0, "LL420BudStaking: Cant deposit zero amount");
        require(totalGameKeyStaked > 0, "LL420Staking: GameKey is not staked yet");
        require(_gameKeyInfo[_msgSender()].length() > 0, "LL420BudStaking: Need more than 1 GAMEKEY staked");
        require(GAME_KEY_CONTRACT.ownerOf(_id) == address(this), "LL420BudStaking: This game key is not staked");
        require(_gameKeyInfo[_msgSender()].contains(_id), "LL420BudStaking: Not the owner of Game Key");

        UserInfo storage user = _userInfo[_msgSender()];
        uint256[] memory userBuds = _getUserBuds(_msgSender());

        /// Check if user has pending reward
        if (userBuds.length > 0) {
            uint256 pending = _getPendingReward(_msgSender());
            if (pending > 0) {
                user.reward += pending;
            }
        }

        for (uint256 i; i < _ids.length; i++) {
            require(BUD_CONTRACT.ownerOf(_ids[i]) == _msgSender(), "LL420BudStaking: Not the owner of BUD");
            require(!_userBudInfo[_id].contains(_ids[i]), "LL42-BudStaking: Cant stake same BUDs");

            BUD_CONTRACT.transferFrom(_msgSender(), address(this), _ids[i]);
            _userBudInfo[_id].add(_ids[i]);
            BudInfo storage bud = _budInfo[_ids[i]];
            bud.timestamp = block.timestamp;

            if (!_startBonus[_ids[i]]) {
                _startBonus[_ids[i]] = true;
                user.reward += INITIAL_REWARD * 3; /// Gives 3 days bonus
            }

            emit Deposit(_msgSender(), _ids[i]);
        }

        totalBudStaked += uint16(_ids.length);
        user.budCount += uint128(_ids.length);
        user.lastCheckpoint = block.timestamp;
    }

    /**
     * @param _id The id of game key.
     * @param _ids The NFT ids to withdraw
     */
    function withdraw(uint256 _id, uint256[] memory _ids) external nonReentrant {
        return _withdraw(_id, _ids);
    }

    /**
     * @dev Deposit Game Keys.
     * @param _ids The GameKey NFT ids to deposit.
     */
    function depositGameKey(uint256[] calldata _ids) external nonReentrant onlyStarted {
        require(_ids.length > 0, "LL420BudStaking: Cant deposit zero amount of buds");
        require(!depositPaused, "LL420BudStaking: Deposit Paused");

        UserInfo storage user = _userInfo[_msgSender()];

        for (uint256 i; i < _ids.length; i++) {
            require(GAME_KEY_CONTRACT.ownerOf(_ids[i]) == _msgSender(), "LL420BudStaking: Not the owner of GAMEKEY");
            require(!_gameKeyInfo[_msgSender()].contains(_ids[i]), "LL420BudStaking: Cant stake same GAMEKEY");

            GAME_KEY_CONTRACT.transferFrom(_msgSender(), address(this), _ids[i]);
            _gameKeyInfo[_msgSender()].add(_ids[i]);

            emit DepositGameKey(_msgSender(), _ids[i]);
        }

        totalGameKeyStaked += uint16(_ids.length);
        user.gameKeyCount += uint128(_ids.length);
    }

    /**
     */
    function withdrawGameKey(uint256[] memory _ids) external nonReentrant onlyStarted {
        _withdrawGameKey(_ids);
    }

    /**
     */
    function getReward(address _user) external view returns (uint256) {
        require(_user != address(0), "LL420BudStaking: user address cant be zero");
        UserInfo memory user = _userInfo[_user];

        return user.reward + _getPendingReward(_user);
    }

    /**
     * @dev calculate reward per day of one user.
     * @param _user The address of staker.
     */
    function getDailyReward(address _user) external view returns (uint256) {
        require(_user != address(0), "LL420BudStaking: user address cant be zero");

        uint256[] memory userBud = _getUserBuds(_user);
        uint256 dailyReward;

        for (uint256 i; i < userBud.length; i++) {
            uint256 tokenId = userBud[i];
            BudInfo memory bud = _budInfo[tokenId];

            uint256 duration = block.timestamp - bud.timestamp;
            if (duration <= LOCK_PERIOD) {
                dailyReward += INITIAL_REWARD;
            } else {
                dailyReward += (bud.thc == 0 ? INITIAL_REWARD : bud.thc);
            }
        }

        return dailyReward;
    }

    /**
     * @dev
     * Todo
     */
    function claimReward() external nonReentrant {
        require(rewardTokenAddress != address(0), "LL420BudStaking: RewardToken is not set yet.");
        UserInfo storage user = _userInfo[_msgSender()];
        uint256 reward = user.reward;
        uint256[] memory userBud = _getUserBuds(_msgSender());

        if (userBud.length > 0) {
            uint256 pending = _getPendingReward(_msgSender());
            if (pending > 0) {
                user.reward += pending;
            }
        }

        require(user.reward > 0, "LL420BudStaking: No reward to withdraw");

        ILL420HighToken HIGH_TOKEN_CONTRACT = ILL420HighToken(rewardTokenAddress);
        HIGH_TOKEN_CONTRACT.claimReward(_msgSender(), user.reward);

        user.reward = 0;
        user.lastCheckpoint = block.timestamp;

        emit ClaimReward(_msgSender(), reward);
    }

    /**
     * @dev returns the bud staking period and reward for each bud per day
     */
    function getBudInfo(uint256[] memory _ids) external view returns (uint256[] memory, uint256[] memory) {
        uint256[] memory times = new uint256[](_ids.length);
        uint256[] memory rewards = new uint256[](_ids.length);

        for (uint256 i; i < _ids.length; i++) {
            BudInfo memory bud = _budInfo[_ids[i]];
            require(bud.timestamp != 0, "LL420BudStaking: Bud is not registered yet");

            times[i] = (block.timestamp - bud.timestamp) / SECONDS_IN_DAY;

            if (block.timestamp - bud.timestamp <= LOCK_PERIOD) {
                rewards[i] = INITIAL_REWARD;
            } else {
                rewards[i] = bud.thc == 0 ? INITIAL_REWARD : bud.thc;
            }
        }

        return (times, rewards);
    }

    /* ==================== INTERNAL METHODS ==================== */

    /**
     * @param _id The id of Game Key.
     * @param _ids The BUD NFT ids to deposit.
     */
    function _withdraw(uint256 _id, uint256[] memory _ids) internal {
        require(_ids.length > 0, "LL420BudStaking: Cant withdraw zero amount");
        require(totalBudStaked > 0, "LL420Staking: Bud is not staked yet");
        require(totalGameKeyStaked > 0, "LL420Staking: Game Key is not staked yet");
        require(_gameKeyInfo[_msgSender()].length() > 0, "LL420BudStaking: Need more than 1 GAMEKEY staked");
        require(_userBudInfo[_id].length() > 0, "LL420BudStaking: Game Key doesn't have buds");
        require(GAME_KEY_CONTRACT.ownerOf(_id) == address(this), "LL420BudStaking: This game key is not staked");
        require(_gameKeyInfo[_msgSender()].contains(_id), "LL420BudStaking: Not the owner of Game Key");

        UserInfo storage user = _userInfo[_msgSender()];
        require(user.budCount >= _ids.length, "LL420BudStaking: Amount NFTs is wrong");

        uint256[] memory userBuds = _getUserBuds(_msgSender());

        if (userBuds.length > 0) {
            uint256 pending = _getPendingReward(_msgSender());
            if (pending > 0) {
                user.reward += pending;
            }
        }

        for (uint256 i; i < _ids.length; i++) {
            require(_userBudInfo[_id].contains(_ids[i]), "LL420BudStaking: Unautorized id");

            BudInfo storage bud = _budInfo[_ids[i]];

            BUD_CONTRACT.transferFrom(address(this), _msgSender(), _ids[i]);
            _userBudInfo[_id].remove(_ids[i]);
            bud.timestamp = 0;

            emit Withdraw(_msgSender(), _ids[i]);
        }

        totalBudStaked -= uint16(_ids.length);
        user.budCount -= uint128(_ids.length);
        user.lastCheckpoint = block.timestamp;
    }

    /**
     * @dev Internal method of withdrawing Game Key.
     *
     * @param _ids id array of Game Keys
     */
    function _withdrawGameKey(uint256[] memory _ids) internal {
        require(_ids.length > 0, "LL420BudStaking: Cant withdraw zero amount of gamekeys");
        require(totalGameKeyStaked > 0, "LL420BudStaking: GameKey is not staked yet");
        require(_gameKeyInfo[_msgSender()].length() >= _ids.length, "LL420BudStaking: Amount of game keys is wrong");

        UserInfo storage user = _userInfo[_msgSender()];
        require(user.gameKeyCount >= _ids.length, "LL420BudStaking: Withdraw amount is incorrect");

        for (uint256 i; i < _ids.length; i++) {
            uint256 gkId = _ids[i];
            require(_gameKeyInfo[_msgSender()].contains(gkId), "LL420BudStaking: Unauthroized GAMEKEY id");

            uint256 length = _userBudInfo[gkId].length();
            uint256[] memory gkBuds = new uint256[](length);
            for (uint256 j; j < length; j++) {
                gkBuds[j] = _userBudInfo[gkId].at(j);
            }

            if (gkBuds.length > 0) {
                _withdraw(gkId, gkBuds);
            }
            GAME_KEY_CONTRACT.transferFrom(address(this), _msgSender(), _ids[i]);
            _gameKeyInfo[_msgSender()].remove(_ids[i]);

            emit WithdrawGameKey(_msgSender(), _ids[i]);
        }

        totalGameKeyStaked -= uint16(_ids.length);
        unchecked {
            user.gameKeyCount -= uint128(_ids.length);
        }
    }

    /**
     * @dev Funtion calculates and returns the reward of staker.
     * @param _user The address of staker.
     */
    function _getPendingReward(address _user) internal view returns (uint256) {
        require(_user != address(0), "LL420BudStaking: user address cant be zero");

        UserInfo memory user = _userInfo[_user];
        uint256[] memory userBuds = _getUserBuds(_user);
        uint256 pendingReward;
        uint256 length = userBuds.length;
        require(length > 0, "LL420BudStaking: Empty bud for this staker");

        for (uint256 i; i < length; i++) {
            BudInfo memory bud = _budInfo[userBuds[i]];

            if (block.timestamp - bud.timestamp <= LOCK_PERIOD) {
                pendingReward += ((block.timestamp - user.lastCheckpoint) / SECONDS_IN_DAY) * INITIAL_REWARD;
            } else if (user.lastCheckpoint - bud.timestamp <= LOCK_PERIOD) {
                pendingReward +=
                    INITIAL_REWARD *
                    ((bud.timestamp + LOCK_PERIOD) / SECONDS_IN_DAY - user.lastCheckpoint / SECONDS_IN_DAY);
                pendingReward +=
                    (bud.thc == 0 ? INITIAL_REWARD : bud.thc) *
                    ((block.timestamp - bud.timestamp - LOCK_PERIOD) / SECONDS_IN_DAY);
            } else {
                pendingReward +=
                    (bud.thc == 0 ? INITIAL_REWARD : bud.thc) *
                    ((block.timestamp - user.lastCheckpoint) / SECONDS_IN_DAY);
            }
        }

        return pendingReward;
    }

    /**
     */
    function _getUserBuds(address _user) internal view returns (uint256[] memory) {
        require(_user != address(0), "LL420BudStaking: user address cant be zero");

        UserInfo memory user = _userInfo[_user];
        uint256[] memory userBud = new uint256[](user.budCount);
        uint256 count = 0;

        for (uint256 i; i < _gameKeyInfo[_user].length(); i++) {
            uint256 gameKeyId = _gameKeyInfo[_user].at(i);
            for (uint256 j; j < _userBudInfo[gameKeyId].length(); j++) {
                userBud[count++] = _userBudInfo[gameKeyId].at(j);
            }
        }

        return userBud;
    }

    /**
     */
    function _getUserGKs(address _user) internal view returns (uint256[] memory) {
        require(_user != address(0), "LL420BudStaking: user address cant be zero");

        uint256 gameKeyLength = _gameKeyInfo[_user].length();
        uint256[] memory gameKeys = new uint256[](gameKeyLength);

        for (uint256 i; i < gameKeyLength; i++) {
            gameKeys[i] = _gameKeyInfo[_user].at(i);
        }

        return gameKeys;
    }

    /**
     */
    // function _checkPair()

    /* ==================== OWNER METHODS ==================== */

    /**
     * @dev Function allows to set HIGH token address.
     * @param _token address of HIGH token address.
     */
    function setRewardTokenAddress(address _token) external onlyOwner {
        require(_token != address(0), "LL420BudStaking: Token address can't be zero ");
        rewardTokenAddress = _token;
    }

    /**
     * @dev Function activates the staking contract.
     */
    function launchStaking() external onlyOwner {
        require(!stakingLaunched, "LL420BudStaking: Staking has been launched already");
        stakingLaunched = true;
    }

    /**
     * @dev Function sets the start time to launch staking.
     */
    function setStartTimestamp(uint256 _startTimestamp) external onlyOwner {
        startTimestamp = _startTimestamp;
    }

    /**
     * @dev Function allows to pause deposits if needed.
     * @param _pause status of deposit to be set.
     */
    function pauseDeposit(bool _pause) external onlyOwner {
        depositPaused = _pause;
    }

    /**
     * @dev Owner can withdraw one single nfts back to stakers in emergency.
     * It withdraws only NFTS, not reward.
     */
    function emergencyWithdraw(address _user) external onlyOwner {
        require(_user != address(0), "LL420BudStaking: user address cant be zero");

        UserInfo storage user = _userInfo[_user];
        user.lastCheckpoint = block.timestamp;

        uint256 gameKeyLength = _gameKeyInfo[_user].length();
        for (uint256 i; i < gameKeyLength; i++) {
            uint256 gkId = _gameKeyInfo[_user].at(0);
            require(
                GAME_KEY_CONTRACT.ownerOf(gkId) == address(this),
                "LL420BudStaking: Game Key is not belong to this contract"
            );

            uint256 budLength = _userBudInfo[gkId].length();
            for (uint256 j; j < budLength; j++) {
                uint256 tokenId = _userBudInfo[gkId].at(0);
                require(
                    BUD_CONTRACT.ownerOf(tokenId) == address(this),
                    "LL420BudStaking: Bud is not belong to this contract"
                );

                BUD_CONTRACT.safeTransferFrom(address(this), _user, tokenId);
                _userBudInfo[gkId].remove(tokenId);
            }
            totalBudStaked -= uint16(budLength);

            GAME_KEY_CONTRACT.safeTransferFrom(address(this), _user, gkId);
            _gameKeyInfo[_user].remove(gkId);
        }
        totalGameKeyStaked -= uint16(gameKeyLength);
        user.budCount = 0;
        user.gameKeyCount = 0;

        emit EmergencyWithdraw(_user);
    }

    /**
     * @dev
     */
    function setLockPeriod(uint256 _days) external onlyOwner {
        LOCK_PERIOD = _days * 1 days;
    }

    /**
     * @dev Set LL420Reveal contract address
     */
    function setRevealContractAddress(address _address) external onlyOwner {
        require(_address != address(0), "Zero address error");

        revealContractAddress = _address;
    }

    /* ==================== THIRD PARTY METHODS ==================== */

    /**
     * @dev Function sets the THC level of each bud.
     * only allows for LL420Reveal cntract
     *
     * _thc 0 => 4.20 $HIGH/day
     * _thc 1 => 5.20 $HIGH/day
     * _thc 2 => 6.20 $HIGH/day
     * _thc 3 => 7.20 $HIGH/day
     * _thc 4 => 10.20 $HIGH/day
     * _thc 5 => 14.20 $HIGH/day
     *
     * @param _ids id of all bud
     * @param _thc => index of thc [0 to 5]
     */
    function setTHC(uint256[] calldata _ids, uint256[] calldata _thc) external {
        require(_ids.length == _thc.length, "LL420BudStaking: id and thc are not matching");
        require(revealContractAddress != address(0), "LL420BudStaking: Reveal contract is not set yet");
        require(
            revealContractAddress == _msgSender() || owner() == _msgSender(),
            "LL420BudStaking: Only able to call from reveal contract"
        );

        for (uint256 i; i < _ids.length; i++) {
            BudInfo storage bud = _budInfo[_ids[i]];
            bud.thc = thcInfo[_thc[i]];

            emit SetBudTHC(_ids[i], bud.thc);
        }
    }
}
