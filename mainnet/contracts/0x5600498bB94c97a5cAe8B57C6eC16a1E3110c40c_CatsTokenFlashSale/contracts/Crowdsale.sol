// SPDX-License-Identifier: UNLICENCED

pragma solidity ^0.5.5;

import "@openzeppelin/contracts/crowdsale/Crowdsale.sol";
import "@openzeppelin/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "@openzeppelin/contracts/crowdsale/validation/CappedCrowdsale.sol";

contract CatsTokenFlashSale is Crowdsale, MintedCrowdsale, CappedCrowdsale {
    constructor(
        uint256 rate,
        address payable wallet,
        IERC20 token,
        uint256 cap
    )
        MintedCrowdsale()
        CappedCrowdsale(cap)
        Crowdsale(rate, wallet, token)
        public
    {

    }
}
