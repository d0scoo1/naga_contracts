// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

contract JustCubesRoyaltySplitter is PaymentSplitter {

    constructor(address[] memory _payees, uint256[] memory _shares) PaymentSplitter(_payees, _shares) payable{

    }
}