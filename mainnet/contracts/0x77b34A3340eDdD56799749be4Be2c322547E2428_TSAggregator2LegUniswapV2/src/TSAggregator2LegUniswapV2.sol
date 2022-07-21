// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import { SafeTransferLib } from "../lib/SafeTransferLib.sol";
import { TSAggregator } from "./TSAggregator.sol";
import { IThorchainRouter } from "./interfaces/IThorchainRouter.sol";
import { IUniswapRouterV2 } from "./interfaces/IUniswapRouterV2.sol";

contract TSAggregator2LegUniswapV2 is TSAggregator {
    using SafeTransferLib for address;

    address public weth;
    IUniswapRouterV2 public swapRouter;
    address public legToken;

    constructor(
        address _ttp, address _weth, address _swapRouter, address _legToken
    ) TSAggregator(_ttp) {
        weth = _weth;
        swapRouter = IUniswapRouterV2(_swapRouter);
        legToken = _legToken;
    }

    function swapIn(
        address tcRouter,
        address tcVault,
        string calldata tcMemo,
        address token,
        uint amount,
        uint amountOutMin,
        uint deadline
    ) public nonReentrant {
        tokenTransferProxy.transferTokens(token, msg.sender, address(this), amount);
        token.safeApprove(address(swapRouter), 0); // USDT quirk
        token.safeApprove(address(swapRouter), amount);

        address[] memory path = new address[](3);
        path[0] = token;
        path[1] = legToken;
        path[2] = weth;
        swapRouter.swapExactTokensForETH(
            amount,
            amountOutMin,
            path,
            address(this),
            deadline
        );

        uint amountOut = skimFee(address(this).balance);
        IThorchainRouter(tcRouter).depositWithExpiry{value: amountOut}(
            payable(tcVault),
            address(0), // ETH
            amountOut,
            tcMemo,
            deadline
        );
    }

    function swapOut(address token, address to, uint256 amountOutMin) public payable nonReentrant {
        uint256 amount = skimFee(msg.value);
        address[] memory path = new address[](3);
        path[0] = weth;
        path[1] = legToken;
        path[2] = token;
        swapRouter.swapExactETHForTokens{value: amount}(
            amountOutMin,
            path,
            to,
            type(uint).max // deadline
        );
    }
}

