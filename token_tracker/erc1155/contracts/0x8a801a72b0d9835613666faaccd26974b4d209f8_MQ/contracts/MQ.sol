
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: MetaQuest
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    MetaQuest Contract                                                                  //
//                                                                                        //
//    ████████████████████████████████████████████▓██████████▐████████████████████████    //
//    █████████▓▓▓▓▓▓███▓████████████████████████████████████╠████████████████████████    //
//    ████████████▓▓╬╠▒▓█████████████████████████████████████░╟███████████████████████    //
//    █████████▓▓▀░╠▒╬▓▓████████████████▓███▀╠╣▓▓▓███████████░╠███████████████████████    //
//    ████████▓▓▒░▒▒▒▓▓▓████████████████████▒░╙╠╠████████████▒╠╫██████████████████████    //
//    ████▓▓▓▓▓░▒▒╩▒╟▓▓████████████████████▒ ,φΓ╠╬╣╫▓████████▌╠▒████████▓█████▓███████    //
//    █▓▓▓▓╬╬╬░▒▒▒░░▓██████████████████████╟▒└╚ε]▓╠▓█╫██████▓▌╠╠╟╬╣▓▓▓▓▓▓▓▓▓█▓▓▓██████    //
//    ▓███▓▓▓░φ▒╠▒░j███████████████████████░▓▄╚▀╟█▓▓█▓╬▓█▓▓▓╬╠░╠▒╬╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████    //
//    ████▓▓▌φ▒░╠▒░j███████████████████████▓╚▓█▒╠▓▒╬▓██╩╠╣▓█▓╣░╠╬╫▓▓████▓███▓▓▓╬╬▓▓███    //
//    ██████░░╠▒▒░░░██████████████████▓╬╬▓╟▌φ▓╫▒╣▓▓╬╬█▒▓╣▓▓╫██▒╠╬╬█████████████▓╬╣▓▓██    //
//    ██████░░╠╠▒░░░█████████████████░▓▓█▓▓╟▓▓▓▀▀▀▒╣▓▓▓██████▓▒╚╬╬╣██████████████▒╠╬▓▓    //
//    ██████░▒▒╠╠▒▒░└███████████████╠╬▓╣╫╣▓██▓▓▓▓▓▓╬▓█▓╬▓▓▓▓██▓░╠╬╬███████████████████    //
//    ██████░▒▒╠╠▒▒▒▒░▀██████████████╬▓▓█╬▓█╣▓╫▓██████╬╫▒╙╠▓▓██▒╠╠╬╬╣▓███████▓████████    //
//    ██████!╠╠╠╠╠╠▒╠▒φ░█████████████▒╚╟▓▓▓█▌█▓▓█████▓╣▓▓▄!╠▒╬╬╬╚╚╠╬╫█████████████████    //
//    ██████∩φ╚▒╚╠╠╬╠╠▒█████████████▀]╣╣██╩▓▌██▓██▓╬╬╣╬╬╬╬▒ ╚╬╣╠▒▒░╠╬████████▓████████    //
//    ██████▌████▒╠╠╬╬╠╬████▓███▌▒╠▒]╣▓███▒█╬█▓███▓█▌▓╬╬╬╬╣▓▄▓▓███░╠╣█████████████████    //
//    █████████▀▀░╠╣▓▓▓▓▓▓▓█████▓█▒▓█▓█████╬█▀▓█▓████╠╬╬╬╬▓▓▓█▓██╬φ╟▓███▓██████▓▓▓▓▓▓▓    //
//    ████████▌▒▒╠╣╣█████████████▓████████╩╠#╬╬╬╫▓████╬█▓╬╣▓▓╬███▌╠╣██████████▓█▓▓████    //
//    ██████████████▌▓██████▓▓██╬████████▒╬▒╬╣╬▓▓▓▓████▓██╬╬╬╬▓▓╬██▒████▌███▓▓████████    //
//    ██████████████▓██████████████████▌╫▓▓▓▓╬██▓╬▓▓▓███╣██╬╬╬╬╬╬╬╟▌████▌╫█▓▓▓▓▓▓▓▓▓▓▓    //
//    █████████████████████▒▓█████████▓╣███▒▓█▓█╬██▌█████▓█▒╬╬╬╬╬╟█╠█████▓▓▓▓▓▓╬╬╬╬╬╬╬    //
//    █████████████████████▓▓▓███████▓╣████╣╣█▓██╣██▓███████╬╬╬╬╬╣╙▓╬▓██╫▓▓▓▓▓╬╬╬▒▒▒╠╠    //
//    ███████████████████████████████▓█████▌╠███║█████▓▓▓██████████▓▒█▓▓╬█████████████    //
//    █████████████▓██▓████████████▓▓████████╬▓▓▓▀██████╬███████████▓███▓█████████████    //
//    █████████████████████████╬╬╬╬╫█████████╬███╩███████╣██████████████╬█████████████    //
//    █████████████████████████╬╬▓█████████╬╠╫██▓████████╬███████████▓█▒╟█████████████    //
//    █████████████████████████▓██▓████████▓█▓██▓█████████████████████▌╫▓█████████████    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract MQ is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
