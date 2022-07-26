
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Zuphioh
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////
//                                                             //
//                                                             //
//                                                             //
//    ███████╗██╗   ██╗██████╗ ██╗  ██╗██╗ ██████╗ ██╗  ██╗    //
//    ╚══███╔╝██║   ██║██╔══██╗██║  ██║██║██╔═══██╗██║  ██║    //
//      ███╔╝ ██║   ██║██████╔╝███████║██║██║   ██║███████║    //
//     ███╔╝  ██║   ██║██╔═══╝ ██╔══██║██║██║   ██║██╔══██║    //
//    ███████╗╚██████╔╝██║     ██║  ██║██║╚██████╔╝██║  ██║    //
//    ╚══════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝    //
//                                                             //
//                                                             //
//                                                             //
//                                                             //
/////////////////////////////////////////////////////////////////


contract ZEBRA is ERC721Creator {
    constructor() ERC721Creator("Zuphioh", "ZEBRA") {}
}
