// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import '@openzeppelin/contracts/math/SafeMath.sol';

import '../interfaces/IConvexVault.sol';
import '../interfaces/ExtendedIERC20.sol';
import '../interfaces/IStableSwap2Pool.sol';
import '../interfaces/IWETH.sol';
import './BaseStrategy.sol';
import '../interfaces/ICVXMinter.sol';
import '../interfaces/IHarvester.sol';

contract ETHConvexStrategy is BaseStrategy {
    using SafeMath for uint8;

    address public immutable crv;
    address public immutable cvx;
    address public immutable aleth;

    address public immutable crvethPool;
    address public immutable cvxethPool;

    uint256 public immutable pid;
    IConvexVault public immutable convexVault;
    IConvexRewards public immutable crvRewards;
    IStableSwap2Pool public immutable stableSwapPool;

    /**
     * @param _name The strategy name
     * @param _want The desired token of the strategy
     * @param _crvethPool The address of crvEthPool
     * @param _cvxethPool The address of cvxEthPool
     * @param _weth The address of WETH
     * @param _aleth The address of alternative ETH
     * @param _pid The pool id of convex
     * @param _convexVault The address of the convex vault
     * @param _stableSwapPool The address of the stable swap pool
     * @param _controller The address of the controller
     * @param _manager The address of the manager
     * @param _routerArray The addresses of routers for swapping tokens
     */
    constructor(
        string memory _name,
        address _want,
        address _crvethPool,
        address _cvxethPool,
        address _weth,
        address _aleth,
        uint256 _pid,
        IConvexVault _convexVault,
        address _stableSwapPool,
        address _controller,
        address _manager,
        address[] memory _routerArray
    ) public BaseStrategy(_name, _controller, _manager, _want, _weth, _routerArray) {
        require(address(_aleth) != address(0), '!_aleth');
        require(address(_convexVault) != address(0), '!_convexVault');
        require(address(_stableSwapPool) != address(0), '!_stableSwapPool');

        (, , , address _crvRewards, , ) = _convexVault.poolInfo(_pid);
        crv = ICurvePool(_crvethPool).coins(1);
        cvx = ICurvePool(_cvxethPool).coins(1);
        aleth = _aleth;
        pid = _pid;
        convexVault = _convexVault;
        crvRewards = IConvexRewards(_crvRewards);
        stableSwapPool = IStableSwap2Pool(_stableSwapPool);
        crvethPool = _crvethPool;
        cvxethPool = _cvxethPool;
        
        _setApprovals(
            _crvethPool,
            _cvxethPool,
        	_want,
        	address(_convexVault),
        	_stableSwapPool,
        	_aleth,
        	_routerArray,
		    _crvRewards
        );
    }
    
    function _setApprovals(
        address _crvethPool,
        address _cvxethPool,
    	address _want,
    	address _convexVault,
    	address _stableSwapPool,
    	address _aleth,
    	address[] memory _routerArray,
	    address _crvRewards
    )
        internal
    {
        IERC20(ICurvePool(_crvethPool).coins(1)).safeApprove(_crvethPool, 0);
        IERC20(ICurvePool(_crvethPool).coins(1)).safeApprove(_crvethPool, type(uint256).max);
        IERC20(ICurvePool(_cvxethPool).coins(1)).safeApprove(_cvxethPool, 0);
        IERC20(ICurvePool(_cvxethPool).coins(1)).safeApprove(_cvxethPool, type(uint256).max);
        IERC20(_want).safeApprove(address(_convexVault), type(uint256).max);
        uint256 _routerArrayLength = _routerArray.length;
        uint rewardsLength = IConvexRewards(_crvRewards).extraRewardsLength();
        for(uint i=0; i<_routerArrayLength; i++) {
            address _router = _routerArray[i];
            if (rewardsLength > 0) {
            	for(uint j=0; j<rewardsLength; j++) {
                    IERC20(IConvexRewards(IConvexRewards(_crvRewards).extraRewards(j)).rewardToken()).safeApprove(_router, 0);
                    IERC20(IConvexRewards(IConvexRewards(_crvRewards).extraRewards(j)).rewardToken()).safeApprove(_router, type(uint256).max);
            	}
            }		    
        }
        IERC20(_want).safeApprove(address(_stableSwapPool), type(uint256).max);
        IERC20(_aleth).safeApprove(_stableSwapPool, type(uint256).max);
    }

    function _deposit() internal override {
        convexVault.depositAll(pid, true);
    }

    function _claimReward() internal {
        crvRewards.getReward(address(this), true);
    }

    function _addLiquidity(uint256 _estimate) public payable onlyController {
        uint256[2] memory amounts;
        amounts[0] = address(this).balance;
        stableSwapPool.add_liquidity{value: amounts[0]}(amounts, _estimate);
        return;
    }

    function _harvest(uint256[] calldata _estimates) internal override {
        _claimReward();
        uint256 _cvxBalance = IERC20(cvx).balanceOf(address(this));
        if (_cvxBalance > 0) {
            _swapTokensCurve(cvxethPool, 1, 0, _cvxBalance, 1);
        }

        uint256 _extraRewardsLength = crvRewards.extraRewardsLength();
        for (uint256 i = 0; i < _extraRewardsLength; i++) {
            address _rewardToken = IConvexRewards(crvRewards.extraRewards(i)).rewardToken();
            uint256 _extraRewardBalance = IERC20(_rewardToken).balanceOf(address(this));
            if (_extraRewardBalance > 0) {
                _swapTokens(_rewardToken, weth, _extraRewardBalance, 1);
            }
        }

        uint256 _crvBalance = IERC20(crv).balanceOf(address(this));
        if (_crvBalance > 0) {
            _swapTokensCurve(crvethPool, 1, 0, _crvBalance, 1);
        }
        uint256 _remainingWeth = _payHarvestFees();
        if (_remainingWeth > 0) {
            IWETH(weth).withdraw(_remainingWeth);
        }
        _addLiquidity(_estimates[0]);
        if (balanceOfWant() > 0) {
            _deposit();
        }
    }

    function _withdrawAll() internal override {
        crvRewards.withdrawAllAndUnwrap(false);
    }

    function _withdraw(uint256 _amount) internal override {
        crvRewards.withdrawAndUnwrap(_amount, false);
    }

    function balanceOfPool() public view override returns (uint256) {
        return IERC20(address(crvRewards)).balanceOf(address(this));
    }

    receive() external payable {}
}
