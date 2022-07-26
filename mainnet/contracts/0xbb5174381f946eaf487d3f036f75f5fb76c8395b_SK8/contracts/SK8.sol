
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Skate Bored
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                                                                    //
//       _____ __         __          ____                      __    //
//      / ___// /______ _/ /____     / __ )____  ________  ____/ /    //
//      \__ \/ //_/ __ `/ __/ _ \   / __  / __ \/ ___/ _ \/ __  /     //
//     ___/ / ,< / /_/ / /_/  __/  / /_/ / /_/ / /  /  __/ /_/ /      //
//    /____/_/|_|\__,_/\__/\___/  /_____/\____/_/   \___/\__,_/       //
//                                                                    //
//                                                                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////


contract SK8 is ERC721Creator {
    constructor() ERC721Creator("Skate Bored", "SK8") {}
}
