// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {LibDiamond} from "../../libraries/diamond/standard/LibDiamond.sol";

abstract contract BFacetOwner {
    modifier onlyOwner() {
        LibDiamond.enforceIsContractOwner();
        _;
    }
}
