// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

// OpenZeppelin Contracts (last updated v4.6.0-rc.0) (token/ERC20/IERC20.sol)



/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

/// @notice An error used to indicate that an argument passed to a function is illegal or
///         inappropriate.
///
/// @param message The error message.
error IllegalArgument(string message);

/// @notice An error used to indicate that a function has encountered an unrecoverable state.
///
/// @param message The error message.
error IllegalState(string message);

/// @notice An error used to indicate that an operation is unsupported.
///
/// @param message The error message.
error UnsupportedOperation(string message);

/// @notice An error used to indicate that a message sender tried to execute a privileged function.
///
/// @param message The error message.
error Unauthorized(string message);
/// @title  Multicall
/// @author Uniswap Labs
///
/// @notice Enables calling multiple methods in a single call to the contract
abstract contract Multicall {
    error MulticallFailed(bytes data, bytes result);

    function multicall(
        bytes[] calldata data
    ) external payable returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);

            if (!success) {
                revert MulticallFailed(data[i], result);
            }

            results[i] = result;
        }
    }
}
/// @title  Mutex
/// @author Alchemix Finance
///
/// @notice Provides a mutual exclusion lock for implementing contracts.
abstract contract Mutex {
    enum State {
        RESERVED,
        UNLOCKED,
        LOCKED
    }

    /// @notice The lock state.
    State private _lockState = State.UNLOCKED;

    /// @dev A modifier which acquires the mutex.
    modifier lock() {
        _claimLock();

        _;

        _freeLock();
    }

    /// @dev Gets if the mutex is locked.
    ///
    /// @return if the mutex is locked.
    function _isLocked() internal view returns (bool) {
        return _lockState == State.LOCKED;
    }

    /// @dev Claims the lock. If the lock is already claimed, then this will revert.
    function _claimLock() internal {
        // Check that the lock has not been claimed yet.
        if (_lockState != State.UNLOCKED) {
            revert IllegalState("Lock already claimed");
        }

        // Claim the lock.
        _lockState = State.LOCKED;
    }

    /// @dev Frees the lock.
    function _freeLock() internal {
        _lockState = State.UNLOCKED;
    }
}

/// @title  IERC20TokenReceiver
/// @author Alchemix Finance
interface IERC20TokenReceiver {
    /// @notice Informs implementors of this interface that an ERC20 token has been transferred.
    ///
    /// @param token The token that was transferred.
    /// @param value The amount of the token that was transferred.
    function onERC20Received(address token, uint256 value) external;
}
/// @title  IERC20Metadata
/// @author Alchemix Finance
interface IERC20Metadata {
    /// @notice Gets the name of the token.
    ///
    /// @return The name.
    function name() external view returns (string memory);

    /// @notice Gets the symbol of the token.
    ///
    /// @return The symbol.
    function symbol() external view returns (string memory);

    /// @notice Gets the number of decimals that the token has.
    ///
    /// @return The number of decimals.
    function decimals() external view returns (uint8);
}

/// @title IWETH9
interface IWETH9 is IERC20, IERC20Metadata {
  /// @notice Deposits `msg.value` ethereum into the contract and mints `msg.value` tokens.
  function deposit() external payable;

  /// @notice Burns `amount` tokens to retrieve `amount` ethereum from the contract.
  ///
  /// @dev This version of WETH utilizes the `transfer` function which hard codes the amount of gas
  ///      that is allowed to be utilized to be exactly 2300 when receiving ethereum.
  ///
  /// @param amount The amount of tokens to burn.
  function withdraw(uint256 amount) external;
}
interface IConvexBooster {
    function deposit(uint256 pid, uint256 amount, bool stake) external returns (bool);
    function withdraw(uint256 pid, uint256 amount) external returns (bool);
}
interface IConvexRewards {
    function rewardToken() external view returns (IERC20);
    function earned(address account) external view returns (uint256);
    function extraRewards(uint256 index) external view returns (address);
    function balanceOf(address account) external returns(uint256);
    function withdraw(uint256 amount, bool claim) external returns (bool);
    function withdrawAndUnwrap(uint256 amount, bool claim) external returns (bool);
    function getReward() external returns (bool);
    function getReward(address recipient, bool claim) external returns (bool);
    function stake(uint256 amount) external returns (bool);
    function stakeFor(address account, uint256 amount) external returns (bool);
}
interface IConvexToken is IERC20 {
    function maxSupply() external view returns (uint256);
    function totalCliffs() external view returns (uint256);
    function reductionPerCliff() external view returns (uint256);
}

