
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Luis Dalvan
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//     ___       ___  ___  ___  ________           ________  ________  ___       ___      ___ ________  ________          //
//    |\  \     |\  \|\  \|\  \|\   ____\         |\   ___ \|\   __  \|\  \     |\  \    /  /|\   __  \|\   ___  \        //
//    \ \  \    \ \  \\\  \ \  \ \  \___|_        \ \  \_|\ \ \  \|\  \ \  \    \ \  \  /  / | \  \|\  \ \  \\ \  \       //
//     \ \  \    \ \  \\\  \ \  \ \_____  \        \ \  \ \\ \ \   __  \ \  \    \ \  \/  / / \ \   __  \ \  \\ \  \      //
//      \ \  \____\ \  \\\  \ \  \|____|\  \        \ \  \_\\ \ \  \ \  \ \  \____\ \    / /   \ \  \ \  \ \  \\ \  \     //
//       \ \_______\ \_______\ \__\____\_\  \        \ \_______\ \__\ \__\ \_______\ \__/ /     \ \__\ \__\ \__\\ \__\    //
//        \|_______|\|_______|\|__|\_________\        \|_______|\|__|\|__|\|_______|\|__|/       \|__|\|__|\|__| \|__|    //
//                                \|_________|                                                                            //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LD is ERC721Creator {
    constructor() ERC721Creator("Luis Dalvan", "LD") {}
}
