// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "ERC20.sol";
import "ERC20Burnable.sol";
import "ERC20Snapshot.sol";
import "Ownable.sol";
import "Pausable.sol";

contract Giant is ERC20, ERC20Burnable, ERC20Snapshot, Ownable, Pausable {
    constructor() ERC20("Giant", "GIAN") {
        _mint(msg.sender, 10000000 * 10 ** decimals());
    }

    function snapshot() public onlyOwner {
        _snapshot();
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override(ERC20, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
