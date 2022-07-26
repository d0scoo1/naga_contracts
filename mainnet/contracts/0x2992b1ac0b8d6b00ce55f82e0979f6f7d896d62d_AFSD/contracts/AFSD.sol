
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Alt Fashion Derivatives
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////
//                                                    //
//                                                    //
//     _                     _       _          _     //
//    | |__   ___  _   _  __| | __ _| | ___   _(_)    //
//    | '_ \ / _ \| | | |/ _` |/ _` | |/ / | | | |    //
//    | | | | (_) | |_| | (_| | (_| |   <| |_| | |    //
//    |_| |_|\___/ \__,_|\__,_|\__,_|_|\_\\__, |_|    //
//                                        |___/       //
//                                                    //
//                                                    //
////////////////////////////////////////////////////////


contract AFSD is ERC721Creator {
    constructor() ERC721Creator("Alt Fashion Derivatives", "AFSD") {}
}
