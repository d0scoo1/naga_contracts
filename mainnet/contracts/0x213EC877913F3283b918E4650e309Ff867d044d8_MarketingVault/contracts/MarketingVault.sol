//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "./vaults/DesignedVault.sol";

contract MarketingVault is DesignedVault {
    constructor(address _docAddress)
        DesignedVault("Marketing", _docAddress)
    {}
}
