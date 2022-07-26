/**
WEM PROJECT
------------
Creation Date: 9 JUNE 2020

/// GUIDESTONE ///

- Maintain network growth in perpetual balance with wisely duplication.
- Follow the GUIDESTONE, extend the network, and sustain data.
- Unite mankind with a living new reserve system.
- Rule all things with tempered, balance rights and duties.
- Feed and respect passion, faith and traditions, and value the victory.
- Prize truth, beauty, love, harmony and balance with infinite value.
- Avoid petty laws and always be top of useless officials.
- Study wisely and follow the nature rules.
- We are wise and free mankind, let all nations rule internally.

Content Signature (SHA256): 8d6e3c80b4f7fa160b87960ca504c2f49021923f38d5390bad1c54ab3a5927e7

"SEARCH CONTENT SIGNATURE AND YOU WILL FIND WEM"
*/


// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.8;

interface IWEM20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

contract WEM20 is IWEM20 {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "WEM20: transfer from the zero address");
        require(recipient != address(0), "WEM20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "WEM20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address owner, uint256 value) internal {
        require(owner != address(0), "WEM20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[owner] = _balances[owner].sub(value);
        emit Transfer(owner, address(0), value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "WEM20: approve from the zero address");
        require(spender != address(0), "WEM20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _burnFrom(address owner, uint256 amount) internal {
        _burn(owner, amount);
        _approve(owner, msg.sender, _allowances[owner][msg.sender].sub(amount));
    }
}

contract WEM is WEM20 {
    string public constant name = "WEM";
    string public constant symbol = "WEM"; 
    uint8 public constant decimals = 12; 
    uint256 public constant initialSupply = 369127105115000000000000;
    
    constructor() public {
        super._mint(msg.sender, initialSupply);
        owner = msg.sender;
    }

    address public owner;

    event OwnershipRenounced(address indexed previousOwner);
    event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "This is not Owner.");
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        _transferOwnership(_newOwner);
    }

    function _transferOwnership(address _newOwner) internal {
        require(_newOwner != address(0), "This is Owner.");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    event Burn(address indexed burner, uint256 value);

    function burn(uint256 _value) public onlyOwner{
        require(_value <= super.balanceOf(owner), "Small Balance.");

        _burn(owner, _value);
        emit Burn(owner, _value);
    }
    
}