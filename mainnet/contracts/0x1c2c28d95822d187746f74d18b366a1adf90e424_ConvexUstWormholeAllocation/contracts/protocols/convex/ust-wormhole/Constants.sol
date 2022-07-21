// SPDX-License-Identifier: BUSDL-1.1
pragma solidity 0.6.11;

import {IERC20, INameIdentifier} from "contracts/common/Imports.sol";
import {
    IBaseRewardPool
} from "contracts/protocols/convex/common/interfaces/Imports.sol";
import {IMetaPool} from "contracts/protocols/curve/metapool/Imports.sol";

abstract contract ConvexUstWormholeConstants is INameIdentifier {
    string public constant override NAME = "convex-ust-wormhole";

    uint256 public constant PID = 59;

    // sometimes a metapool is its own LP token; otherwise,
    // you can obtain from `token` attribute
    IERC20 public constant LP_TOKEN =
        IERC20(0xCEAF7747579696A2F0bb206a14210e3c9e6fB269);

    // metapool primary underlyer
    IERC20 public constant PRIMARY_UNDERLYER =
        IERC20(0xa693B19d2931d498c5B318dF961919BB4aee87a5);

    IMetaPool public constant META_POOL =
        IMetaPool(0xCEAF7747579696A2F0bb206a14210e3c9e6fB269);

    IBaseRewardPool public constant REWARD_CONTRACT =
        IBaseRewardPool(0x7e2b9B5244bcFa5108A76D5E7b507CFD5581AD4A);
}
