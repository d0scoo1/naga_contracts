
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: POMA
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//                                                                                         //
//                         ]╣╬╬╬╬╬▒╠'╠╬╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╬░  ║▓▓╬╬╬╬╬░   '        '    //
//                       ║╬╬╬╬╬╬▒╡ ╚╬╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬░░   ▓▓╣╬╬╬▒▒                   //
//        ░              ║╬╬╬╬╬▒░╠ ¡╬╬╬▓▓▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▒[   ║▓╣╣╬╬╬▒░                  //
//        ░              ╣╬╬╬╬╬▒░▒,╣╬╬▓╬╬╬╬██████████████╬╬╬▓µ  └▓▓╬╬╬╬╠░                  //
//        ░░             ╠╬╬╬╬╬▒▒▒▓▓▓▓╣╬╬╬╬╬╬╬╬▓█▓▓▓█╬╬╬╬╬╬╣╣╬▓▄ ╟▓╬╬╬╬╬░│                 //
//        ░│░            ╠╬╬╬╬╬▒╠▓▓▓▓▓▓╬╬╬╬╬╬╬╬▒╠███╬╬╬╬╬╠╠╠╠╠╣▓▓µ▓╬╬╬╬╬▒'                 //
//        ░││            ║╬╬╬╬╬╬╣██▓▓▓╬╬╬╬╬╬╬╬╬▒▒▓█╬╬╬╬╬╬╬▒▒░Γ╚╠▓▓╣▓╬╬╬╬▒                  //
//        ░│ '           ╠╬╬╬╬╬╬▓█▓▓▓╬╬╬╬╬╬╬╬╬╬▒╠╣█╬╬╬╬╬╬╬╠▒░░░░╠╣▓╟▓╬╬╬▒                  //
//        ││'            ]╬╬╬╬╬╣██▓▓▓╬╬╬╬╬╬╬╬╬╬╬╬╣█╬╬╬╬╬╬╬╬▒▒░░ ⌠╟▓▒█▓╬╬╬░                 //
//        │││  .          ╬╬╬╬╬▓██▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╣█╬╬╬╬╬╬╬╬╬▒▒░░¡╠▓▌║█╬╬╬░                 //
//        │''             ╬╬╬╬╬▓██▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬█╬╬╬╬╬╬╬╬╬╬▒░░░╠▓▓ █▓╬╬▒                 //
//        │'''            ║╬╬╬╬╬╣█▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╣█╬╬╬╬╬╬╬╬╬╬╬▒░░╠▓▓╓╬╬╬╬╩                 //
//        │.               ╢╬╬╬╬╬╬█▓▓╬╬╬╬╬╣╬╬╬╬╬╬╣█╬╬╬╬╬╬╬╬╬╬╬▒░φ╣▓█╬╬▒░ΓΓ                 //
//        │'                ╟╬╣╬╬╬╬█▓▓╣╣╬╬╬╬╬╬╬╬╣██▓╬╬╬╬╬╬╬╬╬╬╬╠╣▓█╬╩░░▒"                  //
//        │'                ╚╠╬╬╬╬╬╬█▓▓╬╬╬╬╬╬╬╬▓█████▓╬╬╬╬╬╬╬╬╣▓▓█▓╬░╚╙                    //
//        │'                 ║╬╬╬╣╬╬╬▓▓╬╬╬╬╬╬╬╬╬▓╔██▓▓╬╬╬╬╬╬╬╬╣▓██╬▒;'                     //
//        ''                 ▐╣╣╬╬╬╣╬╬╣▓╬╬╬╬╬╬╬╣▓██▓▓╬╬╬╬╬╬╬╬╬▓▓╬╬╬▒"                      //
//         '''                 ╚╬▓╬╬╬╣▒▓╬╬╬╬╬╬╬╣╣██▓▓╬╬╬╬╬╬╣▓▓╬╬╬╩╔▒                       //
//          ''                  ╟╬▓▓╬╬╬▓▓╬╬╬╬╬╬╬╣██▓╬╬╬╬╬╬╣▓╬╬╠╬╬░╬░                       //
//           '                  ╚╬╬╬╬▓╬╠▓╬╬╬╬╬╬╬╣██▓╬╬╬╬╬╬╬╬╬╬╬╚╙ ╠░                       //
//                               ╠╬╬╣╬╬╬╬╬╬╬╬╬╬╬▓██▓╬╬╬╬╬╬╬╬╬╩░░   `                       //
//                               └╬╬╬╬╬╬╬╬╬╬╬╬╬╣▌╟█▓╬╬╬╬╬╬╬╬▒░░░                           //
//                                ╙╬╬╠╬╬╬╬╬╬╬╬╬╣▌╟█▓╬╬╬╬╬╬╬╬▒░░                            //
//                                 ╠╬╬╬╬╬╬╬╬╬╬╬╣▌▓█▓╬╬╬╬╬╬╬▒░░                             //
//                                                                                         //
//                                                                                         //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////


contract POMA is ERC721Creator {
    constructor() ERC721Creator("POMA", "POMA") {}
}
