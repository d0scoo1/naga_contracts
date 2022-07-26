
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: TRIPTYCH CABAL
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//                                                                                         //
//                                           ,,«≡»-,,,,,                                   //
//                                  -φφ≥░░"!""""""   ░'''^'"Γ░░░≥,                         //
//                           ,φ░░░╚╙░"'"╠░,,,..,;,,╓Å╩╙`     ¡░ .''└≥,                     //
//                       ,≤░░;╓╓φ░;. .;ê╙`      ╙╟▓╙      ,≡╩╙`       '░≥                  //
//                    ╓░φ▄φ╩╙`    ╙φ▄╩`         ,╙       φ              '"                 //
//                  φ└ ╙╟╨   .     ]▀           "      .'    '░    .'      ░»              //
//                «φ░┐ ╠⌐   ²▄∩   ]╩    ;      ]      .⌐       ║##ê╝φ░     ]░'≥            //
//              ,░░╠░'φ░   .φ░    ░    ;░     ;░      φ      ;░`      └░ε    '  ≥          //
//              ╩░▒░.░░┐.¡¡φ▒'   ;░   .░.     ░      ;Γ     !      .   '¡░    ░..!,        //
//             ╠▒╩░░░φ░░░░░╠░.  .░'...φ░┐ . ..░░...░░░......    ...]░...φ░   .φ░░░φ        //
//            ║╠▒░░░φ╬░░░░░╬░░┐.┌░░┌¡░▐▒░┐.┌.ê╙░░░▒░░░¡¡¡¡░░¡;;░░╓φ╙░░░░╩▒;;;φ╩░││░≥       //
//            ╬▒▒▒▒╩╩╠░░░░░╬░░░░░░░░░φ╣▒░░░¡¡¡│░░░╙▒░░░░░░░░░░░▄╩░░░░░░│.  └╙╙╠░░░░░░      //
//           ║╬▒▒▒▒░░░░░▒▒▒▓▒░░░░░░░░░╚▓▒▒░░░░░░░φ▒╬▓▓▄▓╣╣╣╣╣▓█▒░░░░░░░░░░░░░░░╚▒░░░░φ     //
//           ╫▓╬╬▒▒▒▒▒▒▒▒▒▒╠▓▒░░░░░▒▒▒▒▓▌╬╠╠╠╠▒▒▄▓▀▀╙╙││░░░░░░││░░░░░░╠▒░░░░░░░░╠▒░░░░▒    //
//           ╫╣▓╬╬╬╬╬╬╬╬╠╬╬╬╬▓╬╬╠╬╬╬▓▓▓███▓▓▓▀╙╙┘││││░░░░░░░░░░░░░░░░▒╫▒▒░░░░░░░╠▒░░▒▒Γ    //
//           ╣╣╣▓█▓▓▓▓▓╬╬╬╬╬╬▓▓██▓▀╩╙Γ░░Γ│╙╩│░│░░░░░░░░░φφ▒▒▒▒░░φφφ▒╣╬╬▀╬▒▒▒▒▒▒▒╠╠▒▒▒╠     //
//            ▀▓▓▓▓▓▓▓▓▓▓▓█▓▓██▀Γ░░░░░░░░░░░░░░░░φ░░░░φ▒▓▀╬╩╬╣╣▓╬▓▓▒▒Γ░░Γ╚▓╬▒░▒▒╠╬▒╠╠▌     //
//             ╙▓▓▓▓█▓▓▓▓▓▓▓█╬╠▒▒░░░░░╠▒░░░░░φφ▒╣╬╩╣╣╣╣╬▒▒░░▒▒▒╠╟█╬╠▒▒φφ░░░╬▒▒▒╠╠╬╬╬╬⌐     //
//              └▀╬▓╣╬██████▓╬╬╬╠╠▒▒╣╣▓╣╣╣╣╣▓╬╬╠▒▒▒▒▒╠╠╠╠╠╠╠╠╠▒▒╠╠╬╠╠╠╠╠╠▒▒╠╬╬╠╬╬╬╬╬╬      //
//                 └╙▀▀▓▓███╬╬╬╬╬▓╬╬╬╠╠╠╠╠╠╠╠╠╠╠╠╬╬▒╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╠╣╬╬╬╬╬╬╣       //
//                       ╙▀▓╬╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓▓╬╬╬▓▓▓▓█▓▓╬╬╬╬╬╬╬╬╬╬╬▓╬╬╬╬╬╬╬╬╬╬▓        //
//                          ▓▓▓▓╬╬╬╬╬╬╣▓╬╬╬╬╬╬▓╬╬╬╬╣▓▓▓████████▓▓▓▓▓▓▓▓▓▓╬╬╬╬╬╣▓▓▓         //
//                           ▀▓▓▓▓▓▓▓▓▓╬╬╣╣╣▓▓▓▓▓█████████▓▓╬╬╬▓█████████▓▓▓▓▓█▓─          //
//                            └▀███████████████████████▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬▓████▌└─             //
//                                └╙╙╙╙└└'▀████████████▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╣╣╬▓                //
//                                          └╙╙▀╙▀████▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╙                 //
//                                                 ╙███▓▓▓╬╬╬╬╬╬╬╬╬╣╬╬╣▀                   //
//                                                    ╙▀███▓▓▓▓▓▓▓▓▓▀╙                     //
//                                                         ─└╙╙╙╙─                         //
//                                                                                         //
//                                                                                         //
//                                                                                         //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////


contract CABAL is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
