
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Drifter
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                       ,                  //
//                                                                 ,▄▄▓█▀                   //
//                                                 ,,,,,__,,,▄▄▄▀▓███▀"                     //
//                                               ██████████████████╙                        //
//                                              ╫███████████████▀  ____,,_                  //
//                                              ███████████▀▀▌▄▄▓▀████▀▀└                   //
//                                             ╫█╟██████████████▓██▀`                       //
//                                             █▌ ███████████████▀                          //
//                                            ▓█  "████████████"                            //
//                                           ┌██   █████████▀                               //
//                                           ██"   ╫███▀▀"                                  //
//                                          ╒██    ▐███_                                    //
//                                          ████    ████µ                                   //
//                                        ╓█████    ██'██▄                                  //
//                                       ▓██████w  ▐██ '██▓                                 //
//                                     ▄▀███████▌   ██   ███╥                               //
//                                    ▓█████████▌   ███▄  ╙██▌                              //
//                                  ▄███████████▌   █████   ███                             //
//                                 ▓████████████▌   ██████   ╙██▄                           //
//                               ▄███████████████   ▐██████µ  '██▌                          //
//                              █████████████████   ▐███████▌   ▀██                         //
//                            ▄██████████████████    █████████   └██▄                       //
//                           ████████████████████    ██████████    ▓█▓                      //
//                         ▄█████████████████████    ███████████▄   ╙██_                    //
//                       ,███████████████████████    ████████████▄   '██▄                   //
//                      ▄███████████████████████▌    '▀▀▀▀████████▓    ███                  //
//                    ,█████████████████████████        ▄███████████    ▀██,                //
//                   ▄██████████▌ ████████████▀    Φ█▓███████████████,   ╙██▄               //
//                 ┌███████████████████████▀"╓▓█▄  ▐██████████████████▄   ▓███              //
//                ▓██████████████████████▓▓██████   ██████████████████▀ ╓██████▄            //
//              ╓████████████████████████████████   ████████████████▀  ▓████████▌           //
//             ▓█████████████████████████████████   ██████████████▀  ▄██████████▌█          //
//           ╓▓█████████████████▀████████████████   ╫███████████"  ▄███████████████▄        //
//          ▓██████████████████▌     ███████████▌   ╫████████▀   ╓██████████████████▌       //
//          ▀█████████████████▀       ▀█████████▌   ▓██████▀    ▓█████████████████████_     //
//            ████████████████▓▄,  ╓███▄█████████   ▓████"    ▄████████████████████████▄    //
//             ╙██████████████████ ██████████████    ╙▀"    ▄████████████████████████▀█▀    //
//               ████████▀███████████████████████    ╓╓    █████████████████████████▀▀`     //
//                ╙██████▌ ▀█████████████████████   ▐███▄   ▀██████████████████████▓"       //
//                  ██████─  ╙▀▀█████████████████   ▐████▄   └████████████████████"         //
//                   ╙█████      ███████████████▌   ╫█████▌    █████████████████▀           //
//                     █████     ╘██████████████▌   ███████▌    ▓█████████████▀             //
//                      ╙████     ██████████████▌   ████████▌    ╙██████████▀               //
//                        ████,    █████████████▌   █████████▄    '███████▀                 //
//                         ╙███▌   ╙████████████▌   ██████████▌     ╙███▀                   //
//                           ████▄  ╫███████████▌  ▐█████████▀     ▄███"                    //
//                            ╙████_ ▓██████████▌  ▐████████     ▄█▓█"                      //
//                              ████▄ ██████████▌  ███████"    ▄▓██"                        //
//                               ╙▓███_▀████████▌  █████"    ╓███▀                          //
//                                 ▓███▄╙███████▌  ███▀    ╓███▀                            //
//                                  ╙████'██████▌        ,███▀                              //
//                                    ▓███_▀████▌      ,▓██▀                                //
//                                     ╙███▄'████    ,███▀`                                 //
//                                       ███▓ └     ▄███"                                   //
//                                        ╙███_   ▄███"                                     //
//                                          ███▄▄███▀                                       //
//                                           ╙████▀                                         //
//                                             ▀▀                                           //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////


contract BOOK is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
