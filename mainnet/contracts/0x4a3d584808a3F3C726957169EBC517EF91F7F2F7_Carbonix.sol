// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
            unchecked {
                _approve(sender, _msgSender(), currentAllowance - amount);
            }
        }

        _transfer(sender, recipient, amount);

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

abstract contract ERC20Burnable is Context, ERC20 {
    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual {
        uint256 currentAllowance = allowance(account, _msgSender());
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        unchecked {
            _approve(account, _msgSender(), currentAllowance - amount);
        }
        _burn(account, amount);
    }
}
// kWh contract
contract KWH is ERC20, ERC20Burnable, Ownable {
    // Create crowdsale variable (type address), which will be the address where the crowdsale is deployed
    address public crowdsale;
    // Create array to track minters
    address[] public minters;
    // Create mapping of allowances
    mapping (address => mapping (address => uint)) public allowed;
    // Feed constructor the name/symbol, set message caller (owner) as approved minter, excluded owner from tax and set the owner's address as feeDist
    constructor() ERC20("kWh", "kWh") {
    }
    // Modifier to limit calls to only approved minters
    modifier onlyMinters {
        require(msg.sender == crowdsale, "Only approved minters can call this function");
        _;
    }
    // Mint function
    function mint(address to, uint256 amount) public onlyMinters returns(bool) {
        _mint(to, amount);
        return true;
    }
    // Define crowdsale address (only owner may call)
    function addCrowdsale(address _crowdsale) public onlyOwner returns (bool) {
        require(crowdsale == address(0), "Crowdsale address has already been defned!");
        minters.push(_crowdsale);
        crowdsale = _crowdsale;
        return true;
    }
}
// CNIX contract
contract Carbonix is ERC20, ERC20Burnable, Ownable {
    // Create supplyCap variable
    uint256 public supplyCap = 10000000000000000000000000000;
    // Create crowdsale variable (type address), which will be the address where the crowdsale is deployed
    address public crowdsale;
    // Create mappings to identifying certain classes of users
    mapping (address => bool) public farms;
    // Create mapping of allowances
    mapping (address => mapping (address => uint)) public allowed;
    // Create array to track minters
    address[] public minters;
    // Feed constructor the name/symbol, set message caller (owner) as approved minter, excluded owner from tax and set the owner's address as feeDist
    constructor() ERC20("Carbonix", "CNIX") {
    }
    // Modifier to limit calls to only approved minters
    modifier onlyMinters {
        require(farms[msg.sender] == true || msg.sender == crowdsale, "Only approved minters can call this function");
        _;
    }
    // Mint function
    function mint(address to, uint256 amount) public onlyMinters returns(bool) {
        require(totalSupply() + amount < supplyCap, "Minting the desired amount of CNIX would exceed the supply cap on CNIX!");
        _mint(to, amount);
        return true;
    }
    // Define the addresss of a farm (only owner may call)
    function addFarm(address newFarm) public onlyOwner returns (bool) {
        minters.push(newFarm);
        farms[newFarm] = true;
        return true;
    }
    // Define crowdsale address (only owner may call)
    function addCrowdsale(address _crowdsale) public onlyOwner returns (bool) {
        require(crowdsale == address(0), "Crowdsale address has already been defned!");
        minters.push(_crowdsale);
        crowdsale = _crowdsale;
        return true;
    }
}
// Crowdsale contract
contract Crowdsale is Ownable {
    // Create forwardAddress, the EOA that will take the eth sent to the crowdsale
    address payable private forwardAddress;
    // Create kwh and car, the instances of kwh/carbonix token contracts
    KWH private kwh;
    Carbonix private car;
    // Create the eth to kwh variable
    uint256 public ethToKwh;
    // Create the eth to cnix variable
    uint256 public ethToCnix;
    // Create the carbonixReward variable (10000 represents 1:1 reward on kwh purchased)
    uint256 public carbonixReward;
    // Pass kwh token contract address, car token contract address, initial rate and initial carbonixReward. Set forwardAddress to msg.sender(owner)  
    constructor(KWH _kwh, Carbonix _car, uint256 _ethToKwh, uint256 _ethToCnix, uint256 _carbonixReward) {
        kwh = _kwh;
        car = _car;
        ethToKwh = _ethToKwh;
        ethToCnix = _ethToCnix;
        carbonixReward = _carbonixReward;
        forwardAddress = payable(msg.sender);
    }
    // Update carbonixReward
    function updateCarbonixReward(uint256 _carbonixReward) public onlyOwner returns (bool) {
        carbonixReward = _carbonixReward;
        return true;
    }
    // Update ETH-kWh rate
    function updateKwhRate(uint256 _ethToKwh) public onlyOwner returns (bool) {
        ethToKwh = _ethToKwh;
        return true;
    }
    // Update ETH-CNIX rate
    function updateCnixRate(uint256 _ethToCnix) public onlyOwner returns (bool) {
        ethToCnix = _ethToCnix;
        return true;
    }
    // Update the EOA where ETH is forwarded
    function updateForwardAddress(address _new) public onlyOwner returns (bool) {
        forwardAddress = payable(_new);
        return true;
    }
    // Payable function to purchase kwh with eth at current crowdsale price and reward rate
    function buyKwh() public payable returns (bool) {
        address client = msg.sender;
        uint256 kwhToSend = msg.value * ethToKwh;
        forwardAddress.transfer(msg.value);
        kwh.mint(client, kwhToSend);
        if (kwhToSend > 10000 && carbonixReward > 0) {
            car.mint(client, (kwhToSend * carbonixReward) / 10000);
        }
        return true;
    }
    // Payable function to purchase cnix with eth at current crowdsale price
    function buyCnix() public payable returns (bool) {
        address client = msg.sender;
        uint256 cnixToSend = msg.value * ethToCnix;
        forwardAddress.transfer(msg.value);
        car.mint(client, cnixToSend);
        return true;
    }
}
// CNIXFarm contract
contract CNIXFarm is Ownable{
    // Define Depositor struct
    struct Depositor {
        uint256 deposit;
        uint256 withdrawable;
        uint256 withdrawn;
        uint256 lastUpdate;
    }
    // Create cnix, an instance of Carbonix token contract
    Carbonix private cnix;
    // Create rewardPerSecond
    uint256 rewardPerSec;
    // Create mapping of address to Depositor struct
    mapping (address => Depositor) private depositors;
    // Create mapping of address to bool, true if a user has deposited or attempted to deposit 
    // (which would create a Depositor assosicated with the address in depositors mapping
    mapping (address => bool) private hasDeposited;
    // Pass Carbonix token contract address and initial rewardsPerSecond
    constructor (Carbonix _cnix, uint256 _rewardPerSec) {
        cnix = _cnix;
	    rewardPerSec = _rewardPerSec;
    }
    // Update Depositor associated with address in depositors
    function updateDepositor(address _depositor) internal {
        if (hasDeposited[_depositor] == true) {
            uint256 delta = block.timestamp - depositors[_depositor].lastUpdate;
            uint256 reward = delta * rewardPerSec;
            depositors[_depositor].withdrawable += (reward * depositors[_depositor].deposit);
            depositors[_depositor].lastUpdate = block.timestamp;
        }
        else {
            depositors[_depositor] = Depositor(0, 0, 0, block.timestamp);
            hasDeposited[_depositor] = true;
        }
    }
    // Update the rewardPerSecond
    function updateReward(uint256 _new) public onlyOwner {
	    rewardPerSec = _new;
    }   
    // Deposit CNIX
    function depositCnix(uint256 _amount) public {
        updateDepositor(msg.sender);
        cnix.transferFrom(msg.sender, payable(address(this)), _amount);
	    depositors[msg.sender].deposit += _amount;	
        depositors[msg.sender].lastUpdate = block.timestamp;
    }
    // Withdraw CNIX earned
    function withdrawRewards(uint256 _amount) public {
        updateDepositor(msg.sender);
        require(_amount < depositors[msg.sender].withdrawable, "Attempted to withdraw more CNIX than withdrawable");
        depositors[msg.sender].withdrawable -= _amount;
        depositors[msg.sender].withdrawn += _amount;
        cnix.mint(msg.sender, _amount);
    }
    // Withdraw CNIX staked as collateral
    function withdrawCollateral(uint256 _amount) public {
        updateDepositor(msg.sender);
        require(_amount < depositors[msg.sender].deposit, "Attempted to withdraw more collateral than was deposited");
        depositors[msg.sender].deposit -= _amount;
        cnix.transfer(msg.sender, _amount);
    }
    // Withdraw CNIX staked as collateral and CNIX rewards earned
    function withdrawEverything() public {
        updateDepositor(msg.sender);
        require(0 < depositors[msg.sender].withdrawable, "No rewards accured");
        require(0 < depositors[msg.sender].deposit, "No collateral deposited");
        cnix.transfer(msg.sender, depositors[msg.sender].deposit);
        depositors[msg.sender].deposit = 0;
        cnix.mint(msg.sender, depositors[msg.sender].withdrawable);
        depositors[msg.sender].withdrawn += depositors[msg.sender].withdrawable;
        depositors[msg.sender].withdrawable = 0;
    }
    // Update the function caller's information in depositors
    function updateAccount() public {
        updateDepositor(msg.sender);
    }
}