
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: bronwyn
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                        ╣╣ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//                                                      ╣╣╣╣╣  ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//                                                     ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//                                               ╣         ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//                                                    ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//                                                      ╣╣   ╣  ╣╣╣╣  ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//                                                          ╣     ╣ ╣   ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//                                                                ╣╣╣  ╣╣╣╣╣╣╣╣╣╣╣╣           //
//                                        ╣╣╣╣╣                          ╣╣╣╣ ╣╣╣╣╣           //
//                                      ╣╣╣╣╣╣╣╣╣╣╣╣                      ╣                   //
//                                     ╣╣╣╣╣╣╣╣ ╣╣   ╣                      ╣╣╣               //
//                                    ╣╣╣╣╣╣╣╣╣╣ ╣ ═                          ╣╣              //
//                                    ╣╣╣╣╣╣╣╣    ╝  │                                        //
//                                      ╣╣╣╣╣╬       ╙                                        //
//                                       ╣╣╣╣  └       ╔                       ╣              //
//                                       ╣╣╣          ╞                                       //
//                                                 ╓╓╓                                        //
//                                           ┌                                                //
//                                                  ╙                                         //
//                                    └                                                       //
//                                                       ┐                                    //
//                                                       ╓                                    //
//                                                   ╓╣╣╣╣╣╓ ╘                                //
//                             ╣   ╓                ╔╣╣╣╣╣╣╣                                  //
//                                  ╣ ╣╣╣╣╣╣╣╣╣╣╦  ╓╣╣╣╣╣╣╣╣                                  //
//                               ╝ ╞╣╣╣╣╣╣╣╣╣╣╣╣╣╣ ╣╣╣╣╣╣╣╣╣  ╘                               //
//                                 ╘ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣                                   //
//                                   ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    └                              //
//                                      ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣                                   //
//                                        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣ ┐                                 //
//                                          ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣     ╙                            //
//                                ╓        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣                                 //
//                              ╓       ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣                                 //
//                            ╓╔       ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣                                //
//                            ╒        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    ╞                           //
//                           ┌        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣  ╣╣╣╣╣╣                               //
//                        ╣ ╘         ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣ ╣╣╣╣╣╣                               //
//                                   ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╬   ╘                           //
//        ╣               ╣╣         ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╬                                //
//        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╬    ╣                          //
//        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣  ╗┌ ╣                          //
//        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣  ╣╣╣╣╣                       //
//        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╬                      //
//        ╣╣╣╣╣╣╣╣╣╣ ╣     ╬╬ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╬                          //
//         ╣╣╣╣╣╣╣    ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╬                          //
//        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣  ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╬                          //
//        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣   ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╬                          //
//        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣                           //
//        ╣╣╣╣╣╣╣ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣                           //
//        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣                          //
//        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣                          //
//        ╣╣╣╣╣╣╣ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣                          //
//        ╣╣╣╣╣╣ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╬                         //
//        ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣                         //
//        ╣╣╣╣╣╣ ╫╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣           ╣ ╣╣   ╣ ╣    //
//        ╣╣╣╣╣╣ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣  ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//        ╣╣╣╣╣╣ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//        ╣╣╣╣╣╣ ╫╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//        ╣╣╣╣╣╣ ╫╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//         ╣╣╣╣╣ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//               ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//         ╣╣╣╣╣   ╣╣ ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//        ╣╣╣╣╣╣ ╣╣╣╣╣╣╣╣╣╣╬╬  ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//        ╣╣╣╣╣╣ ╣╣╣╣      ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//        ╣╣╣╣╣╣ ╣╣  ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//        ╣╣╣╣╣    ╣╣╣╣╬           ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//        ╣╣╣╣╣   ╣╣                   ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//        ╣╣╣╣╣   ╣                         ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//           ╣╣                                        ╣╣╣╣╣    ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//        ╣   ╣                                                     ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//         ╣                                                            ╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣    //
//                                                                                            //
//    ---                                                                                     //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract Bro is ERC721Creator {
    constructor() ERC721Creator("bronwyn", "Bro") {}
}
