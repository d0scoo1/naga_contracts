pragma solidity 0.5.17;


library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * > It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

contract Owned {
    address public owner;
    address public nominatedOwner;

    constructor(address _owner) public {
        require(_owner != address(0), "Owner address cannot be 0");
        owner = _owner;
        emit OwnerChanged(address(0), _owner);
    }

    function nominateNewOwner(address _owner) external onlyOwner {
        nominatedOwner = _owner;
        emit OwnerNominated(_owner);
    }

    function acceptOwnership() external {
        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
        emit OwnerChanged(owner, nominatedOwner);
        owner = nominatedOwner;
        nominatedOwner = address(0);
    }

    modifier onlyOwner {
        _onlyOwner();
        _;
    }

    function _onlyOwner() private view {
        require(msg.sender == owner, "Only the contract owner may perform this action");
    }

    event OwnerNominated(address newOwner);
    event OwnerChanged(address oldOwner, address newOwner);
}

contract Pausable is Owned {
    uint public lastPauseTime;
    bool public paused;

    constructor() internal {
        // This contract is abstract, and thus cannot be instantiated directly
        require(owner != address(0), "Owner must be set");
        // Paused will be false, and lastPauseTime will be 0 upon initialisation
    }

    /**
     * @notice Change the paused state of the contract
     * @dev Only the contract owner may call this.
     */
    function setPaused(bool _paused) external onlyOwner {
        // Ensure we're actually changing the state before we do anything
        if (_paused == paused) {
            return;
        }

        // Set our paused state.
        paused = _paused;

        // If applicable, set the last pause time.
        if (paused) {
            lastPauseTime = now;
        }

        // Let everyone know that our pause state has changed.
        emit PauseChanged(paused);
    }

    event PauseChanged(bool isPaused);

    modifier notPaused {
        require(!paused, "This action cannot be performed while the contract is paused");
        _;
    }
}

contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}


library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

