// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../MarketPlaceCore.sol";
import "../interfaces/ILegitArtERC721.sol";

contract MarketPlaceCoreMock is MarketPlaceCore {
    constructor(
        IERC20 _usdc,
        ILegitArtERC721 _legitArtNFT,
        address _feeBeneficiary,
        uint256 _primaryFeePercentage,
        uint256 _secondaryFeePercentage
    ) MarketPlaceCore(_usdc, _legitArtNFT, _feeBeneficiary, _primaryFeePercentage, _secondaryFeePercentage) {}
}
