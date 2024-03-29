
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Dewed
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                              //
//                                                                                              //
//     _______   ________  __       __  ________  _______      ________  ________  __    __     //
//    /       \ /        |/  |  _  /  |/        |/       \    /        |/        |/  |  /  |    //
//    $$$$$$$  |$$$$$$$$/ $$ | / \ $$ |$$$$$$$$/ $$$$$$$  |   $$$$$$$$/ $$$$$$$$/ $$ |  $$ |    //
//    $$ |  $$ |$$ |__    $$ |/$  \$$ |$$ |__    $$ |  $$ |   $$ |__       $$ |   $$ |__$$ |    //
//    $$ |  $$ |$$    |   $$ /$$$  $$ |$$    |   $$ |  $$ |   $$    |      $$ |   $$    $$ |    //
//    $$ |  $$ |$$$$$/    $$ $$/$$ $$ |$$$$$/    $$ |  $$ |   $$$$$/       $$ |   $$$$$$$$ |    //
//    $$ |__$$ |$$ |_____ $$$$/  $$$$ |$$ |_____ $$ |__$$ |__ $$ |_____    $$ |   $$ |  $$ |    //
//    $$    $$/ $$       |$$$/    $$$ |$$       |$$    $$//  |$$       |   $$ |   $$ |  $$ |    //
//    $$$$$$$/  $$$$$$$$/ $$/      $$/ $$$$$$$$/ $$$$$$$/ $$/ $$$$$$$$/    $$/    $$/   $$/     //
//                                                                                              //
//                                                                                              //
//                                                                                              //
//                                                                                              //
//                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////


contract ETH is ERC721Creator {
    constructor() ERC721Creator("Dewed", "ETH") {}
}
