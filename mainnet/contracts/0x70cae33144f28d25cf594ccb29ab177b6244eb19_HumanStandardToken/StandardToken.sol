//You should inherit from StandardToken or, for a token like you would want to
//deploy in something like Mist, see HumanStandardToken.sol.
//(This implements ONLY the standard functions and NOTHING else.
//If you deploy this, you won't have anything useful.)
//Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20.*/

pragma solidity ^0.4.11;
import "./Token.sol";
contract StandardToken is Token {
    function transfer(address _to, uint256 _value) returns (bool success) {
        //默认totalSupply 不会超过最大值 (2^256 - 1).
        //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
        //require(balances[msg.sender] >= _value && balances[_to] + _value >balances[_to]);
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
        balances[_to] += _value;//往接收账户增加token数量_value
        Transfer(msg.sender, _to, _value);//触发转币交易事件
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
        require(balances[_from] >= _value && allowed[_from][msg.sender] >=  _value);
        balances[_to] += _value;//接收账户增加token数量_value
        balances[_from] -= _value;//支出账户_from减去token数量_value
        allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
        Transfer(_from, _to, _value);//触发转币交易事件
        return true;
    }
    //查询余额
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
    //授权账户_spender可以从消息发送者账户转出数量为_value的token
    function approve(address _spender, uint256 _value) returns (bool success)   
    {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}