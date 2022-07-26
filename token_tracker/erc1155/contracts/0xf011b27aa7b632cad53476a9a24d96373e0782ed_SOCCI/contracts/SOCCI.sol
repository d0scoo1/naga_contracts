
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: P. Socci Collections
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//     ________   ________   ________    ________   ___  ___   ________         //
//    |\   __  \ |\   __  \ |\   ___  \ |\   ____\ |\  \|\  \ |\   __  \        //
//    \ \  \|\  \\ \  \|\  \\ \  \\ \  \\ \  \___| \ \  \\\  \\ \  \|\  \       //
//     \ \   ____\\ \   __  \\ \  \\ \  \\ \  \     \ \   __  \\ \  \\\  \      //
//      \ \  \___| \ \  \ \  \\ \  \\ \  \\ \  \____ \ \  \ \  \\ \  \\\  \     //
//       \ \__\     \ \__\ \__\\ \__\\ \__\\ \_______\\ \__\ \__\\ \_______\    //
//        \|__|      \|__|\|__| \|__| \|__| \|_______| \|__|\|__| \|_______|    //
//                 ________   ________   ________   ________   ___              //
//                |\   ____\ |\   __  \ |\   ____\ |\   ____\ |\  \             //
//                \ \  \___|_\ \  \|\  \\ \  \___| \ \  \___| \ \  \            //
//                 \ \_____  \\ \  \\\  \\ \  \     \ \  \     \ \  \           //
//                  \|____|\  \\ \  \\\  \\ \  \____ \ \  \____ \ \  \          //
//                    ____\_\  \\ \_______\\ \_______\\ \_______\\ \__\         //
//                   |\_________\\|_______| \|_______| \|_______| \|__|         //
//                   \|_________|                                               //
//                                                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////


contract SOCCI is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
