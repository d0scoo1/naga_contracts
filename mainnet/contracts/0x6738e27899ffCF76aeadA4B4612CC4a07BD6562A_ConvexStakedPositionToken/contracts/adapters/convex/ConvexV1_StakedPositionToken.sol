// SPDX-License-Identifier: BUSL-1.1
// Gearbox Protocol. Generalized leverage for DeFi protocols
// (c) Gearbox Holdings, 2021
pragma solidity ^0.8.10;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {PhantomERC20} from "../../tokens/PhantomERC20.sol";
import {IBooster} from "../../integrations/convex/IBooster.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

/// @title ConvexStakedPositionToken
/// @dev Represents the balance of the staking token position in Convex pools
contract ConvexStakedPositionToken is PhantomERC20 {
    address public immutable pool;

    constructor(address _pool, address _lptoken)
        PhantomERC20(
            _lptoken,
            string(
                abi.encodePacked(
                    "Convex Staked Position ",
                    IERC20Metadata(_lptoken).name()
                )
            ),
            string(abi.encodePacked("stk", IERC20Metadata(_lptoken).symbol())),
            IERC20Metadata(_lptoken).decimals()
        )
    {
        pool = _pool;
    }

    function balanceOf(address account) public view returns (uint256) {
        return IERC20(pool).balanceOf(account);
    }
}
