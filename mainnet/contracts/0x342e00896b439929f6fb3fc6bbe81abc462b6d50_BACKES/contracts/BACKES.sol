
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Backes Coleção
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////
//                                                        //
//                                                        //
//    .------..------..------..------..------..------.    //
//    |B.--. ||A.--. ||C.--. ||K.--. ||E.--. ||S.--. |    //
//    | :(): || (\/) || :/\: || :/\: || (\/) || :/\: |    //
//    | ()() || :\/: || :\/: || :\/: || :\/: || :\/: |    //
//    | '--'B|| '--'A|| '--'C|| '--'K|| '--'E|| '--'S|    //
//    `------'`------'`------'`------'`------'`------'    //
//                                                        //
//                                                        //
////////////////////////////////////////////////////////////


contract BACKES is ERC721Creator {
    constructor() ERC721Creator(unicode"Backes Coleção", "BACKES") {}
}
