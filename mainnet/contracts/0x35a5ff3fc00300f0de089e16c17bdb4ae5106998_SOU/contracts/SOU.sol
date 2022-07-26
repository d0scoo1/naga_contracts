
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Story Of Us
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                //
//                                                                                                                                                                                //
//                        ___           ___           ___                         ___           ___                         ___                         ___           ___         //
//          ___          /  /\         /  /\         /  /\          ___          /  /\         /  /\          __           /  /\          ___          /  /\         /  /\        //
//         /__/\        /  /:/        /  /::\       /  /::\        /__/\        /  /::\       /  /::\        |  |\        /  /::\        /  /\        /  /:/        /  /::\       //
//         \  \:\      /  /:/        /  /:/\:\     /__/:/\:\       \  \:\      /  /:/\:\     /  /:/\:\       |  |:|      /  /:/\:\      /  /::\      /  /:/        /__/:/\:\      //
//          \__\:\    /  /::\ ___   /  /::\ \:\   _\_ \:\ \:\       \__\:\    /  /:/  \:\   /  /::\ \:\      |  |:|     /  /:/  \:\    /  /:/\:\    /  /:/        _\_ \:\ \:\     //
//          /  /::\  /__/:/\:\  /\ /__/:/\:\ \:\ /__/\ \:\ \:\      /  /::\  /__/:/ \__\:\ /__/:/\:\_\:\     |__|:|__  /__/:/ \__\:\  /  /::\ \:\  /__/:/     /\ /__/\ \:\ \:\    //
//         /  /:/\:\ \__\/  \:\/:/ \  \:\ \:\_\/ \  \:\ \:\_\/     /  /:/\:\ \  \:\ /  /:/ \__\/~|::\/:/     /  /::::\ \  \:\ /  /:/ /__/:/\:\ \:\ \  \:\    /:/ \  \:\ \:\_\/    //
//        /  /:/__\/      \__\::/   \  \:\ \:\    \  \:\_\:\      /  /:/__\/  \  \:\  /:/     |  |:|::/     /  /:/~~~~  \  \:\  /:/  \__\/  \:\_\/  \  \:\  /:/   \  \:\_\:\      //
//       /__/:/           /  /:/     \  \:\_\/     \  \:\/:/     /__/:/        \  \:\/:/      |  |:|\/     /__/:/        \  \:\/:/        \  \:\     \  \:\/:/     \  \:\/:/      //
//       \__\/           /__/:/       \  \:\        \  \::/      \__\/          \  \::/       |__|:|~      \__\/          \  \::/          \__\/      \  \::/       \  \::/       //
//                       \__\/         \__\/         \__\/                       \__\/         \__\|                       \__\/                       \__\/         \__\/        //
//                                                                                                                                                                                //
//                                                                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SOU is ERC721Creator {
    constructor() ERC721Creator("The Story Of Us", "SOU") {}
}
