//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "./vaults/DesignedVault.sol";

contract AirdropTOSStakerVault is DesignedVault {
    constructor(address _docAddress)
        DesignedVault("AirdropTOSStaker", _docAddress)
    {}
}
