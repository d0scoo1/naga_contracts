
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Negative Vibrations - Maciej Drabik
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    █████████████████████████▓▓▓▓▓▓▓▓▒▓▓▒▓▓▓▓▓▓▓▓▓▒▓▓▓▒░░▒▒▒▒▒▒░░▒▒▓▓▓▓▒▓█████████████████████    //
//    ███████████████████████▓█▒▓▒▓▓▒▓▓▒█▓▒▓▓▒▓▓▓▓▓▓▓▓▒▒░░▒▒▒▒▒░▒░░▒░░▒▓▒█▓▓▓███████████████████    //
//    █████████████████████▓█▒▓▒▓▓▓▓▒▓▓▒█▓▒▒▓▓▓▒▓▒▒▓▓▓▓▒░░▒░░▒░░▒░▒▒░░░░▒▒▒▓▓▓▓█████████████████    //
//    ███████████████████▓█▓▓▒█▓▓█▒▓▒▓▓▒▓▓▒▓▓▓▓▒▓▒▒▒▒▒▒▓▒░▒░░▒░░▒░░░▒▒░▒░░░▒▒▓▓▒▓███████████████    //
//    ███████████████████▓█▒█▒█▓▓█▒█▓▒▓▓▓█▒▓▓▒▓▓▓▓▓▓▒▒▒▒▒▒▓░░▒░░▒░▒░▒░░▒░░░░░▒▒▒▓▓██████████████    //
//    █████████████████▓█▒█▓█▓▓█▒█▓▓█▒█▓▒█▓▓▓▒▓▓▓▓▓▓▒▒▓▒░░▒░░▒░▒░▒▒░▒░░░░░░░░▒░▒▒▒▓▓████████████    //
//    █████████████████▓▓▓▓▓▓█▒█▒█▓▓█▒▓▓▒▓▓▒▓▒▓▓▓▓▓▓▒▒▒▒▒░▒░▒░░▒░░░▒▒░░░░░░░░░░▒▒▒▒▓████████████    //
//    ████████████████▓█▒█▒█▒█▒█▒█▓▒█▒▓█▒▓▓▒▓▓▒▓▓▓▓▓▓▒░▒░▒░░▒░░▒░▒░░▒░░░░░░░░░░░▒▒▒▒████████████    //
//    █████████████████▓▒█▒█▒█▒█▒▓▓▒█▒▓█▒▓▓▒▓▓▒▓▓▓▓▓▒▓▓▒▒▓░░▓░▒▒░░░░▒░░░░░░░░░░░░░▒▒████████████    //
//    █████████████████▓▓▓▓█▒█▒█▒█▓▒█▒▓█▓██▓█▓▒█▓▓▓█▓▒▓▒▓▓▒▓▓▒░▒░▒░░▒░▒░░░░░░░░░░▒▒▒▓███████████    //
//    █████████████████▓█▓▓▓▓█▒█▓██▓█▓▓█▓██▓██▓▓▓█▓▓▓▓█▓▓▓▓▒▓▒▒▓▒▓▒░▒░░░░░░░░░░░░▒▒▒▓███████████    //
//    ███████████████▓███▓█▓██▓█▓▓█▓█▓██▓█▓███▓█████████▒▓▓▓▓▓▓▓▓▓▓▒▓░▒▒░▒▒░░░░▒▒▒▒▒▓███████████    //
//    █████████████████▓▓▓▓█▓█████████████▓█▓█▓▓██▓▓▒▓▓█▓▓████████████▓▒▒▒▒▒▒░░░░▒▒▒▓███████████    //
//    ██████████████████▓▓████████████████████▓███▓▒▒▓▓▓████████████████▓▓▓▓▓▒▒░░░▒▒▓███████████    //
//    █████████████████▓▓████████████████████▓████▓▓▓▒▓▓███████████████▓▓▓▓▓▓▒░░░░▒▒▒███████████    //
//    █████████████████▓██████████████████████▓▓▓▓▒▓▒▒▓▒█████████▓▓▒░▒▓▓█▓▓▓▓▓▒░░░▒▒▓███████████    //
//    █████████████████▓███████████████████████▓▒▓▒▒▒▒▒▒██████████▓▓▒░▒▓█▓▓▓▓▒▒░░░▒▒▓███████████    //
//    █████████████████▓█████████████████████▓▓▓▓▒▒▒░▒▒▒▓█████████▓▒▒▓▓███▓▓▓▒▒░░░▒░████████████    //
//    ████████████████▓▓█████████████████████▓█▓██▓░░▒▒░▓▓▓▓▓▓█████▓▓▓▒███▓▓▓▒░░░░░░████████████    //
//    ████████████████▓▓████████████████████▓▓██▓▓▒░░░▒▓▒▒▒▒▓▓▒▒▓▓▒▒▒▒▓▓██▓▓▓▒░░░░░░░░░▒████████    //
//    ████████▓█████████▓████████████████▓█▓████▓▒▒░░░░▒▓▒▒▒░▒▒▓▒▒░░░░▒▓▓▓█▓▓▒░▒▒░░░░▒▓█▒███████    //
//    █████████████▓█▓███▓███████████▓█▓█▓█████▓▓▒░░░░░░▓▒▒░▒▒▒▒▒▒░░░░░░▒▒▓▓▒░▒▒▒▒░░░▒▓█▓▓██████    //
//    ███████████████▓▓███▓▓█▓█▓█▓█▓▓▓█▓█████████▓▓▓▒░░░▒▓▒▒▒▓▒▒▒▒▓▒▓▒▒▓▒▓▒░░▒▒▒▒░░░░░▓██▒██████    //
//    ████████████████▓█▓█▒██▓█▓███████▓████████████▓▒▓█▓▓▓▒▒▓▓▒▓▓▓▓▓▓▒▓▒▒▓░░░▒▒▒▒░░░░▒██▒██████    //
//    ████████████▓█████▓█▓██▓██████████▓▓▓█████▓▓██▓█████▓▒▒▒▓▒▓▒▓▓▓▓▓▓▒▓▓▒▒░░▒▒▒░░░░▒▓▓▓██████    //
//    █████████████▓▓▓▓██████▓██████▓█▓▓▓█▓█████████▓█████▓▒▒▓▓▒▓▒▓▒▒▓▓▓▓█▓▓▓▓▒▒▒░░▓░░░▒░███████    //
//    █████████████▓▒▓▓▓█████▓██████▓█▓█▓▓▓▓████████▓▒▓███▒░▒▒▓▒▓▒█▒▓▓▓▓▓▓▓▓▓▓▓▓▒░░▒░░░░████████    //
//    ███████████████▓▓▓█▓█▓█▓█▓████▓██▓█▓████████▓▓▓░▒▓▒▒▒▒▒▒░█▓▓█▓▓▓▒▓▓▓▒▓▓▓▓▒░░░░░▒▒█████████    //
//    ████████████████▓▓▓▓▓▓█▓▓▓██▓██▓████████████▓██▓▓█▓▒░▒▒░▒▓░▓▓▒▓▓▒▓▒▓▒▓▓▓▒░░░░░▒░██████████    //
//    █████████████████▓███████████▓██▓██▓██▓██▓██▓██▓▒▓▒░░▒░░▒░░▓░▒▒▓▓▓▓██▓▒▒░░░░░░░▒██████████    //
//    ██████████████▓███▓█████████▓█▓██▓██▓██▓██▓█▓██▒▓▒▓▓░▒▒░░░▒░▒░▒▓▒▒▒▒▒░░░░░░░░░░▓██████████    //
//    ████████████████████████████▓█▓▓██▓██▓██████▓▓▓▓▒▒▓▒▒█▒▒▓▓░▒▒▓▒▒▓▒░░░▒░▒░░░░░░▒███████████    //
//    ███████████████████▓█████████▓██▓█▓▓███████████▓▓▓▓▓█░▓█▒░▓▒▒▓▒░░░░░▒▒▒░░░░░██████████████    //
//    ████████████████████▓████████████▓▓█▓█▓██████▓▓▒▒▒▒▒░▒▓▒▒▓▒▒▓▓▒░░░▒░▒▒▓░░░░▒██████████████    //
//    ███████████████████████████████████▓██▓███▓█▓▓▓▓▓▒▒▒▒▒▓█▒░░▒▓▓▓▒░░░░▒▓▒░░▒▒███████████████    //
//    ███████████████████████████████████▓▓████▓▓▓███▓▓▓▓▓▓▒▒▒░░░░░▒▓▒░░░░▒▒▒░▒▒████████████████    //
//    █████████████████████████████████████████████████████▓▓▒░░░░░░░░░▒░░░▒░▒▒▓████████████████    //
//    █████████████████▓████████████████████████████▓▓▓▒▒▓▓▒░░░░░░░░░░▒▒▒▒▒▓░▒▒▓████████████████    //
//    █████████████████▓▓█████████████████████████████▒░░░░░░░░░░░░░░░░░▒▒▓▒▒▓▒▒████████████████    //
//    █████████████████▓█████████████████████████████▓▓▒░░░░░░░░░░▒▒▒▒▒▒▒▒▓▒▓▓▓▒████████████████    //
//    ███████████████████▓█████████████████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▒▒▓▓████████████████    //
//    █████████████████▓███▓██████▓▓███████████████████████▓▓▓▓▓▓▓▓▓▓▓████▓▓▓▓▓▒████████████████    //
//    ██████████████████████████▓██▓▓▓██████████████████████████████████▓▓█▓█▓▓█████████████████    //
//    ███████████████████████████████████████████████████████████████████▓██▓▓▓▓████████████████    //
//    ████████████████████████████████████████████████████████████████████████▓█████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    █████████████▓▒██▓▓███▓▒▒▒▒▒▓████▓▒▒▓████▓▒▓▓███▒▒▒▒▒▒▒█▓▒▓███▓▒▓██▒▓███▒▒▒▒▒▓████████████    //
//    █████████████▒░░▒▒░░▒█▓▒░░▓▓███░░▒▓▒▓████▓▒░░░██▓▓░░▒▓██▒░░▓██▒░░█▓░░▒█▓▒░░▓▒▓████████████    //
//    █████████████▓░░██░░▒██▒░░▒▒██▓░░▓███████▓▒▓░░████░░▓████░░▓██▓░░██░░▓██▒░░▒▒▓████████████    //
//    █████████████▓░░██░░▒██▒░░▓▓██▓░░██░░▓██▒▒▒▒░░████░░█████░░▓██▒░░██░░▓██▒░░▓▓█████████████    //
//    █████████████▒░░▓█░░░▓█▒░░▒▓▓█▓░░▒▒░░██░▒▓█▓░░▓██▓░░▒████░░▒▓█▓░░▒▒░░▓██▒░░▒▓▓████████████    //
//    ██████████████▓▓███▓▓██▓▓▓▒▓████▓▒▓░░██▓▒███▓▒████▓▒▓████▓▒▓████▓▒▓██████▓▓▒▓█████████████    //
//    █████▓███▓▓███▓▓████▓██▓▓▓███▓▓██▓▓▒█████▓▓█████▓▓▓▓▓▓██▓████████▓▓█████▓▓██▓███████▓▓▓███    //
//    ████░░░█▒░░▒█▓░░░██▒░░▒▒░░▒█▓░░░▒░░░████▓▒░░░▓█▓▒░░░▒▓█▒░░▓███▓▒▒░░░░▓█▓░░░▒░░░▓██▒░▒░▒███    //
//    ████▓░░██░░▒██▒░░███░░▓▓░░▓██▒░░▓▒░▒█████░▓░░▓███░░▓████░░▓██▒░░███░░▒██▒░▒██░░▓█▒░░▒▓████    //
//    ████▓░░██░░▒██▒░░███░░▒░░░░██▒░░▒░░▓███▓░▒▒░░▓███░░▓████░░▓██▒░░███░░▓██▒░▒██░░▓██▓▒░░░▓██    //
//    ████▓░░▒▓░░▓██▒░░▓██░░▓█▒░░██▒░░▓▓░░▓█▒░███░░▓███░░▒████░░▒██▒░░▓▓▓░░▓██░░▒██░░▒██▓▓▓░░▓██    //
//    █████▓▓▒▒▓████▓▒▒▓██▒▒░▒▓▓███▓▒▒▓█▓▒▓▓▒░▓██▒▒▒███▒▒▒████▒▒▒███▓▒░░▒▓████▓▒▒▓█▓▒▓█▓▒▒▒█████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract NV is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
