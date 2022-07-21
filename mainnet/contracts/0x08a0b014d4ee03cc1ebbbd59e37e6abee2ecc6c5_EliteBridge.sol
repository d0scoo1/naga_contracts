pragma solidity 0.8.7;
// SPDX-License-Identifier: Unlicensed
pragma abicoder v2;

interface IERC20 {

    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library ECDSA {
    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toETHSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        // Check the signature length
        if (signature.length != 65) {
            revert("ECDSA: invalid signature length");
        }

        // Divide the signature in r, s and v variables
        bytes32 r;
        bytes32 s;
        uint8 v;

        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            revert("ECDSA: invalid signature 's' value");
        }

        if (v != 27 && v != 28) {
            revert("ECDSA: invalid signature 'v' value");
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
    }

    /**
     * @dev Returns an ETHereum Signed Message, created from a `hash`. This
     * replicates the behavior of the
     * https://github.com/ETHereum/wiki/wiki/JSON-RPC#ETH_sign[`ETH_sign`]
     * JSON-RPC mETHod.
     *
     * See {recover}.
     */
    function toETHSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}

contract EliteBridge is Ownable {
    
    struct userDetails {
        uint amount;
        address token;
        uint lastTransaction;
    }
    
      // ECDSA Address
    using ECDSA for address;
    address public signer;
    bool public lockStatus;
    
    event SetSigner(address indexed user,address indexed signer);
    event Deposit(address indexed user,uint amount,address indexed token,uint time);
    event Claim(address indexed user,address indexed token,uint amount,uint time);
    event Fallback(address indexed user,uint amount,uint time);
    event Failsafe(address indexed user, address indexed tokenAddress,uint amount);
    
    mapping(bytes32 => bool)public msgHash;
    mapping(address => mapping(address => userDetails))public UserInfo;
    mapping (address => bool) public isApproved;
    
    constructor (address _signer)  {
        signer = _signer;
    }
    
    /**
     * @dev Throws if lockStatus is true
    */
    modifier isLock() {
        require(lockStatus == false, "Elite: Contract Locked");
        _;
    }

    modifier isApprove(address _token){
        require(isApproved[_token],"Un approve token");
        _;
    }

    /**
     * @dev Throws if called by other contract
     */
    modifier isContractCheck(address _user) {
        require(!isContract(_user), "Elite: Invalid address");
        _;
    }
    
    function addToken(address _tokenAddress,uint _amount) public onlyOwner {
        require(_amount > 0,"Invalid amount");
        IERC20(_tokenAddress).transferFrom(msg.sender,address(this),_amount);
    }
    
    receive()external payable {
        emit Fallback(msg.sender,msg.value,block.timestamp);
    }

    function approveTokenToDeposit(address _tokenAddress, bool _approveStatus) external onlyOwner {
        isApproved[_tokenAddress] = _approveStatus;
    }
    
    function deposit(address _tokenAddress, uint _amount)public isLock isApprove(_tokenAddress){
        require (_amount > 0,"Incorrect params");
        userDetails storage users = UserInfo[msg.sender][_tokenAddress]; 
        IERC20(_tokenAddress).transferFrom(msg.sender,address(this),_amount);
        users.token = _tokenAddress;
        users.amount = _amount;
        users.lastTransaction = block.timestamp;
        emit Deposit(msg.sender,_amount,_tokenAddress,block.timestamp);
    }
    
    function claim(address _user,address _tokenAddress,uint amount, bytes calldata signature,uint _time) public isLock isApprove(_tokenAddress) {
        
        //messageHash can be used only once
        require(_time > block.timestamp,"signature Expiry");
        bytes32 messageHash = message(_user, _tokenAddress,amount,_time);
        require(!msgHash[messageHash], "claim: signature duplicate");
        
        //Verifes signature    
        address src = verifySignature(messageHash, signature);
        require(signer == src, " claim: unauthorized");
        IERC20(_tokenAddress).transfer(_user,amount);
        msgHash[messageHash] = true;
        emit Claim(_user,_tokenAddress,amount,block.timestamp);
    }
    
    /**
    * @dev ETHereum Signed Message, created from `hash`
    * @dev Returns the address that signed a hashed message (`hash`) with `signature`.
    */
    function verifySignature(bytes32 _messageHash, bytes memory _signature) public pure returns (address signatureAddress)
    {
        bytes32 hash = ECDSA.toETHSignedMessageHash(_messageHash);
        signatureAddress = ECDSA.recover(hash, _signature);
    }
    
    /**
    * @dev Returns hash for given data
    */
    function message(address  _receiver, address _tokenAdderss ,uint amount,uint time)
        public pure returns(bytes32 messageHash)
    {
        messageHash = keccak256(abi.encodePacked(_receiver, _tokenAdderss,amount,time));
    }
    
    // updaate signer address
    function setSigner(address _signer)public onlyOwner{
        signer = _signer;
        emit SetSigner(msg.sender, _signer);
    }
    
    function failsafe(address user,address tokenAddress,uint amount)public onlyOwner{
        if(tokenAddress == address(0x0)){
            payable(user).transfer(amount);
        }else {
            IERC20(tokenAddress).transfer(user,amount);
        }
        
        emit Failsafe(user, tokenAddress,amount);
    }
    
    function checkBalance()public view returns(uint){
        return address(this).balance;
    }
    
     /**
     * @dev contractLock: For contract status
     */
    function contractLock(bool _lockStatus) public onlyOwner returns(bool) {
        lockStatus = _lockStatus;
        return true;
    }

    /**
     * @dev isContract: Returns true if account is a contract
     */
    function isContract(address _account) public view returns(bool) {
        uint32 size;
        assembly {
            size:= extcodesize(_account)
        }
        if (size != 0)
            return true;
        return false;
    }
    
}