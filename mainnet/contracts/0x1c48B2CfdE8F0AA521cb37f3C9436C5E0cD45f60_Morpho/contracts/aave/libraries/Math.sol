// SPDX-License-Identifier: GNU AGPLv3
pragma solidity 0.8.13;

/// @title Math library.
/// @dev Aave math modified and basic math library.
library Math {
    /// AAVE MATH ///

    uint256 internal constant WAD = 1e18;
    uint256 internal constant halfWAD = WAD / 2;

    uint256 internal constant RAY = 1e27;
    uint256 internal constant halfRAY = RAY / 2;

    uint256 internal constant WAD_RAY_RATIO = 1e9;

    function ray() internal pure returns (uint256) {
        return RAY;
    }

    function wad() internal pure returns (uint256) {
        return WAD;
    }

    function halfRay() internal pure returns (uint256) {
        return halfRAY;
    }

    function halfWad() internal pure returns (uint256) {
        return halfWAD;
    }

    function wadMul(uint256 a, uint256 b) internal pure returns (uint256) {
        return (halfWAD + a * b) / WAD;
    }

    function wadDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 halfB = b / 2;

        return (halfB + a * WAD) / b;
    }

    function rayMul(uint256 a, uint256 b) internal pure returns (uint256) {
        return (halfRAY + a * b) / RAY;
    }

    function rayDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 halfB = b / 2;

        return (halfB + a * RAY) / b;
    }

    function rayToWad(uint256 a) internal pure returns (uint256) {
        uint256 halfRatio = WAD_RAY_RATIO / 2;

        return (halfRatio + a) / WAD_RAY_RATIO;
    }

    function wadToRay(uint256 a) internal pure returns (uint256) {
        return a * WAD_RAY_RATIO;
    }

    function divWadByRay(uint256 a, uint256 b) internal pure returns (uint256) {
        return rayToWad(rayDiv(wadToRay(a), b));
    }

    function mulWadByRay(uint256 a, uint256 b) internal pure returns (uint256) {
        return rayToWad(rayMul(wadToRay(a), b));
    }

    /// GENERAL ///

    function min(
        uint256 a,
        uint256 b,
        uint256 c
    ) internal pure returns (uint256) {
        return a < b ? a < c ? a : c : b < c ? b : c;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute.
        return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
    }
}
