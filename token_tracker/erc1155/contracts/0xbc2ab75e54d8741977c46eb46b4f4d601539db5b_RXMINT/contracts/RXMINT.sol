
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: INDUSTRY RX MINT PRESCRIPTION
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████╠╠╠╠╬╬╬╬╬▒╠╬╠╬╠╬╬╠╠╬╠╬╬╬╬╬╬╬╬╬╬╬╠███████████████████████    //
//        █████████████████████╬╬╬╬╬╬╬╬╬╬╬╬╬╠╠╠╬╬╬╬╬╠╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╠╣███████████████████    //
//        ████████████████████▓▓╬╬╠╠╬╬╬╬╬╬╬╬╬╬╬╠╠╬╠╠▒╬╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╠██████████████████    //
//        ██████████████████▓▓▓╬╬╬╣██╠╬╠╠╠╬╬╬╬▒╬╠╠╬╬╬╬╬╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬║████████████████    //
//        ██████████████████▓▓╬╬╬╬╟███▌,'╙╙╝╬╠╠╠▒╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╠▒▄╠╬╬████████████████    //
//        █████████████████▓▓╬╬╬╬╬╣████'ⁿ⌐    '╙╙╬╬╬╬╬╬╬╠╬╬╬╬╬╝╩╙` «▐██╠╬╠║███████████████    //
//        ██████████████████╬╬╬╬╬╬▓║████,      ▄████▒╬╬╬╬╬║███µ    .██▌╬╬╠╫███████████████    //
//        ██████████████████╬╬╬╬╬╬╬▓╬██████████████╬╬╬╬╠╬╬╬█████▄▄███▀╬╬╠╠████████████████    //
//        ███████████████████╬╬╬╬╬╬╬╬▓╬╬████████▀╠╬╝╝╩╝╝╬╬╬╬░╬████▀╬░╠╬╬╠█████████████████    //
//        ████████████████████╬╬╬╬╬╬╬╬╬╬╠╬╬╬╬╬╬╩╜   ²⌐     ╙`'╙╬╬╬╬╠╠╬╬║██████████████████    //
//        ██████████████████████╬╬╬╬╬╬╬╠╠╠╠╠╠╠╦φ▒▒╬╠╬╬▒▒▒╬╬▒╬φ╦φ╠╠╠╬╠╣████████████████████    //
//        █████████████████████████▓╬╬╬╬╬╠╠╠╬╬╬╬╠╠╬╠╠╠╠╠╠╠╬╬╠╬╠╬╬╬████████████████████████    //
//        ██████████████████████████████████▒╬╬╬╬╬╬░╬╬╬╬╬╬║▄░║████████████████████████████    //
//        ████████████████████████████████╬╬╬╠╬╬╠╠╠╬╬╬╬╬╬╬╬╠▒█████████████████████████████    //
//        █████████████████████████████╣▓████▓▓▓▓▄▄╬▄▄▓▓▓▓▓█▀╫█╬║█████████████████████████    //
//        ███████████████████████████╬╬╬╠╬╬╠╬╬╠╠╬╬╬╬╣╬╬╬╬╚╠╬╬╬╬╠▓█████████████████████████    //
//        ██████████████████████████╬╢╢╢╬╬╬╬╬╠╠╠╬╬╬╠╠╬╠╬╠▒╠╣█▓▓╣╬╠╠███████████████████████    //
//        ███████████████████████▓███▓▓▓▓▓▓█▒╠╠╬╬╠╠╠╬╠╬╬╬╬▒╠╬╬╬╬╬╬╬╬║█████████████████████    //
//        ████████████████████▓█╬╬╬╠╬╬╬╬╬╬╬▒╠╬╬╠╬╬╬╠╬╠╬╬╬╠║▒▒╬╬╬╠╬╬╬╬█████████████████████    //
//        ██████████████████████╬╬╬╬╬╬╬╬╬╠╠╣▓██▓▓╣▓╬░╠╬╠╣╣▓▌▒╠╬╬╬╬╬╠▓█████████████████████    //
//        ███████████████████████▓╬╬╠╬╬╠▒▓█╬╬╠╬╠╬╫█▓░╠╣██╬╠╬██████████████████████████████    //
//        █████████████████████████████░╠╠╬╠╠╬╠╬╬██▒▒║╬╬▒╠╬╬╠╬╢╣▓█████████████████████████    //
//        █████████████████████████████▓╣╬╠╠╠╬╠╠╬███╬╠╣╬╣▓▓▓▓▓▓╣╬█████████████████████████    //
//        ██████████████████████████╬╠╬╠█▓▓▓╬╬▓▓▓█╬║╬╬╠╬╬╬╬╬╬╬╬╬╬╠║███████████████████████    //
//        ████████████████████████╬╬╬╠╠╠╠╬╬╠╠╬╬╬╬╣▓▓▒▒╬╬╬╬╬╬╬╬╬╬╬╠╬███████████████████████    //
//        ████████████████████████▓╬╬╠╠╬╬╬╠╬╬╬╬╬║██╬╠▒╬╬╬╬╬╬╬╬╬╬╬╠╣███████████████████████    //
//        █████████████████████████▓╬╬╠╠╠╬╬╬╬╬╬╠╬╠╬▓▓╣╣▓▓▓╬▒▒╬╣▓▒╣╬╬╬╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        █████████████████▓▓▓▓▓▓█▓▓█▓▓╣▓▓▒▓▓▓▓╣╣╣╣╣╣╣╣╣╣╣╬╬╬╬╬╬╬╣╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract RXMINT is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
