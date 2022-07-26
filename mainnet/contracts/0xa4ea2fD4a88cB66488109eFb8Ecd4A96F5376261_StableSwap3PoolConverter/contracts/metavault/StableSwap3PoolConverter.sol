// SPDX-License-Identifier: MIT
// solhint-disable func-name-mixedcase
// solhint-disable var-name-mixedcase

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "./IConverter.sol";
import "./IVaultManager.sol";
import "./IStableSwap3Pool.sol";
import "./IStableSwap3PoolOracle.sol";

/**
 * @title StableSwap3PoolConverter
 * @notice The StableSwap3PoolConverter is used to convert funds on Curve's 3Pool.
 * It is backed by Chainlink's price feeds to be secure against attackers.
 */
contract StableSwap3PoolConverter is IConverter {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 public constant ONE_HUNDRED_PERCENT = 10000;

    uint256[3] public PRECISION_MUL = [1, 1e12, 1e12];
    IERC20[3] public tokens; // DAI, USDC, USDT
    IERC20 public token3CRV; // 3Crv

    IStableSwap3Pool public stableSwap3Pool;
    IVaultManager public vaultManager;
    IStableSwap3PoolOracle public oracle;

    mapping(address => bool) public strategies;

    /**
     * @param _tokenDAI The address of the DAI token
     * @param _tokenUSDC The address of the USDC token
     * @param _tokenUSDT The address of the USDT token
     * @param _token3CRV The address of the 3CRV token
     * @param _stableSwap3Pool The address of 3Pool
     * @param _vaultManager The address of the Vault Manager
     * @param _oracle The address of the StableSwap3PoolOracle
     */
    constructor(
        IERC20 _tokenDAI,
        IERC20 _tokenUSDC,
        IERC20 _tokenUSDT,
        IERC20 _token3CRV,
        IStableSwap3Pool _stableSwap3Pool,
        IVaultManager _vaultManager,
        IStableSwap3PoolOracle _oracle
    ) public {
        tokens[0] = _tokenDAI;
        tokens[1] = _tokenUSDC;
        tokens[2] = _tokenUSDT;
        token3CRV = _token3CRV;
        stableSwap3Pool = _stableSwap3Pool;
        tokens[0].safeApprove(address(stableSwap3Pool), type(uint256).max);
        tokens[1].safeApprove(address(stableSwap3Pool), type(uint256).max);
        tokens[2].safeApprove(address(stableSwap3Pool), type(uint256).max);
        token3CRV.safeApprove(address(stableSwap3Pool), type(uint256).max);
        vaultManager = _vaultManager;
        oracle = _oracle;
    }

    /**
     * @notice Sets a new address for the 3Pool contract
     * @param _stableSwap3Pool The address of 3Pool
     */
    function setStableSwap3Pool(IStableSwap3Pool _stableSwap3Pool) external onlyGovernance {
        stableSwap3Pool = _stableSwap3Pool;
        tokens[0].safeApprove(address(stableSwap3Pool), type(uint256).max);
        tokens[1].safeApprove(address(stableSwap3Pool), type(uint256).max);
        tokens[2].safeApprove(address(stableSwap3Pool), type(uint256).max);
        token3CRV.safeApprove(address(stableSwap3Pool), type(uint256).max);
    }

    /**
     * @notice Called by Governance to set the value for the vaultManager address
     * @param _vaultManager The new vaultManager value
     */
    function setVaultManager(IVaultManager _vaultManager) external onlyGovernance {
        vaultManager = _vaultManager;
    }

    /**
     * @notice Called by Governance to enable or disable a strategy to use the converter
     * @param _strategy The address of the strategy
     * @param _status The bool flag allowing or disallowing use of the converter by the strategy
     */
    function setStrategy(address _strategy, bool _status) external override onlyGovernance {
        strategies[_strategy] = _status;
    }

    /**
     * @notice Called by Governance to approve a token address to be spent by an address
     * @param _token The address of the token
     * @param _spender The address of the spender
     * @param _amount The amount to spend
     */
    function approveForSpender(
        IERC20 _token,
        address _spender,
        uint256 _amount
    ) external onlyGovernance {
        _token.safeApprove(_spender, _amount);
    }

    /**
     * @notice Returns the address of the 3CRV token
     */
    function token() external override returns (address) {
        return address(token3CRV);
    }

    /**
     * @notice Returns the expected amount of tokens for a given amount by querying
     * the latest data from Chainlink
     * @param _inputAmount The input amount of tokens that are being converted
     */
    function getExpected(uint256 _inputAmount) public view returns (uint256) {
        return _inputAmount.mul(
                    oracle.getEthereumPrice().mul(
                        oracle.getMinimumPrice()
                    ).div(1e18)
                ).div(1e18);
    }

    /**
     * @notice Converts the amount of input tokens to output tokens
     * @param _input The address of the token being converted
     * @param _output The address of the token to be converted to
     * @param _inputAmount The input amount of tokens that are being converted
     */
    function convert(
        address _input,
        address _output,
        uint256 _inputAmount
    ) external override onlyAuthorized returns (uint256 _outputAmount) {
        uint256 _expected = getExpected(_inputAmount);
        if (_output == address(token3CRV)) { // convert to 3CRV
            uint256[3] memory amounts;
            for (uint8 i = 0; i < 3; i++) {
                if (_input == address(tokens[i])) {
                    amounts[i] = _inputAmount;
                    uint256 _before = token3CRV.balanceOf(address(this));
                    stableSwap3Pool.add_liquidity(amounts, _expected);
                    uint256 _after = token3CRV.balanceOf(address(this));
                    _outputAmount = _after.sub(_before);
                    token3CRV.safeTransfer(msg.sender, _outputAmount);
                    return _outputAmount;
                }
            }
        } else if (_input == address(token3CRV)) { // convert from 3CRV
            for (uint8 i = 0; i < 3; i++) {
                if (_output == address(tokens[i])) {
                    uint256 _before = tokens[i].balanceOf(address(this));
                    stableSwap3Pool.remove_liquidity_one_coin(_inputAmount, i, _expected.div(PRECISION_MUL[i]));
                    uint256 _after = tokens[i].balanceOf(address(this));
                    _outputAmount = _after.sub(_before);
                    tokens[i].safeTransfer(msg.sender, _outputAmount);
                    return _outputAmount;
                }
            }
        }
        return 0;
    }

    /**
     * @notice Checks the amount of input tokens to output tokens
     * @param _input The address of the token being converted
     * @param _output The address of the token to be converted to
     * @param _inputAmount The input amount of tokens that are being converted
     */
    function convert_rate(
        address _input,
        address _output,
        uint256 _inputAmount
    ) external override view returns (uint256) {
        if (_output == address(token3CRV)) { // convert to 3CRV
            uint256[3] memory amounts;
            for (uint8 i = 0; i < 3; i++) {
                if (_input == address(tokens[i])) {
                    amounts[i] = _inputAmount;
                    return stableSwap3Pool.calc_token_amount(amounts, true);
                }
            }
        } else if (_input == address(token3CRV)) { // convert from 3CRV
            for (uint8 i = 0; i < 3; i++) {
                if (_output == address(tokens[i])) {
                    // @dev this is for UI reference only, the actual share price
                    // (stable/CRV) will be re-calculated on-chain when we do convert()
                    return stableSwap3Pool.calc_withdraw_one_coin(_inputAmount, i);
                }
            }
        }
        return 0;
    }

    /**
     * @notice Converts stables of the 3Pool to 3CRV
     * @dev 0: DAI, 1: USDC, 2: USDT
     * @param amounts Array of token amounts
     */
    function convert_stables(
        uint256[3] calldata amounts
    ) external override onlyAuthorized returns (uint256 _shareAmount) {
        uint256 _before = token3CRV.balanceOf(address(this));
        stableSwap3Pool.add_liquidity(amounts, 1);
        uint256 _after = token3CRV.balanceOf(address(this));
        _shareAmount = _after.sub(_before);
        token3CRV.safeTransfer(msg.sender, _shareAmount);
    }

    /**
     * @notice Checks the amount of 3CRV given for the amounts
     * @dev 0: DAI, 1: USDC, 2: USDT
     * @param amounts Array of token amounts
     * @param deposit Flag for depositing LP tokens
     */
    function calc_token_amount(
        uint256[3] calldata amounts,
        bool deposit
    ) external override view returns (uint256 _shareAmount) {
        _shareAmount = stableSwap3Pool.calc_token_amount(amounts, deposit);
    }

    /**
     * @notice Checks the amount of an output token given for 3CRV
     * @param _shares The amount of 3CRV
     * @param _output The address of the output token
     */
    function calc_token_amount_withdraw(
        uint256 _shares,
        address _output
    ) external override view returns (uint256) {
        for (uint8 i = 0; i < 3; i++) {
            if (_output == address(tokens[i])) {
                return stableSwap3Pool.calc_withdraw_one_coin(_shares, i);
            }
        }
        return 0;
    }

    /**
     * @notice Allows Governance to withdraw tokens from the converter
     * @dev This contract should never have any tokens in it at the end of a transaction
     * @param _token The address of the token
     * @param _amount The amount to withdraw
     * @param _to The address to receive the tokens
     */
    function governanceRecoverUnsupported(
        IERC20 _token,
        uint256 _amount,
        address _to
    ) external onlyGovernance {
        _token.transfer(_to, _amount);
    }

    /**
     * @dev Throws if not called by a vault, controller, strategy, or governance
     */
    modifier onlyAuthorized() {
        require(vaultManager.vaults(msg.sender)
            || vaultManager.controllers(msg.sender)
            || strategies[msg.sender]
            || msg.sender == vaultManager.governance(),
            "!authorized"
        );
        _;
    }

    /**
     * @dev Throws if not called by a controller or governance
     */
    modifier onlyGovernance() {
        require(vaultManager.controllers(msg.sender)
            || msg.sender == vaultManager.governance(), "!governance");
        _;
    }
}
