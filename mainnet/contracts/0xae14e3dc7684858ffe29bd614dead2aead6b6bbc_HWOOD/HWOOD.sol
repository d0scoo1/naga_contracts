// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract HWOOD is ERC20, ERC20Burnable {

    uint256 constant CAP = 1E28;
    
    address constant ADDR_PLATFORM_REWARDS = 0x77Efc7cf9aa6E775cD2b1c7eC6B9ac98acBa6F7A;
    address constant ADDR_MARKETING_FUND = 0x350907A113e220d2205365fCcF88760f5832CFCD;
    address constant ADDR_FASHION_BRAND_CONTENT_DEVELOPMENT_FUNDS = 0x071ac5e7cc1dE6BDf635fA10e33a3d6dfD4c86a7;
    address constant ADDR_LIQUIDITY_POOL = 0x5B38396a53a57D09f8b972412ef6dbe56B6DA9a2;
    address constant ADDR_TEAM_ADVISORS = 0x0CbecF6687E00364337E8A4BA6398aF6C22f27BF;
    address constant ADDR_COMPANY_RESERVE = 0xB8494Ee2558d2f78Dc28474fE40462F8D496CE95;
    address constant ADDR_PUBLIC_SALE = 0xCa1Cc9cfEf09781BC0d0808A0FC8ad2ff6590A33;
    address constant ADDR_STRATEGIC_PRIVATE_SALE = 0x5A14e126a7DdF0aC2B048EDeB9b1706e813aCEeD;

    constructor() ERC20("HWOOD", "HWOOD") {
        _mint(ADDR_PLATFORM_REWARDS, CAP * 150 / 1000);
        _mint(ADDR_MARKETING_FUND, CAP * 120 / 1000);
        _mint(ADDR_FASHION_BRAND_CONTENT_DEVELOPMENT_FUNDS, CAP * 100 / 1000);
        _mint(ADDR_LIQUIDITY_POOL, CAP * 200 / 1000);
        _mint(ADDR_TEAM_ADVISORS, CAP * 200 / 1000);
        _mint(ADDR_COMPANY_RESERVE, CAP * 165 / 1000);
        _mint(ADDR_PUBLIC_SALE, CAP * 5 / 1000);
        _mint(ADDR_STRATEGIC_PRIVATE_SALE, CAP * 60 / 1000);
    }
}