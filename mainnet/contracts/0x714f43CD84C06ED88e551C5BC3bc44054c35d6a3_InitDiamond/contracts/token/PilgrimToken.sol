// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PilgrimToken is ERC20, Ownable {
    constructor() ERC20("Pilgrim", "PIL") {}

    function mint(uint256 _amount) public onlyOwner {
        _mint(owner(), _amount);
    }
}
