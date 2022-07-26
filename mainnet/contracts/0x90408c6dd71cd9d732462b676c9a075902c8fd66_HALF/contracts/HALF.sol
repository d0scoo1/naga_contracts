
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Human Alien Friendship League
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                        //
//                                                                                                                                                                        //
//                                                                                                                                                                        //
//     .----------------.  .-----------------. .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.     //
//    | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |    //
//    | |     _____    | || | ____  _____  | || | ____   ____  | || |      __      | || |  ________    | || |  _________   | || |  _______     | || |    _______   | |    //
//    | |    |_   _|   | || ||_   \|_   _| | || ||_  _| |_  _| | || |     /  \     | || | |_   ___ `.  | || | |_   ___  |  | || | |_   __ \    | || |   /  ___  |  | |    //
//    | |      | |     | || |  |   \ | |   | || |  \ \   / /   | || |    / /\ \    | || |   | |   `. \ | || |   | |_  \_|  | || |   | |__) |   | || |  |  (__ \_|  | |    //
//    | |      | |     | || |  | |\ \| |   | || |   \ \ / /    | || |   / ____ \   | || |   | |    | | | || |   |  _|  _   | || |   |  __ /    | || |   '.___`-.   | |    //
//    | |     _| |_    | || | _| |_\   |_  | || |    \ ' /     | || | _/ /    \ \_ | || |  _| |___.' / | || |  _| |___/ |  | || |  _| |  \ \_  | || |  |`\____) |  | |    //
//    | |    |_____|   | || ||_____|\____| | || |     \_/      | || ||____|  |____|| || | |________.'  | || | |_________|  | || | |____| |___| | || |  |_______.'  | |    //
//    | |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |    //
//    | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |    //
//     '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'     //
//                                                                                                                                                                        //
//                                                                                                                                                                        //
//                                                                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract HALF is ERC721Creator {
    constructor() ERC721Creator("Human Alien Friendship League", "HALF") {}
}
