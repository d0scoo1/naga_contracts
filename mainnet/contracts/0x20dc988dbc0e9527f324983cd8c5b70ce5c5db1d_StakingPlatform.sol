// SPDX-License-Identifier: MIT
pragma solidity =0.8.10;

abstract contract Context {
    //function _msgSender() internal view virtual returns (address payable) {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
    * @dev Leaves the contract without owner. It will not be possible to call
    * `onlyOwner` functions anymore. Can only be called by the current owner.
    *
    * NOTE: Renouncing ownership will leave the contract without an owner,
    * thereby removing any functionality that is only available to the owner.
    */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

}

interface IERC20 {

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
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
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
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}



/// @author RetreebInc
/// @title Interface Staking Platform with fixed APY and lockup
interface IStakingPlatform {
    /**
     * @notice function that start the staking
     * @dev set `startPeriod` to the current current `block.timestamp`
     * set `lockupPeriod` which is `block.timestamp` + `lockupDuration`
     * and `endPeriod` which is `startPeriod` + `stakingDuration`
     */
    function startStaking() external;

    /**
     * @notice function that allows a user to deposit tokens
     * @dev user must first approve the amount to deposit before calling this function,
     * cannot exceed the `maxAmountStaked`
     * @param amount, the amount to be deposited
     * @dev `endPeriod` to equal 0 (Staking didn't started yet),
     * or `endPeriod` more than current `block.timestamp` (staking not finished yet)
     * @dev `totalStaked + amount` must be less than `stakingMax`
     * @dev that the amount deposited should greater than 0
     */
    function deposit(uint amount) external;

    /**
     * @notice function that allows a user to withdraw its initial deposit
     * @dev must be called only when `block.timestamp` >= `endPeriod`
     * @dev `block.timestamp` higher than `lockupPeriod` (lockupPeriod finished)
     * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
     * if rewards to claim
     */
    function withdrawAll() external;

    /**
     * @notice function that allows a user to withdraw its initial deposit
     * @param amount, amount to withdraw
     * @dev `block.timestamp` must be higher than `lockupPeriod` (lockupPeriod finished)
     * @dev `amount` must be higher than `0`
     * @dev `amount` must be lower or equal to the amount staked
     * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
     * if rewards to claim
     */
    function withdraw(uint amount) external;

    /**
     * @notice function that returns the amount of total Staked tokens
     * for a specific user
     * @param stakeHolder, address of the user to check
     * @return uint amount of the total deposited Tokens by the caller
     */
    function amountStaked(address stakeHolder) external view returns (uint);

    /**
     * @notice function that returns the amount of total Staked tokens
     * on the smart contract
     * @return uint amount of the total deposited Tokens
     */
    function totalDeposited() external view returns (uint);

    /**
     * @notice function that returns the amount of pending rewards
     * that can be claimed by the user
     * @param stakeHolder, address of the user to be checked
     * @return uint amount of claimable rewards
     */
    function rewardOf(address stakeHolder) external view returns (uint);

    /**
     * @notice function that claims pending rewards
     * @dev transfer the pending rewards to the `msg.sender`
     */
    function claimRewards() external;

    /**
     * @dev Emitted when `amount` tokens are deposited into
     * staking platform
     */
    event Deposit(address indexed owner, uint amount);

    /**
     * @dev Emitted when user withdraw deposited `amount`
     */
    event Withdraw(address indexed owner, uint amount);

    /**
     * @dev Emitted when `stakeHolder` claim rewards
     */
    event Claim(address indexed stakeHolder, uint amount);

    /**
     * @dev Emitted when staking has started
     */
    event StartStaking(uint startPeriod, uint lockupPeriod, uint endingPeriod);
}


