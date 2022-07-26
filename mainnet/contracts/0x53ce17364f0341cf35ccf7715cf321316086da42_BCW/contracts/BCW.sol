
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: BlockChainWedding.io
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
//                                                                               //
//    ██████  ██       ██████   ██████ ██   ██                                   //
//    ██   ██ ██      ██    ██ ██      ██  ██                                    //
//    ██████  ██      ██    ██ ██      █████                                     //
//    ██   ██ ██      ██    ██ ██      ██  ██                                    //
//    ██████  ███████  ██████   ██████ ██   ██                                   //
//                                                                               //
//                                                                               //
//     ██████ ██   ██  █████  ██ ███    ██                                       //
//    ██      ██   ██ ██   ██ ██ ████   ██                                       //
//    ██      ███████ ███████ ██ ██ ██  ██                                       //
//    ██      ██   ██ ██   ██ ██ ██  ██ ██                                       //
//     ██████ ██   ██ ██   ██ ██ ██   ████                                       //
//                                                                               //
//                                                                               //
//    ██     ██ ███████ ██████  ██████  ██ ███    ██  ██████     ██  ██████      //
//    ██     ██ ██      ██   ██ ██   ██ ██ ████   ██ ██          ██ ██    ██     //
//    ██  █  ██ █████   ██   ██ ██   ██ ██ ██ ██  ██ ██   ███    ██ ██    ██     //
//    ██ ███ ██ ██      ██   ██ ██   ██ ██ ██  ██ ██ ██    ██    ██ ██    ██     //
//     ███ ███  ███████ ██████  ██████  ██ ██   ████  ██████  ██ ██  ██████      //
//                                                                               //
//                                                                               //
//                                                                               //
//                                                                               //
//                                                                               //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////


contract BCW is ERC721Creator {
    constructor() ERC721Creator("BlockChainWedding.io", "BCW") {}
}
