// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-4.0.0/access/AccessControl.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract IChainLinkOracle {
  function getAvailableToken(address tokenAddress)
    external
    view
    virtual
    returns (address)
  {}

  function setAvailableToken(address tokenAddress, address dataFeedAddress)
    external
    virtual
  {}

  function getAvailableTokenBatch(address[] memory tokenAddresss)
    external
    view
    virtual
    returns (address[] memory)
  {}

  function setAvailableTokenBatch(
    address[] memory tokenAddresss,
    address[] memory dataFeedAddresses
  ) external virtual {}

  function getLatestPrice(address tokenAddress)
    external
    view
    virtual
    returns (uint256)
  {}

  function hasToken(address tokenAddress) public view virtual returns (bool) {}
}
