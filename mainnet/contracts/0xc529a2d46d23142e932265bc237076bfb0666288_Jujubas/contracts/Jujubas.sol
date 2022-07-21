
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Jujuba's Monochromatic Club
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////
//                                   //
//                                   //
//    Jujuba's Monochromatic Club    //
//                                   //
//                                   //
///////////////////////////////////////


contract Jujubas is ERC721Creator {
    constructor() ERC721Creator("Jujuba's Monochromatic Club", "Jujubas") {}
}
