// SPDX-License-Identifier: MIT
pragma solidity 0.6.10;

import {ILoanToken2} from "ILoanToken2.sol";
import {ITrueLender2} from "ITrueLender2.sol";
import {ISAFU} from "ISAFU.sol";

/**
 * @dev Library that has shared functions between legacy TrueFi Pool and Pool2
 */
library PoolExtensions {
    function _liquidate(
        ISAFU safu,
        ILoanToken2 loan,
        ITrueLender2 lender
    ) internal {
        require(msg.sender == address(safu), "TrueFiPool: Should be called by SAFU");
        lender.transferAllLoanTokens(loan, address(safu));
    }
}
