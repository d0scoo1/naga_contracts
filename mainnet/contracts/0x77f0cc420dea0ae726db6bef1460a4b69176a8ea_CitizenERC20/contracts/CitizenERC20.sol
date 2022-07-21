pragma solidity ^0.8.0;

// Import contracts.
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol';

//@title Kong Land Alpha $CITIZEN Token
contract CitizenERC20 is ERC20, ERC20Burnable {

    constructor() ERC20('KONG Land Alpha Citizenship', 'CITIZEN') {
        _mint(msg.sender, 500 * 10 ** 18);
    }

}