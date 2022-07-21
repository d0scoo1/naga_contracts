// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.3.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.3.3/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@4.3.3/security/Pausable.sol";
import "@openzeppelin/contracts@4.3.3/access/Ownable.sol";

contract AegisToken is ERC20, ERC20Burnable, Pausable, Ownable {
    uint256 private TOTAL_SUPPLY = 1100 * (10 ** 6); // 1.1 billion
    constructor() ERC20("Aegis Token", "AEGIS") {
        uint256 dec = 10 ** decimals();
        _mint(payable(msg.sender), TOTAL_SUPPLY * dec);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
    internal
    whenNotPaused
    virtual
    override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
