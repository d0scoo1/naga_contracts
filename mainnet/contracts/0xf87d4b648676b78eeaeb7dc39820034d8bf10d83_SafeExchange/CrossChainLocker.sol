//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Utils.sol";

contract CrossChainLocker {
  address lockOwner;
  address safeExchangeAddr;

  constructor(address _lockOwner, address _safeExchangeAddr) {
    lockOwner = _lockOwner;
    safeExchangeAddr = _safeExchangeAddr;
  }

  modifier onlyLockOwner() {
    require(tx.origin == lockOwner || msg.sender == address(safeExchangeAddr), "Fuck off.");
    _;
  }

  receive() external payable {}

  function withdrawBalance(
    address token,
    address recipient,
    uint256 amt
  ) external payable onlyLockOwner {
    require(amt > 0, "amt is 0");
    if (token == address(0)) {
      payable(recipient).transfer(amt);
    } else {
      IERC20(token).transfer(recipient, amt);
    }
  }
}