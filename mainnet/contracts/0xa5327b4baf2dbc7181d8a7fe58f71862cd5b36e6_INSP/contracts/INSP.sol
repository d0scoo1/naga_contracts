
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Inscape
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////
//                                                                //
//                                                                //
//                                                                //
//    .------..------..------..------..------..------..------.    //
//    |I.--. ||N.--. ||S.--. ||C.--. ||A.--. ||P.--. ||E.--. |    //
//    | (\/) || :(): || :/\: || :/\: || (\/) || :/\: || (\/) |    //
//    | :\/: || ()() || :\/: || :\/: || :\/: || (__) || :\/: |    //
//    | '--'I|| '--'N|| '--'S|| '--'C|| '--'A|| '--'P|| '--'E|    //
//    `------'`------'`------'`------'`------'`------'`------'    //
//                                                                //
//                                                                //
////////////////////////////////////////////////////////////////////


contract INSP is ERC721Creator {
    constructor() ERC721Creator("Inscape", "INSP") {}
}
