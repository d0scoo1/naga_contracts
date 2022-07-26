
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: newblock
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//     /$$   /$$                               /$$$$$$$  /$$                     /$$          //
//    | $$$ | $$                              | $$__  $$| $$                    | $$          //
//    | $$$$| $$  /$$$$$$  /$$  /$$  /$$      | $$  \ $$| $$  /$$$$$$   /$$$$$$$| $$   /$$    //
//    | $$ $$ $$ /$$__  $$| $$ | $$ | $$      | $$$$$$$ | $$ /$$__  $$ /$$_____/| $$  /$$/    //
//    | $$  $$$$| $$$$$$$$| $$ | $$ | $$      | $$__  $$| $$| $$  \ $$| $$      | $$$$$$/     //
//    | $$\  $$$| $$_____/| $$ | $$ | $$      | $$  \ $$| $$| $$  | $$| $$      | $$_  $$     //
//    | $$ \  $$|  $$$$$$$|  $$$$$/$$$$/      | $$$$$$$/| $$|  $$$$$$/|  $$$$$$$| $$ \  $$    //
//    |__/  \__/ \_______/ \_____/\___/       |_______/ |__/ \______/  \_______/|__/  \__/    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract NB is ERC721Creator {
    constructor() ERC721Creator("newblock", "NB") {}
}
