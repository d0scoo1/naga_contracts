// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20CappedUpgradeable.sol";

contract GDEX is ERC20CappedUpgradeable, OwnableUpgradeable {

    event Minted(address indexed user, uint amount);

    constructor() initializer {}

    function initialize(string memory name, string memory symbol, address admin, uint initialSupply, uint cap) initializer public {
        __ERC20_init(name, symbol);
        __ERC20Capped_init_unchained(cap);
        __Ownable_init_unchained();
        _mint(admin, initialSupply);
        transferOwnership(admin);
    }

    function mint(address account, uint amount) external onlyOwner {
        _mint(account, amount);
        emit Minted(account, amount);
    }

    function burn(uint amount) external {
        _burn(msg.sender, amount);
    }
}
