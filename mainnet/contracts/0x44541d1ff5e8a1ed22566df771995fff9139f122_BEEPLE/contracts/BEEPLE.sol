
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: BEEPLE: EVERYDAYS
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//      ____  ______ ______ _____  _      ______     ________      ________ _______     _______      __     _______     //
//     |  _ \|  ____|  ____|  __ \| |    |  ____|_  |  ____\ \    / /  ____|  __ \ \   / /  __ \   /\\ \   / / ____|    //
//     | |_) | |__  | |__  | |__) | |    | |__  (_) | |__   \ \  / /| |__  | |__) \ \_/ /| |  | | /  \\ \_/ / (___      //
//     |  _ <|  __| |  __| |  ___/| |    |  __|     |  __|   \ \/ / |  __| |  _  / \   / | |  | |/ /\ \\   / \___ \     //
//     | |_) | |____| |____| |    | |____| |____ _  | |____   \  /  | |____| | \ \  | |  | |__| / ____ \| |  ____) |    //
//     |____/|______|______|_|    |______|______(_) |______|   \/   |______|_|  \_\ |_|  |_____/_/    \_\_| |_____/     //
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BEEPLE is ERC721Creator {
    constructor() ERC721Creator("BEEPLE: EVERYDAYS", "BEEPLE") {}
}
