
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: PERSUE ART DEPLOYER
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████▀            ▀██████████████████████    //
//        ███████████████████ █████████████████████▀    ▄▄██████▄▄    ▀███████████████████    //
//        ██████████████████   ██████████████████    ▄██████████    ▄   ▀█████████████████    //
//        ████████████████      ▀██████████████     ▐█████████▀  █████▄   ████████████████    //
//        █████████████████▄   ██████████████    ███  ███████▌  ████████   ▀██████████████    //
//        ███████████████████ ████████████▀    ██████ ▐██████  ▐█████████   ██████████████    //
//        █████████████████████████████▀    ▄████████  ██████▄ ▐██████████   █████████████    //
//        ██████████████████████████▀     ▄██████████  ███████  ██████████▌  ▐████████████    //
//        ██████████████████████▀       ████████████▌ ▐███████▌  ██████████   ████████████    //
//        ██████████████████▀     ▄▄██▄  ██████████  ▄██████████▄ ▀████████   ████████████    //
//        ████████████████    ▄▄████████▄  ▀▀██▀▀  ▄██████████████▄   ▀▀▀▀    ▓███████████    //
//        ██████████████    ███████████████▄▄▄▄▄▄█████████████████████▄▄▄▄█   ████████████    //
//        █████████████   ▄████████████████████████████████████████████████   ████████████    //
//        ████████████   ███████████▀▀▀   ▀▀▀▀█████████████████████████████   ████████████    //
//        ████████████       ▀▀█▀   ▄▄▄▄▄▄▄        ▀█████████████▀████████▌  ▐████████████    //
//        ████████████   ▄██▄▄   ▄████████             ██████    ▄▄   ▀███   █████████████    //
//        ████████████   ██████  ▐███████  ▌       ███▄  ▀█  ▄███████▄  █   ██████████████    //
//        █████████████   ██████  ▀█████  █       ███████   ███████████    ▐██████████████    //
//        ██████████████   ▀█████   ▀██  ██▌      ████████▄ ▐██████████   ▄███████████████    //
//        ███████████████▄   ███▀  ▄    ████     ▐█████████  █████████   ▄████████████████    //
//        █████████████████      ▄███  ███████▄  ████████▀  ▄███████    ██████████████████    //
//        ███████████████████▄    ▀█▌ ▐████████           ▄███████▀   ▄███████████████████    //
//        █████████████████████▄▄     █████████  ███████▄ ▐████▀    ▄█████████████████████    //
//        ████████████████████████   ▐█████████  ▀███████▄ ▀▀    ▄████████████████████████    //
//        ████████████████████████   ██████████               ▄███████████████████████████    //
//        ████████████████████████   ██████████   ▄█▓▄▄▄▄█████████████████████████████████    //
//        ████████████████████████   ██████████   ████████████████████████████████████████    //
//        ████████████████████████▌  ▐█████████   ████████████████████████████████████████    //
//        █████████████████████████   ▀███████▀  ▐████████████████████████████████████████    //
//        ██████████████████████████▄    ▀▀▀▀   ▄█████████████████████████████████████████    //
//        ████████████████████████████▄       ▄███████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract PERSUE is ERC721Creator {
    constructor() ERC721Creator("PERSUE ART DEPLOYER", "PERSUE") {}
}
