
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: DigitalApe Glitch Series
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    ░░░▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░▒▓▓▒▒▒▒▒▓▓▒▒▒▒▒▓▓▒▒▒▒▓▓▓▓▓▓▓▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒░    //
//    ░░▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░    //
//    ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓░    //
//    ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░    //
//    ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░▒▓██▓█████████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░    //
//    ░░▒▒▒░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒█████▓█████████████▓▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░    //
//    ░░▒▒▒░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒░░░░░░▒██▓▒▒░░░▒▒▓▓██████████▒░░░░░░░░░▒░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░    //
//    ░░▒▒▒░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒░░░░░░▒█▓▒░░░░░░░░░░▒▓█████████▓░░░░░░░░░░░░░░░░░░░░░░░░▒▒░▒░    //
//    ░░▒▒▒░░░░░░░▒▒░░░░░░░░░░░░▒▒░░░░░░▒██▒░░░░░░░░░░░▒▒▓█████████▓░░▒░░░░░▒░▒▒░░░░░░░░░░░░░░░░    //
//    ░░▒▒▒░░░░▒▒▒▒▒▒░░▒░░░░░░░░░░░░░░░▒▓██▒░░░░░░░░░░▒▒▒▓▓█████████▒▒▓▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░▒▒░░    //
//    ░░▒▓▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░▒█▓█▓▒░░░░░░░░░▒▒▒▒▓▓▓████████▓▒▓▓▒▒▒▓▒▒▒▒▒░░░░░░░░░░▒▒▒▒░    //
//    ░░▒▓▓▒▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓▒▒▒░░░░░░░░▓███▒▓▓██▓▒▒▒▓██▓▓▒▒▓██████████▒▒▓▓▒▒▒▒▓▓▒▒░░░░░░░░▒▒▒▒▒▒░    //
//    ░░▒▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒░░▒▒▒░░░▓███▓█████▒▓███████▒███████████▒▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░▒▒▒▒░░    //
//    ░░▒▓▓▓▓▒▓▒▒▒▒▒▓▓▓▓▓▓▓▒▓▒▓▒▒▒▓▒░▒▓███▓▒▒▓▒▓▓▓▒▒▒▓▒▒▒▓███████████▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░▒▒▒▒▒▒▒░    //
//    ░░▒▓▓▓▓▓▓▒▒▒▓▓▓▒▓▓▓▓▓▓▓▓▓▓▓▒▓▓▒▓▓███▓▒▒▒▒███▓▒▓▒▒▒▓▓▓██████████▓▓▓▓▓▓▓▓▓▓▓▓▒▒░░░░░░▒▒▒▒▓▓░    //
//    ░░▒██████▓▓▓▓▓▓▓▒▒▓▒▓▓▓▓▓▓▓▓▓▓▓██████▓▓▓▒▒▒▒▓▓▒▒▓▓▓▓███████████▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▒▒▓▓▓░    //
//    ░░▒██████▓▒▒▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓█████████▒░▒▒▒▓▒▓███████████████▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓██░    //
//    ░░▒██▓▓██▓▒▒▒▓▓▓▓▓▓▓▒▓▓▓▓▓▓▓▓▓▓████████▓▒▒▒▒▒▓▓▓▓█▓█▓██████████▓▓▓▓▓▓▓▓▓████▓▓▓▓▓▒▓▓▓████░    //
//    ░░▒██▓███▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓███████▒▒▒▒▒▓▓▓▓▓▓▓▓▓██████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▓▓▓██░    //
//    ░░▒██▓▓███▓▓▓▓▓▓▓████▓▓▓▓▓▓▓▓▒▓▓████████▒░░▒▒▒▒▒▒▓▓▓████████████▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███░    //
//    ░░▒▓█▓▓▓▓▓█▓▒▓▓▓▓██████▓▓▓▓▓▓▒▒▓█████████▒▒▒▒▓▓▓████████████████▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███░    //
//    ░░▒███▓▓██▓█▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓███████████████████████████████▓▓▓▓▓▓▓▓▓▓▓████████▓▓▓▓▓▓░    //
//    ░░▒███▓▓█▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█████████████▓▓▓██▓████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓░    //
//    ░░▒▓█▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█████████████▓▓▓▓███████████▓██▓▓▓▓▓▓▓▓▒▒▒▓▓▒▒▒▒▒▓▓▓▓▓▓▓░    //
//    ░░▒▓█▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓█▓▒▒▓▓▓▓▓▓▓█████████████▓▒▓▓▓██████████▓█████████▓▓█▓█▓▒▒▒▓▓▓▓▓▓███░    //
//    ░░▒▓█▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▒▓█████▓██████████████▓▓██▒▒▓▓▓▓██████▓█████▓█▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓███░    //
//    ░░▒██▓█████▓▓▓▓▓██▓▓▓▓██▓███▓████████████▓▒███▓▒▒▓▓█▓▓█████▓███████████▓▒░▒▒▒▒▒▓▓▓▓▓█▓▓▓▓░    //
//    ░░▒▓▓▓▓▓█▓██▓▓▓▓▓▓▓▓▓██▓▓▓█▓▓█████████▓▒▒▒▓████▒▓▓▓█▓██████▓███████████▓▒▒▒▒▒▒▒▒▒▓▓▓▒▒▒▓█░    //
//    ░░▒█▓▓▓██▓██▓▒▒▒▒▓▓▓▓▓▓▓▓█▓▓██████████▓██▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓███▓████████▓███▓▓▓▓▓▒▓▒▒▓▒▒▒▒▓▓▓░    //
//    ░░▒██████████▓█▒▒▒▒▓▓▓▓█▓▓███████████▓░▒▓▓▒░░░▓███████▓▓███████▓▓█▓▓████████████▓██▒▓▒▒▓▒░    //
//    ░░▒██▓▓▓█▓███▓███▓▒▓▒▒▓▓██████████▓▓██▓▒▓▒░░░░▒▒▒▒▒▒▒▓▓██████▓▓▓▓▓██████████▓████████▓▒▒▒░    //
//    ░░▒█▓▓██████▓▓▓▓▓▓▓▓▒▒▓███████████▓░▓▓██▓▒░▒▒▓█▓▓▓▓██████████████████████████▓▓▓███████▓▓░    //
//    ░░▒███▓▓▓▓▓▓▓▓▓▓▒▒▒▓▓▓██████████████▓▒▒▒▒░░░▒▓█▓██████████████████████████████▓▓▓▓▓██████░    //
//    ░░▒██▓█▓▓█▓▒▓▓█▓▓▓████████████████████████▓▓▓▓▓▓▓▓▓████████████████████████████████████▓▓░    //
//    ░░▒█▓▓▓▓▓▓▓▓▓▓▓▒▒▒▓▓▓████████████████████████████████████████████████████████████▓███████░    //
//    ░░▒████████▓▓▓▓▓▓▓▓▓▓████████████████████████████████████████████████████████████▓▓▓▓▓█▓█░    //
//    ░░▒█▓▓▓▓▓▓▓▓██████▓██████████████████████████████████████████████████████████████████▓▓▓▓░    //
//    ░░▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▓████████████████████████████████████████████████████████████████▒▒▒▒▒▒░    //
//    ░░▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓████████████████████████████████████████████████████████████████▓▒▒▓▓▓░    //
//    ░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████████████████████████████████████████████████████████████████░    //
//    ░░▒██████████████████████████████████████████████████████████████████████████████████████░    //
//    ░░▒████▓█████████████████████████████████████████████████████████████████████████████████░    //
//    ░░▒██████████████████████████████████████████████████████████████████████████████████████░    //
//    ░░▒██████████████████████████████████████████████████████████████████████████████████████░    //
//    ░░▒██████████████████████████████████████████████████████████████████████████████████████░    //
//    ░░▒████████████▓▓▓▓██████████████████████████████████████████████████████████████████████░    //
//    ░░▒███████████▓▓▓▓█▓▓▓▓▓█████████████████████████████████████████████████████████████████░    //
//    ░░▒████████████▓▓▓▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████████████████████████████████████████░    //
//    ░░▒████████████▓▓▓▓▓▓█▓▓▓█▓█▓▓▒▒▒▒▒▒▒▒▒▒▒▓███████████████████████████████████████████████░    //
//    ░░▒████████████▓█▓▓▓█▓█▓█▓▓▓▓█▓▓▒▓▒▒▒▓▒▓▓▓▒▒▒▓▓██████████████████████████████████████████░    //
//    ░░▒██████████████▓█▓██▓██▓██▓▓▒▒▒▓▒▒▓▒▓▒▓███▓▒▓▒▓▓▓██████████▓▓▓▓▓███████████████████████░    //
//    ░░▒███████████████████████████████▓▓▓▒▓█▓▒▒▓███▓▓▓▓▓▓▓▓▓▒▓▓▓▓▓▓▓▒▓███████████████████████░    //
//    ░░▒██████████████████████████▓▓▒▒▓▓▒▒█▓▒▓█▓▒▒█████▓▓▓▓▓██▓▓▓▓▓▓▓▓▓███████████████████████░    //
//    ░░▒██████████████████████▓▒▒▓▓▒▒▓▓▓▓▓▒▓▓▒▒▓██▓▓▓██████▓▓██▓█▓▓▓██████████████████████████░    //
//    ░░▒██████████████████████▓██▓▓█▓▒▒▓▓▓█▓▓▓██▓▓██▓▓▓███████████████████████████████████████░    //
//    ░░▒██████████████████████▓▓▒██▓▓▓▒▓▓▓████▓▓██▓▓███▓▓█████████████████████████████████████░    //
//    ░░▒██████████████████████▓▓▓█▒▓▓█████████████████████████████████████████████████████████░    //
//    ░░▒████████████████████████▓▓▓▓██████████████████████████████████████████████████████████░    //
//    ░░▒██████████████████████████▒▓██████████████████████████████████████████████████████████░    //
//    ░░▒██████████████████████████▓███████████████████████████████████████████████████████████░    //
//    ░░▒██████████████████████████████████████████████████████████████████████████████████████░    //
//    ░░▒██████████████████████████████████████████████████████████████████████████████████████░    //
//    ░░▒████████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░    //
//    ░░▒▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract DGS is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
