
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: soul fantasy
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
//                                                                                                                  //
//                                                                                                                  //
//                                   __         ______                      __                                      //
//                                  |  \       /      \                    |  \                                     //
//      _______   ______   __    __ | $$      |  $$$$$$\ ______   _______ _| $$_    ______    _______  __    __     //
//     /       \ /      \ |  \  |  \| $$      | $$_  \$$|      \ |       \   $$ \  |      \  /       \|  \  |  \    //
//    |  $$$$$$$|  $$$$$$\| $$  | $$| $$      | $$ \     \$$$$$$\| $$$$$$$\$$$$$$   \$$$$$$\|  $$$$$$$| $$  | $$    //
//     \$$    \ | $$  | $$| $$  | $$| $$      | $$$$    /      $$| $$  | $$| $$ __ /      $$ \$$    \ | $$  | $$    //
//     _\$$$$$$\| $$__/ $$| $$__/ $$| $$      | $$     |  $$$$$$$| $$  | $$| $$|  \  $$$$$$$ _\$$$$$$\| $$__/ $$    //
//    |       $$ \$$    $$ \$$    $$| $$      | $$      \$$    $$| $$  | $$ \$$  $$\$$    $$|       $$ \$$    $$    //
//     \$$$$$$$   \$$$$$$   \$$$$$$  \$$       \$$       \$$$$$$$ \$$   \$$  \$$$$  \$$$$$$$ \$$$$$$$  _\$$$$$$$    //
//                                                                                                    |  \__| $$    //
//                                   __         ______                      __                         \$$    $$    //
//                                  |  \       /      \                    |  \                         \$$$$$$     //
//      _______   ______   __    __ | $$      |  $$$$$$\ ______   _______ _| $$_    ______    _______  __    __     //
//     /       \ /      \ |  \  |  \| $$      | $$_  \$$|      \ |       \   $$ \  |      \  /       \|  \  |  \    //
//    |  $$$$$$$|  $$$$$$\| $$  | $$| $$      | $$ \     \$$$$$$\| $$$$$$$\$$$$$$   \$$$$$$\|  $$$$$$$| $$  | $$    //
//     \$$    \ | $$  | $$| $$  | $$| $$      | $$$$    /      $$| $$  | $$| $$ __ /      $$ \$$    \ | $$  | $$    //
//     _\$$$$$$\| $$__/ $$| $$__/ $$| $$      | $$     |  $$$$$$$| $$  | $$| $$|  \  $$$$$$$ _\$$$$$$\| $$__/ $$    //
//    |       $$ \$$    $$ \$$    $$| $$      | $$      \$$    $$| $$  | $$ \$$  $$\$$    $$|       $$ \$$    $$    //
//     \$$$$$$$   \$$$$$$   \$$$$$$  \$$       \$$       \$$$$$$$ \$$   \$$  \$$$$  \$$$$$$$ \$$$$$$$  _\$$$$$$$    //
//                                                                                                    |  \__| $$    //
//                                   __         ______                      __                         \$$    $$    //
//                                  |  \       /      \                    |  \                         \$$$$$$     //
//      _______   ______   __    __ | $$      |  $$$$$$\ ______   _______ _| $$_    ______    _______  __    __     //
//     /       \ /      \ |  \  |  \| $$      | $$_  \$$|      \ |       \   $$ \  |      \  /       \|  \  |  \    //
//    |  $$$$$$$|  $$$$$$\| $$  | $$| $$      | $$ \     \$$$$$$\| $$$$$$$\$$$$$$   \$$$$$$\|  $$$$$$$| $$  | $$    //
//     \$$    \ | $$  | $$| $$  | $$| $$      | $$$$    /      $$| $$  | $$| $$ __ /      $$ \$$    \ | $$  | $$    //
//     _\$$$$$$\| $$__/ $$| $$__/ $$| $$      | $$     |  $$$$$$$| $$  | $$| $$|  \  $$$$$$$ _\$$$$$$\| $$__/ $$    //
//    |       $$ \$$    $$ \$$    $$| $$      | $$      \$$    $$| $$  | $$ \$$  $$\$$    $$|       $$ \$$    $$    //
//     \$$$$$$$   \$$$$$$   \$$$$$$  \$$       \$$       \$$$$$$$ \$$   \$$  \$$$$  \$$$$$$$ \$$$$$$$  _\$$$$$$$    //
//                                                                                                    |  \__| $$    //
//                                   __         ______                      __                         \$$    $$    //
//                                  |  \       /      \                    |  \                         \$$$$$$     //
//      _______   ______   __    __ | $$      |  $$$$$$\ ______   _______ _| $$_    ______    _______  __    __     //
//     /       \ /      \ |  \  |  \| $$      | $$_  \$$|      \ |       \   $$ \  |      \  /       \|  \  |  \    //
//    |  $$$$$$$|  $$$$$$\| $$  | $$| $$      | $$ \     \$$$$$$\| $$$$$$$\$$$$$$   \$$$$$$\|  $$$$$$$| $$  | $$    //
//     \$$    \ | $$  | $$| $$  | $$| $$      | $$$$    /      $$| $$  | $$| $$ __ /      $$ \$$    \ | $$  | $$    //
//     _\$$$$$$\| $$__/ $$| $$__/ $$| $$      | $$     |  $$$$$$$| $$  | $$| $$|  \  $$$$$$$ _\$$$$$$\| $$__/ $$    //
//    |       $$ \$$    $$ \$$    $$| $$      | $$      \$$    $$| $$  | $$ \$$  $$\$$    $$|       $$ \$$    $$    //
//     \$$$$$$$   \$$$$$$   \$$$$$$  \$$       \$$       \$$$$$$$ \$$   \$$  \$$$$  \$$$$$$$ \$$$$$$$  _\$$$$$$$    //
//                                                                                                    |  \__| $$    //
//                                                                                                     \$$    $$    //
//                                                                                                      \$$$$$$     //
//                                                                                                                  //
//                                                                                                                  //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract sfy is ERC721Creator {
    constructor() ERC721Creator("soul fantasy", "sfy") {}
}
