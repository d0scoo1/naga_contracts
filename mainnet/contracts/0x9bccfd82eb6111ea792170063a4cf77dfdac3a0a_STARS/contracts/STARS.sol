
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: StarCrypts
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////
//                                                                                   //
//                                                                                   //
//                                                                                   //
//                                                                                   //
//      _________ __                _________                        __              //
//     /   _____//  |______ _______ \_   ___ \_______ ___.__._______/  |_  ______    //
//     \_____  \\   __\__  \\_  __ \/    \  \/\_  __ <   |  |\____ \   __\/  ___/    //
//     /        \|  |  / __ \|  | \/\     \____|  | \/\___  ||  |_> >  |  \___ \     //
//    /_______  /|__| (____  /__|    \______  /|__|   / ____||   __/|__| /____  >    //
//            \/           \/               \/        \/     |__|             \/     //
//                                                                                   //
//                                                                                   //
//                                                                                   //
//                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////


contract STARS is ERC721Creator {
    constructor() ERC721Creator("StarCrypts", "STARS") {}
}
