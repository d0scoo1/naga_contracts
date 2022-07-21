pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VegetableCoin is ERC20, Ownable {
    constructor() ERC20('VegetableCoin', 'Vege') {
        _mint(msg.sender, 76000000000000 * 10 ** 18);
    }

    function burn(uint amount) public {
        _burn(msg.sender, amount);
    }
}