// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;

import {EvolutionToken} from '../../protocol/tokenization/EvolutionToken.sol';
import {ILendingPool} from '../../interfaces/ILendingPool.sol';
import {IEaveIncentivesController} from '../../interfaces/IEaveIncentivesController.sol';

contract MockEToken is EvolutionToken {
  function getRevision() internal pure override returns (uint256) {
    return 0x2;
  }
}
