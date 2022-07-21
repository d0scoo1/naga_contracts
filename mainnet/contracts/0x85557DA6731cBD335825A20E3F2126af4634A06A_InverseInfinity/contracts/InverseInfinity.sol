// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*

.___                                         .___        _____.__       .__  __          
|   | _______  __ ___________  ______ ____   |   | _____/ ____\__| ____ |__|/  |_ ___.__.
|   |/    \  \/ // __ \_  __ \/  ___// __ \  |   |/    \   __\|  |/    \|  \   __<   |  |
|   |   |  \   /\  ___/|  | \/\___ \\  ___/  |   |   |  \  |  |  |   |  \  ||  |  \___  |
|___|___|  /\_/  \___  >__|  /____  >\___  > |___|___|  /__|  |__|___|  /__||__|  / ____|
         \/          \/           \/     \/           \/              \/          \/     

*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

/// @custom:security-contact keir@chainfrog.com
contract InverseInfinity is ERC20, ERC20Burnable, Pausable, Ownable, ERC20Permit, ERC20Votes {
    constructor(address _receiver) ERC20("Inverse Infinity", "INVCOIN") ERC20Permit("Inverse Infinity") {
        _mint(_receiver, 52000000 * 10**decimals());
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }
}
