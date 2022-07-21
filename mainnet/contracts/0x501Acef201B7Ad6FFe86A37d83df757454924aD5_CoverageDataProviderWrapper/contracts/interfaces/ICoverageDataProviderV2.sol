// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.9;

/**
 * @title ICoverageDataProviderV2
 * @author solace.fi
 * @notice Holds underwriting pool amounts in `USD`. Provides information to the [**Risk Manager**](./RiskManager.sol) that is the maximum amount of cover that `Solace` protocol can sell as a coverage.
*/
interface ICoverageDataProviderV2 {
  
    /**
      * @notice Resets the underwriting pool balances.
      * @param uwpNames The underwriting pool values to set.
      * @param amounts The underwriting pool balances.
    */
    function set(string[] calldata uwpNames, uint256[] calldata amounts) external payable;

    /**
     * @notice Removes the given underwriting pool.
     * @param uwpNames The underwriting pool names to remove.
    */
    function remove(string[] calldata uwpNames) external payable;
}
