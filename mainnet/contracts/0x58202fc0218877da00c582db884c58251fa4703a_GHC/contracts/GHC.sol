
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: GHCHAPMAN
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//                                                                                      //
//                                                                                      //
//                                                                                      //
//     ██████  ██   ██  ██████ ██   ██  █████  ██████  ███    ███  █████  ███    ██     //
//    ██       ██   ██ ██      ██   ██ ██   ██ ██   ██ ████  ████ ██   ██ ████   ██     //
//    ██   ███ ███████ ██      ███████ ███████ ██████  ██ ████ ██ ███████ ██ ██  ██     //
//    ██    ██ ██   ██ ██      ██   ██ ██   ██ ██      ██  ██  ██ ██   ██ ██  ██ ██     //
//     ██████  ██   ██  ██████ ██   ██ ██   ██ ██      ██      ██ ██   ██ ██   ████     //
//                                                                                      //
//                                                                                      //
//                                                                                      //
//                                                                                      //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////


contract GHC is ERC721Creator {
    constructor() ERC721Creator("GHCHAPMAN", "GHC") {}
}
