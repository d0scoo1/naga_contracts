
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Dreams of Alchemy
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ███████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓███████████████████████████████████████████████████    //
//    ██████████████████████████▒░░░░░░░░░░░░░░░░▒▒▓████████████████████████████████████████████    //
//    ██████████████████████████▒░░░░░▒▒▒▒░░░░░░░░░░░░▒▓████████████████████████████████████████    //
//    ██████████████████████████▒░░░░▓█████████▓▒▒░░░░░░░░▒▓████████████████████████████████████    //
//    ██████████████████████████▒░░░░▓█████████████▓▒▒░░░░░░░▓██████████████████████████████████    //
//    ██████████████████████████▒░░░░▓█████████████████▓░░░░░░░▒████████████████████████████████    //
//    ██████████████████████████▒░░░░▓████████████████████▒░░░░░░▓██████████████████████████████    //
//    ██████████████████████████▒░░░░▓██████████████████████▓░░░░░░▓████████████████████████████    //
//    ██████████████████████████▒░░░░▓█████████▓▓▒▒▒▒▒▒▒▒▒▓▓██▒░░░░░▓███████████████████████████    //
//    ██████████████████████████▒░░░░▓████▓▒░░░░░░░░░░░░░░░░░░░░░░░░░▓██████████████████████████    //
//    ██████████████████████████▒░░░░▓█▓▒░░░░░░░▒▓▒░░░░▒▓▓▒░░░░░░░░░░░▓█████████████████████████    //
//    ██████████████████████████░░░░░▒░░░░░░▒▓███▓░░░░░░░▓███▓▒░░░░░░░░█████████████████████████    //
//    ██████████████████████████▒░░░░░░░░░▓█████▒░░░░░░░░░▒█████▒░░░░░░▓████████████████████████    //
//    ██████████████████████████░░░░░░░░░█████▓░░░░░▓█▓░░░░░▓████▓░░░░░▒████████████████████████    //
//    ██████████████████████████░░░░░░░░████▓▒░░░░▒█████▒░░░░▒████▒░░░░░████████████████████████    //
//    ██████████████████████████░░░░░░░▒███▒░░░░░▓███████▓░░░░░▓██▓░░░░░████████████████████████    //
//    ██████████████████████████▒░░░░░░░█▒░░░░░▓███████████▒░░░░░▓▓░░░░░████████████████████████    //
//    ██████████████████████████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░████████████████████████    //
//    ██████████████████████████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓████████████████████████    //
//    ██████████████████████████░░░░░░░░░░▒███████████████████▓▒░░░░░░░█████████████████████████    //
//    ██████████████████████████▒░░░░▒▓░░░░░░▒▓▓█████████▓▓▒░░░░░░░░░░▓█████████████████████████    //
//    ██████████████████████████▒░░░░▒██▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░▓██████████████████████████    //
//    ██████████████████████████▒░░░░▒██████▓▓▒▒░░░░░░░░░░▒▒▓▒░░░░░░████████████████████████████    //
//    ██████████████████████████▒░░░░▒█████████████████████▓░░░░░░▓█████████████████████████████    //
//    ██████████████████████████▒░░░░▓███████████████████▓░░░░░░▒███████████████████████████████    //
//    ██████████████████████████▒░░░░▓████████████████▓▒░░░░░░▒█████████████████████████████████    //
//    ██████████████████████████▒░░░░▓████████████▓▒▒░░░░░░▒▓███████████████████████████████████    //
//    ██████████████████████████▒░░░░▓█████▓▓▓▒▒░░░░░░░░▒▓██████████████████████████████████████    //
//    ██████████████████████████▒░░░░░░░░░░░░░░░░░░░▒▓▓█████████████████████████████████████████    //
//    ██████████████████████████▒░░░░░░░░░░░░░▒▒▒▓██████████████████████████████████████████████    //
//    ███████████████████████████▓▓▓▓▓▓▓████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract ALCH is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
