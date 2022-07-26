
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Isles
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////
//                                                     //
//                                                     //
//                                                     //
//      _______ _            _____     _               //
//     |__   __| |          |_   _|   | |              //
//        | |  | |__   ___    | |  ___| | ___  ___     //
//        | |  | '_ \ / _ \   | | / __| |/ _ \/ __|    //
//        | |  | | | |  __/  _| |_\__ \ |  __/\__ \    //
//        |_|  |_| |_|\___| |_____|___/_|\___||___/    //
//                                                     //
//                                                     //
//                                                     //
//                                                     //
//                                                     //
/////////////////////////////////////////////////////////


contract ISLE is ERC721Creator {
    constructor() ERC721Creator("The Isles", "ISLE") {}
}
