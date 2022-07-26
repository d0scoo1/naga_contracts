
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: MechArcade 1 of 1's
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                              //
//                                                                                                                              //
//                                                                                                                              //
//     _____ ______    _______    ________   ___  ___   ________   ________   ________   ________   ________   _______          //
//    |\   _ \  _   \ |\  ___ \  |\   ____\ |\  \|\  \ |\   __  \ |\   __  \ |\   ____\ |\   __  \ |\   ___ \ |\  ___ \         //
//    \ \  \\\__\ \  \\ \   __/| \ \  \___| \ \  \\\  \\ \  \|\  \\ \  \|\  \\ \  \___| \ \  \|\  \\ \  \_|\ \\ \   __/|        //
//     \ \  \\|__| \  \\ \  \_|/__\ \  \     \ \   __  \\ \   __  \\ \   _  _\\ \  \     \ \   __  \\ \  \ \\ \\ \  \_|/__      //
//      \ \  \    \ \  \\ \  \_|\ \\ \  \____ \ \  \ \  \\ \  \ \  \\ \  \\  \|\ \  \____ \ \  \ \  \\ \  \_\\ \\ \  \_|\ \     //
//       \ \__\    \ \__\\ \_______\\ \_______\\ \__\ \__\\ \__\ \__\\ \__\\ _\ \ \_______\\ \__\ \__\\ \_______\\ \_______\    //
//        \|__|     \|__| \|_______| \|_______| \|__|\|__| \|__|\|__| \|__|\|__| \|_______| \|__|\|__| \|_______| \|_______|    //
//      _____          ________   ________       _____                                                                          //
//     / __  \        |\   __  \ |\  _____\     / __  \                                                                         //
//    |\/_|\  \       \ \  \|\  \\ \  \__/     |\/_|\  \                                                                        //
//    \|/ \ \  \       \ \  \\\  \\ \   __\    \|/ \ \  \                                                                       //
//         \ \  \       \ \  \\\  \\ \  \_|         \ \  \                                                                      //
//          \ \__\       \ \_______\\ \__\           \ \__\                                                                     //
//           \|__|        \|_______| \|__|            \|__|                                                                     //
//                                                                                                                              //
//                                                                                                                              //
//                                                                                                                              //
//                                                                                                                              //
//                                                                                                                              //
//                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Mech1of1s is ERC721Creator {
    constructor() ERC721Creator("MechArcade 1 of 1's", "Mech1of1s") {}
}
