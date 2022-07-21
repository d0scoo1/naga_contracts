// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

import "./Interfaces/IStrategy.sol";
import "./Interfaces/IVault.sol";

interface IERC20Extend is IERC20 {
    function decimals() external view returns (uint8);
}

/**
 * @dev Implementation of a vault to deposit funds for yield optimizing.
 * This is the contract that receives funds and that users interface with.
 * The yield optimizing strategy itself is implemented in a separate 'Strategy.sol' contract.
 */
contract Vault is
    IVault,
    ERC20Upgradeable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable
{
    using SafeERC20 for IERC20;
    using SafeMathUpgradeable for uint256;

    struct StratCandidate {
        address implementation;
        uint256 proposedTime;
    }

    IERC20 public override want;

    // The last proposed strategy to switch to.
    StratCandidate public stratCandidate;
    // The strategy currently in use by the vault.
    IStrategy public strategy;
    // The minimum time it has to pass before a strat candidate can be approved.
    uint256 public approvalDelay;

    /**
     * @dev Sets the value of {token} to the token that the vault will
     * hold as underlying value. It initializes the vault's own token.
     * This token is minted when someone does a deposit. It is burned in order
     * to withdraw the corresponding portion of the underlying assets.
     * @param _want address of want.
     * @param _name the name of the vault token.
     * @param _symbol the symbol of the vault token.
     */
    function initialize(
        address _want,
        string memory _name,
        string memory _symbol
    ) public initializer {
        __Ownable_init();
        __ReentrancyGuard_init_unchained();

        __ERC20_init_unchained(_name, _symbol);
        want = IERC20(_want);
        _setupDecimals(IERC20Extend(_want).decimals());

        emit WantUpdated(_want);
    }

    /**

     * @param _strategy the address of the strategy.
     * @param _approvalDelay the delay before a new strat can be approved.
     */
    function setParams(IStrategy _strategy, uint256 _approvalDelay)
        external
        onlyOwner
    {
        _checkStrategy(_strategy);
        strategy = _strategy;
        approvalDelay = _approvalDelay;

        emit StrategyUpdated(address(_strategy));
    }

    /**
     * @dev It calculates the total underlying value of {token} held by the system.
     * It takes into account the vault contract balance, the strategy contract balance
     *  and the balance deployed in other contracts as part of the strategy.
     */
    function balance() public view override returns (uint256) {
        return
            want.balanceOf(address(this)).add(IStrategy(strategy).balanceOf());
    }

    /**
     * @dev Custom logic in here for how much the vault allows to be borrowed.
     * We return 100% of tokens for now. Under certain conditions we might
     * want to keep some of the system funds at hand in the vault, instead
     * of putting them to work.
     */
    function available() public view override returns (uint256) {
        return want.balanceOf(address(this));
    }

    /**
     * @dev Function for various UIs to display the current value of one of our yield tokens.
     * Returns an uint256 with 18 decimals of how much underlying asset one vault share represents.
     */
    function getPricePerFullShare() public view override returns (uint256) {
        return
            totalSupply() == 0 ? 1e18 : balance().mul(1e18).div(totalSupply());
    }

    /**
     * @dev A helper function to call deposit() with all the sender's funds.
     */
    function depositAll() external override returns (uint256) {
        return deposit(want.balanceOf(msg.sender));
    }

    /**
     * @dev The entrypoint of funds into the system. People deposit with this function
     * into the vault. The vault is then in charge of sending funds into the strategy.
     */
    function deposit(uint256 _amount)
        public
        override
        nonReentrant
        returns (uint256)
    {
        strategy.beforeDeposit();

        uint256 _pool = balance();
        want.safeTransferFrom(msg.sender, address(this), _amount);
        earn();
        uint256 _after = balance();
        _amount = _after.sub(_pool); // Additional check for deflationary tokens
        uint256 shares = 0;
        if (totalSupply() == 0) {
            shares = _amount;
        } else {
            shares = (_amount.mul(totalSupply())).div(_pool);
        }
        _mint(msg.sender, shares);

        emit Deposited(msg.sender, _amount);

        return shares;
    }

    /**
     * @dev Function to send funds into the strategy and put them to work. It's primarily called
     * by the vault's deposit() function.
     */
    function earn() public override {
        uint256 _bal = available();
        want.safeTransfer(address(strategy), _bal);
        strategy.deposit();
    }

    /**
     * @dev A helper function to call withdraw() with all the sender's funds.
     */
    function withdrawAll() external override returns (uint256) {
        return withdraw(balanceOf(msg.sender));
    }

    /**
     * @dev Function to exit the system. The vault will withdraw the required tokens
     * from the strategy and pay up the token holder. A proportional number of IOU
     * tokens are burned in the process.
     */
    function withdraw(uint256 _shares) public override returns (uint256) {
        uint256 r = (balance().mul(_shares)).div(totalSupply());
        _burn(msg.sender, _shares);

        uint256 b = want.balanceOf(address(this));
        if (b < r) {
            uint256 _withdraw = r.sub(b);
            strategy.withdraw(_withdraw);
            uint256 _after = want.balanceOf(address(this));
            uint256 _diff = _after.sub(b);
            if (_diff < _withdraw) {
                r = b.add(_diff);
            }
        }

        want.safeTransfer(msg.sender, r);

        emit Withdrawn(msg.sender, _shares);

        return r;
    }

    function _checkStrategy(IStrategy _strategy) internal view {
        require(
            address(this) == _strategy.vault() && want == _strategy.want(),
            "_strategy not valid for this Vault"
        );
    }

    /**
     * @dev Sets the candidate for the new strat to use with this vault.
     * @param _implementation The address of the candidate strategy.
     */
    function proposeStrat(address _implementation) public override onlyOwner {
        _checkStrategy(IStrategy(_implementation));

        stratCandidate = StratCandidate({
            implementation: _implementation,
            proposedTime: block.timestamp
        });

        emit StrategyProposed(_implementation);
    }

    /**
     * @dev It switches the active strat for the strat candidate. After upgrading, the
     * candidate implementation is set to the 0x00 address, and proposedTime to a time
     * happening in +100 years for safety.
     */

    function upgradeStrat() public override onlyOwner {
        require(
            stratCandidate.implementation != address(0),
            "There is no candidate"
        );
        require(
            stratCandidate.proposedTime.add(approvalDelay) < block.timestamp,
            "Delay has not passed"
        );

        strategy.retireStrat();
        strategy = IStrategy(stratCandidate.implementation);
        stratCandidate.implementation = address(0);
        stratCandidate.proposedTime = 5000000000;

        earn();

        emit StrategyUpdated(stratCandidate.implementation);
    }

    /**
     * @dev Rescues random funds stuck that the strat can't handle.
     * @param _token address of the token to rescue.
     */
    function inCaseTokensGetStuck(address _token) external override onlyOwner {
        require(_token != address(want), "!token");

        uint256 amount = IERC20(_token).balanceOf(address(this));
        IERC20(_token).safeTransfer(msg.sender, amount);
    }
}
