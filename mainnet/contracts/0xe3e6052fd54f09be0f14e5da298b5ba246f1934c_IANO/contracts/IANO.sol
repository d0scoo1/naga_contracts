
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: EDITIONS by Bogdan Ianosi
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//                                                                             //
//                     ___ ___ ___ _____ ___ ___  _  _ ___                     //
//                    | __|   \_ _|_   _|_ _/ _ \| \| / __|                    //
//                    | _|| |) | |  | |  | | (_) | .` \__ \                    //
//      _           __|___|___/___| |_| |___\___/|_|\_|___/              _     //
//     | |__ _  _  | _ ) ___  __ _ __| |__ _ _ _   |_ _|__ _ _ _  ___ __(_)    //
//     | '_ \ || | | _ \/ _ \/ _` / _` / _` | ' \   | |/ _` | ' \/ _ (_-< |    //
//     |_.__/\_, | |___/\___/\__, \__,_\__,_|_||_| |___\__,_|_||_\___/__/_|    //
//           |__/            |___/                                             //
//                                                                             //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract IANO is ERC721Creator {
    constructor() ERC721Creator("EDITIONS by Bogdan Ianosi", "IANO") {}
}
