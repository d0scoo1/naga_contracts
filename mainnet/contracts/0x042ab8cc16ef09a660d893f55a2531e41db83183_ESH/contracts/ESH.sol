
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Evgeny Shelkovoy
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//                                                                                //
//      ____|   ___|   |   |  ____|  |      |  /   _ \ \ \     /  _ \ \ \   /     //
//      __|   \___ \   |   |  __|    |      ' /   |   | \ \   /  |   | \   /      //
//      |           |  ___ |  |      |      . \   |   |  \ \ /   |   |    |       //
//     _____| _____/  _|  _| _____| _____| _|\_\ \___/    \_/   \___/    _|       //
//                                                                                //
//                                                                                //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////


contract ESH is ERC721Creator {
    constructor() ERC721Creator("Evgeny Shelkovoy", "ESH") {}
}
