// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract XMannaToken is ERC20, Ownable {
    uint256 private _cap;

    constructor() ERC20("XMANNA", "XMAN") {
        _cap = 7777777777 * 10**decimals();
    }

    function _mintCapped(address account, uint256 amount) internal virtual {
        require(totalSupply() + amount <= cap(), "cap exceeded");
        _mint(account, amount);
    }

    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mintCapped(to, amount);
    }
}
