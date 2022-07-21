// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
pragma solidity ^0.8.0;

import "./IERC20.sol";
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IPTX is IERC20{

    /**
     * @dev Mints `amount` tokens on `receiver_` address
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */

    function mint(
        address receiver_, 
        uint256 amount_
    ) external returns (bool);

    /**
     * @dev Burns `amount` tokens from `account_` address
     * Returns a boolean value indicating whether the operation succeeded.
     *
     */
    function burn(
        address account_, 
        uint256 amount_
    ) external returns(bool);
    

}