// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

import "Governance.sol";

contract StarknetGovernance is Governance {
    string constant STARKNET_GOVERNANCE_INFO_TAG = "STARKNET_1.0_GOVERNANCE_INFO";

    /*
      Returns the GovernanceInfoStruct associated with the governance tag.
    */
    function getGovernanceInfo() internal view override returns (GovernanceInfoStruct storage gub) {
        bytes32 location = keccak256(abi.encodePacked(STARKNET_GOVERNANCE_INFO_TAG));
        assembly {
            gub_slot := location
        }
    }

    function starknetIsGovernor(address testGovernor) external view returns (bool) {
        return isGovernor(testGovernor);
    }

    function starknetNominateNewGovernor(address newGovernor) external {
        nominateNewGovernor(newGovernor);
    }

    function starknetRemoveGovernor(address governorForRemoval) external {
        removeGovernor(governorForRemoval);
    }

    function starknetAcceptGovernance() external {
        acceptGovernance();
    }

    function starknetCancelNomination() external {
        cancelNomination();
    }
}
