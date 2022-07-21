
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: HPPYJellyfish
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////
//                      //
//                      //
//    HPPY Jellyfish    //
//                      //
//                      //
//////////////////////////


contract HJF is ERC721Creator {
    constructor() ERC721Creator("HPPYJellyfish", "HJF") {}
}
