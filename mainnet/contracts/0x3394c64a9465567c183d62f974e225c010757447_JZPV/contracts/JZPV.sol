
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Jason Zeenkov Photo Vault
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                 //
//                                                                                                                                                                                                                 //
//         ██  █████  ███████  ██████  ███    ██     ███████ ███████ ███████ ███    ██ ██   ██  ██████  ██    ██     ██████  ██   ██  ██████  ████████  ██████      ██    ██  █████  ██    ██ ██      ████████     //
//         ██ ██   ██ ██      ██    ██ ████   ██        ███  ██      ██      ████   ██ ██  ██  ██    ██ ██    ██     ██   ██ ██   ██ ██    ██    ██    ██    ██     ██    ██ ██   ██ ██    ██ ██         ██        //
//         ██ ███████ ███████ ██    ██ ██ ██  ██       ███   █████   █████   ██ ██  ██ █████   ██    ██ ██    ██     ██████  ███████ ██    ██    ██    ██    ██     ██    ██ ███████ ██    ██ ██         ██        //
//    ██   ██ ██   ██      ██ ██    ██ ██  ██ ██      ███    ██      ██      ██  ██ ██ ██  ██  ██    ██  ██  ██      ██      ██   ██ ██    ██    ██    ██    ██      ██  ██  ██   ██ ██    ██ ██         ██        //
//     █████  ██   ██ ███████  ██████  ██   ████     ███████ ███████ ███████ ██   ████ ██   ██  ██████    ████       ██      ██   ██  ██████     ██     ██████        ████   ██   ██  ██████  ███████    ██        //
//                                                                                                                                                                                                                 //
//                                                                                                                                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract JZPV is ERC721Creator {
    constructor() ERC721Creator("Jason Zeenkov Photo Vault", "JZPV") {}
}
