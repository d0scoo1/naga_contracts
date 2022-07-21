// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

interface IMultiSignWalletFactory {
    function getWalletImpl() external view returns(address) ;
}