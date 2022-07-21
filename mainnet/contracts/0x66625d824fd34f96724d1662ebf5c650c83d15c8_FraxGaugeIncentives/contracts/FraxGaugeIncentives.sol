// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.6;

// ====================================================================
// |       ______                _                 ___      __        |
// |      / ____/________ __  __(_)___ ___  ____ _/ (_)____/ /______  |
// |     / /_  / ___/ __ `/ |/_/ / __ `__ \/ __ `/ / / ___/ __/ ___/  |
// |    / __/ / /  / /_/ />  </ / / / / / / /_/ / / (__  ) /_(__  )   |
// |   /_/   /_/   \__,_/_/|_/_/_/ /_/ /_/\__,_/_/_/____/\__/____/    |
// |                                                                  |
// ====================================================================
// ============================= Pitch ================================
// ====================================================================

// Original idea and credit: 
// Curve Finance's Incentive System 
// bribe.crv.finance
// https://etherscan.io/address/0x7893bbb46613d7a4fbcc31dab4c9b823ffee1026
// Almost all logic and algorithms used are from that team, with the only difference being contract addresses, an implementation of fees, ownability, events for monitoring, and changes in variable visibility.

// Primary Author(s)
// Charlie Pyle: https://github.com/charliepyle

import "@openzeppelin/contracts/access/Ownable.sol";

// Interface used to interact with Frax's gauge system, which is found here: https://etherscan.io/address/0x44ade9AA409B0C29463fF7fcf07c9d3c939166ce
interface GaugeController {
    struct VotedSlope {
        uint slope;
        uint power;
        uint end;
    }
    
    struct Point {
        uint bias;
        uint slope;
    }
    
    function vote_user_slopes(address, address) external view returns (VotedSlope memory);
    function last_user_vote(address, address) external view returns (uint);
    function points_weight(address, uint256) external view returns (Point memory);
    function checkpoint_gauge(address) external;
}

// Interface used to interact with Frax's veFXS system, which is found here: https://etherscan.io/address/0xc8418aF6358FFddA74e09Ca9CC3Fe03Ca6aDC5b0
interface ve {
    function get_last_user_slope(address) external view returns (int128);
}

interface erc20 { 
    function transfer(address recipient, uint256 amount) external returns (bool);
    function decimals() external view returns (uint8);
    function balanceOf(address) external view returns (uint);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint amount) external returns (bool);
}

