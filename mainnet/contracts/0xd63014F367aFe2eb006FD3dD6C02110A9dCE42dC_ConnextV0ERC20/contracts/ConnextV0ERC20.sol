//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@rari-capital/solmate/src/tokens/ERC20.sol";

contract ConnextV0ERC20 is ERC20 {

    constructor(address _custodian) ERC20("Connext", "NEXT", 18) {
        _mint(_custodian, 1_000_000_000 ether);
    }
}
