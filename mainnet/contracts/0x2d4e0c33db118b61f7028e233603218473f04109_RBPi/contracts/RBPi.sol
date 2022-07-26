
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Orbpods Inception
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////
//                                                                                 //
//                                                                                 //
//              __                   __       __               __     __           //
//             |  \                 |  \     |  \             |  \   |  \          //
//     __    __ \▓▓ ______  __    __ \▓▓ ____| ▓▓    ______  _| ▓▓_  | ▓▓____      //
//    |  \  /  \  \/      \|  \  /  \  \/      ▓▓   /      \|   ▓▓ \ | ▓▓    \     //
//     \▓▓\/  ▓▓ ▓▓  ▓▓▓▓▓▓\\▓▓\/  ▓▓ ▓▓  ▓▓▓▓▓▓▓  |  ▓▓▓▓▓▓\\▓▓▓▓▓▓ | ▓▓▓▓▓▓▓\    //
//      >▓▓  ▓▓| ▓▓ ▓▓  | ▓▓ >▓▓  ▓▓| ▓▓ ▓▓  | ▓▓  | ▓▓    ▓▓ | ▓▓ __| ▓▓  | ▓▓    //
//     /  ▓▓▓▓\| ▓▓ ▓▓__/ ▓▓/  ▓▓▓▓\| ▓▓ ▓▓__| ▓▓__| ▓▓▓▓▓▓▓▓ | ▓▓|  \ ▓▓  | ▓▓    //
//    |  ▓▓ \▓▓\ ▓▓ ▓▓    ▓▓  ▓▓ \▓▓\ ▓▓\▓▓    ▓▓  \\▓▓     \  \▓▓  ▓▓ ▓▓  | ▓▓    //
//     \▓▓   \▓▓\▓▓ ▓▓▓▓▓▓▓ \▓▓   \▓▓\▓▓ \▓▓▓▓▓▓▓\▓▓ \▓▓▓▓▓▓▓   \▓▓▓▓ \▓▓   \▓▓    //
//                | ▓▓                                                             //
//                | ▓▓                                                             //
//                 \▓▓                                                             //
//                                                                                 //
//                                                                                 //
//                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////


contract RBPi is ERC721Creator {
    constructor() ERC721Creator("Orbpods Inception", "RBPi") {}
}
