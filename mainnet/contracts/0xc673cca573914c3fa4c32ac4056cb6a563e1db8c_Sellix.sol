pragma solidity 0.4.24;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

interface Token {
    function transfer(address _to, uint256 _value) external returns (bool success);
    function balanceOf(address who) external view returns (uint256 balance);
}

contract Sellix {
    using SafeMath for uint256;
    
    address public owner;
    uint public tokenSendFee; // in wei
    uint public ethSendFee; // in wei
    
    constructor() public payable {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }
    
    function multiPayoutEth(address[] addresses, uint256[] amounts) public onlyOwner returns(bool success) {
        uint total = 0;

        for (uint8 i = 0; i < amounts.length; i++){
            total = total.add(amounts[i]);
        }
        
        // ensure that the ethreum is enough to complete the transaction
        uint requiredAmount = total.add(ethSendFee * 1 wei);
        require(address(this).balance >= (requiredAmount * 1 wei));
        
        // transfer to each address
        for (uint8 j = 0; j < addresses.length; j++) {
            addresses[j].transfer(amounts[j] * 1 wei);
        }

        return true;
    }
    
    function balance() public constant returns (uint value) {
        return address(this).balance;
    }
    
    function balanceToken(Token tokenAddr) public constant returns (uint value) {
        return tokenAddr.balanceOf(address(this));
    }
    
    function deposit() payable public onlyOwner returns (bool) {
        return true;
    }
    
    function withdrawEther(address addr, uint amount) public onlyOwner returns(bool success) {
        addr.transfer(amount * 1 wei);
        return true;
    }
    
    function withdrawToken(Token tokenAddr, address _to, uint _amount) public onlyOwner returns(bool success) {
        tokenAddr.transfer(_to, _amount);
        return true;
    }
    
    function multiPayoutToken(Token tokenAddr, address[] addresses, uint256[] amounts) public onlyOwner returns(bool success) {
        uint total = 0;

        for (uint8 i = 0; i < amounts.length; i++) {
            total = total.add(amounts[i]);
        }
        
        // check if user has enough balance
        require(total <= tokenAddr.balanceOf(address(this)));
        
        // transfer token to addresses
        for (uint8 j = 0; j < addresses.length; j++) {
            tokenAddr.transfer(addresses[j], amounts[j]);
        }
        
        return true;
    }
    
    function setTokenFee(uint _tokenSendFee) public onlyOwner returns(bool success) {
        tokenSendFee = _tokenSendFee;
        return true;
    }
    
    function setEthFee(uint _ethSendFee) public onlyOwner returns(bool success) {
        ethSendFee = _ethSendFee;
        return true;
    }
 
    function contractAddress() public onlyOwner constant returns (address) {
        return address(this);
    }

    function destroy (address _to) public onlyOwner {
        selfdestruct(_to);
    }
}