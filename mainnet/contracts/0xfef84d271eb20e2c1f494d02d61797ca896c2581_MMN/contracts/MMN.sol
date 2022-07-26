
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Matthias Meissen
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//     __   __  _______  _______  _______  __   __  ___   _______  _______     //
//    |  |_|  ||   _   ||       ||       ||  | |  ||   | |   _   ||       |    //
//    |       ||  |_|  ||_     _||_     _||  |_|  ||   | |  |_|  ||  _____|    //
//    |       ||       |  |   |    |   |  |       ||   | |       || |_____     //
//    |       ||       |  |   |    |   |  |       ||   | |       ||_____  |    //
//    | ||_|| ||   _   |  |   |    |   |  |   _   ||   | |   _   | _____| |    //
//    |_|   |_||__| |__|  |___|    |___|  |__| |__||___| |__| |__||_______|    //
//         __   __  _______  ___   _______  _______  _______  __    _          //
//        |  |_|  ||       ||   | |       ||       ||       ||  |  | |         //
//        |       ||    ___||   | |  _____||  _____||    ___||   |_| |         //
//        |       ||   |___ |   | | |_____ | |_____ |   |___ |       |         //
//        |       ||    ___||   | |_____  ||_____  ||    ___||  _    |         //
//        | ||_|| ||   |___ |   |  _____| | _____| ||   |___ | | |   |         //
//        |_|   |_||_______||___| |_______||_______||_______||_|  |__|         //
//                                                                             //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract MMN is ERC721Creator {
    constructor() ERC721Creator("Matthias Meissen", "MMN") {}
}