contract MultiRewards is ReentrancyGuard, Pausable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    /* ========== STATE VARIABLES ========== */

    struct Reward {
        address rewardsDistributor;
        uint256 rewardsDuration;
        uint256 periodFinish;
        uint256 rewardRate;
        uint256 lastUpdateTime;
        uint256 rewardPerTokenStored;
    }
    IERC20 public stakingToken;
    mapping(address => Reward) public rewardData;
    address[] public rewardTokens;

    struct RewardRate {
        uint256 startingTime;      // inclusive of this time
	    uint256 ratePerToken;	   // reward per second for each token from startingTime to next (exclusive).  last one applicable to lastTimeRewardApplicable
    }
    // reward token -> RewardRate[]
    mapping(address => RewardRate[]) public rewardRatePerToken;

    // user -> reward token -> amount
    mapping(address => mapping(address => uint256)) public userRewardPerTokenPaid;
    mapping(address => mapping(address => uint256)) public rewards;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    // handling lockup for individual stake
    uint256 public lockDuration;
    // user -> reward token -> amount
    mapping(address => mapping(address => uint256)) public claimedRewards;

    struct Stake {
        uint256 stakingMaturity;
	    uint256 remainingBalance;	
    }    
    // user -> stakes [stake index]
    mapping(address => Stake[]) public userStakes;

    struct StakeBalance {
        uint256 startingTime;    // inclusive of this time
	    uint256 sBalance;	     // balance from startingTime to next (exclusive of next)    
    }
    // user -> StakeBalance[]
    mapping(address => StakeBalance[]) public userStakeBalance;

    /* ========== CONSTRUCTOR ========== */

    constructor(
        address _owner,
        address _stakingToken,
        uint256 _lockDuration
    ) public Owned(_owner) {
        stakingToken = IERC20(_stakingToken);
        lockDuration = _lockDuration;
    }

    function addReward(
        address _rewardsToken,
        address _rewardsDistributor,
        uint256 _rewardsDuration
    )
        public
        onlyOwner
    {
        require(rewardData[_rewardsToken].rewardsDuration == 0, "reward data of token has been added");
        require(_rewardsToken != address(0) && _rewardsDistributor != address(0), "Zero address not allowed");
        require(_rewardsDuration > 0, "Reward duration must be non-zero");
        rewardTokens.push(_rewardsToken);
        rewardData[_rewardsToken].rewardsDistributor = _rewardsDistributor;
        rewardData[_rewardsToken].rewardsDuration = _rewardsDuration;
        emit RewardsDistributorUpdated(_rewardsToken, _rewardsDistributor);
        emit RewardsDurationUpdated(_rewardsToken, _rewardsDuration);
    }

    /* ========== VIEWS ========== */

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function lastTimeRewardApplicable(address _rewardsToken) public view returns (uint256) {
        return Math.min(block.timestamp, rewardData[_rewardsToken].periodFinish);
    }

    function rewardPerToken(address _rewardsToken) public view returns (uint256) {
        if (_totalSupply == 0) {
            return rewardData[_rewardsToken].rewardPerTokenStored;
        }
        return
            rewardData[_rewardsToken].rewardPerTokenStored.add(
                lastTimeRewardApplicable(_rewardsToken).sub(rewardData[_rewardsToken].lastUpdateTime).mul(rewardData[_rewardsToken].rewardRate).mul(1e18).div(_totalSupply)
            );
    }

    function earned(address account, address _rewardsToken) public view returns (uint256) {
        return _balances[account].mul(rewardPerToken(_rewardsToken).sub(userRewardPerTokenPaid[account][_rewardsToken])).div(1e18).add(rewards[account][_rewardsToken]);
    }
    
    function earnedLifetime(address account, address _rewardsToken) public view returns (uint256) {
        uint256 notClaimed = earned(account, _rewardsToken);
        return notClaimed.add(claimedRewards[account][_rewardsToken]);
    }    

    function getRewardForDuration(address _rewardsToken) external view returns (uint256) {
        return rewardData[_rewardsToken].rewardRate.mul(rewardData[_rewardsToken].rewardsDuration);
    }
    
    function unlockedStakeAtTime(address account, uint256 thisTime, uint256 stakeI) public view returns (uint256) {
	    if (userStakes[account][stakeI].remainingBalance > 0 && 
	            (block.timestamp >= rewardData[rewardTokens[0]].periodFinish || userStakes[account][stakeI].stakingMaturity <= thisTime ) )		
	        return userStakes[account][stakeI].remainingBalance;
        else
            return 0;
    }

    function unlockedStake(address account) public view returns (uint256) {
	    uint256 actualAmount = 0;
	    uint256 thisTest = lastTimeRewardApplicable(rewardTokens[0]);
        for (uint i; i < userStakes[account].length; i++) {
		    actualAmount = actualAmount.add(unlockedStakeAtTime(account, thisTest, i));
	    }
	    require(actualAmount <= _balances[account], "internal 0");
        return actualAmount;
    }

    // returns the index in rewardRatePerToken s.t. time[index]<= timeT and time[sss+1]>timeT.
    // corner cases:
    //      if timeT >= time[length-1], return length-1
    //      if timeT <= time[0], return 0
    function indexForRate(address _rewardsToken, uint256 timeT) public view returns (uint256) {
        uint256 length = rewardRatePerToken[_rewardsToken].length;
        uint256 sss = length-1;

        if (length > 1) {    
            for (uint256 j=1; j < length; j++) {
                if (timeT < rewardRatePerToken[_rewardsToken][j].startingTime) {  // rewardRatePerToken[account][j].startingTime is the ending time for j-1 period
                    sss = j.sub(1);
                    break;
                }          
            }
        } else if (length == 1)
            sss = 0;
        else
            sss = 1;   // length == 0, return length+1, invalid

        return sss;
    }

    // returns the index in userStakeBalance s.t. time[index]<= timeT and time[sss+1]>timeT.
    // corner cases:
    //      if timeT >= time[length-1], return length-1
    //      if timeT <= time[0], return 0
    function indexForBalance(address account, uint256 timeT) public view returns (uint256) {
        uint256 length = userStakeBalance[account].length;
        uint256 sss = length-1;

        if (length > 1) {    
            for (uint256 j=1; j < length; j++) {
                if (timeT < userStakeBalance[account][j].startingTime) {  // userStakeBalance[account][j].startingTime is the ending time for j-1 period
                    sss = j.sub(1);
                    break;
                }          
            }
        } else if (length == 1)
            sss = 0;
        else
            sss = 1;   // length == 0, return length+1, invalid

        return sss;
    }

    function rewardForNotionalPeriod(uint256 notional, uint256 rewardRate, uint256 start, uint256 end) public pure returns (uint256) {
        require(start <= end, "time 1");
        uint256 reward = notional.mul(rewardRate).div(1e18).mul(end.sub(start));
        return reward;
    }   

    // returns accumulated rewards from time start to end for account on _rewardsToken
    // start is restricted to on or after the first starting time at the earliest for the account
    // end is restricted to be the earliest time of 1) end  2) maturity 3) the current block time
    // so no reward is generated after maturity
    // the ratePerToken across the maturity has to be handled carefully
    function rewardForTimePeriod(address account, address _rewardsToken, uint256 start, uint256 end) public view returns (uint256) {
        if (userStakeBalance[account].length==0)
            return 0;
        if (start >= lastTimeRewardApplicable(_rewardsToken))
            return 0;  // no reward after the applicable time
        start = Math.max(start, userStakeBalance[account][0].startingTime);
        if (end > lastTimeRewardApplicable(_rewardsToken))
            end = lastTimeRewardApplicable(_rewardsToken);
        require(start < end, "time 0");      

        uint256 balIndex = indexForBalance(account, start); 
        require(balIndex < userStakeBalance[account].length, "balance idx 0");  

        uint256 timeIndex = indexForRate(_rewardsToken, start);
        require(timeIndex < rewardRatePerToken[_rewardsToken].length, "rate idx 0");       

        uint256 accReward = 0;    
        if (timeIndex == rewardRatePerToken[_rewardsToken].length -1) {
            accReward = rewardForNotionalPeriod(userStakeBalance[account][balIndex].sBalance, rewardRatePerToken[_rewardsToken][timeIndex].ratePerToken, start, end );
        } else {
            // case for timeIndex < length-1, so myStart < time[length-1]

            // solving the stack too deep problem: separating the first period here  
            {
                uint256 endT = Math.min(end, rewardRatePerToken[_rewardsToken][timeIndex+1].startingTime);
                accReward = rewardForNotionalPeriod(userStakeBalance[account][balIndex].sBalance, rewardRatePerToken[_rewardsToken][timeIndex].ratePerToken, start, endT);
                timeIndex = timeIndex.add(1);  // done the current time period, moving to the next one
            }

            // integrating intermediate steps.  
            // each step integrating from rewardRatePerToken[_rewardsToken][iii].startingTime to rewardRatePerToken[_rewardsToken][iii+1].startingTime
            // so the loop can only end at length-1
            for ( uint256 iii = timeIndex; iii< rewardRatePerToken[_rewardsToken].length.sub(1); iii++ ) {
                if (end <= rewardRatePerToken[_rewardsToken][iii].startingTime)
                    break;
                // going to the right balIndex if necessary.  the very last one does not have restriction of time
                if (balIndex < userStakeBalance[account].length.sub(1)) {
                    // userStakeBalance[account][balIndex.add(1)].startingTime is the end time for balIndex
                    // rewardRatePerToken[_rewardsToken][iii].startingTime is the starting time for iii
                    if (userStakeBalance[account][balIndex.add(1)].startingTime <= rewardRatePerToken[_rewardsToken][iii].startingTime)
                        balIndex = balIndex.add(1);
                }
                if (end <= rewardRatePerToken[_rewardsToken][iii+1].startingTime) {
                    accReward = accReward.add( rewardForNotionalPeriod(userStakeBalance[account][balIndex].sBalance, rewardRatePerToken[_rewardsToken][iii].ratePerToken, rewardRatePerToken[_rewardsToken][iii].startingTime, end ));
                    break;
                } else
                    accReward = accReward.add( rewardForNotionalPeriod(userStakeBalance[account][balIndex].sBalance, rewardRatePerToken[_rewardsToken][iii].ratePerToken, rewardRatePerToken[_rewardsToken][iii].startingTime, rewardRatePerToken[_rewardsToken][iii+1].startingTime )); 
            }

            // handling the last time period, timeIndex == length-1.  the rate of the last one applies for [lastPeriodTime, maturity)
            // note for current case, myStart < time[length-1]
            {
                uint256 lastIdx = rewardRatePerToken[_rewardsToken].length.sub(1);
                uint256 lastPeriodTime = rewardRatePerToken[_rewardsToken][lastIdx].startingTime;
                if (end > lastPeriodTime) {
                    // userStakeBalance[account][balIndex.add(1)].startingTime is the end time for balIndex
                    // lastPeriodTime is the starting time for the period beyond the end of time index
                    if (balIndex < userStakeBalance[account].length.sub(1)) {
                        if (userStakeBalance[account][balIndex.add(1)].startingTime <= lastPeriodTime)
                            balIndex = balIndex.add(1);
                    }    
                    accReward = accReward.add( rewardForNotionalPeriod(userStakeBalance[account][balIndex].sBalance, rewardRatePerToken[_rewardsToken][lastIdx].ratePerToken, lastPeriodTime, end ));                       
                }  
            }                       
        }

        return accReward;
    }      

    function checkRewardForTimePeriod(address account, address _rewardsToken) public view returns (uint256) {
        if (userStakeBalance[account].length == 0)
            return 0;
        uint256 totalReward = earnedLifetime(account,  _rewardsToken);
        uint256 rewardFromIntegration = rewardForTimePeriod( account,  _rewardsToken, userStakeBalance[account][0].startingTime, block.timestamp);
        require(totalReward >= rewardFromIntegration, "check 0");
        return totalReward.sub(rewardFromIntegration);
    }  

    function rewardUnlockCutoffTime(address _rewardsToken) public view returns (uint256) {
        return Math.min(block.timestamp.sub(lockDuration), rewardData[_rewardsToken].periodFinish);
    }

    function unlockedReward(address account, address _rewardsToken) public view returns (uint256) {
        uint256 sss = userStakeBalance[account].length;
        if (sss==0)
            return 0;
        uint256 startT = userStakeBalance[account][0].startingTime;
        uint256 endT = rewardUnlockCutoffTime(_rewardsToken);
        if (endT <= startT)
            return 0;
        uint256 rewardUnLocked = rewardForTimePeriod( account, _rewardsToken, startT, endT);
        rewardUnLocked = rewardUnLocked.sub(claimedRewards[account][_rewardsToken]);
        uint256 earnedAmount = earned( account, _rewardsToken);
        rewardUnLocked = Math.min(rewardUnLocked, earnedAmount);    // to eusure no possibility of overpaying
        return rewardUnLocked;
    }      
    
    function distributorRemainingReward(address _rewardsToken) public view returns (uint256) {
        return rewards[rewardData[_rewardsToken].rewardsDistributor][_rewardsToken];
    }
    
    function userInfoByIndexRange(address account, uint256 _start, uint256 _stop) external view returns (uint256[2][] memory)  {
        uint256 _allStakeLength = userStakes[account].length;
        if (_stop > _allStakeLength) {
            _stop = _allStakeLength;
        }
        require(_stop >= _start, "start cannot be higher than stop");
        uint256 _qty = _stop - _start;
        uint256[2][] memory result = new uint256[2][](_qty);
        for (uint i = 0; i < _qty; i++) {
            result[i][0] = userStakes[account][_start + i].stakingMaturity;
            result[i][1] = userStakes[account][_start + i].remainingBalance;         
        }
        return result;
    }    

    /* ========== MUTATIVE FUNCTIONS ========== */

    function setRewardsDistributor(address _rewardsToken, address _rewardsDistributor) external onlyOwner {
        require(_rewardsToken != address(0) && _rewardsDistributor != address(0), "Zero address not allowed");
        rewardData[_rewardsToken].rewardsDistributor = _rewardsDistributor;
        emit RewardsDistributorUpdated(_rewardsToken, _rewardsDistributor);
    }

    function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
        require(amount > 0, "Cannot stake 0");
        uint256 previousBalance = IERC20(stakingToken).balanceOf(address(this));
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        uint256 actualAmount = IERC20(stakingToken).balanceOf(address(this)).sub(previousBalance);
        actualAmount = Math.min(actualAmount, amount);
        _totalSupply = _totalSupply.add(actualAmount);
        _balances[msg.sender] = _balances[msg.sender].add(actualAmount);

        if (actualAmount > 0) {
            userStakes[msg.sender].push(Stake(block.timestamp.add(lockDuration), actualAmount));

            {  
                uint256 prev = userStakeBalance[msg.sender].length;
                if (prev > 0 && block.timestamp == userStakeBalance[msg.sender][prev-1].startingTime)
                    // in case the user can stake more than once within the same block.  no reward is generated within this block yet
                    userStakeBalance[msg.sender][prev-1].sBalance = _balances[msg.sender];  
                else
                    userStakeBalance[msg.sender].push(StakeBalance(block.timestamp, _balances[msg.sender]));
            } 
            for (uint i = 0; i < rewardTokens.length; i++) {
                require(block.timestamp < rewardData[rewardTokens[i]].periodFinish, "maturity 0");
                uint256 prev = rewardRatePerToken[rewardTokens[i]].length;
                uint256 reward_rate = 0;
                if (_totalSupply > 0 )
                    reward_rate = rewardData[rewardTokens[i]].rewardRate.mul(1e18).div(_totalSupply);
                if (prev > 0 && block.timestamp == rewardRatePerToken[rewardTokens[i]][prev-1].startingTime)  // in case same block stake or withdraw
                    rewardRatePerToken[rewardTokens[i]][prev-1].ratePerToken = reward_rate; 
                else          
                    rewardRatePerToken[rewardTokens[i]].push(RewardRate(block.timestamp, reward_rate ) );   
            }  
        }

        emit Staked(msg.sender, actualAmount);
    }

    function withdraw(uint256 amount) public nonReentrant notPaused updateReward(msg.sender) {
        require(amount > 0, "Cannot withdraw 0");
	    uint256 askedAmount = Math.min(amount, _balances[msg.sender]);
	    uint256 actualAmount = 0;
	    uint256 thisTest = lastTimeRewardApplicable(rewardTokens[0]);
        for (uint i; i < userStakes[msg.sender].length; i++) {
            uint256 outAmount = unlockedStakeAtTime(msg.sender, thisTest, i);
            if (outAmount > 0) {
                outAmount = Math.min(outAmount, askedAmount);
	   	        userStakes[msg.sender][i].remainingBalance = userStakes[msg.sender][i].remainingBalance.sub(outAmount);	   
 	   	        askedAmount = askedAmount.sub(outAmount);
		        actualAmount = actualAmount.add(outAmount);
            }
            if (askedAmount == 0)
        	    break;
	    }
        require(actualAmount > 0 && actualAmount <= amount && actualAmount <= _balances[msg.sender], "No unlocked stake");    
        _totalSupply = _totalSupply.sub(actualAmount);
        _balances[msg.sender] = _balances[msg.sender].sub(actualAmount);

        {  
            uint256 prev = userStakeBalance[msg.sender].length;
            if (prev > 0 && block.timestamp == userStakeBalance[msg.sender][prev-1].startingTime)
                userStakeBalance[msg.sender][prev-1].sBalance = _balances[msg.sender];  // in case the user can withdraw more than once within the same block
            else
                userStakeBalance[msg.sender].push(StakeBalance(block.timestamp, _balances[msg.sender]));
        }
        for (uint i = 0; i < rewardTokens.length; i++) {
            uint256 prev = rewardRatePerToken[rewardTokens[i]].length;
            uint256 reward_rate = 0;
            if (_totalSupply > 0 && block.timestamp < rewardData[rewardTokens[i]].periodFinish)
                reward_rate = rewardData[rewardTokens[i]].rewardRate.mul(1e18).div(_totalSupply);
            if (prev > 0 && block.timestamp == rewardRatePerToken[rewardTokens[i]][prev-1].startingTime)  // in case same block stake or withdraw
                rewardRatePerToken[rewardTokens[i]][prev-1].ratePerToken = reward_rate; 
            else          
                rewardRatePerToken[rewardTokens[i]].push(RewardRate(block.timestamp, reward_rate ) );   
        } 

        stakingToken.safeTransfer(msg.sender, actualAmount);
        emit Withdrawn(msg.sender, actualAmount);
    }

    function getReward() public nonReentrant notPaused updateReward(msg.sender) {
        for (uint i; i < rewardTokens.length; i++) {
            address _rewardsToken = rewardTokens[i];
            uint256 reward = rewards[msg.sender][_rewardsToken];
            uint256 actualAmount = unlockedReward(msg.sender, _rewardsToken);
            actualAmount = Math.min(actualAmount, reward);
            if (actualAmount > 0) {  // let 0 case pass so that exit and other i's work
                rewards[msg.sender][_rewardsToken] = rewards[msg.sender][_rewardsToken].sub(actualAmount);
                claimedRewards[msg.sender][_rewardsToken] = actualAmount.add(claimedRewards[msg.sender][_rewardsToken]);
                IERC20(_rewardsToken).safeTransfer(msg.sender, actualAmount);
                emit RewardPaid(msg.sender, _rewardsToken, actualAmount);
            }
        }
    }

    function exit() external {
        withdraw(_balances[msg.sender]);
        getReward();
    }

    /* ========== RESTRICTED FUNCTIONS ========== */

    function notifyRewardAmount(address _rewardsToken, uint256 reward) external updateReward(address(0)) {
        require(rewardData[_rewardsToken].rewardsDistributor == msg.sender);
        // handle the transfer of reward tokens via `transferFrom` to reduce the number
        // of transactions required and ensure correctness of the reward amount
        IERC20(_rewardsToken).safeTransferFrom(msg.sender, address(this), reward);

        if (block.timestamp >= rewardData[_rewardsToken].periodFinish) {
            rewardData[_rewardsToken].rewardRate = reward.div(rewardData[_rewardsToken].rewardsDuration);
        } else {
            uint256 remaining = rewardData[_rewardsToken].periodFinish.sub(block.timestamp);
            uint256 leftover = remaining.mul(rewardData[_rewardsToken].rewardRate);
            rewardData[_rewardsToken].rewardRate = reward.add(leftover).div(rewardData[_rewardsToken].rewardsDuration);
        }
        rewardData[_rewardsToken].lastUpdateTime = block.timestamp;
        rewardData[_rewardsToken].periodFinish = block.timestamp.add(rewardData[_rewardsToken].rewardsDuration);
        emit RewardAdded(reward);
    }

    function collectRemainingReward(address _rewardsToken) external nonReentrant updateReward(address(0)) {
        require(rewardData[_rewardsToken].rewardsDistributor == msg.sender);
        require(block.timestamp >= rewardData[_rewardsToken].periodFinish);
        uint256 amount = rewards[msg.sender][_rewardsToken];
        if (amount > 0) {
            rewards[msg.sender][_rewardsToken] = 0;
            IERC20(_rewardsToken).safeTransfer(msg.sender, amount);
        }
    }

    // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
    function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
        require(tokenAddress != address(stakingToken), "Cannot withdraw staking token");
        require(rewardData[tokenAddress].lastUpdateTime == 0, "Cannot withdraw reward token");
        IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
        emit Recovered(tokenAddress, tokenAmount);
    }

    /* ========== MODIFIERS ========== */

    modifier updateReward(address account) {
        for (uint i; i < rewardTokens.length; i++) {
            address token = rewardTokens[i];
            
            if (_totalSupply == 0)
                rewards[rewardData[token].rewardsDistributor][token] = lastTimeRewardApplicable(token).sub(rewardData[token].lastUpdateTime).mul(rewardData[token].rewardRate).add(rewards[rewardData[token].rewardsDistributor][token]);
            
            rewardData[token].rewardPerTokenStored = rewardPerToken(token);
            rewardData[token].lastUpdateTime = lastTimeRewardApplicable(token);
            if (account != address(0)) {
                rewards[account][token] = earned(account, token);
                userRewardPerTokenPaid[account][token] = rewardData[token].rewardPerTokenStored;
            }
        }
        _;
    }

    /* ========== EVENTS ========== */

    event RewardAdded(uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, address indexed rewardsToken, uint256 reward);
    event RewardsDistributorUpdated(address indexed token, address indexed newDistributor);
    event RewardsDurationUpdated(address indexed token, uint256 newDuration);
    event Recovered(address token, uint256 amount);
}