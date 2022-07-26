// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

import "./DropShop721.sol";

/**
  @title A contract for selling on-chain generative bees.

  Bees are generated 100% on-chain and cost 0.04 ETH each.
  bzz bzz

  March 10th, 2022.
*/
contract BeeShop is
  DropShop721
{

  /**
    Construct a new shop with configuration details about the intended sale.

    @param _collection The address of the ERC-721 item being sold.
    @param _configuration A parameter containing shop configuration information,
      passed here as a struct to avoid a stack-to-deep error.
  */
  constructor (
    address _collection,
    ShopConfiguration memory _configuration
  ) DropShop721(_collection, _configuration) {
  }

  /**
    Allow a caller to purchase a bee. Bees cost 0.04 ETH each.

    @param _amount The amount of items that the caller would like to purchase.
  */
  function mint (
    uint256 _amount
  ) public override payable {
    super.mint(_amount);
  }
}
