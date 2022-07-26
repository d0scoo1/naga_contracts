
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Iman Europe
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                           //
//                                                                                                                                                           //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▓▄▄▓▓▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▓▓▓▓▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▓▓▓▓▓▓▓▄▄▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄▄░░▄░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▓▄▄▄▄▄▄▓▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ▄░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░▄▄▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▄▄▄▄▄▄▓▓▓▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░▄▄▄▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▓▓▓▓▄▄▄▄▄▄░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░▄▄▄▄▓▓▓▓▓▓▓▄▄▄▄░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▄▓▓▓▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░▄▄▄▄▓▓▓▓▓▓▓▓▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░▄▄▄▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░ ░  ░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░▄▄▓▓▓▓▓▓▓▓▓▓▄▄▄▄░░░░░           ░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░▄▄▄▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░               ░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░▄▄▄▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░                  ░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░▄▄▄▓▓▓▓▓▓▓▓▓▓▄▄░░░░░                      ░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░▄▄▄▓▓▓▓▓▓▓▓▓▓▄▄░░░░░                       ░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░▄▄▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░                        ░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░▄▄▓▓▓▓▓▓▓▓▓▓▄░░░░░░░                          ░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▓▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░▄▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░                           ░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░▄▄▓▓▓▓▓▓▓▓▓▓▓▄░░░░░                                ░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░▄▄▓▓▓▓▓▓▓▓▓▓▓▄░░░░                                 ░░░▄▄▄▄▄▄░░░▄▄▄▄▄▄▄▄▄▄▓▓▓▓▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░▄▄▓▓▓▓▓▓▓▓▓▓▓▄░░                                 ░░▄▄▄▄▄░░░░░░░░░░░▄▄▄▄▄▄▄▓▓▄▓▓▓▓▓▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░▄▄▓▓▓▓▓▓▓▓▓▓▓▓░                                ░░░▄▄▄▄░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▓▄▓▓▓▓▓▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░▄▄▓▓▓▓▓▓▓▓▓▓▓▓░  ░░░░░░                      ░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░▄▓▓▓▓▓▓▓▓▓▓▓▓▄░▄▄░░░░░░░░░░░░░            ░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░▄▄▓▓▓▓▓▓▓▓▓▓▓▄░░       ░░░░░░░░░         ░░░░░░░░░░░░░▄▄▄▄▄▓▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░▄▄▄▓▓▓▓▓▓▓▓▓▄░░  ░░░░░ ░░░░░░░░░░       ░░░░░░░░░░▄▄▄▄▄▄▄▓▓▓▓▓▄▄▓▓▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░▄▄▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░      ░░░▄▄▄░░░░░▄░  ▄▄▄▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░▄▄▓▓▓▓▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░      ░░▄▄▄░░░░▄░     ▄▄▄▄▄▄▄▄▄▄▄░░░░▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░▄▓▓▓▓▓▓▓▓▓▓▄▄▄▄▓▓▓▓▄▄▄▓▓▓▓▓▓▄▄▄░░░     ░░▄▄▄▄░░░░░    ░░▄▄▄▄▄▄▄▄▄░░░░░░▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░▄▓▓▓▓▓▓▓▓▓▓▓▄▄▄▄▄▓▄░  ▄▄▄▓▄▄▄░         ░░▄▄▄▄▄░░ ░░░░░░░░░░▄▄▄░░░░░░░░░▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░▄▓▓▓▓▓▓▓▓▓▓▄  ░░░▄░   ░▄▄▄▄▄▄░░        ░░▄▄▄▄░░░░  ░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░▄▓▓▓▓▓▓▓▓▓▄    ░░░░░░░░░░░░░░         ░░▄▄▄▄░░░░░░     ░░░░░░░░░░░░░░▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░▄▓▓▓▓▓▓▓▓░      ░░░░░░░░░░          ░░░▄▄▄▄░░░░░░           ░░░░░░░░▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░▄▄▓▓▓▓▓▓▓░                          ░░▄▄▄▄▄▄░░░░░░          ░░░░░░░░▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░▄▄▓▓▓▓▓▓░                         ░░░▄▄▄▄▄▄▄▄░░░░         ░░░░░░░░░▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░▄▄▓▓▓▓▓▓░                         ░░░▄▄▄▄▄▄▄▄▄░░░        ░░░░░░░░░░▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄▄░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░▄▄▓▓▓▓▓▓▄                          ░░▄▄▄▄▄▄▄▄▄▄▄░░      ░░░░░░░░░░░▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░▄▄▄▓▓▓▓▓▄░                ░░░       ░░▄▄▄▄▄░▄▄▄▄▄▄▄░    ░░░░░░░░░░░▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░▄▄▄▓▓▓▓▓░                         ░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄░   ░░░░░░░░░░▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░▄▄▄▄▓▓▓▓▄░                ░░░░░░░░░░▄▄▄▄▓▓▓▄░▄▄▄▄▄▄░  ░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░▄▄▄▓▓▓▓▓▄░              ░░▄▄▄░░░░░░░▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▓▓▓▓▄░               ░░░░       ░░░░▄░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄▄░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▓▓▓▓▓▄░                          ░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▓▓▓▓▓▄░░                        ░░░░░░▄▄▄▄▄▄▄░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▓▓▓▓▓▄░░                     ░░░░░░░░▄▄▄▄▄▄▄▄░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░▄▄▄▓▄▄▓▓▓▓▓▓▄░░░░          ░░░░░░ ░░░░░░░░░░░▄▄▄▄▄▄▄▄░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░▄▄▄▓▓▄▓▓▓▓▓▓▓▄░░░░░░ ░░░  ░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░▄▄▄▄▓▄▄▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░     ░░░░░░░▄▄▄▄▄▄▄▄▄░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░▄░░░░▄▄░░░░░░░░░░░░░▄▄▄▄▄▄▄░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░               ░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░            ░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░▄▄▄▓▓▄▄▄▄▓▄▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░ ░░░░          ░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░▄▄▓▓▓▓▓▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░    ░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░▄▄▄▓▓▓▓▓▓▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░░░    //
//    ▄▄▄░░░░░░▄▄▄▓▓▓▓▓▓▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░           ░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░░    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░           ░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░░    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░         ░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░░    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░   ░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░░    //
//    ▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░░    //
//    ▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄░░░░░    //
//    ▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░▄ ░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░    //
//    ▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄▄▓▓▓▓▓▄▄▄▄▄░░░░░ ░░░          ░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▓▓▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░    //
//    ▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄▄░░░░▄▄░ ░░  ░ ▄░ ░░░░   ░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄░▄▄░▄▄▄▓▓▓▓▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░    //
//    ░▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░░▄░   ░░░▄ ░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄░░▄▄▄▄▄▓▓▓▄▄▄▄▄▄▄▄▄░▓▄▄▓▓▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄    //
//    ░░░▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄░░░░░░░░░▄░       ░░░░░ ░░░░░░░░░░░░░░░░░▄░ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░▄▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ░░░░░▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄▄▓▓▓▓▓▓▓▄▄░░░░░░░░░░░░        ░░░░▄ ░▄░ ░▄ ░▄  ░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ░░░░░░░▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄▄▄▄▄▓▓▓▓▓▄▄▄▄░░░░░░▄▄▄░░            ░░ ░░░░░  ░░░░▄▄▄░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄░▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓    //
//    ░░░░░░░░░▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░▄▄░▄▄░░░      ░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄░▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄    //
//    ░▄░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░▄▄░░▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄    //
//    ░▄▄▄▄▄░░░░░░░▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄    //
//    ░▄▄▄▄▄▄▄░░░░░░░▄▄▄▄▄▄▄▄▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░▄▄░░ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░▄▄▄▄▄▄▄    //
//    ░▄▄▄▄▄▄▄▄▄░░░░░░▄▄▄▄▄▄▄▄▄▄▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░▄░░░░░░▄▄▄░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░▄▄    //
//    ░▄▄▄▄▄▄▄▄▄▄░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░▄░░░ ░  ░▄▄▄▄░░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░▄▄▄▄▄▄▄▄▄▄░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░▄░░░ ░░▄░░░░░▄▄▄░░░░░░░░░░░░░░░░▄▄▄░▄▄░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░    //
//    ░░▄▄▄▄▄▄▄▄▓▄░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░▄▄░░░░░░░ ░▄░░░▄▄▄▄░░░░░░░░░░▄▄▄▄░▄▄▄▄▄░▄▄▄▄▄░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░▄▄▄▄▄▄▄▓▓▄░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░▄▄░░░░░░░ ░░  ░░░▄▄▄▄▄▄▄▄▄░░░▄▄░░▄▄▄░░▄▄░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░    //
//    ░░░▄▄▄▄▄▄▄▄▓▓▄░░ ░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░▄▄░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄░▄▄▄▄▄░░░░▄▄░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░       //
//    ░░░▄▄▄▄▄▄▄▄▄▓▄░░ ░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░▄▄░░░░░░░░░░░░░░░░░░░░░▄▄▄▄░░░░░░░▄▄░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░         //
//    ░░▄▄▄▄▄▄▄▄▄▄▓▓▄░░ ░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░           //
//    ░░▄▄▄▄▄▄▄▄▄▄▄▓▓░░ ░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░▄▄▄░░░░░░░░░░░░░░░░░░░▄▄▄▄░▄░▄▄▄░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░              //
//    ░░▄▄▄▄▄▄▄▄▄▄▄▓▓▄░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░▄▄░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░                //
//    ░▄▄▄▄▄▄▄▄▄▄▄▄▓▓▄░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░ ▄▄░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░                   //
//    ░▄▄▄▄▄▄▄▄▄▄▄▄▓▓▄░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░▄▄░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░                      //
//    ░▄▄▄▄▄▄▄▄▄▄▄▄▓▓▄░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░▄▄▄░░▄▄▄▄░░░▄░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░                        //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░  ░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░                           //
//    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▄░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄                                                                                                   //
//                                                                                                                                                           //
//                                                                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract IMAN is ERC721Creator {
    constructor() ERC721Creator("Iman Europe", "IMAN") {}
}
