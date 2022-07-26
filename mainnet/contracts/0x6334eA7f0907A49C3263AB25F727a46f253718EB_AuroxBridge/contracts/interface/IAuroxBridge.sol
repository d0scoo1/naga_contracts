//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IAuroxBridge {
    /**
     * @notice Register the swap request from user
     * @dev thisTokenPath[0] = inputToken,
     *   thisTokenPath[last] = stableToken
     */
    function registerSwap(
        address[] calldata thisTokenPath,
        address[] calldata targetTokenPath,
        uint256 amountIn,
        uint minAmountOut) external;

    /**
     * @notice Register the usdc swap request from user
     */
    function registerUsdcSwap(
        address[] calldata targetTokenPath,
        uint256 amountIn) external;

    /**
     * @notice Purchase asset on behalf of user
     * @dev thisTokenPath should be generated by user
     */
    function buyAssetOnBehalf(
        address[] calldata path,
        address userAddress,
        uint256 usdAmount,
        int256 usdBalance,
        bytes32 hash) external;

    /**
    * @notice Purchase asset on behalf of user
    */
    function buyUsdcOnBehalf(
        address userAddress,
        uint256 usdAmount,
        int256 usdBalance,
        bytes32 hash) external;

    event RegisterSwap(address, address[], address[], uint256, uint256, int256);
    event BuyAssetOnBehalf(address, address, uint256, uint256, int256, bytes32);
}