// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract BLToken is Ownable, ERC20Burnable {

    constructor(address wallet) Ownable() ERC20("Build Learning","BL") {
        _mint(wallet, (1 * (10 ** 9)) * (10 ** 18));
        transferOwnership(wallet);
    }
}
