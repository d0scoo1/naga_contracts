// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import {IERC20, IWETHToken, ILockedWETHOffer, IOfferFactory, IOwnable} from "./Interfaces.sol";

contract WETHLens {
    // supported stablecoins
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant FEI = 0x956F47F50A910163D8BF957Cf5846D573E7f87CA; 

    IWETHToken WETH = IWETHToken(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

      function getVolume(IOfferFactory factory) public view returns (uint256 sum) {
        address[4] memory stables = [USDC, USDT, DAI, FEI];
        address factoryOwner = IOwnable(address(factory)).owner();

        uint256 volume;
        for (uint256 i; i < stables.length; i++) {
            volume += IERC20(stables[i]).balanceOf(factoryOwner) * (10**(18 - IERC20(stables[i]).decimals()));
        }
        sum = volume * 40;
    }

    function getOfferInfo(ILockedWETHOffer offer)
        public
        view
        returns (
            uint256 WETHBalance,
            address tokenWanted,
            uint256 amountWanted
        )
    {
        return (WETH.totalBalanceOf(address(offer)), offer.tokenWanted(), offer.amountWanted());
    }

    function getActiveOffersPruned(IOfferFactory factory) public view returns (ILockedWETHOffer[] memory) {
        ILockedWETHOffer[] memory activeOffers = factory.getActiveOffers();
        // determine size of memory array
        uint count;
        for (uint i; i < activeOffers.length; i++) {
            if (address(activeOffers[i]) != address(0)) {
                count++;
            }
        }
        ILockedWETHOffer[] memory pruned = new ILockedWETHOffer[](count);
        for (uint j; j < count; j++) {
            pruned[j] = activeOffers[j];
        }
        return pruned;
    }

    function getAllActiveOfferInfo(IOfferFactory factory)
        public
        view
        returns (
            address[] memory offerAddresses,
            uint256[] memory WETHBalances,
            address[] memory tokenWanted,
            uint256[] memory amountWanted
        )
    {
        ILockedWETHOffer[] memory activeOffers = factory.getActiveOffers();
        uint256 offersLength = activeOffers.length;
        offerAddresses = new address[](offersLength);
        WETHBalances = new uint256[](offersLength);
        tokenWanted = new address[](offersLength);
        amountWanted = new uint256[](offersLength);
        uint256 count;
        for (uint256 i; i < activeOffers.length; i++) {
            uint256 bal = WETH.totalBalanceOf(address(activeOffers[i]));
            if (bal > 0) {
                WETHBalances[count] = bal;
                offerAddresses[count] = address(activeOffers[i]);
                tokenWanted[count] = activeOffers[i].tokenWanted();
                amountWanted[count] = activeOffers[i].amountWanted();
                count++;
            }
        }
    }
}