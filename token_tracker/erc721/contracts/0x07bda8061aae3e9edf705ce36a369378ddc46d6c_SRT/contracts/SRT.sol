
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Seurat
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//        //   ) )  //   / /  //   / / //   ) )  // | |  /__  ___/     //
//       ((        //____    //   / / //___/ /  //__| |    / /         //
//         \\     / ____    //   / / / ___ (   / ___  |   / /          //
//           ) ) //        //   / / //   | |  //    | |  / /           //
//    ((___ / / //____/ / ((___/ / //    | | //     | | / /            //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


contract SRT is ERC721Creator {
    constructor() ERC721Creator("Seurat", "SRT") {}
}
