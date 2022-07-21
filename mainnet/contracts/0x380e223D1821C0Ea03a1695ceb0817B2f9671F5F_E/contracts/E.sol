
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ediep
/// @author: manifold.xyz

import "@manifoldxyz/creator-core-solidity/contracts/ERC721Creator.sol";

///////////////////////////////////////
//                                   //
//                                   //
//    war aint what it used to be    //
//                                   //
//                                   //
///////////////////////////////////////


contract E is ERC721Creator {
    constructor() ERC721Creator("ediep", "E") {}
}
