// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.3.2/token/ERC20/ERC20.sol";

contract KRLBalancerListing is ERC20 {
    constructor() ERC20("KRL balancer Listing", "KRL") {
        _mint(msg.sender, 300000000 * 10 ** decimals());
    }
}
