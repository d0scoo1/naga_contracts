
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Unusual Conditions
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////
//                                                             //
//                                                             //
//     _     _  _____  _____ ______  _____  __   _             //
//     |_____| |     |   |    ____/ |     | | \  |             //
//     |     | |_____| __|__ /_____ |_____| |  \_|             //
//                                                             //
//                                                             //
//                                                             //
//    (_)   (_)                            | |                 //
//     _     _ ____  _   _  ___ _   _ _____| |                 //
//    | |   | |  _ \| | | |/___) | | (____ | |                 //
//    | |___| | | | | |_| |___ | |_| / ___ | |                 //
//     \_____/|_| |_|____/(___/|____/\_____|\_)                //
//                                                             //
//     _______                _ _       _                      //
//    (_______)              | (_)  _  (_)                     //
//     _       ___  ____   __| |_ _| |_ _  ___  ____   ___     //
//    | |     / _ \|  _ \ / _  | (_   _) |/ _ \|  _ \ /___)    //
//    | |____| |_| | | | ( (_| | | | |_| | |_| | | | |___ |    //
//     \______)___/|_| |_|\____|_|  \__)_|\___/|_| |_(___/     //
//                                                             //
//                                                             //
//                                                             //
/////////////////////////////////////////////////////////////////


contract UNC is ERC721Creator {
    constructor() ERC721Creator("Unusual Conditions", "UNC") {}
}
