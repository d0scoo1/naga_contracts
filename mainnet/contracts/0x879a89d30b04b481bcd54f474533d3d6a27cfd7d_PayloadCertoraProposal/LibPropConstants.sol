// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

library LibPropConstants {
    

    // Addresses
    address internal constant AAVE_GOVERNANCE = 0xEC568fffba86c094cf06b22134B23074DFE2252c;
    address internal constant ECOSYSTEM_RESERVE = 0x25F2226B597E8F9514B3F68F00f494cF4f286491;
    address internal constant ECOSYSTEM_RESERVE_CONTROLLER = 0x1E506cbb6721B83B1549fa1558332381Ffa61A93;
    address internal constant SHORT_EXECUTOR = 0xEE56e2B3D491590B5b31738cC34d5232F378a8D5;
    address internal constant AAVE_TOKEN = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
    address internal constant USDC_TOKEN = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant AUSDC_TOKEN = 0xBcca60bB61934080951369a648Fb03DF4F96263C;
    address internal constant SABLIER = 0xCD18eAa163733Da39c232722cBC4E8940b1D8888;
    address internal constant POOL = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;
    address internal constant CERTORA_BENEFICIARY = 0x0F11640BF66e2D9352d9c41434A5C6E597c5e4c8;
    address internal constant CERTORA_AAVE_MULTISIG = 0x5CC8438831D2DD88Cdedf0cB4Bc2D0381Ba3627E;
    address internal constant AAVE_USD_CHAINLINK_ORACLE = 0x547a514d5e3769680Ce22B2361c10Ea13619e8a9;
    // new impl
    address internal constant AAVE_COLLECTOR = 0x7AB1e5c406F36FE20Ce7eBa528E182903CA8bFC7;
    
    // Amounts
    uint256 internal constant USDC_VEST = 1_000_000 * 1e6;
    uint256 internal constant AAVE_VEST_USDC_WORTH = 700_000 * 1e6;
    uint256 internal constant AAVE_FUND_USDC_WORTH = 200_000 * 1e6;
}
