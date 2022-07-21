// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakingRewards {

    IERC20 public stakingToken;
    IERC20 public rewardsToken;
    
    uint public rewardRate; // tokens distributed per second
    uint public lastUpdateTime;
    uint public rewardPerTokenStored;
    uint public lockedTime; // in seconds
    uint public initialTime; // in seconds
    uint public maxTotalSupply; // max amount of staked tokens, 0 == unlimited
    uint public totalSupply;
    
    address public owner;
    
    bool public paused = false;
    
    mapping(address => uint) public userRewardPerTokenPaid;
    mapping(address => uint) public rewards;
    mapping(address => uint) public stakeStart;
    mapping(address => uint) public balances;

    /* ========== EVENTS ========== */

    event StartStaking(address indexed user, uint _amount);
    event WitdrawStaked(address indexed user, uint _amount, bool _withPenalty);
    event WitdrawRewards(address indexed user, uint _amount);
    event Recovered(address token, uint amount);
    
    /* ========== CONSTRUCTOR ========== */

    constructor(address _stakingToken, address _rewardsToken, uint _rewardRate, uint _lockedTime, uint _initialTime, uint _maxTotalSupply) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
        rewardRate = _rewardRate;
        lockedTime = _lockedTime;
        initialTime = _initialTime;
        maxTotalSupply = _maxTotalSupply;
    }
    
    /* ========== MODIFIERS ========== */

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;

        rewards[account] = earned(account);
        userRewardPerTokenPaid[account] = rewardPerTokenStored;
        _;
    }
    
    /* ========== VIEWS ========== */

    function rewardPerToken() public view returns (uint) {
        if (totalSupply == 0) {
            return 0;
        }
        return
            rewardPerTokenStored +
            (((block.timestamp - lastUpdateTime) * rewardRate * 1e18) / totalSupply);
    }

    function earned(address account) public view returns (uint) {
        if(balances[account] == 0) {
            return rewards[account];
        }
        return
            ((balances[account] *
                (rewardPerToken() - userRewardPerTokenPaid[account])) / 1e18) +
            rewards[account];
    }
    
    /* ========== MUTATIVE FUNCTIONS ========== */

    function stake(uint _amount) external updateReward(msg.sender) {
        require(!paused, "Staking is Paused");
        require(maxTotalSupply == 0 || maxTotalSupply >= totalSupply + _amount, "Max total supply exceeded");

        totalSupply += _amount;
        balances[msg.sender] += _amount;
        stakeStart[msg.sender] = block.timestamp;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        
        emit StartStaking(msg.sender, _amount);
    }
    
    function withdraw(uint _amount) external updateReward(msg.sender) {
        require( (block.timestamp - stakeStart[msg.sender]) >= initialTime, "Not time yet" ); 
        require(balances[msg.sender] > 0, "Nothing to withdraw");
        require(balances[msg.sender] >= _amount, "Amount too high");
        
        if((block.timestamp - stakeStart[msg.sender]) < lockedTime){
            uint _amountToWithdraw = _amount - (_amount / 5); // penalty 20%
            totalSupply -= _amount;
            balances[msg.sender] -= _amount;
            stakingToken.transfer(msg.sender, _amountToWithdraw);
            
            emit WitdrawStaked(msg.sender, _amountToWithdraw, true);
            
        }else{
            totalSupply -= _amount;
            balances[msg.sender] -= _amount;
            stakingToken.transfer(msg.sender, _amount); // without penalty
            
            emit WitdrawStaked(msg.sender, _amount, false);
            
        }
        
    }

    function getReward() external updateReward(msg.sender) {
        require( (block.timestamp - stakeStart[msg.sender]) >= initialTime, "Not time yet" );
        
        uint reward = rewards[msg.sender];

        require(rewardsToken != stakingToken || stakingToken.balanceOf(address(this)) - reward >= totalSupply, "Withdrawal of reward unavailable");

        rewards[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, reward);
        
        emit WitdrawRewards(msg.sender, reward);
    }
    
    /* ========== RESTRICTED FUNCTIONS ========== */

    function recoverERC20(address _tokenAddress, uint _tokenAmount) external onlyOwner {
        require(_tokenAddress != address(stakingToken) || stakingToken.balanceOf(address(this)) - _tokenAmount >= totalSupply, "Cannot withdraw staked tokens."); // can withdraw stakingToken but cannot withdraw the ones that are staked
        
        IERC20(_tokenAddress).transfer(owner, _tokenAmount);

        emit Recovered(_tokenAddress, _tokenAmount);
    }

    function changeRewardRate(uint _rewardRate) public onlyOwner{
        require(_rewardRate > 0, "Value too low");

        rewardRate = _rewardRate;
    }
    
    function changeMaxTotalSupply(uint _maxTotalSupply) public onlyOwner{
        maxTotalSupply = _maxTotalSupply;
    }

    function transferOwnership(address _newOwner) external onlyOwner{
        owner = _newOwner;
    }

    function pause() public onlyOwner{
        paused = true;
    }

    function unpause() public onlyOwner{
        paused = false;
    }
    
}