contract FraxGaugeIncentives is Ownable {
    uint constant WEEK = 86400 * 7;
    uint constant PRECISION = 10**18;

    // Fee structure added using Votium as reference implementation
    
    // Fraximalists Multisig
    address public feeAddress = 0x8A421C3A25e8158b9aC815aE1319fBCf83F6bD6c;
    uint256 public platformFee = 400;             // 4%
    uint256 public constant DENOMINATOR = 10000;  // denominates weights 10000 = 100%

    // The two addresses below are changed from the bribe.crv.finance implementation
    GaugeController constant GAUGE = GaugeController(0x44ade9AA409B0C29463fF7fcf07c9d3c939166ce);
    ve constant VE = ve(0xc8418aF6358FFddA74e09Ca9CC3Fe03Ca6aDC5b0);
    
    // These mappings were made public, while the bribe.crv.finance implementation keeps them private.
    mapping(address => mapping(address => uint)) public _claims_per_gauge;
    mapping(address => mapping(address => uint)) public _reward_per_gauge;
    
    mapping(address => mapping(address => uint)) public reward_per_token;
    mapping(address => mapping(address => uint)) public active_period;
    mapping(address => mapping(address => mapping(address => uint))) public last_user_claim;
    
    mapping(address => address[]) _rewards_per_gauge;
    mapping(address => address[]) _gauges_per_reward;
    mapping(address => mapping(address => bool)) _rewards_in_gauge;

    
    
    function _add(address gauge, address reward) internal {
        if (!_rewards_in_gauge[gauge][reward]) {
            _rewards_per_gauge[gauge].push(reward);
            _gauges_per_reward[reward].push(gauge);
            _rewards_in_gauge[gauge][reward] = true;
        }
    }
    
    function rewards_per_gauge(address gauge) external view returns (address[] memory) {
        return _rewards_per_gauge[gauge];
    }
    
    function gauges_per_reward(address reward) external view returns (address[] memory) {
        return _gauges_per_reward[reward];
    }
    
    function _update_period(address gauge, address reward_token) internal returns (uint) {
        uint _period = active_period[gauge][reward_token];
        if (block.timestamp >= _period + WEEK) {
            _period = block.timestamp / WEEK * WEEK;
            GAUGE.checkpoint_gauge(gauge);
            uint _slope = GAUGE.points_weight(gauge, _period).slope;
            uint _amount = _reward_per_gauge[gauge][reward_token] - _claims_per_gauge[gauge][reward_token];
            reward_per_token[gauge][reward_token] = _amount * PRECISION / _slope;
            active_period[gauge][reward_token] = _period;
        }
        return _period;
    }
    
    function add_reward_amount(address gauge, address reward_token, uint amount) external returns (bool) {
        // The below was added to the bribe.crv.finance implementation to handle fee distribution
        uint256 fee = amount*platformFee/DENOMINATOR;
        uint256 incentiveTotal = amount-fee;
        _safeTransferFrom(reward_token, msg.sender, feeAddress, fee);
        
        // replaced the amount variable with our incentiveTotal variable
        _safeTransferFrom(reward_token, msg.sender, address(this), incentiveTotal);
        _reward_per_gauge[gauge][reward_token] += incentiveTotal;
        _update_period(gauge, reward_token);
        _add(gauge, reward_token);
        return true;
    }
    
    function tokens_for_incentive(address user, address gauge, address reward_token) external view returns (uint) {
        return uint(int(VE.get_last_user_slope(user))) * reward_per_token[gauge][reward_token] / PRECISION;
    }
    
    function claimable(address user, address gauge, address reward_token) external view returns (uint) {
        uint _period = active_period[gauge][reward_token];
        uint _amount = 0;
        if (last_user_claim[user][gauge][reward_token] < _period) {
            uint _last_vote = GAUGE.last_user_vote(user, gauge);
            if (_last_vote < _period) {
                uint _slope = GAUGE.vote_user_slopes(user, gauge).slope;
                _amount = _slope * reward_per_token[gauge][reward_token] / PRECISION;
            }
        }
        return _amount;
    }
    
    function claim_reward(address user, address gauge, address reward_token) external returns (uint) {
        uint amount = _claim_reward(user, gauge, reward_token);
        emit Claimed(user, gauge, reward_token, amount);
        return amount;
    }
    
    function claim_reward(address gauge, address reward_token) external returns (uint) {
        uint amount = _claim_reward(msg.sender, gauge, reward_token);
        emit Claimed(msg.sender, gauge, reward_token, amount);
        return amount;
    }
    
    function _claim_reward(address user, address gauge, address reward_token) internal returns (uint) {
        uint _period = _update_period(gauge, reward_token);
        uint _amount = 0;
        if (last_user_claim[user][gauge][reward_token] < _period) {
            last_user_claim[user][gauge][reward_token] = _period;
            uint _last_vote = GAUGE.last_user_vote(user, gauge);
            if (_last_vote < _period) {
                uint _slope = GAUGE.vote_user_slopes(user, gauge).slope;
                _amount = _slope * reward_per_token[gauge][reward_token] / PRECISION;
                if (_amount > 0) {
                    _claims_per_gauge[gauge][reward_token] += _amount;
                    _safeTransfer(reward_token, user, _amount);
                }
            }
        }

        return _amount;
    }
    
    function _safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) =
            token.call(abi.encodeWithSelector(erc20.transfer.selector, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))));
    }
    
    function _safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) =
            token.call(abi.encodeWithSelector(erc20.transferFrom.selector, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))));
    }

    /* ========== OWNER FUNCTIONS ========== */

    // update fee address
    function updateFeeAddress(address _feeAddress) public onlyOwner {
      feeAddress = _feeAddress;
    }

    // update fee amount
    function updateFeeAmount(uint256 _feeAmount) public onlyOwner {
      require(_feeAmount < 400, "max fee"); // Max fee 4%
      platformFee = _feeAmount;
      emit UpdatedFee(_feeAmount);
    }



    /* ========== EVENTS ========== */
    /* This event was added to record claimed events for testing purposes, but it isn't strictly needed for the app's functionality. */
    event Claimed(address indexed user, address indexed gauge, address indexed token, uint256 amount);
    event UpdatedFee(uint256 _feeAmount);
    
}