
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: HOMEV_GALLERY
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                 //
//                                                                                                                                 //
//     __    __  ______  __       __ ________ __     __         ______   ______  __       __       ________ _______ __      __     //
//    |  \  |  \/      \|  \     /  |        |  \   |  \       /      \ /      \|  \     |  \     |        |       |  \    /  \    //
//    | $$  | $|  $$$$$$| $$\   /  $| $$$$$$$| $$   | $$      |  $$$$$$|  $$$$$$| $$     | $$     | $$$$$$$| $$$$$$$\$$\  /  $$    //
//    | $$__| $| $$  | $| $$$\ /  $$| $$__   | $$   | $$      | $$ __\$| $$__| $| $$     | $$     | $$__   | $$__| $$\$$\/  $$     //
//    | $$    $| $$  | $| $$$$\  $$$| $$  \   \$$\ /  $$      | $$|    | $$    $| $$     | $$     | $$  \  | $$    $$ \$$  $$      //
//    | $$$$$$$| $$  | $| $$\$$ $$ $| $$$$$    \$$\  $$       | $$ \$$$| $$$$$$$| $$     | $$     | $$$$$  | $$$$$$$\  \$$$$       //
//    | $$  | $| $$__/ $| $$ \$$$| $| $$_____   \$$ $$        | $$__| $| $$  | $| $$_____| $$_____| $$_____| $$  | $$  | $$        //
//    | $$  | $$\$$    $| $$  \$ | $| $$     \   \$$$          \$$    $| $$  | $| $$     | $$     | $$     | $$  | $$  | $$        //
//     \$$   \$$ \$$$$$$ \$$      \$$\$$$$$$$$    \$            \$$$$$$ \$$   \$$\$$$$$$$$\$$$$$$$$\$$$$$$$$\$$   \$$   \$$        //
//                                                                                                                                 //
//                                                                                                                                 //
//                                                                                                                                 //
//                                                                                                                                 //
//                                                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract HMVGLR is ERC721Creator {
    constructor() ERC721Creator("HOMEV_GALLERY", "HMVGLR") {}
}