/// @author RetreebInc
/// @title Staking Platform with fixed APY and lockup
contract StakingPlatform is IStakingPlatform, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;

    uint8 public immutable fixedAPY;

    uint public immutable stakingDuration;
    uint public immutable lockupDuration;
    uint public immutable stakingMax;

    uint public startPeriod;
    uint public lockupPeriod;
    uint public endPeriod;

    uint private _totalStaked;
    uint internal _precision = 1E6;

    mapping(address => uint) public staked;
    mapping(address => uint) private _rewardsToClaim;
    mapping(address => uint) private _userStartTime;

    /**
     * @notice constructor contains all the parameters of the staking platform
     * @dev all parameters are immutable
     */
    constructor(
        address _token,
        uint8 _fixedAPY,
        uint _durationInDays,
        uint _lockDurationInDays,
        uint _maxAmountStaked
    ) {
        stakingDuration = _durationInDays * 1 days;
        lockupDuration = _lockDurationInDays * 1 days;
        token = IERC20(_token);
        fixedAPY = _fixedAPY;
        stakingMax = _maxAmountStaked;
    }

    /**
     * @notice function that start the staking
     * @dev set `startPeriod` to the current current `block.timestamp`
     * set `lockupPeriod` which is `block.timestamp` + `lockupDuration`
     * and `endPeriod` which is `startPeriod` + `stakingDuration`
     */
    function startStaking() external override onlyOwner {
        require(startPeriod == 0, "Staking has already started");
        startPeriod = block.timestamp;
        lockupPeriod = block.timestamp + lockupDuration;
        endPeriod = block.timestamp + stakingDuration;
        emit StartStaking(startPeriod, lockupDuration, endPeriod);
    }

    /**
     * @notice function that allows a user to deposit tokens
     * @dev user must first approve the amount to deposit before calling this function,
     * cannot exceed the `maxAmountStaked`
     * @param amount, the amount to be deposited
     * @dev `endPeriod` to equal 0 (Staking didn't started yet),
     * or `endPeriod` more than current `block.timestamp` (staking not finished yet)
     * @dev `totalStaked + amount` must be less than `stakingMax`
     * @dev that the amount deposited should greater than 0
     */
    function deposit(uint amount) external override {
        require(
            endPeriod == 0 || endPeriod > block.timestamp,
            "Staking period ended"
        );
        require(
            _totalStaked + amount <= stakingMax,
            "Amount staked exceeds MaxStake"
        );
        require(amount > 0, "Amount must be greater than 0");

        if (_userStartTime[_msgSender()] == 0) {
            _userStartTime[_msgSender()] = block.timestamp;
        }

        _updateRewards();

        staked[_msgSender()] += amount;
        _totalStaked += amount;
        token.safeTransferFrom(_msgSender(), address(this), amount);
        emit Deposit(_msgSender(), amount);
    }

    /**
     * @notice function that allows a user to withdraw its initial deposit
     * @param amount, amount to withdraw
     * @dev `block.timestamp` must be higher than `lockupPeriod` (lockupPeriod finished)
     * @dev `amount` must be higher than `0`
     * @dev `amount` must be lower or equal to the amount staked
     * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
     * if rewards to claim
     */
    function withdraw(uint amount) external override {
        require(
            block.timestamp >= lockupPeriod,
            "No withdraw until lockup ends"
        );
        require(amount > 0, "Amount must be greater than 0");
        require(
            amount <= staked[_msgSender()],
            "Amount higher than stakedAmount"
        );

        _updateRewards();
        if (_rewardsToClaim[_msgSender()] > 0) {
            _claimRewards();
        }
        _totalStaked -= amount;
        staked[_msgSender()] -= amount;
        token.safeTransfer(_msgSender(), amount);

        emit Withdraw(_msgSender(), amount);
    }

    /**
     * @notice function that allows a user to withdraw its initial deposit
     * @dev must be called only when `block.timestamp` >= `lockupPeriod`
     * @dev `block.timestamp` higher than `lockupPeriod` (lockupPeriod finished)
     * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
     * if rewards to claim
     */
    function withdrawAll() external override {
        require(
            block.timestamp >= lockupPeriod,
            "No withdraw until lockup ends"
        );

        _updateRewards();
        if (_rewardsToClaim[_msgSender()] > 0) {
            _claimRewards();
        }

        _userStartTime[_msgSender()] = 0;
        _totalStaked -= staked[_msgSender()];
        uint stakedBalance = staked[_msgSender()];
        staked[_msgSender()] = 0;
        token.safeTransfer(_msgSender(), stakedBalance);

        emit Withdraw(_msgSender(), stakedBalance);
    }

    /**
     * @notice claim all remaining balance on the contract
     * Residual balance is all the remaining tokens that have not been distributed
     * (e.g, in case the number of stakeholders is not sufficient)
     * @dev Can only be called one year after the end of the staking period
     * Cannot claim initial stakeholders deposit
     */
    function withdrawResidualBalance() external onlyOwner {
        require(
            block.timestamp >= endPeriod + (365 * 1 days),
            "Withdraw 1year after endPeriod"
        );

        uint balance = token.balanceOf(address(this));
        uint residualBalance = balance - (_totalStaked);
        require(residualBalance > 0, "No residual Balance to withdraw");
        token.safeTransfer(owner(), residualBalance);
    }

    /**
     * @notice function that returns the amount of total Staked tokens
     * for a specific user
     * @param stakeHolder, address of the user to check
     * @return uint amount of the total deposited Tokens by the caller
     */
    function amountStaked(address stakeHolder)
        external
        view
        override
        returns (uint)
    {
        return staked[stakeHolder];
    }

    /**
     * @notice function that returns the amount of total Staked tokens
     * on the smart contract
     * @return uint amount of the total deposited Tokens
     */
    function totalDeposited() external view override returns (uint) {
        return _totalStaked;
    }

    /**
     * @notice function that returns the amount of pending rewards
     * that can be claimed by the user
     * @param stakeHolder, address of the user to be checked
     * @return uint amount of claimable rewards
     */
    function rewardOf(address stakeHolder)
        external
        view
        override
        returns (uint)
    {
        return _calculateRewards(stakeHolder);
    }

    /**
     * @notice function that claims pending rewards
     * @dev transfer the pending rewards to the `msg.sender`
     */
    function claimRewards() external override {
        _claimRewards();
    }

    /**
     * @notice calculate rewards based on the `fixedAPY`, `_percentageTimeRemaining()`
     * @dev the higher is the precision and the more the time remaining will be precise
     * @param stakeHolder, address of the user to be checked
     * @return uint amount of claimable tokens of the specified address
     */
    function _calculateRewards(address stakeHolder)
        internal
        view
        returns (uint)
    {
        if (startPeriod == 0 || staked[stakeHolder] == 0) {
            return 0;
        }

        return
            (((staked[stakeHolder] * fixedAPY) *
                _percentageTimeRemaining(stakeHolder)) / (_precision * 100)) +
            _rewardsToClaim[stakeHolder];
    }

    /**
     * @notice function that returns the remaining time in seconds of the staking period
     * @dev the higher is the precision and the more the time remaining will be precise
     * @param stakeHolder, address of the user to be checked
     * @return uint percentage of time remaining * precision
     */
    function _percentageTimeRemaining(address stakeHolder)
        internal
        view
        returns (uint)
    {
        bool early = startPeriod > _userStartTime[stakeHolder];
        uint startTime;
        if (endPeriod > block.timestamp) {
            startTime = early ? startPeriod : _userStartTime[stakeHolder];
            uint timeRemaining = stakingDuration -
                (block.timestamp - startTime);
            return
                (_precision * (stakingDuration - timeRemaining)) /
                stakingDuration;
        }
        startTime = early
            ? 0
            : stakingDuration - (endPeriod - _userStartTime[stakeHolder]);
        return (_precision * (stakingDuration - startTime)) / stakingDuration;
    }

    /**
     * @notice internal function that claims pending rewards
     * @dev transfer the pending rewards to the user address
     */
    function _claimRewards() private {
        _updateRewards();

        uint rewardsToClaim = _rewardsToClaim[_msgSender()];
        require(rewardsToClaim > 0, "Nothing to claim");

        _rewardsToClaim[_msgSender()] = 0;
        token.safeTransfer(_msgSender(), rewardsToClaim);
        emit Claim(_msgSender(), rewardsToClaim);
    }

    /**
     * @notice function that update pending rewards
     * and shift them to rewardsToClaim
     * @dev update rewards claimable
     * and check the time spent since deposit for the `msg.sender`
     */
    function _updateRewards() private {
        _rewardsToClaim[_msgSender()] = _calculateRewards(_msgSender());
        _userStartTime[_msgSender()] = (block.timestamp >= endPeriod)
            ? endPeriod
            : block.timestamp;
    }
}