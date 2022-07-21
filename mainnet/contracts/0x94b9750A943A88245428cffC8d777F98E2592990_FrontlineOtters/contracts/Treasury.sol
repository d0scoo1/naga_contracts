// SPDX-License-Identifier: None
pragma solidity 0.8.12;

import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

contract Treasury is PaymentSplitter {
  uint256 private _numberOfPayees;

  constructor(address[] memory payees, uint256[] memory shares_)
    payable
    PaymentSplitter(payees, shares_)
  {
    _numberOfPayees = payees.length;
  }

  function withdrawAll() external {
    require(address(this).balance > 0, "No balance to withdraw");

    for (uint256 i = 0; i < _numberOfPayees; i++) {
      release(payable(payee(i)));
    }
  }

  function withdrawAll(IERC20 token) external {
    require(token.balanceOf(address(this)) > 0, "No balance to withdraw");

    for (uint256 i = 0; i < _numberOfPayees; i++) {
      release(token, payable(payee(i)));
    }
  }
}
