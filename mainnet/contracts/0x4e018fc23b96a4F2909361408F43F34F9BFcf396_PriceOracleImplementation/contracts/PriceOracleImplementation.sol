pragma solidity ^0.5.16;

import "./PriceOracle.sol";

interface ChainlinkFeed {
    function latestAnswer() external view returns (int256);
}

contract PriceOracleImplementation is PriceOracle {
    address public cEtherAddress;

    constructor(address _cEtherAddress) public {
        cEtherAddress = _cEtherAddress;
    }

    /**
      * @notice Get the underlying price of a cToken asset
      * @param cToken The cToken to get the underlying price of
      * @return The underlying asset price mantissa (scaled by 1e18).
      *  Zero means the price is unavailable.
      */
    function getUnderlyingPrice(CToken cToken) external view returns (uint) {
        if (address(cToken) == cEtherAddress) {
            // ether always worth 1
            return 1e18;
        }

        // For now, we only have USDC and ETH.
        int256 usdcPrice = ChainlinkFeed(0x986b5E1e1755e3C2440e960477f25201B0a8bbD4).latestAnswer();
        if (usdcPrice <= 0) {
            return 0;
        }

        // Checck for overflow.
        uint256 result = uint256(usdcPrice) * 1e12;
        if (result / uint256(usdcPrice) != 1e12) {
            return 0;
        }

        return result;
    }
}
