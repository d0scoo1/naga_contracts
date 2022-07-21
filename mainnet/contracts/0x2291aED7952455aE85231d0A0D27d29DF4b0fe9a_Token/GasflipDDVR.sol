
// SPDX License Indentifier: MIT License

import "http://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";
import "http://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "http://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";


pragma solidity ^0.8.3;

contract Token is ERC20 {

    constructor () ERC20("Dodona Metaverse", "DDVR") {
        _mint(msg.sender, 77777777 * (10 ** uint256(decimals())));
    }
}
