// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract HoneyPotFake is Context, ERC20 {
    constructor() ERC20("Honey Pot", "HON") {
        _mint(_msgSender(), 219000000);
    }

    function decimals() public pure override returns (uint8) {
        return 1;
    }
}
