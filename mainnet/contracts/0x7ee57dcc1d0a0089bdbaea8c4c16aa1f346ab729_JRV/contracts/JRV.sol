
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Jarvinart
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//          ██╗  █████╗  ██████╗  ██╗   ██╗ ██╗ ███╗   ██╗  █████╗  ██████╗  ████████╗    //
//          ██║ ██╔══██╗ ██╔══██╗ ██║   ██║ ██║ ████╗  ██║ ██╔══██╗ ██╔══██╗ ╚══██╔══╝    //
//          ██║ ███████║ ██████╔╝ ██║   ██║ ██║ ██╔██╗ ██║ ███████║ ██████╔╝    ██║       //
//     ██   ██║ ██╔══██║ ██╔══██╗ ╚██╗ ██╔╝ ██║ ██║╚██╗██║ ██╔══██║ ██╔══██╗    ██║       //
//     ╚█████╔╝ ██║  ██║ ██║  ██║  ╚████╔╝  ██║ ██║ ╚████║ ██║  ██║ ██║  ██║    ██║       //
//      ╚════╝  ╚═╝  ╚═╝ ╚═╝  ╚═╝   ╚═══╝   ╚═╝ ╚═╝  ╚═══╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝    ╚═╝       //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract JRV is ERC721Creator {
    constructor() ERC721Creator("Jarvinart", "JRV") {}
}
