pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract CryptoWarriorsGold is ERC20Burnable{
    constructor() ERC20("CryptoWarriorsGold","CWGOLD"){
        _mint(msg.sender, 10**9 * 10**18);
    }
}