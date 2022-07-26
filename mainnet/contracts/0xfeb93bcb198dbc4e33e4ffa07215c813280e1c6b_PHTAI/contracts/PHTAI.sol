
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: PHOTO IN ART AI
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//     ██▓███   ██░ ██  ▒█████  ▄▄▄█████▓ ▒█████      ██▓ ███▄    █     ▄▄▄       ██▀███  ▄▄▄█████▓    ▄▄▄       ██▓    //
//    ▓██░  ██▒▓██░ ██▒▒██▒  ██▒▓  ██▒ ▓▒▒██▒  ██▒   ▓██▒ ██ ▀█   █    ▒████▄    ▓██ ▒ ██▒▓  ██▒ ▓▒   ▒████▄    ▓██▒    //
//    ▓██░ ██▓▒▒██▀▀██░▒██░  ██▒▒ ▓██░ ▒░▒██░  ██▒   ▒██▒▓██  ▀█ ██▒   ▒██  ▀█▄  ▓██ ░▄█ ▒▒ ▓██░ ▒░   ▒██  ▀█▄  ▒██▒    //
//    ▒██▄█▓▒ ▒░▓█ ░██ ▒██   ██░░ ▓██▓ ░ ▒██   ██░   ░██░▓██▒  ▐▌██▒   ░██▄▄▄▄██ ▒██▀▀█▄  ░ ▓██▓ ░    ░██▄▄▄▄██ ░██░    //
//    ▒██▒ ░  ░░▓█▒░██▓░ ████▓▒░  ▒██▒ ░ ░ ████▓▒░   ░██░▒██░   ▓██░    ▓█   ▓██▒░██▓ ▒██▒  ▒██▒ ░     ▓█   ▓██▒░██░    //
//    ▒▓▒░ ░  ░ ▒ ░░▒░▒░ ▒░▒░▒░   ▒ ░░   ░ ▒░▒░▒░    ░▓  ░ ▒░   ▒ ▒     ▒▒   ▓▒█░░ ▒▓ ░▒▓░  ▒ ░░       ▒▒   ▓▒█░░▓      //
//    ░▒ ░      ▒ ░▒░ ░  ░ ▒ ▒░     ░      ░ ▒ ▒░     ▒ ░░ ░░   ░ ▒░     ▒   ▒▒ ░  ░▒ ░ ▒░    ░         ▒   ▒▒ ░ ▒ ░    //
//    ░░        ░  ░░ ░░ ░ ░ ▒    ░      ░ ░ ░ ▒      ▒ ░   ░   ░ ░      ░   ▒     ░░   ░   ░           ░   ▒    ▒ ░    //
//              ░  ░  ░    ░ ░               ░ ░      ░           ░          ░  ░   ░                       ░  ░ ░      //
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract PHTAI is ERC721Creator {
    constructor() ERC721Creator("PHOTO IN ART AI", "PHTAI") {}
}
