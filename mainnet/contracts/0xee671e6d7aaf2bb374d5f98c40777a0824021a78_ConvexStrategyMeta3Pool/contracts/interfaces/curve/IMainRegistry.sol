// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

interface IMainRegistry {
    function get_pool_from_lp_token(address lp_token)
        external
        returns (address);

    function get_underlying_coins(address pool)
        external
        returns (address[8] memory);
}
