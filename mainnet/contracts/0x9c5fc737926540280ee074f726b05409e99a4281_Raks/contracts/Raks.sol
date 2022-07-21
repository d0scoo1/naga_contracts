//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./AdminManager.sol";

contract Raks is Initializable, ERC20Upgradeable, AdminManagerUpgradable {
    function initialize() public initializer {
        __ERC20_init("RAKS", "$RAKS");
        __AdminManager_init();
    }

    function mint(address account, uint256 amount) external onlyAdmin {
        _mint(account, amount);
    }
}
