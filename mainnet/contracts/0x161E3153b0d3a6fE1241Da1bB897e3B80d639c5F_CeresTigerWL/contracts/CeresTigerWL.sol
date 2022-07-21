// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../common/Ownable.sol";

contract CeresTigerWL is ERC20Burnable, Ownable {

    constructor(address _owner, uint256 _premint) Ownable(_owner) ERC20("CeresTigerWL", "CTW") {
        _mint(owner(), _premint);
    }

    function decimals() public view override returns (uint8) {
        return 0;
    }
    
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
