// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20FlashMint.sol";

contract fcYLD is ERC20, ERC20Burnable, Ownable, ERC20FlashMint {
    constructor() ERC20("fcYLD", "fcYLD") {

        // Mint enough tokens to provide 1,000,000 whole tokens with 18 decimals places.
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function decimals() public pure override returns (uint8) {

        // 18 Decimals is the default but setting is explicitly here for clarity
        // and learning how to...
        return 18;
    }

    function mint(address to, uint256 amount) public onlyOwner {

        _mint(to, amount);
    }
}
