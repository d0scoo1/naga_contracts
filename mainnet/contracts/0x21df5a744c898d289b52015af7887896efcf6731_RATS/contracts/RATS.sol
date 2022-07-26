
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Stinky Rats
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//                                                                                //
//      _________ __  .__        __            __________         __              //
//     /   _____//  |_|__| ____ |  | _____.__. \______   \_____ _/  |_  ______    //
//     \_____  \\   __\  |/    \|  |/ <   |  |  |       _/\__  \\   __\/  ___/    //
//     /        \|  | |  |   |  \    < \___  |  |    |   \ / __ \|  |  \___ \     //
//    /_______  /|__| |__|___|  /__|_ \/ ____|  |____|_  /(____  /__| /____  >    //
//            \/              \/     \/\/              \/      \/          \/     //
//                                                                                //
//                                                                                //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////


contract RATS is ERC721Creator {
    constructor() ERC721Creator("Stinky Rats", "RATS") {}
}
