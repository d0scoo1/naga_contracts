
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Venice Sharks
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
//                                                                               //
//                                                     ,▄█▀▀█▄                   //
//                                                   ,█▀░▒▒▒▒░█▄                 //
//                                                  █▀░▒▒▒▒▒▒▒▒▀█                //
//                                                ▄█░▒▒▒▒▒▒▒▒▒▒▒▐▌               //
//                                               █▀░▄░▒▒▒▒▒▒▒▒▒▒▒█               //
//                                     ▄▄▄▄▄▄▄▄██░▒▒▀██░▒▒▒▒▒▒▒▒▒▒█              //
//                                 ▐█████████▄█▌▄▄░▒▒▒▀▀▒▒▒▒▒▒▒▒▒▒▐▌             //
//                                 █████████████████████▄███████▀████▄           //
//             ██                  █████████▀▒██████████░▒▒▒▒▒▒▒▒▒▒█▌▀▌          //
//            ███▄                  ▀██▀▀▄█░▒▒▀████████░▒▒▒▒▒▒▒▒▒▒▒▐▌▐▌          //
//            █▌░█▄                     █▀▒▒▒▒▒▀█████▀▒▒▒▓▓▓▒▒▒▒▒▒▒▒█            //
//           ▐█▒▒░█▄                  ▄█▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒█            //
//           ▐█▒▒▒▒█▄                ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓▓▓▓▒▒▒▒▒▒█            //
//           ▐█▒░██▀▀█               ▀███▓▓▓▓▓▓▓▓▓▓███▀  █▌▓▓▓▒▒▒▒▒▒█            //
//            █▒░░▒▒▒░█▄             █▌ `▀▀▀▀▀▀▀▀▀   █▌  █▌▓▓▓▒▒▒▒▒▒█            //
//            █░▒▒▒▒▄█▀▀█           ▐█▄▄█▄  ,██  ███▄██  █▓▓▓▓▒▒▒▒▒▒█            //
//            ▐▌▒▒▒▀▀▒▒▒░██,       ▐█▀   "█▄█ ▀███    ▀  █▓▓▓▒▒▒▒▒▒▒█            //
//             █░▒▒▒▒▒▒▄█▀░▀█▄           ,▄▌    ▀ ╒▄▄▄████▓▓▓▒▒▒▒▒▒▒█            //
//             ▐█▒▒▒▒▒▒▀░▒▒▒▄█▀█▄▄▄▄▄▄▄████        █   ╒█▓▓▓▒▒▒▒▒▒▐▌             //
//              ▀▌▒▒▒▒▒▒▒▒▒░█░▒▒▒░█▒▒░▒▒▄█     █▄▄ █▌  █▌▓▓▓▒▒▒▒▒▒▒░█▄           //
//               ▀█░▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▄█▀  ▄▄ ▐█  ▀▀▀,█▓▓▓▓▒▒▒▒▒▒▒▒▒▒▀█          //
//                 ▀█▌▒▒▒▒▒▒▒▒▒▒▒▒▒░▄█▀   ██▀███    ▄█▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▀█         //
//                   █░▒▒▒▒▒▒▒▒▒░▄███▄   █▀   ▀  ,▄█▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒░█        //
//                   ▐█░▒▒▒▒▒▒▀▀█▓▓▓▓▓████▄▄▄▄▄███▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█       //
//                    ▀█▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀▌      //
//                     ▀█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▄█▄▄▄░▒▒▒▒▒▒▒▒█      //
//                      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ▀▀▀██▄▒▒▒░█     //
//                       ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▀          ▀▀█▄░█     //
//                        ▀█░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄█▀               ▀█▌    //
//                         ▀█▄▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░██                        //
//                           ▀█▄▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄██                          //
//                             ▀██▄▒▒▒▒▒▒▒▒▒▒▒▒▒░▄██▀                            //
//                                ▀▀███▄▄▄▄▄███▀▀'                               //
//                                                                               //
//                                                                               //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////


contract SHARK is ERC721Creator {
    constructor() ERC721Creator("Venice Sharks", "SHARK") {}
}
