// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../utils/Errors.sol";

contract OnChainRewardsWallet {
    address private _owner;

    constructor(address owner_) {
        _owner = owner_;
    }

    function approve(
        address asset,
        address contract_,
        bool enable
    ) external {
        _onlyOwner();
        if (enable) {
            IERC20(asset).approve(contract_, type(uint256).max - 1);
        } else {
            IERC20(asset).approve(contract_, 0);
        }
    }

    function _onlyOwner() internal view {
        if (msg.sender != _owner) revert Unauthorized();
    }
}
