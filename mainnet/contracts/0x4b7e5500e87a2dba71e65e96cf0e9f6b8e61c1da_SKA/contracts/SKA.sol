
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Sean Keeton Art
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//                                                                                       //
//                                ▄▄▄▄▀▀▀▀▀▀▀▀▀▀▀▄▄▄▄                                    //
//                           ▄▄█▀▀                   ▀▀█▄▄                               //
//                        ▄█▀  ▄▄▄▄               ▄▄▄▄▄   ▀█▄                            //
//                     ▄█▀  ▄▀▀    █▄           ▄▀     ▀▀▄▄  ▀▄                          //
//                   ▄█▀  █▀    ▄▄███           █▄███▄▄    █▄  █▄                        //
//                  █▀  █▀    ▄██████           ▐███████▄    █  ▀█                       //
//                 █   █    ▄███████             ▀████████    █   █                      //
//                █   █    ▄███████▌              █████████    █  ▐█                     //
//               ▐▌   █    ████████                █████████   █   █                     //
//               █    █    ████████       █        ▐████████   ▐▌  █                     //
//               █▌   ▐▄   ███████▌      ██▌        ████████   █   █                     //
//               ▐█    ▀▄   ██████▌     ▐███        ▐███████  █▀  ▐█                     //
//                █▄     █▄  ▀████      ████▌        ▀████▀ ▄█    █                      //
//                 ▀█      ▀▀▀▀▀▀       █   █          ▀▀▀▀▀    ▄█                       //
//                   ▀▀▄▄                                   ▄▄█▀                         //
//                       ▀▀▀▀██  ▄   █     █    █   ▄  ██▀▀▀▀                            //
//       ▄████████▀▀▀▀▀▀▀▀█████▄██  ▄█▌   ██    █▄  ██▄█████████████▀▀▄▄                 //
//     ▄█████████        ██████████████ ▄████▄ ███████████████████▀     ▀▀▀▄▄            //
//    ▐█████████        ▐████████████████████████████████████████            ▀██▄▄       //
//    ██████████        ████████████████████████████████████████             ███████▄    //
//    ██████████        ████████████████████████████████████████             ██████▀     //
//    ▐█████████▄       ▐████████████████████████████████████████            ▄█▀▀        //
//     ▐█████████▄       ▀██████████ ▀██ ▀██▀ ▐██▀ ███████████████▄     ▄▄▄▀▀            //
//       ▀████████▄▄▄▄▄▄▄▄▄███████▀                ▀▀███████████████▄▄▀▀                 //
//                              ▄▀                   ▀▄                                  //
//                             ▐▌     ▄▄▄▀▀▀▀▀▄▄▄      █                                 //
//                              ▀▄▄▄▄▀           ▀▄▄▄▄▀                                  //
//                                                                                       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


contract SKA is ERC721Creator {
    constructor() ERC721Creator("Sean Keeton Art", "SKA") {}
}
