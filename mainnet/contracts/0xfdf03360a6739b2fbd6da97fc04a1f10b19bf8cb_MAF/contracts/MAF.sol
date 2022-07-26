
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: M.emories A.re F.orever
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ███████████████████████████████▀▀▀█░╙└.,│█└└╙╙╙╟█▀██████████████████████████████    //
//        █████████████████████████▀▀╙█.░;░░╫▌φφφ░░█φ░≥░░█▒,'..╙█▀████████████████████████    //
//        ███████████████████████∩░;;¡╟█░▄▄▄▓█▓▓▓▓▓█▓▓▓▓▄█▄▒░░░▓▌;░║██████████████████████    //
//        ████████████████████████░░▄▓▓█████████████████████████▄░▓███████████████████████    //
//        ███████████████████████╬████▓███████████████████████████▓▓███╬╬╬╬███████████████    //
//        ██████████████░╬▓███╬╠╢╬╬████▓█████████████████████████╬▓██╬╬╬╬╬▓█╬█████████████    //
//        ████████████▄╠╠╬╬╬╬╬▓▒╠╬╣╬╣███████████████████████████╬╬█╬╬╬╬╬▓╬╬╬╬╬╬███████████    //
//        ██████████▀╠╬▓▓▒╠╠╠╠╠╬╣╬╬╣╬╬████████████████████████▓╬▓█╬╬╬╬╬╬╬╬╬╬╬╬╬▓██████████    //
//        █████████░╠╠╬╠╠╬▀▓▒╠╠╬╬╬╬╬╬▓╬██████████████████████▓╬█╬╬╬╬╬╬╬╬╬╬╬╬▓▓╬╬╠╬████████    //
//        █████████▓▄▒╠╠╠╠╠╠╬╬╬╬╬╬╬╣╬▓██████████████████████╬╣██╬╬╬╣╬╬╬╬╬╬╬╬╠╠╠╬╬╠░███████    //
//        ███████░╠╠╬╬▀▓▒▒╠╠╬╬╬╬╬╣▓▓█▓╬╬╬██████████████████╬╬╬▓╬╬█▓╬╬╬╣╬╬╬╬╠╠╬╠▒▓▓▓▀██████    //
//        ██████░╠╠╬╠▒╠╠╠╠╬╢╬╬╬╣▓╣▓╬╬╬╬██████████████████████▓╬╬▓█▓▓▓╣▓╬╬╬╬╢╣╬╬╬╠╠╬╠╠█████    //
//        █████▓▀▓▓▓▄▒▒╠╠╠╠╬╬╬╬╣╬╬╬╬╬██████████████████████████▓╬╬╬███╬╬╬╬╬╬╠╠╠╠╠╠╠╠╠╫████    //
//        █████▒╠╠╠╠╠╬╬╬╬╢╬╫╬╣▓▓█╬╬▓█████████████████████████████╬╬╬╣▓█▓╬╬╬╬╬▒╬╫╣▓▓▀▀▀████    //
//        ████▌╠╠╠╠╠╠╠╠╠╠╬╬╬╬▓▓█▓▓╬██████████████████████████████▓╣▓██▓▓╬╬╬╬╬╬╠╠╠╠╠╠╠▒▓███    //
//        ████▓▀▀▓▓▓▓╬╬╬╬╫╢╬╣▓╫▓╬╬╣███████████████████████████████╬╬╬██▓▓╬╬╬╬╬╠╠╬╬╠╬╠╠╫███    //
//        ████▒╠╠╠╠╠╠╠╠╠╠╠╠╬╬╬█▓╬╬╣███████████████████████████████╬╬╬╬╬▓▓╬╬╬╬╬╬╬╬╬╬╬╬▀▓███    //
//        ████▒╠╠╬╠╠╠╬╬╬╬╬╬╬╬╬▓▄▓╫╫███████████████████████████████▀▓▓██▓▓╬╬╬╬╬╬╠╬╬╠╬╠╠╫███    //
//        █████▀▀▀▀╬╬╬╬╬╬╬╬╬╬╣▓█╬╬╬██████████████████████████████▓▒╬╬█▓▓╣╬╬╬╣╣╫╬╬╬╬╬╠▒▓███    //
//        █████░╠╠╠╬╠╠╬╬╬╬╠╬╬╣╫█▓╬╬╠████████████████████████████▒╠╬╬╬█╬▓╬╣╬╬╬╬╬╬╬╬╬╬▀▀████    //
//        █████▒╠╠╠▒╣▓▓╫╬╬╬╬╬╬╬╣█╬▓▓╬▓█████████████████████████▒╬▓▓██▓╬╬╬╬╣╬╬╬╬╬╬╬╬╬╠╫████    //
//        ██████▓▀╬╬╬╬╠╬╬╬╬╬╬╬╫╬▓██╬╬▓▓████████████████████████▓╬╬▓▓▓╬╬╬╬╬╬╬╬╬▓▓▓╬▒╠½█████    //
//        ███████▒╠╠╠╠╬╬╬▓╣╬╬╬╬╬╬▓███▓╬▓██████████████████████▓▓███▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬▀██████    //
//        ████████╚▒▒▓▓╬╬╬╬╬╬╬╬╣╬╬▓████████╬╬╫╬╬████▓╬╬▒╬╬████████▓▓╬╬╬╬╬╬╣▓▒▒╬╬╬╠▒███████    //
//        █████████▀╬╠╠╬╬╬╬╬▓╬╬╬╣▓▓▓██████████▓▓█╣▓╣█▓╬█╬█▓█████▓██▓╬▓╬╬╬╬╬╬╬╬▓▓▄▒████████    //
//        ██████████▒╠╠╠╬╣▓╬╬╬╣▓▓╬▓█▓███▒▓╢████▓███▓███▓█▓▓█╬╟███▓╣██▓╬▓▓▒╬╬╬╬╬╩╟█████████    //
//        ███████████▓▄█╬╬╠╬╣▓▓▓██▓▓███░╣▒▒█╬╬╬▓╬╬╬╣▓╬╬╬▌░░╟▓▌╟▓█╬█▓▓██▓╬██▒╠╠▒███████████    //
//        █████████████▓╠╠╠╬╬╢██▓▓▓███φ╣▒╚█▒╠╠▒█░╠╠╣█╬╠╠╫▒╠▒╟╣▌╚╬█▓╬█╬▓╬╬╬╬╬██████████████    //
//        ███████████████▓▒╟█╬╬▓▓███▌▒╣▒░╫▌░░╚▐▌░╚╚╩█╚╚╚Γ█░░░╠╣█╙╬▓▓╬█▓╬╬╬╠▓██████████████    //
//        ██████████████████▄╠▓▓████▒╬▒░▐█░░░░╫▒░░░░█░░░░╟▌░░░╟╣█▓▓▓╬╬╬█▄█████████████████    //
//        ████████████████████████▓╬╬▓▓▓█▒▄▄▒░█░░░░░█░░Q▄▄█▓▓▓▓▓╣█▓▓▓▓████████████████████    //
//        ██████████████████████████▓╬╣██╬╬╬▓╣█▓▓▓▓▓█▓▓▓╬▓╣█▓▓▓╬▓█████████████████████████    //
//        █████████████████████████████████▓╬██▓▓▓▓▓██▓╬╬▓████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract MAF is ERC721Creator {
    constructor() ERC721Creator("M.emories A.re F.orever", "MAF") {}
}
