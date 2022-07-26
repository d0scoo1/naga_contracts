
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: NY Vignettes
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//                                                                              //
//     _      _         _      _   __    _      ____ _____ _____  ____  __      //
//    | |\ | \ \_/     \ \  / | | / /`_ | |\ | | |_   | |   | |  | |_  ( (`     //
//    |_| \|  |_|       \_\/  |_| \_\_/ |_| \| |_|__  |_|   |_|  |_|__ _)_)     //
//                                                                              //
//                                                                              //
//                                                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////


contract NYV is ERC721Creator {
    constructor() ERC721Creator("NY Vignettes", "NYV") {}
}
