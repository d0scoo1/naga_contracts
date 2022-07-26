
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: I miei fiori preferiti
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////
//                                                   //
//                                                   //
//    ///////////////////////////////////////////    //
//    //                                       //    //
//    //                                       //    //
//    //    _--=._              /|_/|          //    //
//    //      `-.}   `=._-.-=-._.'  @ @._,     //    //
//    //         `._ _--.   )      _,.-'       //    //
//    //            `    Gm-"""^Gm'            //    //
//    //                    .                  //    //
//    //    ..-.     .-.    /                  //    //
//    //       )   /.-._. /  .-.   .-.         //    //
//    //      /   /(   ) /   /  )./.-'_        //    //
//    //     (  .'  `-'_/_.-/`-' (__.'         //    //
//    //      \/           /                   //    //
//    //                                       //    //
//    //                                       //    //
//    ///////////////////////////////////////////    //
//                                                   //
//                                                   //
///////////////////////////////////////////////////////


contract FIORI is ERC721Creator {
    constructor() ERC721Creator("I miei fiori preferiti", "FIORI") {}
}
