
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: dYdX Ambassador
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
//    ██████╗ ██╗   ██╗██████╗ ██╗  ██╗    ███████╗ ██████╗ ██╗   ██╗███╗   ██╗██████╗  █████╗ ████████╗██╗ ██████╗ ███╗   ██╗    //
//    ██╔══██╗╚██╗ ██╔╝██╔══██╗╚██╗██╔╝    ██╔════╝██╔═══██╗██║   ██║████╗  ██║██╔══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║    //
//    ██║  ██║ ╚████╔╝ ██║  ██║ ╚███╔╝     █████╗  ██║   ██║██║   ██║██╔██╗ ██║██║  ██║███████║   ██║   ██║██║   ██║██╔██╗ ██║    //
//    ██║  ██║  ╚██╔╝  ██║  ██║ ██╔██╗     ██╔══╝  ██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══██║   ██║   ██║██║   ██║██║╚██╗██║    //
//    ██████╔╝   ██║   ██████╔╝██╔╝ ██╗    ██║     ╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║    //
//    ╚═════╝    ╚═╝   ╚═════╝ ╚═╝  ╚═╝    ╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract AMB is ERC721Creator {
    constructor() ERC721Creator("dYdX Ambassador", "AMB") {}
}
