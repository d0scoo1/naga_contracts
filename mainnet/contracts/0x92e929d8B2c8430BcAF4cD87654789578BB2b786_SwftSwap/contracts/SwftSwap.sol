// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./lib/TransferHelper.sol";

/// @notice swftswap
contract SwftSwap is ReentrancyGuard, Ownable {
    using SafeMath for uint256;

    string public name;

    string public symbol;

    /// @notice Swap's log.
    /// @param fromToken token's address.
    /// @param toToken 兑换的目标币的名称，比如'usdt(matic)'
    /// @param sender Who swap
    /// @param destination 目标币的地址
    /// @param fromAmount Input amount.
    /// @param minReturnAmount 用户期望的目标币的最小接收数量
    event Swap(
        address fromToken,
        string toToken,
        address sender,
        string destination,
        uint256 fromAmount,
        uint256 minReturnAmount
    );

    /// @notice SwapEth's log.
    /// @param toToken 兑换的目标币的名称，比如'usdt(matic)'
    /// @param sender Who swap
    /// @param destination 目标币的地址
    /// @param fromAmount Input amount.
    /// @param minReturnAmount 用户期望的目标币的最小接收数量
    event SwapEth(
        string toToken,
        address sender,
        string destination,
        uint256 fromAmount,
        uint256 minReturnAmount
    );

    event WithdrawETH(uint256 amount);

    event Withdtraw(address token, uint256 amount);

    constructor() {
        name = "SWFT Swap1.1";
        symbol = "SSwap";
    }

    /// @notice Excute transactions. 从转入的币中扣除手续费。
    /// @param fromToken token's address. 源币的合约地址
    /// @param toToken 目标币的类型，比如'usdt(matic)'
    /// @param destination 目标币的收币地址
    /// @param fromAmount 原币的数量
    /// @param minReturnAmount 用户期望的目标币的最小接收数量
    function swap(
        address fromToken,
        string memory toToken,
        string memory destination,
        uint256 fromAmount,
        uint256 minReturnAmount
    ) external nonReentrant {
        require(fromToken != address(0), "FROMTOKEN_CANT_T_BE_0"); // 源币地址不能为0
        require(fromAmount > 0, "FROM_TOKEN_AMOUNT_MUST_BE_MORE_THAN_0");
        uint256 _inputAmount; // 实际收到的源币的数量
        uint256 _fromTokenBalanceOrigin = IERC20(fromToken).balanceOf(address(this));
        TransferHelper.safeTransferFrom(fromToken, msg.sender, address(this), fromAmount);
        uint256 _fromTokenBalanceNew = IERC20(fromToken).balanceOf(address(this));
        _inputAmount = _fromTokenBalanceNew.sub(_fromTokenBalanceOrigin);
        require(_inputAmount > 0, "NO_FROM_TOKEN_TRANSFER_TO_THIS_CONTRACT");
        emit Swap(fromToken, toToken, msg.sender, destination, fromAmount, minReturnAmount);
    }

    /// @notice Excute transactions. 从转入的币中扣除手续费。
    /// @param toToken  目标币的类型，比如'usdt(matic)'
    /// @param destination 目标币的收币地址
    /// @param minReturnAmount 用户期望的目标币的最小接收数量
    function swapEth(string memory toToken, string memory destination, uint256 minReturnAmount
    ) external payable nonReentrant {
        uint256 _ethAmount = msg.value; // 实际收到的eth的数量
        require(_ethAmount > 0, "ETH_AMOUNT_MUST_BE_MORE_THAN_0");
        emit SwapEth(toToken, msg.sender, destination, _ethAmount, minReturnAmount);
    }

    function withdrawETH(address destination, uint256 amount) external onlyOwner {
        require(destination != address(0), "DESTINATION_CANNT_BE_0_ADDRESS");
        uint256 balance = address(this).balance;
        require(balance >= amount, "AMOUNT_CANNT_MORE_THAN_BALANCE");
        TransferHelper.safeTransferETH(destination, amount);
        emit WithdrawETH(amount);
    }

    function withdraw(address token, address destination, uint256 amount) external onlyOwner {
        require(destination != address(0), "DESTINATION_CANNT_BE_0_ADDRESS");
        require(token != address(0), "TOKEN_MUST_NOT_BE_0");
        uint256 balance = IERC20(token).balanceOf(address(this));
        require(balance >= amount, "AMOUNT_CANNT_MORE_THAN_BALANCE");
        TransferHelper.safeTransfer(token, destination, amount);
        emit Withdtraw(token, amount);
    }

    receive() external payable {}
}
