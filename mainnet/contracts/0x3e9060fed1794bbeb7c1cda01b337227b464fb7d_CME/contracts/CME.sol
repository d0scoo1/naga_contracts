
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Cassi Moghan Editions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀▓▓▓▓▌▒▌▌▓▓▓▓▓▀▓▓▌▒▀▌▒▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░▄▓▓▀▀╬╬╣╬╬╟╣▒▒▒▀▌▌╫▒▒▒╣▓▓▌▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▌▓▓▓▓▓▓▓▓▒╫▒░░░▒▒╣╠╬▒▒╣▒╣╬╬╬▓▓▒▒▓▀▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▌╣▌▓▓▓▓▓▓▀╫    //
//        ▓▓▓▓▓▓▓▌▀▓▓▓▓▓▓▓▓▓▓▓▓▀▓▓▓▓▀▒▒╝≤╩░╣▌╬╗╣▒▒▀▌▓▓▓▓▓▓▓▌▌╬▄╣╣╣▒╣▒╣▌▀▓▓▓▓▓▓▒▓▓▓▓▓▓╬▓▓╬▓    //
//        ▓▓▓▓▓▌▒▌╬╬║█▀▓▓▓▓▓▓▓▓▓▀▓▓▀╝å░░░ ░╩╟╬▄▒▓▓▓▓▓▓▓▓▌▓▓▓▓▓▌▀▌╣▌▒▓▓╬▌▀╣▓▓▓▓▓▀▓▓▓▓▓▓▌▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▀▓▓╬▓▌▒ε─^,╒δ╟░╢▓▓▓▓▓▓▓▀▒░╣▓▓▓▓▓▓▓▓▓▓▓▌╬▌▌▓▀╬╬╬▓▓▀▐▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀░░▓╣╣▀▀╚",─"░░╣▓▀▓▓▓▓▓▓▌▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒╬╬▓▀Q▀▓▓▓█▓▓▓▌▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▌▀▓▀░  ║▀░░     ,║▒▒▌▓▓Q╬▒╬╠▀▀╠╝█▓▌▓▀▀▓Å▐▀▀╬╨▀▓▓▓▓▓▓▓▓▒▒▀╣▌█▓▌█▓▓▌▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▌▓▀█╗╜ ╠░   .»]▒▒▀▓▓▓▓▌╢▄▄░╬░╠▄▄▄╫╤▀╒╕,╦╬"╦╟╗ ║▒▀▓▓▌▌▀▀▀░░▀▓▓▓▓▓▓▓▌    //
//        ▓▓▓▓▀▓▓▓▓▓▓▓▓▀▀░╬   ╒╣Θ ╓░╗╬▌▓▓░▓▓▓▓▓▌▓▓╠▌▓▓▓▒╣░ Ö╫▀▓▓▌▓▓▓▓▓▓▓▌▓▓▓▓░░▌░╫▀▓▓▓▓▓▓▓    //
//        ▌▀▓▓╬▓▓▓▓▓▀▓▓▌╟▀-a░╦╪,e-φ╬╣Å╬▒╬║▓▓▓▌▒▓▌▀▒╬╬Å▀▀▒░   ░░░░Å╬╬▀▀▀▀▓▓▓▓▓▓▌▄░╣╫▓▓▓▓▓▓▓    //
//        ╣╢▓▓▌▓▓▓▓▓▄▄▓▓▌╬░▒▒▓▌╣║▀▌δ▄▒╬╫╣▓▀▀░░░░░░░░░╦╦╦╬░░-,,'░░░░░░╠╬╣▒▓▓▓▓▓▓╣▒╣█▀▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬▀▌ ▐"▒▒▒║█╬╪╫▀░░⌐`░"░░░░╠╬╬╬╬╬╬╬╬╬░╦░░░░░░╠╬╬╣▀▓▓▓▓▓░░╟╫▓╬▓▓▓▓▓    //
//        ▓▓▀▓▓▓▓▌▓▌▓▓▀▀▀▓▌▒▌▄▌╬▀Å "╬╟▓░░      ░╠╣▒▒▒▒╬╬╣╬╣╣▒╬╬╬╬╬╬░╠╬╬╬╬╬╬▓▓▓▌░░░▀╣╟▓▓▀▓░    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▌φ▀▀╙≥▀▀▒▀▒╖,"Å▀▌░   =φ╦╣╣╣▒▒▒▒▒▒▒▒▒▒▒▒▒▒╣╬╬╬╣╬╣▒▒▒╣▒▓▓▓▌░░░░░╢▓▀░░░    //
//        ▓▓▓▓▓▓▀▀▓▌╬░Å▒▌╣╣▌▄╬▌╣▒ ╟╬▒╩▌░░ φ╣╣▒╣╣╣▒▒▒▒▒▒▒▒▒▒▒▒▒╬╣▒╣▒▒▒▒▒▒▒▌▌▓▓▓▓▓▌░░░╬░░╞░░    //
//        ▓▓▓▓▓▓╬╬▒▓▓▓▓▌▄▀▒╣▓ê╣█▓▓▀╬▒▀▌░░╠▒▒▒▒▒▒▒╣╣▒╣▒▒╣╣▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌▌▌▓▓▓▓▓░▀▒▒░▒░░╣╬░    //
//        ▓▓▓▓▓▓▓▌╫▓▓▓▓▀▓▌▀▓▓▓▓▓▓▀╣╬▒▓▓▌░░╟▒▒▒▒╣╬╬╬╬╬╣▒▒▒╣╬▒╣╬▒▒▒▒▒▒▒▌▌▌▌▌▌▓▓▓▓▓▀╠░╠╠░]╠╬░    //
//        ▓▓▓▓▓▓▌▓▌▓▓▓▓▓▓▒▄▓▓▓▀▒▒╣▒▓▒▓▓▌░░░"╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╣╣╬╣╣╬╬╬▒▀▒▒▓▓▓▓▓▌░╠░░║╙┴╣╬    //
//        ▓╬▓▓▓▓▌▓▓▓▓▓▓▓▓▀▌▓▓▓▓▓▓▓▓▓▓▓╣▓░  ╠╬╬╣╬╣▒▒╬╬╬╣╬╬╬╣▒╣▒▌▌▌▌▌▌▌▒╣╬╬╬╬▓▓▓▓▀▌░⌠░╣▒▀▌█▀    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▓▓▓▓▓▓▓▓▓▓▌▒▓░ ╔╣▓▓▓▓▓▓▓▓▓▌▒▌▒▒▒▒▌▓▓▓▓▓▓▓▓▓▓▓▓▌╬╬▓▓▓╣▄▄▄░╠▄╦╠▀Q    //
//        ▀▓▓▓▓▓▓▓▌╙▀▀▀▀╬▀▓▓▓▓▓▓▓▓▓▓▓▓▓`]╣▓▓▓▓▓▓▓▓▓▓▓▓▓▌▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▀╩▄▓▓▓▓▓▓▓▓█▓▌    //
//        ▓▓▓▓▓▓▓▓╫▌▓▒▄  ╠▓▓▓▓▓▓▓▓▓▓▓▓▓ ╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒╬▒▄▓▓▓▓▓▓▓▓▓▌╠    //
//        ╣▓▓▓▌╬╬▓▓▓▓▌▌╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓⌠╩▀▀▀▓▓▓▓▓▓▓▓▓▓▓▓▌▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌╬╬░░░▓▓▓▓▓▓▓▓▌▌    //
//        █▓▓▓▓▄▄▓▓▓▓▓╬▌▌ ▓▓▓▓▓▓▓▓▓▓▓▓▓░░╠╠▒▓▓▓▓▓▓▓▓▓▓▓▌╬╬╬▀▓▓▓▓▓▓▓▓▓▓▓▓▌▒╬╣╬╬▄▌▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▀▀▓▓▓▓▓▌╣▀╗▓▓▓▓▓▓▓▓▓▓▓▓▓░╠▒▒▀▀▓▌▌▌▓▓▀▀▀▀╬╬╬╬╣▀▀▀▓▓▓▓▌▌▌▀▒▒╣╣▒▒▓▓▓╬▀▀▓▓▓▓╬╬▓    //
//        ▓▓▓▓▄▓▌▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀▓▓▓░░╬╬╣╣╣▒▒▌▓▓▓▌╬░░░░╬╬╬▒▒▓▓▌▌▒▒▒▒╬╬╬╣▒▒▓▓▓▓▌▓▓▓▓▓▓▓▓    //
//        ▓▓▀▄▓▓▓▓▓▓▓▓▓▓▀▓▓▓▓▓▓▓▓▓▓░░╟▓░╟╣▒▒▒▒▓▓▓▓▓╬╬╬░╬╬╬╬╬╬╬╬▀▓▓▓▌▒▒▒╣╣▒╣▒▓▓▓▓▓▌▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀▀▀  ▐▀░▓░░╟▓▄▄▒▒▌▓▓▓▓▓▓▓▓▌╬╬╣╬▒▒╬╣╬╣▓▓▓▓▓▓▌▒╣▒▒▒▓█▓▓╠▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▀▀         ƒ▄▄▓▓▓▓▓▓▀▓▒▓▓▓▓▓▓▓▓▓▓▓▓▌▌▌▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓       ,▄▄█▓▓▓▓▓▓▓▓▓▓▓▓▓╝▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ░▀▓▓▓▓▀  ╓▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓^@φ▄▀ ,â▓▌▓▓▓▓▓▓▓▓▀█▓▓▓▓▓█▓▓▓▓▓▓▓▓▌▌▌▌░░⌐░▀▀▓▓▓▓▓▓▓▓▓▓▓    //
//        ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▀▀▀,╓╦╗▌╣▌ ░▓▓▓▓▓▓▓▓▓▓▓▓▓▌▄╠░░╫▌▓▓▓▓▓▓▓▓▓▓▓▓▒╬╣╬░= ░▀█▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▀▀ ╔╦╣▒▓▓▓▓╫▓▓▓░ ░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌╬╕ ░░  ▐▀▓▓▓    //
//        ╬▓▓▀▓▓▓▓▓▓▌╬╦╦░░╠╬╬╬▀▀▌▓▓▓▓▓▌]▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒ ▄▄,░░╠░╙▀    //
//        ▒▓▓╬▀▓▀▒▌▒╬╬╬╬░░░░░░╠╣▒▓▓▓▓▓▌▐▐▓▓▓▓▓▓▓▓▓▌▌▌▌▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌]▓▓▓▓▌╬╬░░    //
//        ▓▓▓▌▒╣▒▒▒▒╬╬╬╬░░░░░╠╬╣▒▓▓▓▓▓▓╟▐▓▓▓▓▓▓▓▓▓▓▓▌▌▌▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓║▓▓▓▓▓▌▓░░    //
//        ▓▓▓╣▒▒▒▒▒╬╬╬╬╬╬╬╬╬╬▒╣▓▓▓▓▓▓▓▓╣║▓▓▓▓▓▓▓▓▓▓▓▌▌▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌╣▓▓▓▓▓▌▌░░    //
//        ▓▌▌▌▒▒▒▒╬╬╬╬╬╬╬╬╣▒▒▓▓▓▓▓▓▓▓▓▓▌╟▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▀▌▓▓▓▓▓▓▌▓░░    //
//        ▓▓▓▌▌▌▒▒▒▒▒╣▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀▀▒░░╢▓▓▓▓▓▓▓▓╬╬    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▌▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▌▒╣╣▓▓▓▓▓▓▓▓▓▓▒    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract CME is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
