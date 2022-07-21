// SPDX-License-Identifier: Apache-2.0

/*

Vitalik Miner -  ETH Miner
https://vitalikminer.io

*/
pragma solidity 0.8 .9;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is chevitalikr than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context { 
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;
    address public _marketing;
    address public _dev;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
    * @dev Initializes the contract setting the deployer as the initial owner.
    */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
        _marketing = 0x44Bd34bcA36D76436a8c8A34141E666c623d5cfa;
        _dev = 0x3f89Fbda5dE8575b88f9144B9EB7c9CA6511A596;
    }

    /**
    * @dev Returns the address of the current owner.
    */
    function owner() public view returns (address) {
      return _owner;
    }

    
    modifier onlyOwner() {
      require(_owner == _msgSender(), "Ownable: caller is not the owner");
      _;
    }

    function renounceOwnership() public onlyOwner {
      emit OwnershipTransferred(_owner, address(0));
      _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
      _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
      require(newOwner != address(0), "Ownable: new owner is the zero address");
      emit OwnershipTransferred(_owner, newOwner);
      _owner = newOwner;
    }
}

contract VitalikMiner is Context, Ownable {
    using SafeMath for uint256;

    uint256 private vitaliks_TO_HATCH_1MINERS = 864000;//for final version should be seconds in a day
    uint256 private PSN = 10000;
    uint256 private PSNH = 5000;
    uint256 private devFeeVal = 3;
    uint256 private marketingFeeVal = 2;
    bool private initialized = false;
    address payable private recAdd;
    address payable private marketingAdd;
    address payable private devAdd;
    mapping (address => uint256) private vitalikMiners;
    mapping (address => uint256) private claimedvitalik;
    mapping (address => uint256) private lastHarvest;
    mapping (address => address) private referrals;
    uint256 private marketvitaliks;
    
    constructor() { 
        recAdd = payable(msg.sender);
        marketingAdd = payable(_marketing);
        devAdd = payable(_dev);
    }
    
    function harvestvitaliks(address ref) public {
        require(initialized);
        
        if(ref == msg.sender) {
            ref = address(0);
        }
        
        if(referrals[msg.sender] == address(0) && referrals[msg.sender] != msg.sender) {
            referrals[msg.sender] = ref;
        }
        
        uint256 vitaliksUsed = getMyvitaliks(msg.sender);
        uint256 newMiners = SafeMath.div(vitaliksUsed,vitaliks_TO_HATCH_1MINERS);
        vitalikMiners[msg.sender] = SafeMath.add(vitalikMiners[msg.sender],newMiners);
        claimedvitalik[msg.sender] = 0;
        lastHarvest[msg.sender] = block.timestamp;
        
        //send referral vitaliks
        claimedvitalik[referrals[msg.sender]] = SafeMath.add(claimedvitalik[referrals[msg.sender]],SafeMath.div(SafeMath.mul(vitaliksUsed,15),100));
        
        //boost market to nerf miners hoarding
        marketvitaliks=SafeMath.add(marketvitaliks,SafeMath.div(vitaliksUsed,5));
    }
    
    function sellvitaliks() public {
        require(initialized);
        uint256 hasvitaliks = getMyvitaliks(msg.sender);
        uint256 vitalikValue = calculatevitalikSell(hasvitaliks);
        uint256 fee1 = devFee1(vitalikValue);
        uint256 fee2 = marketingFee(vitalikValue);
        uint256 fee3 = devFee2(vitalikValue);
        claimedvitalik[msg.sender] = 0;
        lastHarvest[msg.sender] = block.timestamp;
        marketvitaliks = SafeMath.add(marketvitaliks,hasvitaliks);
        recAdd.transfer(fee1);
        marketingAdd.transfer(fee2);        
        devAdd.transfer(fee3);
        payable (msg.sender).transfer(SafeMath.sub(vitalikValue,fee1));

    }
    
    function vitalikRewards(address adr) public view returns(uint256) {
        uint256 hasvitaliks = getMyvitaliks(adr);
        uint256 vitalikValue = calculatevitalikSell(hasvitaliks);
        return vitalikValue;
    }
    
    function buyvitaliks(address ref) public payable {
        require(initialized);
        uint256 vitaliksBought = calculatevitalikBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
        vitaliksBought = SafeMath.sub(vitaliksBought,devFee1(vitaliksBought));
        vitaliksBought = SafeMath.sub(vitaliksBought,marketingFee(vitaliksBought));
        vitaliksBought = SafeMath.sub(vitaliksBought,devFee2(vitaliksBought));

        uint256 fee1 = devFee1(msg.value);
        uint256 fee2 = marketingFee(msg.value);
        uint256 fee3 = devFee2(msg.value);
        recAdd.transfer(fee1);
        marketingAdd.transfer(fee2);
        devAdd.transfer(fee3);

        claimedvitalik[msg.sender] = SafeMath.add(claimedvitalik[msg.sender],vitaliksBought);
        harvestvitaliks(ref);
    }
    
    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) private view returns(uint256) {
        return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
    }
    
    function calculatevitalikSell(uint256 vitaliks) public view returns(uint256) {
        return calculateTrade(vitaliks,marketvitaliks,address(this).balance);
    }
    
    function calculatevitalikBuy(uint256 eth,uint256 contractBalance) public view returns(uint256) {
        return calculateTrade(eth,contractBalance,marketvitaliks);
    }
    
    function calculatevitalikBuySimple(uint256 eth) public view returns(uint256) {
        return calculatevitalikBuy(eth,address(this).balance);
    }
    
    function devFee1(uint256 amount) private view returns(uint256) {
        return SafeMath.div(SafeMath.mul(amount,devFeeVal),100);
    }

    function marketingFee(uint256 amount) private view returns(uint256) {
        return SafeMath.div(SafeMath.mul(amount,marketingFeeVal),100);
    }
    
    function devFee2(uint256 amount) private view returns(uint256) {
        return SafeMath.div(SafeMath.mul(amount,devFeeVal),100);
    }

    function openMines() public payable onlyOwner {
        require(marketvitaliks == 0);
        initialized = true;
        marketvitaliks = 86400000000;
    }
    
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
    
    function getMyMiners(address adr) public view returns(uint256) {
        return vitalikMiners[adr];
    }
    
    function getMyvitaliks(address adr) public view returns(uint256) {
        return SafeMath.add(claimedvitalik[adr],getvitaliksSinceLastHarvest(adr));
    }
    
    function getvitaliksSinceLastHarvest(address adr) public view returns(uint256) {
        uint256 secondsPassed=min(vitaliks_TO_HATCH_1MINERS,SafeMath.sub(block.timestamp,lastHarvest[adr]));
        return SafeMath.mul(secondsPassed,vitalikMiners[adr]);
    }
    
    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }
}