
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Lab
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////
//                                                                       //
//                                                                       //
//                                                                       //
//     ▄▀▀▀█▀▀▄  ▄▀▀▄ ▄▄   ▄▀▀█▄▄▄▄      ▄▀▀▀▀▄      ▄▀▀█▄   ▄▀▀█▄▄      //
//    █    █  ▐ █  █   ▄▀ ▐  ▄▀   ▐     █    █      ▐ ▄▀ ▀▄ ▐ ▄▀   █     //
//    ▐   █     ▐  █▄▄▄█    █▄▄▄▄▄      ▐    █        █▄▄▄█   █▄▄▄▀      //
//       █         █   █    █    ▌          █        ▄▀   █   █   █      //
//     ▄▀         ▄▀  ▄▀   ▄▀▄▄▄▄         ▄▀▄▄▄▄▄▄▀ █   ▄▀   ▄▀▄▄▄▀      //
//    █          █   █     █    ▐         █         ▐   ▐   █    ▐       //
//    ▐          ▐   ▐     ▐              ▐                 ▐            //
//                                                                       //
//                                                                       //
//                                                                       //
///////////////////////////////////////////////////////////////////////////


contract liFe is ERC721Creator {
    constructor() ERC721Creator("The Lab", "liFe") {}
}
