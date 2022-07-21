pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Burnable.sol";

contract RolazGold is ERC20, ERC20Detailed, ERC20Burnable {

    constructor () public ERC20Detailed("RolazGold", "rGLD", 18) {
        _mint(msg.sender, 50000000 * (10 ** uint256(decimals())));
    }
}