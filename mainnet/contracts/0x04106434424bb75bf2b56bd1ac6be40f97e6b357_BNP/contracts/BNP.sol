
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: BEATS N PIECES
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
//                                                                                                                  //
//     ______  ______  ______  ______  ______       __   __       ______  __  ______  ______  ______  ______        //
//    /\  == \/\  ___\/\  __ \/\__  _\/\  ___\     /\ "-.\ \     /\  == \/\ \/\  ___\/\  ___\/\  ___\/\  ___\       //
//    \ \  __<\ \  __\\ \  __ \/_/\ \/\ \___  \    \ \ \-.  \    \ \  _-/\ \ \ \  __\\ \ \___\ \  __\\ \___  \      //
//     \ \_____\ \_____\ \_\ \_\ \ \_\ \/\_____\    \ \_\\"\_\    \ \_\   \ \_\ \_____\ \_____\ \_____\/\_____\     //
//      \/_____/\/_____/\/_/\/_/  \/_/  \/_____/     \/_/ \/_/     \/_/    \/_/\/_____/\/_____/\/_____/\/_____/     //
//                                                                                                                  //
//                                                                                                                  //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BNP is ERC721Creator {
    constructor() ERC721Creator("BEATS N PIECES", "BNP") {}
}
