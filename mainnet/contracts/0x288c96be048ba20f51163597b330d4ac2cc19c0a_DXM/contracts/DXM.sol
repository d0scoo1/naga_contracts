
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ｡○♡.｡･ﾟﾟ ☆ﾟ.*･
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////
//                                                       //
//                                                       //
//                                                       //
//    ▄▀▀█▄▄   ▄▀▀█▄▄▄▄  ▄▀▀▄ ▀▄  ▄▀▀▄ ▄▀▀▄              //
//    █ ▄▀   █ ▐  ▄▀   ▐ █  █ █ █ █   █    █             //
//    ▐ █    █   █▄▄▄▄▄  ▐  █  ▀█ ▐  █    █              //
//      █    █   █    ▌    █   █    █    █               //
//     ▄▀▄▄▄▄▀  ▄▀▄▄▄▄   ▄▀   █      ▀▄▄▄▄▀              //
//    █     ▐   █    ▐   █    ▐                          //
//    ▐         ▐        ▐                               //
//     ▄▀▀▄  ▄▀▄      ▄▀▀▄ ▄▀▄  ▄▀▀▄▀▀▀▄  ▄▀▀▀▀▄         //
//    █    █   █     █  █ ▀  █ █   █   █ █    █          //
//    ▐     ▀▄▀      ▐  █    █ ▐  █▀▀▀▀  ▐    █          //
//         ▄▀ █        █    █     █          █           //
//        █  ▄▀      ▄▀   ▄▀    ▄▀         ▄▀▄▄▄▄▄▄▀     //
//      ▄▀  ▄▀       █    █    █           █             //
//     █    ▐        ▐    ▐    ▐           ▐             //
//                                                       //
//                                                       //
//                                                       //
//    ˚ ༘♡ ⋆｡˚˚ੈ✩‧₊˚ˏˋ°•*⁀➷                              //
//                                                       //
//    Denu's contract for Metaprideland                  //
//                                                       //
//                                                       //
//    ˚ ༘♡ ⋆｡˚˚ੈ✩‧₊˚ˏˋ°•*⁀➷                              //
//                                                       //
//                                                       //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░██░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░███░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░█░░██░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░█░░░██░░░░░░░░░░░░░░░░███░░░           //
//    ░░░░░░░░░░░░█░░░░░█░░░░░░░██████████░░░░           //
//    ░░░░░░░░░░░░█░░░░░░████████░░░░░███░░░░░           //
//    ░░░░░░░░░░░░█░░░░░░░█░░░░░░░░░███░░░░░░░           //
//    ░░░░░░░░░░░░█░░░░░░░░░░░░░░░██░░░░░░░░░░           //
//    ░░░░░░░░█████░░░░░░░░░░░████░░░░░░░░░░░░           //
//    ░░░░░░███░░░░░░░░░░░░░░░██░░░░░░░░░░░░░░           //
//    ░░░███░░░░░░░░░░░░░░░░░░░██░░░░░░░░░░░░░           //
//    ░███░░░░░░░░░░░░░░░░░░░░░░██░░░░░░░░░░░░           //
//    ░███████████░░░░██░░░░░░░░░███░░░░░░░░░░           //
//    ░░░░░░░░░░░█░░░░███████░░░░░░██░░░░░░░░░           //
//    ░░░░░░░░░░░█░░░░█░░░░░████░░░░░██░░░░░░░           //
//    ░░░░░░░░░░░█░░░░█░░░░░░░░░█████████░░░░░           //
//    ░░░░░░░░░░░█░░░█░░░░░░░░░░░░░░░░░██░░░░░           //
//    ░░░░░░░░░░░█░░█░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░█░██░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░███░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░█░░░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░           //
//                                                       //
//                                                       //
///////////////////////////////////////////////////////////


contract DXM is ERC721Creator {
    constructor() ERC721Creator(unicode"｡○♡.｡･ﾟﾟ ☆ﾟ.*･", "DXM") {}
}
