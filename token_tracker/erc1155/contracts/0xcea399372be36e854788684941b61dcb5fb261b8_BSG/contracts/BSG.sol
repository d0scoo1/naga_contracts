
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Bysne Gravity
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//                                                                                       //
//                                                                                       //
//                                             ▄▓███▄                                    //
//                                         ▄▓████▀╙▀███▓▄                                //
//                                     ╓▄████▀`      └▀████▓▄                            //
//                                 ,▄████▀└              └▀████▄µ                        //
//                             ,▄████▀╙                      ╙▀████▄,                    //
//                          ▄████▀▀                              ╙▀████▄                 //
//                      ▄▓███▀▀─                           ▓▄        ╙▀████▄             //
//                  ▄▄████▀└╗▄▄▓▓▓█████████████▓▓▄▄▄▄,     ████▄        └▀████▓▄         //
//              ,▄████▀└      ▀█▌                └└╙╙▀▀███▄▄█▌ ██µ          └▀████▄▄     //
//             ███▀╙           ╙█▌        ╓▄▓████▀▀████▓▄▄╙▀██  ╙█▄             ╙▀███    //
//             ███            ▄██▀    ,▄██▀╙,,▄▄▄▓▓▄▄▄╓,╙▀██▄,   ╙█▄,             ███    //
//             ███          ▄█▀`    ╓██▀ ▄▓█▀▀╙└─  ─└╙▀▀██▄ ╙██▄   ╙▀██▄          ███    //
//             ███        ▄█▀      ██╙ ▓█▀─              '▀██ ╙██      ▀█▌        ███    //
//             ███       ▓█└   ╓ ┌██ ▄█▀                    ╙█▌ ▀█µ ╓▄█████       ███    //
//             ███      ▐██████¬ █▌ ▓█¬  █     ▌              ██ ╟█  └██─ ╙^      ███    //
//             ███      █▀╙ ██  ██ ▐█▀  ▐██   ╫██µ            └█▌ ██   ██         ███    //
//             ███         ██   █▌ ██  ▄█▀██  ██╙██▄,          ██ ╟█   ▄█▌        ███    //
//             ███        ╟█▄,, █▌ ██╓██─  ▀█▄╙█▄  ╙▀███▓▄▄▄▄▄▄██ ╟█╖▓█▀─         ███    //
//             ███        ██▀▀▀██▌ ███└      ▀███▄      ,└╙╙╙╙╙██ ╟██▀            ███    //
//             ███          ██▀▀█▌ ██ ▄██▀▀▀██▄      ▄██▀▀▀██▄ ██ ╟█▀▀██          ███    //
//             ███          █▌  █▌ ████       ██    ██─,▄█▓▄ ▀███ ╟█  ╟█          ███    //
//             ███          █▌  █▌ ███         ██████ j█▌ └█▌ ███ ╟█  ╟█          ███    //
//             ███          █▌  █▌ ███▄       ▄█▀  └█▌ ▀███▀ ╓███ ╟█  ╟█          ███    //
//             ███          █▌  █▌ ██╙██▄▄,▄▄██└    └██▄▄,▄▄██▀██ ╟█  ╟█          ███    //
//             ███          ██▄µ█▌ ██   ╙╙█▀╙          ╙╙█▀╙   ██ ╟█▄▄██          ███    //
//             ███            ╙▀█▌ ██     ████▓▄▄▄▄▄▄▓████     ██ ╟█▀╙            ███    //
//             ███,                ▀██▄,   ██▄ ─└└└└─ ▄██   ,▄██▀                ,███    //
//             └▀████▄                ╙▀██▄ └▀███▓▓███▀─ ▄██▀╙                ▄████▀└    //
//                 ╙▀████▄          ╘█▄   ╙▀██▄      ▄▓█▀▀─ ,▄█           ▄▓████▀─       //
//                    └▀▀███▓▄       █████▄ ╫█╙▀█▓▄██▀█▌,▄████▌       ╓▄████▀`           //
//                        └▀████▄╥   ▐████████▄  └└  ▄████████b   ,▄████▀╙               //
//                            ╙▀███` ████████████▓▓████████████  ███▀╙                   //
//                                ` ████████████████████████████  ─                      //
//                                    ╙▀████████████████████▀╙                           //
//                                        ╙▀████████████▀▀                               //
//                                           ─╙▀█████▀─                                  //
//                                                                                       //
//                                                                                       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


contract BSG is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
