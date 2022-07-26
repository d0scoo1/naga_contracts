
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: primalglenn
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                          //
//                                                                                          //
//      _____   ______ _____ _______ _______         ______        _______ __   _ __   _    //
//     |_____] |_____/   |   |  |  | |_____| |      |  ____ |      |______ | \  | | \  |    //
//     |       |    \_ __|__ |  |  | |     | |_____ |_____| |_____ |______ |  \_| |  \_|    //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////


contract glenn is ERC721Creator {
    constructor() ERC721Creator("primalglenn", "glenn") {}
}
