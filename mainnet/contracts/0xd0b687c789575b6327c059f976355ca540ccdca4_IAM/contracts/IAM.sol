
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: International Art Machine
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//                                                                             //
//        ____      __                        __  _                   __       //
//       /  _/___  / /____  _________  ____ _/ /_(_)___  ____  ____ _/ /       //
//       / // __ \/ __/ _ \/ ___/ __ \/ __ `/ __/ / __ \/ __ \/ __ `/ /        //
//     _/ // / / / /_/  __/ /  / / / / /_/ / /_/ / /_/ / / / / /_/ / /         //
//    /___/_/ /_/\__/\___/_/  /_/ /_/\__,_/\__/_/\____/_/ /_/\__,_/_/          //
//       /   |  _____/ /_                                                      //
//      / /| | / ___/ __/                                                      //
//     / ___ |/ /  / /_                                                        //
//    /_/ _|_/_/_  \__/     __    _                                            //
//       /  |/  /___ ______/ /_  (_)___  ___                                   //
//      / /|_/ / __ `/ ___/ __ \/ / __ \/ _ \                                  //
//     / /  / / /_/ / /__/ / / / / / / /  __/                                  //
//    /_/  /_/\__,_/\___/_/ /_/_/_/ /_/\___/                                   //
//                                                                             //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract IAM is ERC721Creator {
    constructor() ERC721Creator("International Art Machine", "IAM") {}
}
