
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Test
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////
//                    //
//                    //
//    Hello World.    //
//                    //
//                    //
////////////////////////


contract TSTT is ERC721Creator {
    constructor() ERC721Creator("Test", "TSTT") {}
}
