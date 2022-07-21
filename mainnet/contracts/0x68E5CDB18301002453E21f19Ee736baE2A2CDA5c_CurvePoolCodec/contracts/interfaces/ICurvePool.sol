// SPDX-License-Identifier: GPL-3.0-only

pragma solidity >=0.8.12;

interface ICurvePool {
    function coins(uint256 i) external view returns (address);

    // specifically for CurveNonStandardMetaPoolCodec, the uint128  not used in other codecs
    function underlying_coins(uint128 i) external view returns (address);

    // plain & meta pool
    function get_dy(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256);

    // meta pool
    function get_dy_underlying(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256);

    // plain & meta pool
    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external;

    // meta pool
    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy,
        address _receiver
    ) external returns (uint256);

    // special function signature that is only used by the sUSD pool on Ethereum 0xA5407eAE9Ba41422680e2e00537571bcC53efBfD
    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external;
}
