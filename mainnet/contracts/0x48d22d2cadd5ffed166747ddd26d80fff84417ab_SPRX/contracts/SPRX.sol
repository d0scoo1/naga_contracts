
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Spores & CRX
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//      ___________________________ _____________________ _________    ______________  ___    //
//     /   _____/\______   \_____  \\______   \_   _____//   _____/    \______   \   \/  /    //
//     \_____  \  |     ___//   |   \|       _/|    __)_ \_____  \      |       _/\     /     //
//     /        \ |    |   /    |    \    |   \|        \/        \     |    |   \/     \     //
//    /_______  / |____|   \_______  /____|_  /_______  /_______  /     |____|_  /___/\  \    //
//            \/                   \/       \/        \/        \/             \/      \_/    //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract SPRX is ERC721Creator {
    constructor() ERC721Creator("Spores & CRX", "SPRX") {}
}