uint256 constant N_COINS = 2;

interface IEthStableMetaPool is IERC20 {
    function get_balances() external view returns (uint256[N_COINS] memory);

    function coins(uint256 index) external view returns (IERC20);

    function A() external view returns (uint256);

    function get_virtual_price() external view returns (uint256);

    function calc_token_amount(
        uint256[N_COINS] calldata amounts,
        bool deposit
    ) external view returns (uint256 amount);

    function add_liquidity(
        uint256[N_COINS] calldata amounts,
        uint256 minimumMintAmount
    ) external payable returns (uint256 minted);

    function get_dy(int128 i, int128 j, uint256 dx) external view returns (uint256 dy);

    function get_dy_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256[N_COINS] calldata balances
    ) external view returns (uint256 dy);

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 minimumDy
    ) external payable returns (uint256);

    function remove_liquidity(uint256 amount, uint256[N_COINS] calldata minimumAmounts) external;

    function remove_liquidity_imbalance(
        uint256[N_COINS] calldata amounts,
        uint256 maximumBurnAmount
    ) external returns (uint256);

    function calc_withdraw_one_coin(uint256 tokenAmount, int128 i) external view returns (uint256);

    function remove_liquidity_one_coin(
        uint256 tokenAmount,
        int128 i,
        uint256 minimumAmount
    ) external returns (uint256);

    function get_price_cumulative_last() external view returns (uint256[N_COINS] calldata);

    function block_timestamp_last() external view returns (uint256);

    function get_twap_balances(
        uint256[N_COINS] calldata firstBalances,
        uint256[N_COINS] calldata lastBalances,
        uint256 timeElapsed
    ) external view returns (uint256[N_COINS] calldata);

    function get_dy(
        int128 i,
        int128 j,
        uint256 dx,
        uint256[N_COINS] calldata balances
    ) external view returns (uint256);
}

/// @title  SafeERC20
/// @author Alchemix Finance
library SafeERC20 {
    /// @notice An error used to indicate that a call to an ERC20 contract failed.
    ///
    /// @param target  The target address.
    /// @param success If the call to the token was a success.
    /// @param data    The resulting data from the call. This is error data when the call was not a
    ///                success. Otherwise, this is malformed data when the call was a success.
    error ERC20CallFailed(address target, bool success, bytes data);

    /// @dev A safe function to get the decimals of an ERC20 token.
    ///
    /// @dev Reverts with a {CallFailed} error if execution of the query fails or returns an
    ///      unexpected value.
    ///
    /// @param token The target token.
    ///
    /// @return The amount of decimals of the token.
    function expectDecimals(address token) internal view returns (uint8) {
        (bool success, bytes memory data) = token.staticcall(
            abi.encodeWithSelector(IERC20Metadata.decimals.selector)
        );

        if (!success || data.length < 32) {
            revert ERC20CallFailed(token, success, data);
        }

        return abi.decode(data, (uint8));
    }

    /// @dev Transfers tokens to another address.
    ///
    /// @dev Reverts with a {CallFailed} error if execution of the transfer failed or returns an
    ///      unexpected value.
    ///
    /// @param token     The token to transfer.
    /// @param recipient The address of the recipient.
    /// @param amount    The amount of tokens to transfer.
    function safeTransfer(address token, address recipient, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.transfer.selector, recipient, amount)
        );

        if (!success || (data.length != 0 && !abi.decode(data, (bool)))) {
            revert ERC20CallFailed(token, success, data);
        }
    }

    /// @dev Approves tokens for the smart contract.
    ///
    /// @dev Reverts with a {CallFailed} error if execution of the approval fails or returns an
    ///      unexpected value.
    ///
    /// @param token   The token to approve.
    /// @param spender The contract to spend the tokens.
    /// @param value   The amount of tokens to approve.
    function safeApprove(address token, address spender, uint256 value) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.approve.selector, spender, value)
        );

        if (!success || (data.length != 0 && !abi.decode(data, (bool)))) {
            revert ERC20CallFailed(token, success, data);
        }
    }

    /// @dev Transfer tokens from one address to another address.
    ///
    /// @dev Reverts with a {CallFailed} error if execution of the transfer fails or returns an
    ///      unexpected value.
    ///
    /// @param token     The token to transfer.
    /// @param owner     The address of the owner.
    /// @param recipient The address of the recipient.
    /// @param amount    The amount of tokens to transfer.
    function safeTransferFrom(address token, address owner, address recipient, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.transferFrom.selector, owner, recipient, amount)
        );

        if (!success || (data.length != 0 && !abi.decode(data, (bool)))) {
            revert ERC20CallFailed(token, success, data);
        }
    }
}

