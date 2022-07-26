
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Aesthetic Apes
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                        _    _            _    _                                     //
//                       | |  | |          | |  (_)                                    //
//       __ _   ___  ___ | |_ | |__    ___ | |_  _   ___    __ _  _ __    ___  ___     //
//      / _` | / _ \/ __|| __|| '_ \  / _ \| __|| | / __|  / _` || '_ \  / _ \/ __|    //
//     | (_| ||  __/\__ \| |_ | | | ||  __/| |_ | || (__  | (_| || |_) ||  __/\__ \    //
//      \__,_| \___||___/ \__||_| |_| \___| \__||_| \___|  \__,_|| .__/  \___||___/    //
//                                                               | |                   //
//                                                               |_|                   //
//                                                                                     //
//                                                                                     //
//                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////


contract AAPES is ERC721Creator {
    constructor() ERC721Creator("Aesthetic Apes", "AAPES") {}
}
