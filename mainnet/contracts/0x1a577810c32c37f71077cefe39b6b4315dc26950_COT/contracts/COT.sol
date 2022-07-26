
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: LUCKYCOT
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////
//                                                    //
//                                                    //
//                                                    //
//                                                    //
//     _    _   _  ____ _  ___   ______ ___ _____     //
//    | |  | | | |/ ___| |/ \ \ / / ___/ _ |_   _|    //
//    | |  | | | | |   | ' / \ V | |  | | | || |      //
//    | |__| |_| | |___| . \  | || |__| |_| || |      //
//    |_____\___/ \____|_|\_\ |_| \____\___/ |_|      //
//                                                    //
//                                                    //
//                                                    //
//                                                    //
////////////////////////////////////////////////////////


contract COT is ERC721Creator {
    constructor() ERC721Creator("LUCKYCOT", "COT") {}
}
