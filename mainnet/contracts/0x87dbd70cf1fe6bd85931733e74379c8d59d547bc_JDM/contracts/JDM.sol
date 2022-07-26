
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Night Runners
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                     //
//                                                                                                                                                                                     //
//          ___                       ___           ___                                ___           ___           ___           ___           ___           ___           ___         //
//         /__/\        ___          /  /\         /__/\          ___                 /  /\         /__/\         /__/\         /__/\         /  /\         /  /\         /  /\        //
//         \  \:\      /  /\        /  /:/_        \  \:\        /  /\               /  /::\        \  \:\        \  \:\        \  \:\       /  /:/_       /  /::\       /  /:/_       //
//          \  \:\    /  /:/       /  /:/ /\        \__\:\      /  /:/              /  /:/\:\        \  \:\        \  \:\        \  \:\     /  /:/ /\     /  /:/\:\     /  /:/ /\      //
//      _____\__\:\  /__/::\      /  /:/_/::\   ___ /  /::\    /  /:/              /  /:/~/:/    ___  \  \:\   _____\__\:\   _____\__\:\   /  /:/ /:/_   /  /:/~/:/    /  /:/ /::\     //
//     /__/::::::::\ \__\/\:\__  /__/:/__\/\:\ /__/\  /:/\:\  /  /::\             /__/:/ /:/___ /__/\  \__\:\ /__/::::::::\ /__/::::::::\ /__/:/ /:/ /\ /__/:/ /:/___ /__/:/ /:/\:\    //
//     \  \:\~~\~~\/    \  \:\/\ \  \:\ /~~/:/ \  \:\/:/__\/ /__/:/\:\            \  \:\/:::::/ \  \:\ /  /:/ \  \:\~~\~~\/ \  \:\~~\~~\/ \  \:\/:/ /:/ \  \:\/:::::/ \  \:\/:/~/:/    //
//      \  \:\  ~~~      \__\::/  \  \:\  /:/   \  \::/      \__\/  \:\            \  \::/~~~~   \  \:\  /:/   \  \:\  ~~~   \  \:\  ~~~   \  \::/ /:/   \  \::/~~~~   \  \::/ /:/     //
//       \  \:\          /__/:/    \  \:\/:/     \  \:\           \  \:\            \  \:\        \  \:\/:/     \  \:\        \  \:\        \  \:\/:/     \  \:\        \__\/ /:/      //
//        \  \:\         \__\/      \  \::/       \  \:\           \__\/             \  \:\        \  \::/       \  \:\        \  \:\        \  \::/       \  \:\         /__/:/       //
//         \__\/                     \__\/         \__\/                              \__\/         \__\/         \__\/         \__\/         \__\/         \__\/         \__\/        //
//                                                                                                                                                                                     //
//                                                                                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract JDM is ERC721Creator {
    constructor() ERC721Creator("Night Runners", "JDM") {}
}
