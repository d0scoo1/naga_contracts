// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./lib/LibTransfer.sol";
import "./ITransferExecutor.sol";

abstract contract TransferExecutor is ITransferExecutor {
    using LibTransfer for address;

    function transfer(
        address token,
        address from,
        address to,
        uint256 value
    ) internal override {
        if (token == address(0)) {
            to.transferEth(value);
        } else {
            IERC20(token).transferFrom(from, to, value);
        }
    }
}
