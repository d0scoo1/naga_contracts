
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Amo's Celebration Collectibles
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                                                                    //
//                                                                    //
//     .----------------.  .----------------.  .----------------.     //
//    | .--------------. || .--------------. || .--------------. |    //
//    | |      __      | || | ____    ____ | || |     ____     | |    //
//    | |     /  \     | || ||_   \  /   _|| || |   .'    `.   | |    //
//    | |    / /\ \    | || |  |   \/   |  | || |  /  .--.  \  | |    //
//    | |   / ____ \   | || |  | |\  /| |  | || |  | |    | |  | |    //
//    | | _/ /    \ \_ | || | _| |_\/_| |_ | || |  \  `--'  /  | |    //
//    | ||____|  |____|| || ||_____||_____|| || |   `.____.'   | |    //
//    | |              | || |              | || |              | |    //
//    | '--------------' || '--------------' || '--------------' |    //
//     '----------------'  '----------------'  '----------------'     //
//                                                                    //
//                                                                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////


contract ACC is ERC721Creator {
    constructor() ERC721Creator("Amo's Celebration Collectibles", "ACC") {}
}
