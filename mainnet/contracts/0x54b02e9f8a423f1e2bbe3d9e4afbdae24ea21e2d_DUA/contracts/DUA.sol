
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: DuaDAO
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////
//                                                                                   //
//                                                                                   //
//                                                                                   //
//     _____  _    _           _____          ____    ____          ______     __    //
//    |  __ \| |  | |  /\     |  __ \   /\   / __ \  |  _ \   /\   |  _ \ \   / /    //
//    | |  | | |  | | /  \    | |  | | /  \ | |  | | | |_) | /  \  | |_) \ \_/ /     //
//    | |  | | |  | |/ /\ \   | |  | |/ /\ \| |  | | |  _ < / /\ \ |  _ < \   /      //
//    | |__| | |__| / ____ \  | |__| / ____ \ |__| | | |_) / ____ \| |_) | | |       //
//    |_____/ \____/_/    \_\ |_____/_/    \_\____/  |____/_/    \_\____/  |_|       //
//                                                                                   //
//                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////


contract DUA is ERC721Creator {
    constructor() ERC721Creator("DuaDAO", "DUA") {}
}
