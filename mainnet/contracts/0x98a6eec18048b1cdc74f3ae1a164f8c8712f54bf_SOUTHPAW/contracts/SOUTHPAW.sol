
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Southpaw Cinema
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                                                                                               //
//     __    __  ______  ______  ______  ______  ______  ______  _____   ______       __  __   __  ______        //
//    /\ "-./  \/\  __ \/\  == \/\  ___\/\  ___\/\  ___\/\  __ \/\  __-./\  ___\     /\ \/\ "-.\ \/\  ___\       //
//    \ \ \-./\ \ \ \/\ \ \  __<\ \___  \ \  __\\ \ \___\ \ \/\ \ \ \/\ \ \  __\     \ \ \ \ \-.  \ \ \____      //
//     \ \_\ \ \_\ \_____\ \_\ \_\/\_____\ \_____\ \_____\ \_____\ \____-\ \_____\    \ \_\ \_\\"\_\ \_____\     //
//      \/_/  \/_/\/_____/\/_/ /_/\/_____/\/_____/\/_____/\/_____/\/____/ \/_____/     \/_/\/_/ \/_/\/_____/     //
//                                                                                                               //
//                                                                                                               //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SOUTHPAW is ERC721Creator {
    constructor() ERC721Creator("Southpaw Cinema", "SOUTHPAW") {}
}
