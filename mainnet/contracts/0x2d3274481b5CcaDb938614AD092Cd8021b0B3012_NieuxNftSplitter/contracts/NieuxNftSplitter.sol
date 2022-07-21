//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./NieuxPaymentSplitter.sol";

contract NieuxNftSplitter is NieuxPaymentSplitter {
    constructor(
        address[] memory payees_,
        uint256[] memory shares
    ) NieuxPaymentSplitter(payees_, shares) { }
}

