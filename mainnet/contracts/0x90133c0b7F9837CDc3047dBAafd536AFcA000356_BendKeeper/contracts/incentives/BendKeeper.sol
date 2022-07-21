// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.4;

import {KeeperCompatibleInterface} from "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
import {IFeeDistributor} from "./interfaces/IFeeDistributor.sol";

contract BendKeeper is KeeperCompatibleInterface {
    uint256 public constant DAY = 86400;
    IFeeDistributor public feeDistributor;
    uint256 public nextDistributeTime;

    constructor(address _feeDistributorAddr) {
        feeDistributor = IFeeDistributor(_feeDistributorAddr);
        nextDistributeTime = ((block.timestamp + DAY - 1) / DAY) * DAY;
    }

    function checkUpkeep(bytes calldata)
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory)
    {
        upkeepNeeded = block.timestamp >= nextDistributeTime;
    }

    function performUpkeep(bytes calldata) external override {
        if (block.timestamp >= nextDistributeTime) {
            feeDistributor.distribute();
            nextDistributeTime += DAY;
        }
    }
}
