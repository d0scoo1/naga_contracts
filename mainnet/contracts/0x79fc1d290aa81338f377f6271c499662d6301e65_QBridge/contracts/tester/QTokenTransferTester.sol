// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "../interfaces/IQToken.sol";
import "../interfaces/IBEP20.sol";


contract QTokenTransferTester {
    /* ========== CONSTANT VARIABLES ========== */

    address public constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address public constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address public constant BUNNY = 0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51;
    address public constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
    address public constant BNB = 0x0000000000000000000000000000000000000000;
    address public constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public constant qore = 0xF70314eb9c7Fe7D88E6af5aa7F898b3A162dcd48;
    address public constant qCAKE = 0xaB9eb4AE93B705b0A74d3419921bBec97F51b264;

    /* ========== STATE VARIABLES ========== */

    /* ========== INITIALIZER ========== */

    constructor() public {}

    function transfer(
        address qToken,
        address sender,
        address receiver,
        uint amount
    ) external {
        IQToken(qToken).transferFrom(sender, receiver, amount);
    }
}
