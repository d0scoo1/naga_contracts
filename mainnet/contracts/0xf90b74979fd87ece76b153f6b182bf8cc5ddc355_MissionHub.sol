/********************************

⏁⟒⍀⍀⏃⎎⍜⍀⋔⏃⏁⟟⍜⋏ ⏁⍀⏃⋏⌇⋔⟟⌇⌇⟟⍜⋏ ⎐.⟒⌰⟒⎐⟒⋏.⌀

“⋔⟟⌇⌇⟟⍜⋏ ⊑⎍⏚ ⎅⟒⌿⌰⍜⊬⋔⟒⋏⏁”: 

⋔⟟⌇⌇⟟⍜⋏ ⊑⎍⏚: ⏁⊑⟒ ☊⟒⋏⏁⍀⏃⌰⟟⋉⟟⋏☌ ⌰⟟⋏☍ ⏁⍜ ⋔⟟⌇⌇⟟⍜⋏ ☊⍜⋏⏁⍀⍜⌰ ⎎⍜⍀ ⏁⍀⟟⏚⎍⏁⟒, ⍀⟒⏚⎍⟟⌰⎅, ⏃⋏⎅ ⏁⍀⎍⏁⊑.

*********************************/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
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
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {

    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }


    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }   
    
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


contract MissionHub is Context, Ownable {
    using SafeMath for uint256;
    using Address for address;
    
    address payable public tributeWallet;
    address payable public rebuildWallet;
    address payable public truthWallet;
    address payable public controlroomWallet;

    uint256 public tributePercent = 35;
    uint256 public rebuildPercent = 55;
    uint256 public truthPercent = 15;
    uint256 public controlroomPercent = 5;
 
    constructor (address payable _truthWallet, address payable _tributeWallet, address payable _rebuildWallet, address payable _controlroomWallet) {
        tributeWallet = _tributeWallet;
        truthWallet = _truthWallet;
        rebuildWallet = _rebuildWallet;
        controlroomWallet = _controlroomWallet;
    }

    function updateRatios(uint256 _tributePercent,uint256 _rebuildPercent, uint256 _truthPercent, uint256 _controlroomPercent) external onlyOwner {
        require(_tributePercent.add(_rebuildPercent).add(_truthPercent).add(_controlroomPercent) == 100, "Percentages don't add up to 100%");
        tributePercent = _tributePercent;
        rebuildPercent = _rebuildPercent;
        truthPercent = _truthPercent;
        controlroomPercent = _controlroomPercent;
    }

    function setWallets(address _truthWallet,address _rebuildWallet, address _tributeWallet, address _controlroomWallet) external onlyOwner() {
        truthWallet = payable(_truthWallet);
        rebuildWallet = payable(_rebuildWallet);
        tributeWallet = payable(_tributeWallet);
        controlroomWallet = payable(_controlroomWallet);
    }

    function recoverStuckETH(address payable receipient) public onlyOwner {
        receipient.transfer(address(this).balance);
    }

     receive() payable external {
         uint256 contractETHBalance = address(this).balance;
         uint256 amountETHTruth = contractETHBalance.mul(truthPercent).div(100);
         uint256 amountETHRebuild = contractETHBalance.mul(rebuildPercent).div(100);
         uint256 amountETHTribute = contractETHBalance.mul(tributePercent).div(100);
         uint256 amountETHControlroom = contractETHBalance.mul(controlroomPercent).div(100);
         truthWallet.transfer(amountETHTruth);
         rebuildWallet.transfer(amountETHRebuild);
         tributeWallet.transfer(amountETHTribute);
         controlroomWallet.transfer(amountETHControlroom);
     }
}