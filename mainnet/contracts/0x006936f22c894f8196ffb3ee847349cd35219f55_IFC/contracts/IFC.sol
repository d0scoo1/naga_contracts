
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Immortals Futbol Club
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////
//                            //
//                            //
//     ██▓  █████▒▄████▄      //
//    ▓██▒▓██   ▒▒██▀ ▀█      //
//    ▒██▒▒████ ░▒▓█    ▄     //
//    ░██░░▓█▒  ░▒▓▓▄ ▄██▒    //
//    ░██░░▒█░   ▒ ▓███▀ ░    //
//    ░▓   ▒ ░   ░ ░▒ ▒  ░    //
//     ▒ ░ ░       ░  ▒       //
//     ▒ ░ ░ ░   ░            //
//     ░         ░ ░          //
//               ░            //
//                            //
//                            //
////////////////////////////////


contract IFC is ERC721Creator {
    constructor() ERC721Creator("Immortals Futbol Club", "IFC") {}
}
