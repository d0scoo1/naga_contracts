
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: non-essential
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                           //
//                                                                                           //
//                                                                                           //
//          ,≥,  ;≥,          ,φφ╓       ╔φ╓  φφ╓                      ,≤ε        ,╓φ╓       //
//          `░░Γ `Γ░░      ╓φ╠ `╚╠╬▒     ╚╬╠╙ `░░░                  ░░░ ░░≥     φ░░ "╩▒╬     //
//           │░[  ╔░░      ░░▒  j╬╠Γ     ╞░░   ░░░           ,      ░░░  φ░φ    ╚░╠  ,╩      //
//           ░░[  ╔░░      ░░▒  j╬╬Γ     ╞░░   ▒░░      ,≤φ▒░░      ░░░,=^      ╩▒▒▒φ╠╦,     //
//           ░░[  ╔░░      ╠╠╬  j╠╬Γ     ╞░░   ░░░      ▒²^         ░░░           ╠╜ ╠╬╠     //
//           ░░   ╔░░      ╠╬╬  j╬╬Γ     ├░░µ╓╓▒φφ╦╦╓╓,             ░░░          Θ   ╠╠╠     //
//           ░¡░  ╙░░,     ╬╬╠╦ j╠╝`  ,╔φ╬╠╬╬╠╠╬╬╠╬╬╠╬╠╬╬▒#╦,       φ░░φ╔,╓     ╬φ╦╓ ╠╬╠     //
//           "φ"   "╬"       ╙╬╜   ╓φ╠▒╠▒╬╬╠╬╠╠╬╠╠╠╬╬╬╬╬╬╬╬╬╬╣╗╖      `╙╬"     !`"╚╬╜        //
//                              ,φ░░░▒╠▒▒╠╬▓▓▓▓████▓▓╬╬╬╬╬╬╬╬╬╠╬▓╦                           //
//                             φ▒░▒▒╠▒φ▄▓██████████████▓▓╬╬╠╬╠╬╬╣╬╬╦                         //
//                           ;░▒░░▒╠╠▓██████████████████████▒╬╬╬╠╬╠╬╬                  ╓     //
//                          φ░░▒░░╠╠▓█████████████████████████╬╬╠╠╠╬╬╬ε              φ▒▒     //
//                         φ░░░░░φ╬█████████▀╙╠╬▓█████████████╬╠╬╬╬╠╬╬╬              ░░░     //
//            ,≤≥  ,       ░░░░╠▒╠╠██████╬░▒░░░░░░░░╙╙╚███████╬╬╠╬╬╬╠▒╠╠ «≥≡,        ░░▒     //
//          ░░[ ⁿ░░     ]░░░Å░░φ╬╠╟██╬╬╬╬╬░╩░░░░░░░░░░░╠██████╠╬╬╬╬╠╬▒╠╬╩^"φ░░░      ░░▒     //
//          ░░[  ≤      ]░░▒╠▒╠╠╬╬╟█╠╬╬╠╬╬░░░▒▓▄▓▓▓▓▓▄░░╚████▌╬╬╬▒╬▒╬╬▒╬▒   ░░░      ░░▒     //
//         -░░░≥░≥,     ]░░╠▒╬╠╬╠╬╬▌▓██████▓░╚╠╣▓▓▓╬╣╬░▒░░███▌▒╬╬╬╬╠░▒░░╬   ░░░      ▒╬▒     //
//            Γ ]░░     ]░╠╠╠╠╬╠╬╬╬▒╣██╣███▒.░░╠╬╬█▀╢╩╩░░░▓██▒╣▒╬╬░▒░╠░▒╠   ░░░      ▒╬╬     //
//          ;   ]░░     ]░░╬╠╬╠╠╢╬╠▒╬╠╬╬█████▄▄▄▄▒░░░░░░░▄██╬▄╠▒▒░░░░░░░░   ░░░      ╬╬╬     //
//         /≥≥, ]░░     «░φ╠╬╬╬╬╣╬╣██████████████████████░╟█╬╠░░░░░░░░░╩░, ,░░░      ╬╠╬     //
//         Γ`²φ=^          "╢╣╬╢╬╬╬▓████████████████████▌φ╠▒░╠▄█████▒░Γ ²▒"  ╚╠^     `╚╩     //
//                           ╚╬╬╬╬╬╣█████████████████████░╠▓█████████▒                       //
//                            └╣╬╠▓██████████████████████╠╫██████████▌                       //
//                              ╙████████████████████████╟████████████                       //
//                              j████████████████████████╬╣███████████                       //
//         .░░░≥-φ░░≥        ╓≈▒▒███████████████████████▒╣████████████ε{░░      ,╓φ╩▒╬╦╓     //
//           '░[  »░░      ▒░▒  j╫██████████████████╬╬╠╠██████████████▌ \░░     ╠╬╬  `╠╜     //
//           ░░[  ╔░░      ╬╠╬ ╓████████████████╬╬╠╠╬╠▓████████████████▄,▐╚"    ╠╬╬  φ       //
//           ░░[  ╔░░      ╬▒▓██████████████████▓▓▓▓▓█████████████████████▄      ╙╬╠╩▒╬φ     //
//           '░   ╔░░      ████████████████████████████████████████████████⌐     ,Θ  ╠░░     //
//           ░░[  ╙░░    ▄█████████████████████████████████████████████████⌐    ╔╙   ╠░░     //
//          «░░░~ ╬▒▒φ⌐  ██████████████████████████████████████████████████⌐    ╬▒╬▒≡╠ⁿ^     //
//            `     ╙    ██████████████████████████████████████████████████⌐       "         //
//                       ██████████████████████████████████████████████████▒                 //
//                       ██████████████████████████████████████████████████▌                 //
//                       ██████████████████████████████████████████████████▌          ╔╠     //
//                       ██████████████████████████████████████████████████▌         ▒▒▒     //
//                       ██████████████████████████████████████████████████▌         ░▒╬     //
//          ,≤░φ░░ ∩     ██████████████████████████████████████████████████▒░»,      ▒╬▒     //
//         j░░   ⁿΓ     ⌠██████████████████████████████████████████████████▌░░░      ▒╠╬     //
//         j░│  ;'      ⌠██████████████████████████████████████████████████▌░░░      ╬╬╠     //
//          "σ'░░░░-    ▐░░░"'       ╠░░~ .░░░ '   .░░░       ││.`    ''"--»░░╬      ▒╬╠     //
//           ¿  ]░░     ▐φ░░         ╠░▒   ░░░     j░░░       │░░     j░░⌐  ▒╠╠      ╬╬▒     //
//          ░   ]░░     ▐╠▒▒         ╠░░   ░░Γ     j░░░       │░░     j░░∩  ▒╬╬      ▒░░     //
//         ░,░░≥⌠≥⌐     ╙╙╬╬╬▒#"     ╬░░≥ «░░░≥    ⁿφ░░φ≥^    φ░░░-   ²φφ▒╦ê╬╬╬╦~   «▒░░≥    //
//            "             ╙╙        '`    `         ``        "       '╙   '╙       '`     //
//                                                                                           //
//                                                                                           //
//    Yesterday I was illegal                                                                //
//    Today I am essential                                                                   //
//                                                                                           //
//    Yesterday I was a foreign invader                                                      //
//    Today I am a savior                                                                    //
//                                                                                           //
//    Yesterday I was the problem                                                            //
//    Today I am the solution                                                                //
//                                                                                           //
//    Yesterday I was overlooked                                                             //
//    Today I look over you                                                                  //
//                                                                                           //
//    Yesterday you declined my call                                                         //
//    Today I answer yours                                                                   //
//                                                                                           //
//    Yesterday I was unwanted, denied and turned away                                       //
//    Today I am invited to the front lines                                                  //
//                                                                                           //
//    Yesterday you hated me                                                                 //
//    But today you need me                                                                  //
//    Today you see me                                                                       //
//    Today you are me                                                                       //
//    And I am you                                                                           //
//    Equalized by the same denominator                                                      //
//                                                                                           //
//    But tomorrow you'll divide                                                             //
//    You'll distance yourself from me;                                                      //
//    Not by a statewide decree                                                              //
//    But by your fears of yesterday                                                         //
//                                                                                           //
//    Because yesterday I was illegal                                                        //
//    Today I am essential                                                                   //
//    But tomorrow I'll be forgotten                                                         //
//                                                                                           //
//    - George Figueroa                                                                      //
//                                                                                           //
//                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////


contract nonES is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
