
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Genesis Collection
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////
//                                                 //
//                                                 //
//                                                 //
//        _/_/_/    _/_/_/    _/_/_/  _/_/_/       //
//       _/    _/    _/    _/          _/          //
//      _/    _/    _/    _/  _/_/    _/           //
//     _/    _/    _/    _/    _/    _/            //
//    _/_/_/    _/_/_/    _/_/_/  _/_/_/           //
//                                                 //
//                                                 //
/////////////////////////////////////////////////////


contract DG is ERC721Creator {
    constructor() ERC721Creator("The Genesis Collection", "DG") {}
}
