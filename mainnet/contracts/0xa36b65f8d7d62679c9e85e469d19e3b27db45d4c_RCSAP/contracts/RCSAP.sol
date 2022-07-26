
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Right-click and Save As punk
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    ▓▓▓▓███▓▒▒▒████▒▒▒▒▓▓▓▓▒▒▒████████▓▓▓████████▒▒▒▒▒▒▒▓███▓▒▒▒███████▓▒▒▒████████▓▓▓████████    //
//    ▓▓▓▓███▓▒▒▒████▒▒▒▓▓▓▓▓▒▒▒████████▓▓▓████████▒▒▒▒▒▒▒▓███▓▒▒▒███████▓▒▒▒████████▓▓▓████████    //
//    ▓▓▓▓▒▒▒▓███████▒▒▒▓███████████▒▒▒▓████▓▓▓████████▓▓▓▓▓▓▓████▓▓▓▓███████▓▓▓▓▒▒▒▓███▓▒▒▒▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓███████▒▒▒▓███████████▓▓▓▓████▓▓▓████████▓▓▓▓▓▓▓████▓▓▓▓███████▓▓▓▓▓▓▓▓████▓▓▓▓▓▓▓    //
//    ████████▓▓▓▓▒▒▒▒▒▒▓████▓▓▓████████▒▒▒▓███▓▒▒▒███████████████████▒▒▒▓███▓▓▓▓███████████▓▓▓▓    //
//    ███████████▓▒▒▒▓▓▓▓██████████████▓▒▒▒▓███▓▓▓▓███████████████████▓▓▓███████████████████████    //
//    ▒▒▒▓███████▓▒▒▒████▒▒▒▓███████▒▒▒▒▒▒▒▓███████████▒▒▒▒▒▒▒▒▒▒▒███████████████▒▒▒▒▓▓▓████████    //
//    ▓▓▓▓███████▓▓▓▓████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████▓▓▓▓▓▓▓▓▒▒▒████████▓▓▓████▒▒▒▓████▓▓▓████    //
//    ████████▓▓▓▓▓▓▓███████▓▒▒▒▒▒▒▒██████████████████████████▓▒▒▒▓▓▓▓███▓▒▒▒████▒▒▒▓███▓▒▒▒▓▓▓▓    //
//    ███████████████████▓▓▓▓▒▒▒▓█████████████████████████████████▓▓▓▓███████████▒▒▒▓███▓▒▒▒▓███    //
//    ████▓▓▓████████████▒▒▒▒▒▒▒██████████████████████████████████▒▒▒▓▓▓▓████▓▓▓▓▒▒▒▓███▓▒▒▒████    //
//    ▓▓▓▓▓▓▓▓████▓▓▓▓▓▓▓▒▒▒▓█████████████████████████████████████████▓▓▓▓▓▓▓███████████▓▒▒▒████    //
//    ▒▒▒▒▒▒▒▓███▓▓▓▓▒▒▒▒▒▒▒▓█████████████████████████████████████████▒▒▒▒▒▒▒███████████▓▒▒▒████    //
//    ███████▓▓▓▓████▒▒▒▓████████████████████████████████████████████████▓▒▒▒████▓▓▓▓███████▓▓▓▓    //
//    ███████▓▒▒▒████▒▒▒▓████████████████████████████████████████████████▓▒▒▒████▒▒▒▓███████▓▒▒▒    //
//    ████▒▒▒▓███▓▒▒▒███████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████▓▒▒▒████▓▓▓▓▓▓▓████    //
//    ████▒▒▒▓███▓▒▒▒███████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████▓▒▒▒████▓▓▓▓▓▓▓████    //
//    ▓▓▓▓▓▓▓████▓▒▒▒███████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███████████████▓▒▒▒████▒▒▒▓███▓▒▒▒    //
//    ▓▓▓▓▓▓▓████▓▒▒▒███████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███████████████▓▒▒▒████▓▓▓▓███▓▓▓▓    //
//    ███████▓▒▒▒▒▒▒▒███████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▓▒▒▒▒▒▒▓███▓▒▒▒████    //
//    ███████▓▒▒▒▓▓▓▓███████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▓▓▓▓▒▒▒▓███▓▓▓▓████    //
//    ▒▒▒▓███▓▒▒▒███████████▓▓▓▓▓▓▓▓███████████▓▓▓▓▓▓▓▓▓▓▓████████████▓▓▓▓███████▒▒▒▓████▓▓▓████    //
//    ▓▓▓▓▓▓▓▓▒▒▒███████████▓▓▓▓▓▓▓▓███████████▓▓▓▓▓▓▓▓▓▓▓████████████▓▓▓▓███████▒▒▒▓████▓▓▓▓▓▓▓    //
//    ████▒▒▒▒▒▒▒███████████▓▒▒▒▓▓▓▓███████████▓▓▓▓▒▒▒▒▓▓▓████████████▓▓▓▓███████▒▒▒▓███▓▒▒▒▒▒▒▒    //
//    ████▓▓▓▓▒▒▒███████████▓▒▒▒▓▓▓▓███████████▓▓▓▓▒▒▒▒▓▓▓████████████▓▓▓▓███████▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓███▓▒▒▒███████████▓▒▒▒▓▓▓▓███████████▓▓▓▓▒▒▒▒▓▓▓████████████▓▓▓▓███████▒▒▒▒▒▒▒▓███████    //
//    ████▓▓▓▓██████████████████▓▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓████████████████▒▒▒▓▓▓▓████    //
//    ████▒▒▒▓██████████████████▓▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓███████████████▒▒▒▓▓▓▓████    //
//    ▓▓▓▓▒▒▒▓██████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███████████████████▒▒▒▓███▓▓▓▓    //
//    ▒▒▒▒▒▒▒▓██████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███████████████████▒▒▒▓███▓▒▒▒    //
//    ████▒▒▒▓██████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒███████████████████▒▒▒▓▓▓▓████    //
//    ████▒▒▒▓██████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒███████████████████▒▒▒▓▓▓▓████    //
//    ▒▒▒▒▒▒▒▓██████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████▒▒▒▒▒▒▒▒▒▒▒███████████████████▒▒▒▓▓▓▓▓▒▒▒    //
//    ▒▒▒▒▒▒▒▓██████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████▒▒▒▒▒▒▒▒▒▒▒███████████████████▒▒▒▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▒▒▒▓██████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒███████████████████▒▒▒▒▒▒▒████    //
//    ███▓▒▒▒▓██████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒██████████████████▓▓▓▓▓▓▓▓████    //
//    ████▒▒▒▒▒▒▒███████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███████████████▒▒▒▒▓▓▓████████    //
//    ████▓▓▓▓▒▒▒███████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓████████████▓▓▓▓▓▓▓███████▓▓▓▓    //
//    ███████▓▒▒▒███████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███████████████▓▒▒▒████████▓▓▓▓▒▒▒    //
//    ███████▓▒▒▒▓▓▓▓███████████▓▒▒▒▒▒▒▒▒▒▒▓██████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓▒▒▒    //
//    ▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒███████████▓▒▒▒▒▒▒▒▒▒▒▓█████████████████████████████▓▒▒▒████▒▒▒▒▒▒▒▓███▓▒▒▒    //
//    ████▒▒▒▓███▓▒▒▒███████████▓▒▒▒▒▒▒▒▒▒▒▓██████████████████████████▓▓▓▓▒▒▒▓▓▓▓▒▒▒▓███▓▓▓▓▓███    //
//    ████▒▒▒▓███▓▒▒▒███████████▓▒▒▒▒▒▒▒▒▒▒▓██████████████████████████▒▒▒▒▒▒▒▓▓▓▓▒▒▒▓███▓▒▒▒████    //
//    ▓▓▓▓███▓▓▓▓▒▒▒▒███████████▓▒▒▒▒▒▒▒▒▒▒▓██████████████████████▓▓▓▓▒▒▒▓███▓▒▒▒████▓▓▓████▓▓▓▓    //
//    ▒▒▒▓███▓▒▒▒▒▒▒▒███████████▓▒▒▒▒▒▒▒▒▒▒▓██████████████████████▒▒▒▒▒▒▒▓███▓▒▒▒████▓▓▓████▓▓▓▓    //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract RCSAP is ERC721Creator {
    constructor() ERC721Creator("Right-click and Save As punk", "RCSAP") {}
}
