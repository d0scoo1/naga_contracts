// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// [Contract] Token Standard
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// [Contract] Access
import "@openzeppelin/contracts/access/Ownable.sol";

contract BikeFiToken is ERC20, Ownable {
    // [Contract] Constructor
    constructor() ERC20("BikeFi Token", "BIKEF") {
        uint256 initialSupply = 1000000000 * (10**uint256(decimals()));
        _mint(_msgSender(), initialSupply);
    }

    // [Contract] Required
    function mint(uint256 supply) public onlyOwner {
        _mint(_msgSender(), supply);
    }
}