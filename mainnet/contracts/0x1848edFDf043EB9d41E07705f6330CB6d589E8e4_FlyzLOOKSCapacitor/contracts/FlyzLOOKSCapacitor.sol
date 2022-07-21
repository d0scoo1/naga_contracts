// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import './interfaces/IFlyzTreasury.sol';

import './types/Ownable.sol';
import './interfaces/IERC20.sol';

import './libraries/SafeMath.sol';
import './libraries/SafeERC20.sol';

import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

interface ILooksStaking {
    function userInfo(address user) external view returns (uint256, uint256, uint256);
    function deposit(uint256 amount, bool claimRewardToken) external;
    function withdraw(uint256 shares, bool claimRewardToken) external;
    function withdrawAll(bool claimRewardToken) external;
    function harvest() external;
}

interface IFlyzWrappedLOOKS is IERC20 {
    function mintTo(address to, uint256 amount) external;
    function burn(uint256 amount) external;
}

contract FlyzLOOKSCapacitor is Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    bool public autoStake;
    bool public autoHarvest;

    address public immutable flyz;
    address public immutable flyzLP;
    address public immutable weth;
    address public immutable looks;
    address public immutable looksLP;
    address public immutable looksStaking;
    address public immutable wrappedLooks;
    address public immutable treasury;
    address public immutable swapRouter;

    mapping(address => bool) private _depositors;

    event DepositorAdded(address indexed depositor);
    event DepositorRemoved(address indexed depositor);

    modifier onlyOnwerOrDepositor() {
        require(msg.sender == owner() || _depositors[msg.sender], "Capacitor: Not owner or depositor");
        _;
    }

    constructor(
        address _flyz,
        address _looks,
        address _looksStaking,
        address _wrappedLooks,
        address _treasury,
        address _router
    ) {
        flyz = _flyz;
        looks = _looks;
        wrappedLooks = _wrappedLooks;
        looksStaking = _looksStaking;
        treasury = _treasury;
        autoStake = true;

        IUniswapV2Router02 _swapRouter = IUniswapV2Router02(_router);
        IUniswapV2Factory _factory = IUniswapV2Factory(_swapRouter.factory());
        address _weth = _swapRouter.WETH();
        address _flyzLP = _factory.getPair(_flyz, _weth);
        address _looksLP = _factory.getPair(_looks, _weth);

        swapRouter = _router;
        weth = _weth;
        flyzLP = _flyzLP;
        looksLP = _looksLP;

        IERC20(_looks).approve(_looksStaking,  uint256(-1));
        IERC20(_looks).approve(_router,  uint256(-1));
        IERC20(_flyz).approve(_router,  uint256(-1));
        IERC20(_weth).approve(_router,  uint256(-1));
        IERC20(_flyz).approve(_treasury,  uint256(-1));
        IERC20(_flyzLP).approve(_treasury,  uint256(-1));
        IERC20(_looks).approve(_treasury,  uint256(-1));
        IERC20(_wrappedLooks).approve(_treasury,  uint256(-1));
    }

    /**
     * @notice returns the pending rewards in LOOKS staking contract
     */
    function getStakingInfos() public view returns (uint256 shares, uint256 userRewardPerTokenPaid, uint256 rewards) {
        (shares, userRewardPerTokenPaid, rewards) = ILooksStaking(looksStaking).userInfo(address(this));
    }

    /**
     * @notice Stake LOOKS tokens (and collect reward tokens if requested)
     * @param amount amount of LOOKS to stake
     * @param claimRewardToken whether to claim reward tokens
     */
    function _stake(uint256 amount, bool claimRewardToken) internal {
        require(amount <= IERC20(looks).balanceOf(address(this)), "Capacitor: over balance");
        ILooksStaking(looksStaking).deposit(amount, claimRewardToken);
    }

    /**
     * @notice Stake LOOKS tokens (and collect reward tokens if requested)
     * @param amount amount of LOOKS to stake
     * @param claimRewardToken whether to claim reward tokens
     */
    function stake(uint256 amount, bool claimRewardToken) external onlyOnwerOrDepositor {
        _stake(amount, claimRewardToken);
    }

    /**
     * @notice Stake all LOOKS tokens (and collect reward tokens if requested)
     * @param claimRewardToken whether to claim reward tokens
     */
    function stakeAll(bool claimRewardToken) external onlyOnwerOrDepositor {
        _stake(IERC20(looks).balanceOf(address(this)), claimRewardToken);
    }

    /**
     * @notice Unstake LOOKS tokens (and collect reward tokens if requested)
     * @param shares shares to withdraw
     * @param claimRewardToken whether to claim reward tokens
     */
    function unstake(uint256 shares, bool claimRewardToken) external onlyOnwerOrDepositor {
        require(shares > 0, "Capacitor: Invalid shares");
        ILooksStaking(looksStaking).withdraw(shares, claimRewardToken);
    }

    /**
     * @notice Unstake all LOOKS tokens (and collect reward tokens if requested)
     * @param claimRewardToken whether to claim reward tokens
     */
    function unstakeAll(bool claimRewardToken) external onlyOnwerOrDepositor {
        ILooksStaking(looksStaking).withdrawAll(claimRewardToken);
    }

    /**
     * @notice Harvest current pending rewards
     */
    function _harvest() internal {
        (, , uint256 rewards) = getStakingInfos();
        if (rewards > 0) {
            ILooksStaking(looksStaking).harvest();
        }
    }

    /**
     * @notice Harvest current pending rewards
     */
    function harvest() external onlyOnwerOrDepositor {
        _harvest();
    }

    /**
     * @notice Deposit LOOKS and send a receipt token to the treasury
     */
    function deposit(uint256 amount) external onlyOnwerOrDepositor {
        IERC20(looks).safeTransferFrom(msg.sender, address(this), amount);
        IFlyzWrappedLOOKS(wrappedLooks).mintTo(treasury, amount);

        if (autoStake) {
            _stake(amount, autoHarvest);
        }
        else if (autoHarvest) {
            _harvest();
        }
    }

    /**
     * @notice send a receipt token to the treasury (LOOKS are transfered first by the caller to the contract)
     * used by BondDepository to save gas
     */
    function depositReceipt(uint256 amount) external onlyOnwerOrDepositor {
        require(amount <= IERC20(looks).balanceOf(address(this)), "Capacitor: over balance");
        IFlyzWrappedLOOKS(wrappedLooks).mintTo(treasury, amount);

        if (autoStake) {
            _stake(amount, autoHarvest);
        }
        else if (autoHarvest) {
            _harvest();
        }
    }

    /**
     * @dev Swap helper function
     */
    function _swap(address pair, address token, uint256 amount, address to) internal returns (uint256) {
        address token0 = IUniswapV2Pair(pair).token0();
        address token1 = IUniswapV2Pair(pair).token1();
        address otherToken = token0 == token ? token1 : token0;

        address[] memory path = new address[](2);
        path[0] = token0 == token ? token0 : token1;
        path[1] = otherToken;

        uint256 balance = IERC20(otherToken).balanceOf(address(this));
        IUniswapV2Router02(swapRouter).swapExactTokensForTokens(amount, 0, path, to, block.timestamp);
        uint256 newBalance = IERC20(otherToken).balanceOf(address(this));

        return newBalance - balance;
    }

    /**
     * @notice Swap LOOKS to WETH, swap WETH to FLYZ, add liquidity to FLYZ/WETH LP and send LP to treasury with 100% profit
     */
    function swapAndSendFlyzLPToTreasury(uint256 looksAmount) external onlyOnwerOrDepositor {
        // swap looks to weth
        if (looksAmount > 0) {
            require(looksAmount <= IERC20(looks).balanceOf(address(this)), "Capacitor: over LOOKS balance");
            _swap(looksLP, looks, looksAmount, address(this));
        }

        // buy back flyz
        uint256 wethAmount = IERC20(weth).balanceOf(address(this)).div(2);
        require(wethAmount > 0, "Capacitor: WETH balance is 0");
        uint256 flyzReceived = _swap(flyzLP, weth, wethAmount, address(this));

        // add liquidity to flyz LP
        IUniswapV2Router02(swapRouter).addLiquidity(flyz, weth, flyzReceived, wethAmount, 0, 0, address(this), block.timestamp);

        // add to the treasury with 100% profit
        uint256 lpAmount = IERC20(flyzLP).balanceOf(address(this));
        uint256 profit = IFlyzTreasury(treasury).valueOfToken(flyzLP, lpAmount);
        IFlyzTreasury(treasury).deposit(lpAmount, flyzLP, profit);
    }

    /**
     * @notice Withdraw LOOKS from treasury to this contract and replace with WRAPPED LOOKS
     */
    function receiveLooksFromTreasury(uint256 amount) external onlyOnwerOrDepositor {
        require(amount <= IERC20(looks).balanceOf(treasury), "Capacitor: over balance");

        // mint wrapped looks receipt
        IFlyzWrappedLOOKS(wrappedLooks).mintTo(address(this), amount);   
        // deposit wrapped looks receipt to treasury
        IFlyzTreasury(treasury).deposit(amount, wrappedLooks, 0);
        // withdraw looks from treasury
        IFlyzTreasury(treasury).withdraw(amount, looks);
    }

    /**
     * @notice Withdraw WRAPPED LOOKS from the treasury to this contract and replace with LOOKS
     * WRAPPED LOOKS are burned
     */
    function sendLooksToTreasury(uint256 amount) external onlyOnwerOrDepositor {
        require(amount <= IERC20(looks).balanceOf(address(this)), "Capacitor: over balance");
     
        // deposit looks to treasury
        IFlyzTreasury(treasury).deposit(amount, looks, 0);
        // withdraw wrapped looks from treasury
        IFlyzTreasury(treasury).withdraw(amount, wrappedLooks);
        // burn wrapped looks receipt
        IFlyzWrappedLOOKS(wrappedLooks).burn(amount);
    }

    /**
     * @notice Auto stake LOOKS on deposits
     */
    function setAutoStake(bool enable) external onlyOwner {
        autoStake = enable;
    }

    /**
     * @notice Auto harvest rewards on deposits
     */
    function setAutoHarvest(bool enable) external onlyOwner {
        autoHarvest = enable;
    }

    /**
     * @notice Returns `true` if `account` is a member of deposit group
     */
    function isDepositor(address account) public view returns(bool) {
        return _depositors[account];
    }

    /**
     * @notice Add `depositor` to the list of addresses allowed to call `deposit()`  
     */
    function addDepositor(address depositor) external onlyOwner {
        require(depositor != address(0), "Capacitor: invalid address(0)");
        require(!_depositors[depositor], "Capacitor: already depositor");
        _depositors[depositor] = true;
        emit DepositorAdded(depositor);
    }

    /**
     * @notice Remove `depositor` from the list of addresses allowed to call `deposit()`  
     */
    function removeDepositor(address depositor) external onlyOwner {
        require(_depositors[depositor], "Capacitor: not depositor");
        _depositors[depositor] = false;
        emit DepositorRemoved(depositor);
    }

    /**
     * @notice Recover tokens sent to this contract by mistake
     */
    function recoverLostToken(address _token, uint256 amount) external onlyOwner returns (bool) {
        require(amount <= IERC20(_token).balanceOf(address(this)), "Capacitor: over token balance");
        IERC20(_token).safeTransfer(
            msg.sender,
            amount
        );
        return true;
    }
}