// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Create Eth App ERC-20 Token
 * @notice Sourced from OpenZeppelin and modified so that anyone can mint.
 */
contract CeaErc20 is ERC20 {
    constructor() ERC20("CeaErc20", "CEAERC20") {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param value The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to, uint256 value) public returns (bool) {
        _mint(to, value);
        return true;
    }
}
