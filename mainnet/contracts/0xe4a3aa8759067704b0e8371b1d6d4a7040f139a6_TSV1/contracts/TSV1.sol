
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Taking Shots Vol.1
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//           ▄φ░╬╣▓██████▒║╣▓ ]███░                                   "╫██╣█║██▓██╣███▒']     //
//             ╙║▀██████ ║╣██▄╣█▓▄▄,╔                                å╣█████▌▄║▌]███▄██▓█▄    //
//               ╓███╠█▓▐▄▒█╩]▓█▓████▀              ▐▓▓  ▓▓██½▄▄     ╩ ║▓█▓██╬░▌║█║█╠█████    //
//            ╓▒██████▓█████▀╙╙╙▓████▌Γ            ]▓███ ,█████▌        ╙└ ╚█▄║███▓║╬╣███▀    //
//            ▄█████████▓╣╬▓▌╙"φ╣▄╣▄ `          ,╓φ▓█▀█▓█╠█████▄╖     ▄██▄▄▓╚╣█████╝█╣██▓▄    //
//             ╠▓╬████╠▓▓▓▓█████████▀▒          ╙╝███▒ ╩█▓▓██▓▀,▓██╠,▓╙╙███╬⌐▐╩████▄╣█╬╝██    //
//        ≥     φ███████████▓▓███▒▄█▌ φ▓φ        ╙└▀╩╙"@▄║███▒╫▓████    █████████████▓█ ╚╣    //
//        ░     ╩╙╠██████████▓██████╛╙▀  ░                   »ª▀█▀      ║█▀╙╚█████████        //
//        ╓▄█▄╓  ]██████╣▓██████▀`               ,,              ░≥,    ╩" ▄▓█╩██████▌        //
//        ███▀╩  ⌠└ ║██╬╣███▀`            ▄▄▓▀╙╙ ╠╙╠ `"▀╗▄           ░≥, ]█▌║▌ ║███▌╚█        //
//        ██▓▄▄     ╙╝╝▓▌╚╙            ╓▓╙ ▐ ╠   ╠ ╠   # ∩ ▀▄             ╙    ╙╚╙█▌ ╙        //
//        ▓████'      ▐▀              å▌≥  j └   ▒ ⌠⌐ ╔    ░╙▓             ░,     ║█          //
//        ████╙╙      │              ]▌╙ ¼    ╙Qj   ≥:  :   ╠^▌              ≥     █µ         //
//        ██╣ ╙      ░                █ ½ ^Ç░   ▓∩░░║▒  ▐;░φ φ▒ ░'            ░    ║█         //
//        ╙╙╩       ▐                 ╙▒▄ε  ▒ⁿ▄╩ ╙▄" ╠  ║ ]░φ╬ ░                    ▓µ        //
//                  [                  ╙╬╬▒φ ]╛▐φ  % ≤▒,║#╬╬╩ "│ .                  ║█        //
//                             .'  ¡     Σ▓╠╬╩▓▓█▓▓▓▓▓╬╩╠╔╩   ░ '"                   ▓▌       //
//                 ╔ε           !     '   ╙╣╬╓╬╣╬╣█╬▓╬ ║╠╩  '  '              ,╩     ║█       //
//               ]▓█╬▓▄▄,   '░'            ╠╣║╣▒╬║╬▒▒╠╠▒╚        ░     .,,▄#╝╙        █▌      //
//               ║█╬╠    ╙▀▀╝φ▄▄,, .    .  ║╬╩╢╬▓╬╬╣╬▒φ╠▌      . ,▄▄#╝▀╙             ▐▓█▓     //
//               ██╬▌           ║╩╙▀╝φ▄▄░░░║▒║║▓╬╬▓╣╬╬▓φ▒;,▄▄Å╝▀╙                     █▓▓ε    //
//              ▐█╣╬           .█         ╙╙╬╝╩╫▓╬▓╫╬▓╫╬▀╫▌                           ╙██▓    //
//              ▓▓╬⌐          ╓▓█▌            ""╙╣▓╩⌐"   ╫▌                            ▓▓▓    //
//             ▐█╬╬           ▓█╬▌               ╫█░     ╫▌                            ▐██    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract TSV1 is ERC721Creator {
    constructor() ERC721Creator("Taking Shots Vol.1", "TSV1") {}
}
