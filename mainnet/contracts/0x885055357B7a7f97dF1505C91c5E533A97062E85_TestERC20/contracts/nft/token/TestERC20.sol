// contracts/Cruise.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract TestERC20 is ERC20, Ownable {
    /**
    * @dev Set the maximum issuance cap and token details.
    */
    constructor () ERC20("WIND TOKEN", "WIND") {
        _mint(msg.sender, 5 * (10**8) * (10**18));
    }

    // function mint(address account, uint256 amount) 
    // public onlyOwner {

    //     _mint(account, amount);
    // }

    // function burn(address account, uint256 amount) 
    // public onlyOwner {

    //     _burn(account, amount);
    // }
    
    // function transferByOwner(address from, address to, uint256 amount) 
    // public onlyOwner {

    //     _transfer(from, to, amount);
    // }
}