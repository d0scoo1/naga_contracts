/**
 * SPDX-License-Identifier: UNLICENSED
 */
pragma solidity 0.6.10;

import {AggregatorInterface} from "./AggregatorInterface.sol";
import {AggregatorV3Interface} from "./AggregatorV3Interface.sol";

/**
 * @dev Interface of the Chainlink aggregator
 */
interface AggregatorV2V3Interface is AggregatorInterface, AggregatorV3Interface {

}
