// SPDX-License-Identifier: MIT
pragma solidity =0.8.11;

import {BoringOwnable} from "BoringOwnable.sol";
import "UUPSUpgradeable.sol";
import "SafeERC20.sol";
import "ERC20.sol";
import "ReentrancyGuard.sol";
import "ERC20VotesUpgradeable.sol";
import {IVault, IAsset} from "IVault.sol";
import "IWeightedPool.sol";
import "IPriceOracle.sol";

contract sNOTE is
    ERC20VotesUpgradeable,
    BoringOwnable,
    UUPSUpgradeable,
    ReentrancyGuard
{
    using SafeERC20 for ERC20;

    IVault public immutable BALANCER_VAULT;
    ERC20 public immutable NOTE;
    ERC20 public immutable BALANCER_POOL_TOKEN;
    ERC20 public immutable WETH;
    bytes32 public immutable NOTE_ETH_POOL_ID;

    /// @notice Balancer token indexes
    /// Balancer requires token addresses to be sorted BAL#102
    uint256 public immutable WETH_INDEX;
    uint256 public immutable NOTE_INDEX;

    /// @notice Maximum shortfall withdraw of 50%
    uint256 public constant MAX_SHORTFALL_WITHDRAW = 50;
    uint256 public constant SHORTFALL_WITHDRAW_COOLDOWN = 7 days;

    /// @notice Redemption window in seconds
    uint256 public constant REDEEM_WINDOW_SECONDS = 3 days;
    uint32 public constant MAXIMUM_COOL_DOWN_PERIOD_SECONDS = 30 days;

    /// @notice Number of seconds that need to pass before sNOTE can be redeemed
    uint32 public coolDownTimeInSeconds;

    /// @notice Timestamp of the last time a shortfall was withdrawn
    uint32 public lastShortfallWithdrawTime;

    /// @notice Mapping between sNOTE holders and their cool down status
    mapping(address => uint256) public accountRedeemWindowBegin;

    /// @notice Emitted when a cool down begins
    event CoolDownStarted(
        address indexed account,
        uint256 redeemWindowBegin,
        uint256 redeemWindowEnd
    );

    /// @notice Emitted when a cool down ends
    event CoolDownEnded(address indexed account);

    /// @notice Emitted when cool down time is updated
    event GlobalCoolDownUpdated(uint256 newCoolDownTimeSeconds);

    /// @notice Emitted when sNote is minted
    event SNoteMinted(
        address indexed account,
        uint256 wethChangeAmount,
        uint256 noteChangeAmount,
        uint256 bptChangeAmount
    );

    /// @notice Emitted when sNote is redeemed
    event SNoteRedeemed(
        address indexed account,
        uint256 wethChangeAmount,
        uint256 noteChangeAmount,
        uint256 bptChangeAmount
    );

    /// @notice Constructor sets immutable contract addresses
    constructor(
        IVault _balancerVault,
        bytes32 _noteETHPoolId,
        uint256 _wethIndex,
        uint256 _noteIndex
    ) initializer {
        // Validate that the pool exists
        // prettier-ignore
        (address poolAddress, /* */) = _balancerVault.getPool(_noteETHPoolId);
        require(poolAddress != address(0));

        WETH_INDEX = _wethIndex;
        NOTE_INDEX = _noteIndex;

        // prettier-ignore
        (address[] memory tokens, /* */, /* */) = _balancerVault.getPoolTokens(_noteETHPoolId);

        WETH = ERC20(tokens[_wethIndex]);
        NOTE = ERC20(tokens[_noteIndex]);
        NOTE_ETH_POOL_ID = _noteETHPoolId;
        BALANCER_VAULT = _balancerVault;
        BALANCER_POOL_TOKEN = ERC20(poolAddress);
    }

    /// @notice Initializes sNOTE ERC20 metadata and owner
    function initialize(address _owner, uint32 _coolDownTimeInSeconds)
        external
        initializer
    {
        string memory _name = "Staked NOTE";
        string memory _symbol = "sNOTE";
        __ERC20_init(_name, _symbol);
        __ERC20Permit_init(_name);

        coolDownTimeInSeconds = _coolDownTimeInSeconds;
        owner = _owner;
        NOTE.safeApprove(address(BALANCER_VAULT), type(uint256).max);
        WETH.safeApprove(address(BALANCER_VAULT), type(uint256).max);

        emit OwnershipTransferred(address(0), _owner);
    }

    /** Governance Methods **/

    /// @notice Authorizes the DAO to upgrade this contract
    function _authorizeUpgrade(
        address /* newImplementation */
    ) internal override onlyOwner {}

    /// @notice Updates the required cooldown time to redeem
    function setCoolDownTime(uint32 _coolDownTimeInSeconds) external onlyOwner {
        require(_coolDownTimeInSeconds <= MAXIMUM_COOL_DOWN_PERIOD_SECONDS);
        coolDownTimeInSeconds = _coolDownTimeInSeconds;
        emit GlobalCoolDownUpdated(_coolDownTimeInSeconds);
    }

    /// @notice Allows the DAO to extract up to 50% of the BPT tokens during a collateral shortfall event
    function extractTokensForCollateralShortfall(uint256 requestedWithdraw)
        external
        nonReentrant
        onlyOwner
    {
        // Check that the last shortfall withdraw time was not recent
        uint32 blockTime = _safe32(block.timestamp);
        require(
            lastShortfallWithdrawTime + SHORTFALL_WITHDRAW_COOLDOWN < blockTime,
            "Shortfall Cooldown"
        );
        lastShortfallWithdrawTime = blockTime;

        uint256 bptBalance = BALANCER_POOL_TOKEN.balanceOf(address(this));
        uint256 maxBPTWithdraw = (bptBalance * MAX_SHORTFALL_WITHDRAW) / 100;
        // Do not allow a withdraw of more than the MAX_SHORTFALL_WITHDRAW percentage. Specifically don't
        // revert here since there may be a delay between when governance issues the token amount and when
        // the withdraw actually occurs.
        uint256 bptExitAmount = requestedWithdraw > maxBPTWithdraw
            ? maxBPTWithdraw
            : requestedWithdraw;

        IAsset[] memory assets = new IAsset[](2);
        assets[WETH_INDEX] = IAsset(address(WETH));
        assets[NOTE_INDEX] = IAsset(address(NOTE));

        // Accept whatever NOTE/WETH we will receive here, since these
        // withdraws will be in a timelock it will be difficult to determine
        // how the pool will be constituted at the time of withdraw
        _exitPool(assets, new uint256[](2), bptExitAmount);
    }

    /// @notice Allows the DAO to set the swap fee on the BPT
    function setSwapFeePercentage(uint256 swapFeePercentage)
        external
        onlyOwner
    {
        IWeightedPool(address(BALANCER_POOL_TOKEN)).setSwapFeePercentage(
            swapFeePercentage
        );
    }

    /** User Methods **/

    /// @notice Mints sNOTE from the underlying BPT token.
    /// @param bptAmount is the amount of BPT to transfer from the msg.sender.
    function mintFromBPT(uint256 bptAmount) external nonReentrant {
        // _mint logic requires that tokens are transferred first
        if (bptAmount == 0) return;
        BALANCER_POOL_TOKEN.safeTransferFrom(
            msg.sender,
            address(this),
            bptAmount
        );
        _mint(msg.sender, bptAmount);
        (uint256 wethAmount, uint256 noteAmount) = _getTokenBalances(bptAmount);
        emit SNoteMinted(msg.sender, wethAmount, noteAmount, bptAmount);
    }

    function _getTokenBalances(uint256 bptAmount)
        internal
        returns (uint256, uint256)
    {
        // prettier-ignore
        (
            /* address[] memory tokens */,
            uint256[] memory balances,
            /* uint256 lastChangeBlock */
        ) = BALANCER_VAULT.getPoolTokens(NOTE_ETH_POOL_ID);

        uint256 bptSupply = BALANCER_POOL_TOKEN.totalSupply();

        // increase NOTE precision to 1e18
        uint256 noteBal = balances[NOTE_INDEX] * 1e10;

        return (
            (balances[WETH_INDEX] * bptAmount) / bptSupply,
            (noteBal * bptAmount) / bptSupply / 1e10
        );
    }

    /// @notice Mints sNOTE from some amount of NOTE and ETH
    /// @param noteAmount amount of NOTE to transfer into the sNOTE contract
    /// @param minBPT slippage parameter to prevent front running
    function mintFromETH(uint256 noteAmount, uint256 minBPT)
        external
        payable
        nonReentrant
    {
        // Transfer the NOTE balance into sNOTE first
        if (noteAmount > 0)
            NOTE.safeTransferFrom(msg.sender, address(this), noteAmount);

        IAsset[] memory assets = new IAsset[](2);
        uint256[] memory maxAmountsIn = new uint256[](2);

        assets[WETH_INDEX] = IAsset(address(0));
        assets[NOTE_INDEX] = IAsset(address(NOTE));
        maxAmountsIn[WETH_INDEX] = msg.value;
        maxAmountsIn[NOTE_INDEX] = noteAmount;

        _mintFromAssets(assets, maxAmountsIn, minBPT);
    }

    /// @notice Mints sNOTE from some amount of NOTE and WETH
    /// @param noteAmount amount of NOTE to transfer into the sNOTE contract
    /// @param wethAmount amount of WETH to transfer into the sNOTE contract
    /// @param minBPT slippage parameter to prevent front running
    function mintFromWETH(
        uint256 noteAmount,
        uint256 wethAmount,
        uint256 minBPT
    ) external nonReentrant {
        // Transfer the NOTE and WETH balance into sNOTE first
        if (noteAmount > 0)
            NOTE.safeTransferFrom(msg.sender, address(this), noteAmount);
        if (wethAmount > 0)
            WETH.safeTransferFrom(msg.sender, address(this), wethAmount);

        IAsset[] memory assets = new IAsset[](2);
        uint256[] memory maxAmountsIn = new uint256[](2);

        assets[WETH_INDEX] = IAsset(address(WETH));
        assets[NOTE_INDEX] = IAsset(address(NOTE));
        maxAmountsIn[WETH_INDEX] = wethAmount;
        maxAmountsIn[NOTE_INDEX] = noteAmount;

        _mintFromAssets(assets, maxAmountsIn, minBPT);
    }

    function _mintFromAssets(
        IAsset[] memory assets,
        uint256[] memory maxAmountsIn,
        uint256 minBPT
    ) internal {
        uint256 bptBefore = BALANCER_POOL_TOKEN.balanceOf(address(this));
        // Set msgValue when joining via ETH
        uint256 msgValue = assets[WETH_INDEX] == IAsset(address(0))
            ? maxAmountsIn[WETH_INDEX]
            : 0;

        BALANCER_VAULT.joinPool{value: msgValue}(
            NOTE_ETH_POOL_ID,
            address(this),
            address(this), // sNOTE will receive the BPT
            IVault.JoinPoolRequest(
                assets,
                maxAmountsIn,
                abi.encode(
                    IVault.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT,
                    maxAmountsIn,
                    minBPT
                ),
                false // Don't use internal balances
            )
        );
        uint256 bptAfter = BALANCER_POOL_TOKEN.balanceOf(address(this));
        uint256 bptChange = bptAfter - bptBefore;

        // Balancer pool token amounts must increase
        _mint(msg.sender, bptChange);

        emit SNoteMinted(
            msg.sender,
            maxAmountsIn[WETH_INDEX],
            maxAmountsIn[NOTE_INDEX],
            bptChange
        );
    }

    function _exitPool(
        IAsset[] memory assets,
        uint256[] memory minAmountsOut,
        uint256 bptExitAmount
    ) internal {
        uint256 wethBefore = address(assets[WETH_INDEX]) == address(0)
            ? msg.sender.balance
            : IERC20(address(assets[WETH_INDEX])).balanceOf(msg.sender);
        uint256 noteBefore = IERC20(address(assets[NOTE_INDEX])).balanceOf(
            msg.sender
        );

        BALANCER_VAULT.exitPool(
            NOTE_ETH_POOL_ID,
            address(this),
            payable(msg.sender), // Owner will receive the underyling assets
            IVault.ExitPoolRequest(
                assets,
                minAmountsOut,
                abi.encode(
                    IVault.ExitKind.EXACT_BPT_IN_FOR_TOKENS_OUT,
                    bptExitAmount
                ),
                false // Don't use internal balances
            )
        );

        uint256 wethAfter = address(assets[WETH_INDEX]) == address(0)
            ? msg.sender.balance
            : IERC20(address(assets[WETH_INDEX])).balanceOf(msg.sender);
        uint256 noteAfter = IERC20(address(assets[NOTE_INDEX])).balanceOf(
            msg.sender
        );

        emit SNoteRedeemed(
            msg.sender,
            wethAfter - wethBefore,
            noteAfter - noteBefore,
            bptExitAmount
        );
    }

    /// @notice Begins a cool down period for the sender, this is required to redeem tokens
    function startCoolDown() external {
        // Cannot start a cool down if there is already one in effect
        _requireAccountNotInCoolDown(msg.sender);
        uint256 redeemWindowBegin = block.timestamp + coolDownTimeInSeconds;
        uint256 redeemWindowEnd = redeemWindowBegin + REDEEM_WINDOW_SECONDS;

        accountRedeemWindowBegin[msg.sender] = redeemWindowBegin;
        emit CoolDownStarted(msg.sender, redeemWindowBegin, redeemWindowEnd);
    }

    /// @notice Stops a cool down for the sender
    function stopCoolDown() external {
        // Reset the cool down back to zero so that the account must initiate it again to redeem
        delete accountRedeemWindowBegin[msg.sender];
        emit CoolDownEnded(msg.sender);
    }

    /// @notice Redeems some amount of sNOTE to underlying BPT tokens (which can then be sold for
    /// NOTE or ETH). An account must have passed its cool down expiration before they can redeem
    /// @param sNOTEAmount amount of sNOTE to redeem
    function redeem(
        uint256 sNOTEAmount,
        uint256 minWETH,
        uint256 minNOTE,
        bool redeemWETH
    ) external nonReentrant {
        uint256 redeemWindowBegin = accountRedeemWindowBegin[msg.sender];
        uint256 redeemWindowEnd = redeemWindowBegin + REDEEM_WINDOW_SECONDS;
        require(
            redeemWindowBegin != 0 &&
                redeemWindowBegin <= block.timestamp &&
                block.timestamp <= redeemWindowEnd,
            "Not in Redemption Window"
        );

        uint256 bptToRedeem = getPoolTokenShare(sNOTEAmount);

        // Handles event emission, balance update and total supply update
        _burn(msg.sender, sNOTEAmount);

        if (bptToRedeem > 0) {
            IAsset[] memory assets = new IAsset[](2);
            uint256[] memory minAmountsOut = new uint256[](2);

            assets[WETH_INDEX] = redeemWETH
                ? IAsset(address(0))
                : IAsset(address(WETH));
            assets[NOTE_INDEX] = IAsset(address(NOTE));
            minAmountsOut[WETH_INDEX] = minWETH;
            minAmountsOut[NOTE_INDEX] = minNOTE;

            _exitPool(assets, minAmountsOut, bptToRedeem);
        }
    }

    /** External View Methods **/

    /// @notice Returns how many Balancer pool tokens an sNOTE token amount has a claim on
    function getPoolTokenShare(uint256 sNOTEAmount)
        public
        view
        returns (uint256 bptClaim)
    {
        uint256 _totalSupply = totalSupply();
        if (_totalSupply == 0) return 0;

        uint256 bptBalance = BALANCER_POOL_TOKEN.balanceOf(address(this));
        // BPT and sNOTE are both in 18 decimal precision so no conversion required
        return (bptBalance * sNOTEAmount) / _totalSupply;
    }

    /// @notice Returns the pool token share of a specific account
    function poolTokenShareOf(address account)
        public
        view
        returns (uint256 bptClaim)
    {
        return getPoolTokenShare(balanceOf(account));
    }

    /// @notice Calculates voting power for a given amount of sNOTE
    /// @param sNOTEAmount amount of sNOTE to calculate voting power for
    /// @return corresponding NOTE voting power
    function getVotingPower(uint256 sNOTEAmount) public view returns (uint256) {
        uint256 _totalSupply = totalSupply();
        if (_totalSupply == 0) return 0;

        // Gets the BPT token price (in ETH)
        uint256 bptPrice = IPriceOracle(address(BALANCER_POOL_TOKEN)).getLatest(
            IPriceOracle.Variable.BPT_PRICE
        );
        // Gets the NOTE token price (in ETH)
        uint256 notePrice = IPriceOracle(address(BALANCER_POOL_TOKEN))
            .getLatest(IPriceOracle.Variable.PAIR_PRICE);

        // Since both bptPrice and notePrice are denominated in ETH, we can use
        // this formula to calculate noteAmount
        // (bptBalance * 0.8) * bptPrice = notePrice * noteAmount
        // noteAmount = (bptPrice * bptBalance * 0.8) / notePrice
        uint256 bptBalance = BALANCER_POOL_TOKEN.balanceOf(address(this));
        // This calculation is (NOTE tokens are in 8 decimal precision):
        // (1e18 * 1e18 * 1e2) / (1e18 * 1e2 * 1e10) == 1e8
        uint256 noteAmount = (bptPrice * bptBalance * 80) /
            (notePrice * 100 * 1e10);

        return (noteAmount * sNOTEAmount) / _totalSupply;
    }

    /// @notice Calculates current voting power for a given account
    /// @param account a given sNOTE holding account
    /// @return corresponding NOTE voting power
    function getVotes(address account) public view override returns (uint256) {
        return getVotingPower(super.getVotes(account));
    }

    /// @notice Calculates voting power for on chain voting (for use with OpenZeppelin Governor)
    /// @param account a given sNOTE holding account
    /// @param blockNumber a block number to calculate voting power at
    /// @return corresponding NOTE voting power
    function getPastVotes(address account, uint256 blockNumber)
        public
        view
        override
        returns (uint256)
    {
        return getVotingPower(super.getPastVotes(account, blockNumber));
    }

    /** Internal Methods **/

    function _requireAccountNotInCoolDown(address account) internal view {
        uint256 redeemWindowBegin = accountRedeemWindowBegin[account];
        uint256 redeemWindowEnd = redeemWindowBegin + REDEEM_WINDOW_SECONDS;
        // An account is not in cool down if the redeem window is not set (== 0) or
        // if the window has already passed (redeemWindowEnd < block.timestamp)
        require(
            redeemWindowBegin == 0 || redeemWindowEnd < block.timestamp,
            "Account in Cool Down"
        );
    }

    /// @notice Mints sNOTE tokens given a bptAmount
    /// @param account account to mint tokens to
    /// @param bptAmount the number of BPT tokens being minted by the account
    function _mint(address account, uint256 bptAmount) internal override {
        // Immediately after minting, we need to satisfy the equality:
        // (sNOTEToMint * bptBalance) / (totalSupply + sNOTEToMint) == bptAmount

        // Rearranging to get sNOTEToMint on one side:
        // (sNOTEToMint * bptBalance) = (totalSupply + sNOTEToMint) * bptAmount
        // (sNOTEToMint * bptBalance) = totalSupply * bptAmount + sNOTEToMint * bptAmount
        // (sNOTEToMint * bptBalance) - (sNOTEToMint * bptAmount) = totalSupply * bptAmount
        // sNOTEToMint * (bptBalance - bptAmount) = totalSupply * bptAmount
        // sNOTEToMint = (totalSupply * bptAmount) / (bptBalance - bptAmount)

        // NOTE: at this point the BPT has already been transferred into the sNOTE contract, so this
        // bptBalance amount includes bptAmount.
        uint256 bptBalance = BALANCER_POOL_TOKEN.balanceOf(address(this));
        uint256 _totalSupply = totalSupply();
        uint256 sNOTEToMint;
        if (_totalSupply == 0) {
            sNOTEToMint = bptAmount;
        } else {
            sNOTEToMint = (_totalSupply * bptAmount) / (bptBalance - bptAmount);
        }

        // Handles event emission, balance update and total supply update
        super._mint(account, sNOTEToMint);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        // Cannot send or receive tokens if a cool down is in effect or else accounts
        // can bypass the cool down. It's not clear if sending tokens can be used to bypass
        // the cool down but we restrict it here anyway, there's no clear use case for sending
        // sNOTE tokens during a cool down.
        if (to != address(0)) {
            // Run these checks only when we are not burning tokens. (OZ ERC20 does not allow transfers
            // to address(0), to == address(0) only when _burn is called).

            // from == address(0) when minting, no need to check cool down
            if (from != address(0)) _requireAccountNotInCoolDown(from);
            _requireAccountNotInCoolDown(to);
        }

        super._beforeTokenTransfer(from, to, amount);
    }

    function _safe32(uint256 x) internal pure returns (uint32) {
        require(x <= type(uint32).max);
        return uint32(x);
    }
}
