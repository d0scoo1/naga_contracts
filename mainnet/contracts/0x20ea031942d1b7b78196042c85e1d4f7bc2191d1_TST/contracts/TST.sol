
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Space Times
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//                                                                             //
//    ████████ ██   ██ ███████     ███████ ██████   █████   ██████ ███████     //
//       ██    ██   ██ ██          ██      ██   ██ ██   ██ ██      ██          //
//       ██    ███████ █████       ███████ ██████  ███████ ██      █████       //
//       ██    ██   ██ ██               ██ ██      ██   ██ ██      ██          //
//       ██    ██   ██ ███████     ███████ ██      ██   ██  ██████ ███████     //
//                                                                             //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract TST is ERC721Creator {
    constructor() ERC721Creator("The Space Times", "TST") {}
}
