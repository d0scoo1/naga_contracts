
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Patience And Time
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////
//                                            //
//                                            //
//                                            //
//     ██████╗ ███╗   ███╗██████╗ ██╗  ██╗    //
//    ██╔════╝ ████╗ ████║██╔══██╗██║ ██╔╝    //
//    ██║  ███╗██╔████╔██║██║  ██║█████╔╝     //
//    ██║   ██║██║╚██╔╝██║██║  ██║██╔═██╗     //
//    ╚██████╔╝██║ ╚═╝ ██║██████╔╝██║  ██╗    //
//     ╚═════╝ ╚═╝     ╚═╝╚═════╝ ╚═╝  ╚═╝    //
//                                            //
//                                            //
//                                            //
//                                            //
////////////////////////////////////////////////


contract PAT is ERC721Creator {
    constructor() ERC721Creator("Patience And Time", "PAT") {}
}
