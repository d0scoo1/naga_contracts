
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Foja Icons
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////
//                                                    //
//                                                    //
//     ________ ________        ___  ________         //
//    |\  _____\\   __  \      |\  \|\   __  \        //
//    \ \  \__/\ \  \|\  \     \ \  \ \  \|\  \       //
//     \ \   __\\ \  \\\  \  __ \ \  \ \   __  \      //
//      \ \  \_| \ \  \\\  \|\  \\_\  \ \  \ \  \     //
//       \ \__\   \ \_______\ \________\ \__\ \__\    //
//        \|__|    \|_______|\|________|\|__|\|__|    //
//                                                    //
//                                                    //
//                                                    //
//                                                    //
//                                                    //
//                                                    //
////////////////////////////////////////////////////////


contract fojaicons is ERC721Creator {
    constructor() ERC721Creator("Foja Icons", "fojaicons") {}
}
