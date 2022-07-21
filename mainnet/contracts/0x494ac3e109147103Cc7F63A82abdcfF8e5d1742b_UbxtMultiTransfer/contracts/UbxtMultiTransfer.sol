// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "./utils/AuthorizableU.sol";

contract UbxtMultiTransfer is ContextUpgradeable, AuthorizableU {
    using SafeMathUpgradeable for uint256;
    using SafeERC20Upgradeable for IERC20Upgradeable;

    ////////////////////////////////////////////////////////////////////////
    // State variables
    ////////////////////////////////////////////////////////////////////////    

    ////////////////////////////////////////////////////////////////////////
    // Events & Modifiers
    ////////////////////////////////////////////////////////////////////////

    // Events.
    event MultiTransfer(IERC20Upgradeable token, address receiver, address[] senders, uint256[] amounts);

    ////////////////////////////////////////////////////////////////////////
    // Initialization functions
    ////////////////////////////////////////////////////////////////////////

    function initialize(
    ) public virtual initializer
    {
        __Context_init();
        __Authorizable_init();
        addAuthorized(_msgSender());
    }

    ////////////////////////////////////////////////////////////////////////
    // External functions
    ////////////////////////////////////////////////////////////////////////

    // update the treasury address
    function multiTransfer(IERC20Upgradeable token, address receiver, address[] memory senders, uint256[] memory amounts) public onlyAuthorized {
        for (uint i=0; i<senders.length; i++) {
            token.safeTransferFrom(senders[i], address(this), amounts[i]);
        }
        uint256 tokenAmount = token.balanceOf(address(this));
        token.safeTransfer(receiver, tokenAmount);
        emit MultiTransfer(token, receiver, senders, amounts);
    }
}