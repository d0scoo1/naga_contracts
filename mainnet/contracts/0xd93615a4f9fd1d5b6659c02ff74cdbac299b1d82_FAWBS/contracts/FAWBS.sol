
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Fight and Win ft. Busy Signal
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
//                                                                                                                  //
//    ___________.___  ________  ___ ______________    _____    _______  ________     __      __.___ _______        //
//    \_   _____/|   |/  _____/ /   |   \__    ___/   /  _  \   \      \ \______ \   /  \    /  \   |\      \       //
//     |    __)  |   /   \  ___/    ~    \|    |     /  /_\  \  /   |   \ |    |  \  \   \/\/   /   |/   |   \      //
//     |     \   |   \    \_\  \    Y    /|    |    /    |    \/    |    \|    `   \  \        /|   /    |    \     //
//     \___  /   |___|\______  /\___|_  / |____|    \____|__  /\____|__  /_______  /   \__/\  / |___\____|__  /     //
//         \/                \/       \/                    \/         \/        \/         \/              \/      //
//                                                                                                                  //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract FAWBS is ERC721Creator {
    constructor() ERC721Creator("Fight and Win ft. Busy Signal", "FAWBS") {}
}
