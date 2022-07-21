
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: gramajo
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////
//                                                  //
//                                                  //
//                                      _           //
//      __ _ _ __ __ _ _ __ ___   __ _ (_) ___      //
//     / _` | '__/ _` | '_ ` _ \ / _` || |/ _ \     //
//    | (_| | | | (_| | | | | | | (_| || | (_) |    //
//     \__, |_|  \__,_|_| |_| |_|\__,_|/ |\___/     //
//     |___/                         |__/           //
//                                                  //
//                                                  //
//                                                  //
//////////////////////////////////////////////////////


contract gram is ERC721Creator {
    constructor() ERC721Creator("gramajo", "gram") {}
}
