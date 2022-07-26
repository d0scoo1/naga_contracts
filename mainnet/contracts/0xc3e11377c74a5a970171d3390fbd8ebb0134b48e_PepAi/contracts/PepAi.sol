
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: PepAi Token
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                                                                        //
//          ___         ___           ___         ___                     //
//         /  /\       /  /\         /  /\       /  /\        ___         //
//        /  /::\     /  /:/_       /  /::\     /  /::\      /  /\        //
//       /  /:/\:\   /  /:/ /\     /  /:/\:\   /  /:/\:\    /  /:/        //
//      /  /:/~/:/  /  /:/ /:/_   /  /:/~/:/  /  /:/~/::\  /__/::\        //
//     /__/:/ /:/  /__/:/ /:/ /\ /__/:/ /:/  /__/:/ /:/\:\ \__\/\:\__     //
//     \  \:\/:/   \  \:\/:/ /:/ \  \:\/:/   \  \:\/:/__\/    \  \:\/\    //
//      \  \::/     \  \::/ /:/   \  \::/     \  \::/          \__\::/    //
//       \  \:\      \  \:\/:/     \  \:\      \  \:\          /__/:/     //
//        \  \:\      \  \::/       \  \:\      \  \:\         \__\/      //
//         \__\/       \__\/         \__\/       \__\/                    //
//                                                                        //
//                                                                        //
////////////////////////////////////////////////////////////////////////////


contract PepAi is ERC721Creator {
    constructor() ERC721Creator("PepAi Token", "PepAi") {}
}
