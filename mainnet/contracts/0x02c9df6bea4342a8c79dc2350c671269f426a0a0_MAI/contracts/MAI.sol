
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Marina Gayrati
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                           //
//                                                                                           //
//                                           ,                                               //
//                                      ╓@╬╠╠╠▒▒▒╠╦,                                         //
//                                    ╓╬╠╠╠╠╠╠▒▒▒▒▒▒╠                                        //
//                                   ╒╠╠╠╠╠╠╠▒▒▒▒▒▒▒▒▒                                       //
//                                   ╠▒╠╠╠╠▒▒▒▒▒▒▒▒▒▒▒t                                      //
//                                   ▐▒▒▒▒▒▒▒▒▒░░░░░░░                                       //
//                                    ╚░░░░░░░░░░░░░░Γ                                       //
//                                     `╚░░░░░░░░░░┘                                         //
//                                         """""`                                            //
//                                                                                           //
//            ╓≤≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥≥»,         //
//          ê░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░        //
//          ░░░░░░░░╚"```"░░░░░░░²"  `"≥░░░░░░░░░░░░░≥ⁿ""=░░░░░░░░░░░░░░`   "░░░░░░░░        //
//          "░░░░░░░,    «░░░░░`        "░░░░░░░░░░░        ²░░░░░░░░░░░      ░░░░░░"        //
//            "╚░░░░░▒⌐ ╔░░░░∩           ≥░░░░░░░░░Γ         `░░░░░░░░░░   ,≤░░░░░∩          //
//               `²╠░Γ ê░░░░`            )░░░░░░░░░            ░░░░░░░░░░  ░░░░≥^            //
//                    ê░░░░  ê░▒╦≥╓,       `````^""          ,  ░░░░░░░░░[ "^                //
//                   ê▒▒▒▒   `"╙╩╠▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░▒ ╘░░░░░░░░░                   //
//                  ê▒▒▒▒╙               ```""""""`````          ╚░░░░░░░░≥                  //
//                 ╔▒▒▒▒╩                ╞▒╬╠╠╠╠╠╠▒               ░░░░░░░░░     ,,           //
//                ┌╠▒▒▒╠                 ╞▒▒▒▒▒▒▒▒▒               ╙░░░░░░░░≥    7░░░≥,       //
//                ╬╠╠╠╠Γ                 ╞▒▒▒▒▒▒▒▒▒               '░░░░░░░░░    ,░░░░░░      //
//               {╠╠╠╠╠                  ╞▒▒▒▒▒▒▒▒▒                ░░░░░░░░░[ ,≤░░░░░░░░     //
//               ╠╠╠╬╬╩                  ╞▒▒▒▒▒▒▒▒▒ ╓╓╓╔╔╔╔╔≡≡≥≥≥≥≥5░░░░░░░░░ ░░░░░░░░░░░    //
//              ⌠╬╬╬╬╬                   ╞▒▒▒▒▒▒▒▒▒ ╠▒▒▒▒▒▒▒░░░░░░░└░░░░░░░░░ ⌠░░░░░░░░░⌐    //
//              ╬╬╬╬╬╬                   ╞▒▒▒▒▒▒▒▒▒ ╠▒▒▒▒▒▒▒▒░░░░░░∩░░░░░░░░░[ ░░░░░░░░`     //
//              ╬╬╬╬╬╬                   ╞▒▒▒▒▒▒▒▒▒ ╠▒▒▒▒▒▒▒▒░░░░░░⌐░░░░░░░░░░ ░░░≥²"        //
//             ]╬╬╬╬╬╬                   ╞▒▒▒▒▒▒▒▒▒ ╚╩"``````       ░░░░░░░░░░               //
//             ╞╬╬╬╬╬╬                   ╞▒▒▒▒▒▒▒▒▒                 ░░░░░░░░░░               //
//             ║╬╬╬╬╬╬▒                  ╞▒▒▒▒▒▒▒▒▒                 ░░░░░░░░░░               //
//             ║╬╬╬╬╬╬╬                  ╞▒▒▒▒▒▒▒▒▒                 ░░░░░░░░░░               //
//             ╠╬╬╬╬╬╬╬╬╖                ▐▒▒▒▒▒▒▒▒▒                «░░░░░░░░░░               //
//             ╠╬╬╠╠╠╠╠╠╠╠▒╦           ,╔▒▒▒▒▒▒▒▒▒▒╠╓           ,╔▒░░░░░░░░░░░               //
//             ╘╠╠╠╠╠╠╠╠╠╠╠╠╠╠╦,    ,╦╠▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒≥,     ,≡╠░░░░░░░░░░░░░░               //
//              ╠╠╠╠╠╠╠╠╠▒▒▒▒▒▒▒ò  ╠▒▒▒▒▒▒▒▒▒░░░░░░░░░░░╠  ╔╠░░░░░░░░░░░░░░░░╚               //
//               ``        ```      `"└╙┘""`````"""²²""^    `""²²²""````""""`                //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////


contract MAI is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
