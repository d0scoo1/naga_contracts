/*
  Copyright 2019-2021 StarkWare Industries Ltd.

  Licensed under the Apache License, Version 2.0 (the "License").
  You may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  https://www.starkware.co/open-source-license/

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions
  and limitations under the License.
*/
// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.11;

import "MOperator.sol";
import "MGovernance.sol";
import "MainStorage.sol";

/**
  The Operator of the contract is the entity entitled to submit state update requests
  by calling :sol:func:`updateState`.

  An Operator may be instantly appointed or removed by the contract Governor
  (see :sol:mod:`MainGovernance`). Typically, the Operator is the hot wallet of the StarkEx service
  submitting proofs for state updates.
*/
abstract contract Operator is MainStorage, MGovernance, MOperator {
    event LogOperatorAdded(address operator);
    event LogOperatorRemoved(address operator);

    function initialize()
        internal
    {
        operators[msg.sender] = true;
        emit LogOperatorAdded(msg.sender);
    }

    function registerOperator(address newOperator)
        external
        override
        onlyGovernance
    {
        operators[newOperator] = true;
        emit LogOperatorAdded(newOperator);
    }

    function unregisterOperator(address removedOperator)
        external
        override
        onlyGovernance
    {
        operators[removedOperator] = false;
        emit LogOperatorRemoved(removedOperator);
    }

    function isOperator(address testedOperator)
        public
        view
        override
        returns (bool) {
        return operators[testedOperator];
    }
}