/// @notice A struct used to define initialization parameters. This is not included
///         in the contract to prevent naming collisions.
struct InitializationParams {
    address admin;
    address operator;
    address rewardReceiver;
    address transmuterBuffer;
    IWETH9 weth;
    IERC20 curveToken;
    IEthStableMetaPool metaPool;
    uint256 metaPoolSlippage;
    IConvexToken convexToken;
    IConvexBooster convexBooster;
    IConvexRewards convexRewards;
    uint256 convexPoolId;
}

/// @dev The amount of precision that slippage parameters have.
uint256 constant SLIPPAGE_PRECISION = 1e4;

/// @dev The amount of precision that curve pools use for price calculations.
uint256 constant CURVE_PRECISION = 1e18;

/// @notice Enumerations for meta pool assets.
///
/// @dev Do not change the order of these fields.
enum MetaPoolAsset {
    ETH, ALETH
}

uint256 constant NUM_META_COINS = 2;

/// @title  EthAssetManager
/// @author Alchemix Finance
contract EthAssetManager is Multicall, Mutex, IERC20TokenReceiver {
    /// @notice Emitted when the admin is updated.
    ///
    /// @param admin The admin.
    event AdminUpdated(address admin);

    /// @notice Emitted when the pending admin is updated.
    ///
    /// @param pendingAdmin The pending admin.
    event PendingAdminUpdated(address pendingAdmin);

    /// @notice Emitted when the operator is updated.
    ///
    /// @param operator The operator.
    event OperatorUpdated(address operator);

    /// @notice Emitted when the reward receiver is updated.
    ///
    /// @param rewardReceiver The reward receiver.
    event RewardReceiverUpdated(address rewardReceiver);

    /// @notice Emitted when the transmuter buffer is updated.
    ///
    /// @param transmuterBuffer The transmuter buffer.
    event TransmuterBufferUpdated(address transmuterBuffer);

    /// @notice Emitted when the meta pool slippage is updated.
    ///
    /// @param metaPoolSlippage The meta pool slippage.
    event MetaPoolSlippageUpdated(uint256 metaPoolSlippage);

    /// @notice Emitted when meta pool tokens are minted.
    ///
    /// @param amounts               The amounts of each meta pool asset used to mint liquidity.
    /// @param mintedThreePoolTokens The amount of meta pool tokens minted.
    event MintMetaPoolTokens(uint256[NUM_META_COINS] amounts, uint256 mintedThreePoolTokens);

    /// @notice Emitted when meta tokens are minted.
    ///
    /// @param asset  The asset used to mint meta pool tokens.
    /// @param amount The amount of the asset used to mint meta pool tokens.
    /// @param minted The amount of meta pool tokens minted.
    event MintMetaPoolTokens(MetaPoolAsset asset, uint256 amount, uint256 minted);

    /// @notice Emitted when meta pool tokens are burned.
    ///
    /// @param asset     The meta pool asset that was received.
    /// @param amount    The amount of meta pool tokens that were burned.
    /// @param withdrawn The amount of the asset that was withdrawn.
    event BurnMetaPoolTokens(MetaPoolAsset asset, uint256 amount, uint256 withdrawn);

    /// @notice Emitted when meta pool tokens are deposited into convex.
    ///
    /// @param amount  The amount of meta pool tokens that were deposited.
    /// @param success If the operation was successful.
    event DepositMetaPoolTokens(uint256 amount, bool success);

    /// @notice Emitted when meta pool tokens are withdrawn from convex.
    ///
    /// @param amount  The amount of meta pool tokens that were withdrawn.
    /// @param success If the operation was successful.
    event WithdrawMetaPoolTokens(uint256 amount, bool success);

    /// @notice Emitted when convex rewards are claimed.
    ///
    /// @param success      If the operation was successful.
    /// @param amountCurve  The amount of curve tokens sent to the reward recipient.
    /// @param amountConvex The amount of convex tokens sent to the reward recipient.
    event ClaimRewards(bool success, uint256 amountCurve, uint256 amountConvex);

    /// @notice Emitted when ethereum is sent to the transmuter buffer.
    ///
    /// @param amount The amount of ethereum that was reclaimed.
    event ReclaimEth(uint256 amount);

    /// @notice Emitted when a token is swept to the admin.
    ///
    /// @param token  The token that was swept.
    /// @param amount The amount of the token that was swept.
    event SweepToken(address token, uint256 amount);

    /// @notice Emitted when ethereum is swept to the admin.
    ///
    /// @param amount The amount of the token that was swept.
    event SweepEth(uint256 amount);

    /// @notice The admin.
    address public admin;

    /// @notice The current pending admin.
    address public pendingAdmin;

    /// @notice The operator.
    address public operator;

    // @notice The reward receiver.
    address public rewardReceiver;

    /// @notice The transmuter buffer.
    address public transmuterBuffer;

    /// @notice The wrapped ethereum token.
    IWETH9 public weth;

    /// @notice The curve token.
    IERC20 public immutable curveToken;

    /// @notice The meta pool contract.
    IEthStableMetaPool public immutable metaPool;

    /// @notice The amount of slippage that will be tolerated when depositing and withdrawing assets
    ///         from the meta pool. In units of basis points.
    uint256 public metaPoolSlippage;

    /// @notice The convex token.
    IConvexToken public immutable convexToken;

    /// @notice The convex booster contract.
    IConvexBooster public immutable convexBooster;

    /// @notice The convex rewards contract.
    IConvexRewards public immutable convexRewards;

    /// @notice The convex pool identifier.
    uint256 public immutable convexPoolId;

    /// @dev A cache of the tokens that the meta pool supports.
    IERC20[NUM_META_COINS] private _metaPoolAssetCache;

    /// @dev A modifier which reverts if the message sender is not the admin.
    modifier onlyAdmin() {
        if (msg.sender != admin) {
            revert Unauthorized("Not admin");
        }
        _;
    }

    /// @dev A modifier which reverts if the message sender is not the operator.
    modifier onlyOperator() {
        if (msg.sender != operator) {
            revert Unauthorized("Not operator");
        }
        _;
    }

    constructor(InitializationParams memory params) {
        admin            = params.admin;
        operator         = params.operator;
        rewardReceiver   = params.rewardReceiver;
        transmuterBuffer = params.transmuterBuffer;
        weth             = params.weth;
        curveToken       = params.curveToken;
        metaPool         = params.metaPool;
        metaPoolSlippage = params.metaPoolSlippage;
        convexToken      = params.convexToken;
        convexBooster    = params.convexBooster;
        convexRewards    = params.convexRewards;
        convexPoolId     = params.convexPoolId;

        for (uint256 i = 0; i < NUM_META_COINS; i++) {
            _metaPoolAssetCache[i] = params.metaPool.coins(i);
            if (_metaPoolAssetCache[i] == IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)) {
                _metaPoolAssetCache[i] = weth;
            }
        }

        emit AdminUpdated(admin);
        emit OperatorUpdated(operator);
        emit RewardReceiverUpdated(rewardReceiver);
        emit TransmuterBufferUpdated(transmuterBuffer);
        emit MetaPoolSlippageUpdated(metaPoolSlippage);
    }

    receive() external payable { }

    /// @notice Gets the amount of meta pool tokens that this contract has in reserves.
    ///
    /// @return The reserves.
    function metaPoolReserves() external view returns (uint256) {
        return metaPool.balanceOf(address(this));
    }

    /// @notice Gets the amount of a meta pool asset that this contract has in reserves.
    ///
    /// @param asset The meta pool asset.
    ///
    /// @return The reserves.
    function metaPoolAssetReserves(MetaPoolAsset asset) external view returns (uint256) {
        IERC20 token = getTokenForMetaPoolAsset(asset);
        if (asset == MetaPoolAsset.ETH) {
            return address(this).balance + token.balanceOf(address(this));
        }
        return token.balanceOf(address(this));
    }

    /// @notice Gets the amount of ethereum that one alETH is worth.
    ///
    /// @return The amount of the underlying token.
    function exchangeRate() public view returns (uint256) {
        IERC20 alETH = getTokenForMetaPoolAsset(MetaPoolAsset.ALETH);

        uint256[NUM_META_COINS] memory metaBalances = metaPool.get_balances();
        return metaPool.get_dy(
            int128(uint128(uint256(MetaPoolAsset.ALETH))),
            int128(uint128(uint256(MetaPoolAsset.ETH))),
            10**SafeERC20.expectDecimals(address(alETH)),
            metaBalances
        );
    }

    /// @notice Gets the amount of curve tokens and convex tokens that can be claimed.
    ///
    /// @return amountCurve  The amount of curve tokens available.
    /// @return amountConvex The amount of convex tokens available.
    function claimableRewards() public view returns (uint256 amountCurve, uint256 amountConvex) {
        amountCurve  = convexRewards.earned(address(this));
        amountConvex = _getEarnedConvex(amountCurve);
    }

    /// @notice Gets the ERC20 token associated with a meta pool asset.
    ///
    /// @param asset The asset to get the token for.
    ///
    /// @return The token.
    function getTokenForMetaPoolAsset(MetaPoolAsset asset) public view returns (IERC20) {
        uint256 index = uint256(asset);
        if (index >= NUM_META_COINS) {
            revert IllegalArgument("Asset index out of bounds");
        }
        return _metaPoolAssetCache[index];
    }

    /// @notice Begins the 2-step process of setting the administrator.
    ///
    /// The caller must be the admin. Setting the pending timelock to the zero address will stop
    /// the process of setting a new timelock.
    ///
    /// @param value The value to set the pending timelock to.
    function setPendingAdmin(address value) external onlyAdmin {
        pendingAdmin = value;
        emit PendingAdminUpdated(value);
    }

    /// @notice Completes the 2-step process of setting the administrator.
    ///
    /// The pending admin must be set and the caller must be the pending admin. After this function
    /// is successfully executed, the admin will be set to the pending admin and the pending admin
    /// will be reset.
    function acceptAdmin() external {
        if (pendingAdmin == address(0)) {
            revert IllegalState("Pending admin unset");
        }

        if (pendingAdmin != msg.sender) {
            revert Unauthorized("Not pending admin");
        }

        admin = pendingAdmin;
        pendingAdmin = address(0);

        emit AdminUpdated(admin);
        emit PendingAdminUpdated(address(0));
    }

    /// @notice Sets the operator.
    ///
    /// The caller must be the admin.
    ///
    /// @param value The value to set the admin to.
    function setOperator(address value) external onlyAdmin {
        operator = value;
        emit OperatorUpdated(value);
    }

    /// @notice Sets the reward receiver.
    ///
    /// @param value The value to set the reward receiver to.
    function setRewardReceiver(address value) external onlyAdmin {
        rewardReceiver = value;
        emit RewardReceiverUpdated(value);
    }

    /// @notice Sets the transmuter buffer.
    ///
    /// @param value The value to set the transmuter buffer to.
    function setTransmuterBuffer(address value) external onlyAdmin {
        transmuterBuffer = value;
        emit TransmuterBufferUpdated(value);
    }

    /// @notice Sets the slippage that will be tolerated when depositing and withdrawing meta pool
    ///         assets. The slippage has a resolution of 6 decimals.
    ///
    /// The operator is allowed to set the slippage because it is a volatile parameter that may need
    /// fine adjustment in a short time window.
    ///
    /// @param value The value to set the slippage to.
    function setMetaPoolSlippage(uint256 value) external onlyOperator {
        if (value > SLIPPAGE_PRECISION) {
            revert IllegalArgument("Slippage not in range");
        }
        metaPoolSlippage = value;
        emit MetaPoolSlippageUpdated(value);
    }

    /// @notice Mints meta pool tokens with a combination of assets.
    ///
    /// @param amounts The amounts of the assets to deposit.
    ///
    /// @return minted The number of meta pool tokens minted.
    function mintMetaPoolTokens(
        uint256[NUM_META_COINS] calldata amounts
    ) external lock onlyOperator returns (uint256 minted) {
        return _mintMetaPoolTokens(amounts);
    }

    /// @notice Mints meta pool tokens with an asset.
    ///
    /// @param asset  The asset to deposit into the meta pool.
    /// @param amount The amount of the asset to deposit.
    ///
    /// @return minted The number of meta pool tokens minted.
    function mintMetaPoolTokens(
        MetaPoolAsset asset,
        uint256 amount
    ) external lock onlyOperator returns (uint256 minted) {
        return _mintMetaPoolTokens(asset, amount);
    }

    /// @notice Burns meta pool tokens to withdraw an asset.
    ///
    /// @param asset  The asset to withdraw.
    /// @param amount The amount of meta pool tokens to burn.
    ///
    /// @return withdrawn The amount of the asset withdrawn from the pool.
    function burnMetaPoolTokens(
        MetaPoolAsset asset,
        uint256 amount
    ) external lock onlyOperator returns (uint256 withdrawn) {
        return _burnMetaPoolTokens(asset, amount);
    }

    /// @notice Deposits and stakes meta pool tokens into convex.
    ///
    /// @param amount The amount of meta pool tokens to deposit.
    ///
    /// @return success If the tokens were successfully deposited.
    function depositMetaPoolTokens(
        uint256 amount
    ) external lock onlyOperator returns (bool success) {
        return _depositMetaPoolTokens(amount);
    }

    /// @notice Withdraws and unwraps meta pool tokens from convex.
    ///
    /// @param amount The amount of meta pool tokens to withdraw.
    ///
    /// @return success If the tokens were successfully withdrawn.
    function withdrawMetaPoolTokens(
        uint256 amount
    ) external lock onlyOperator returns (bool success) {
        return _withdrawMetaPoolTokens(amount);
    }

    /// @notice Claims convex, curve, and auxiliary rewards.
    ///
    /// @return success If the claim was successful.
    function claimRewards() external lock onlyOperator returns (bool success) {
        success = convexRewards.getReward();

        uint256 curveBalance  = curveToken.balanceOf(address(this));
        uint256 convexBalance = convexToken.balanceOf(address(this));

        SafeERC20.safeTransfer(address(curveToken), rewardReceiver, curveBalance);
        SafeERC20.safeTransfer(address(convexToken), rewardReceiver, convexBalance);

        emit ClaimRewards(success, curveBalance, convexBalance);
    }

    /// @notice Flushes meta pool assets into convex by minting meta pool tokens using the assets,
    ///         and then depositing the meta pool tokens into convex.
    ///
    /// This function is provided for ease of use.
    ///
    /// @param amounts The amounts of the meta pool assets to flush.
    ///
    /// @return The amount of meta pool tokens deposited into convex.
    function flush(
        uint256[NUM_META_COINS] calldata amounts
    ) external lock onlyOperator returns (uint256) {
        uint256 mintedMetaPoolTokens = _mintMetaPoolTokens(amounts);

        if (!_depositMetaPoolTokens(mintedMetaPoolTokens)) {
            revert IllegalState("Deposit into convex failed");
        }

        return mintedMetaPoolTokens;
    }

    /// @notice Flushes a meta pool asset into convex by minting meta pool tokens using the asset,
    ///         and then depositing the meta pool tokens into convex.
    ///
    /// This function is provided for ease of use.
    ///
    /// @param asset  The meta pool asset to flush.
    /// @param amount The amount of the meta pool asset to flush.
    ///
    /// @return The amount of meta pool tokens deposited into convex.
    function flush(
        MetaPoolAsset asset,
        uint256 amount
    ) external lock onlyOperator returns (uint256) {
        uint256 mintedMetaPoolTokens = _mintMetaPoolTokens(asset, amount);

        if (!_depositMetaPoolTokens(mintedMetaPoolTokens)) {
            revert IllegalState("Deposit into convex failed");
        }

        return mintedMetaPoolTokens;
    }

    /// @notice Recalls ethereum into reserves by withdrawing meta pool tokens from convex and
    ///         burning the meta pool tokens for ethereum.
    ///
    /// This function is provided for ease of use.
    ///
    /// @param amount The amount of the meta pool tokens to withdraw from convex and burn.
    ///
    /// @return The amount of ethereum recalled.
    function recall(uint256 amount) external lock onlyOperator returns (uint256) {
        if (!_withdrawMetaPoolTokens(amount)) {
            revert IllegalState("Withdraw from convex failed");
        }
        return _burnMetaPoolTokens(MetaPoolAsset.ETH, amount);
    }

    /// @notice Reclaims a three pool asset to the transmuter buffer.
    ///
    /// @param amount The amount of ethereum to reclaim.
    function reclaimEth(uint256 amount) public lock onlyAdmin {
        uint256 balance;
        if (amount > (balance = weth.balanceOf(address(this)))) weth.deposit{value: amount - balance}();

        SafeERC20.safeTransfer(address(weth), transmuterBuffer, amount);

        IERC20TokenReceiver(transmuterBuffer).onERC20Received(address(weth), amount);

        emit ReclaimEth(amount);
    }

    /// @notice Sweeps a token out of the contract to the admin.
    ///
    /// @param token  The token to sweep.
    /// @param amount The amount of the token to sweep.
    function sweepToken(address token, uint256 amount) external lock onlyAdmin {
        SafeERC20.safeTransfer(address(token), msg.sender, amount);
        emit SweepToken(token, amount);
    }

    /// @notice Sweeps ethereum out of the contract to the admin.
    ///
    /// @param amount The amount of ethereum to sweep.
    ///
    /// @return result The result from the call to transfer ethereum.
    function sweepEth(
        uint256 amount
    ) external lock onlyAdmin returns (bytes memory result) {
        (bool success, bytes memory result) = admin.call{value: amount}(new bytes(0));
        if (!success) {
            revert IllegalState("Transfer failed");
        }

        emit SweepEth(amount);

        return result;
    }

    /// @inheritdoc IERC20TokenReceiver
    ///
    /// @dev This function is required in order to receive tokens from the conduit.
    function onERC20Received(address token, uint256 value) external { /* noop */ }

    /// @dev Gets the amount of convex that will be minted for an amount of curve tokens.
    ///
    /// @param amountCurve The amount of curve tokens.
    ///
    /// @return The amount of convex tokens.
    function _getEarnedConvex(uint256 amountCurve) internal view returns (uint256) {
        uint256 supply      = convexToken.totalSupply();
        uint256 cliff       = supply / convexToken.reductionPerCliff();
        uint256 totalCliffs = convexToken.totalCliffs();

        if (cliff >= totalCliffs) return 0;

        uint256 reduction = totalCliffs - cliff;
        uint256 earned    = amountCurve * reduction / totalCliffs;

        uint256 available = convexToken.maxSupply() - supply;
        return earned > available ? available : earned;
    }

    /// @dev Mints meta pool tokens with a combination of assets.
    ///
    /// @param amounts The amounts of the assets to deposit.
    ///
    /// @return minted The number of meta pool tokens minted.
    function _mintMetaPoolTokens(
        uint256[NUM_META_COINS] calldata amounts
    ) internal returns (uint256 minted) {
        IERC20[NUM_META_COINS] memory tokens = _metaPoolAssetCache;

        uint256 total = 0;
        for (uint256 i = 0; i < NUM_META_COINS; i++) {
            // Skip over approving WETH since we are directly swapping ETH.
            if (i == uint256(MetaPoolAsset.ETH)) continue;

            if (amounts[i] == 0) continue;

            total += amounts[i];

            // For assets like USDT, the approval must be first set to zero before updating it.
            SafeERC20.safeApprove(address(tokens[i]), address(metaPool), 0);
            SafeERC20.safeApprove(address(tokens[i]), address(metaPool), amounts[i]);
        }

        // Calculate the minimum amount of meta pool tokens that we are expecting out when
        // adding liquidity for all of the assets. This value is based off the optimistic
        // assumption that one of each token is approximately equal to one meta pool token.
        uint256 expectedOutput    = total * CURVE_PRECISION / metaPool.get_virtual_price();
        uint256 minimumMintAmount = expectedOutput * metaPoolSlippage / SLIPPAGE_PRECISION;

        uint256 value = amounts[uint256(MetaPoolAsset.ETH)];

        // Ensure that the contract has the amount of ethereum required.
        if (value > address(this).balance) weth.withdraw(value - address(this).balance);

        // Add the liquidity to the pool.
        minted = metaPool.add_liquidity{value: value}(amounts, minimumMintAmount);

        emit MintMetaPoolTokens(amounts, minted);
    }

    /// @dev Mints meta pool tokens with an asset.
    ///
    /// @param asset  The asset to deposit into the meta pool.
    /// @param amount The amount of the asset to deposit.
    ///
    /// @return minted The number of meta pool tokens minted.
    function _mintMetaPoolTokens(
        MetaPoolAsset asset,
        uint256 amount
    ) internal returns (uint256 minted) {
        uint256[NUM_META_COINS] memory amounts;
        amounts[uint256(asset)] = amount;

        // Calculate the minimum amount of meta pool tokens that we are expecting out when
        // adding liquidity for all of the assets. This value is based off the optimistic
        // assumption that one of each token is approximately equal to one meta pool token.
        uint256 minimumMintAmount = amount * metaPoolSlippage / SLIPPAGE_PRECISION;

        // Set an approval if not working with ethereum.
        if (asset != MetaPoolAsset.ETH) {
            IERC20 token = getTokenForMetaPoolAsset(asset);

            // For assets like USDT, the approval must be first set to zero before updating it.
            SafeERC20.safeApprove(address(token), address(metaPool), 0);
            SafeERC20.safeApprove(address(token), address(metaPool), amount);
        }

        uint256 value = asset == MetaPoolAsset.ETH
            ? amounts[uint256(MetaPoolAsset.ETH)]
            : 0;

        // Ensure that the contract has the amount of ethereum required.
        if (value > address(this).balance) weth.withdraw(value - address(this).balance);

        // Add the liquidity to the pool.
        minted = metaPool.add_liquidity{value: value}(amounts, minimumMintAmount);

        emit MintMetaPoolTokens(asset, amount, minted);
    }

    /// @dev Burns meta pool tokens to withdraw an asset.
    ///
    /// @param asset  The asset to withdraw.
    /// @param amount The amount of meta pool tokens to burn.
    ///
    /// @return withdrawn The amount of the asset withdrawn from the pool.
    function _burnMetaPoolTokens(
        MetaPoolAsset asset,
        uint256 amount
    ) internal returns (uint256 withdrawn) {
        uint256 index = uint256(asset);

        // Calculate the minimum amount of the meta pool asset that we are expecting out when
        // removing single sided liquidity. This value is based off the optimistic assumption that
        // one of each token is approximately equal to one meta pool lp token.
        uint256 expectedOutput   = amount * metaPool.get_virtual_price() / CURVE_PRECISION;
        uint256 minimumAmountOut = expectedOutput * metaPoolSlippage / SLIPPAGE_PRECISION;

        // Remove the liquidity from the pool.
        withdrawn = metaPool.remove_liquidity_one_coin(
            amount,
            int128(uint128(index)),
            minimumAmountOut
        );

        emit BurnMetaPoolTokens(asset, amount, withdrawn);
    }

    /// @dev Deposits and stakes meta pool tokens into convex.
    ///
    /// @param amount The amount of meta pool tokens to deposit.
    ///
    /// @return success If the tokens were successfully deposited.
    function _depositMetaPoolTokens(uint256 amount) internal returns (bool success) {
        SafeERC20.safeApprove(address(metaPool), address(convexBooster), 0);
        SafeERC20.safeApprove(address(metaPool), address(convexBooster), amount);

        success = convexBooster.deposit(convexPoolId, amount, true /* always stake into rewards */);

        emit DepositMetaPoolTokens(amount, success);
    }

    /// @dev Withdraws and unwraps meta pool tokens from convex.
    ///
    /// @param amount The amount of meta pool tokens to withdraw.
    ///
    /// @return success If the tokens were successfully withdrawn.
    function _withdrawMetaPoolTokens(uint256 amount) internal returns (bool success) {
        success = convexRewards.withdrawAndUnwrap(amount, false /* never claim */);
        emit WithdrawMetaPoolTokens(amount, success);
    }

    /// @dev Claims convex, curve, and auxiliary rewards.
    ///
    /// @return success If the claim was successful.
    function _claimRewards() internal returns (bool success) {
        success = convexRewards.getReward();

        uint256 curveBalance  = curveToken.balanceOf(address(this));
        uint256 convexBalance = convexToken.balanceOf(address(this));

        SafeERC20.safeTransfer(address(curveToken), rewardReceiver, curveBalance);
        SafeERC20.safeTransfer(address(convexToken), rewardReceiver, convexBalance);

        emit ClaimRewards(success, curveBalance, convexBalance);
    }

    /// @dev Gets the minimum of two integers.
    ///
    /// @param x The first integer.
    /// @param y The second integer.
    ///
    /// @return The minimum value.
    function min(uint256 x , uint256 y) private pure returns (uint256) {
        return x > y ? y : x;
    }

    /// @dev Gets the absolute value of the difference of two integers.
    ///
    /// @param x The first integer.
    /// @param y The second integer.
    ///
    /// @return The absolute value.
    function abs(uint256 x , uint256 y) private pure returns (uint256) {
        return x > y ? x - y : y - x;
    }
}