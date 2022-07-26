
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Trashy Tadpoles
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ▓▓▓▓▓▓╣╣╬╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╣╣▓▓▓▓▓    //
//        ▓▓▓▓▓╬╬╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╣▓▓▓▓    //
//        ▓▓▓▓╬╣╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╬╬╣╬╣╣▓▓▓    //
//        ▓▓▓▓╣╣╬╣╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╣╣▓▓▓    //
//        ▓▓▓▓╣╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╣╣╣╣▓▓▓    //
//        ▓▓▓▓▓▓╣╬╣╣╬╬╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╣╬╣▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓╣╬╣╣╣╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╬╣╬╬╬╬╬╬╬╬╬╬╬╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╬╣╣▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓╣╬╣╣╣╣╣╬╬╬╬╬╬╬╬╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╬╣╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╬╣╬╬╬╣╣╬╣╣▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓╣╣╣╣╣╬╬╬╬╬╬╬╬╬╬╣╣╬▒▒╚╝╣╬╠╣▓╣╬▒▒S▒╝╣╩╙░╦░╙╝╣╣╬╣╬╬╬╬╣╣╣╣╣╣╣╣▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣╣╣╣╣╬╣╬╣╬╬╬╣▓████▓╣▓▓▓▓▓▓▌▄▄▒╚╠╬▒╟███▄φ▒╣╬╬╣╣╬╬╣╬╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╣╣╣╬╬╣╬▓███████████████████▌╬╠╣██▌░░░╣╬╣╣╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▓██████████████████▓╬▒│░#╢╬╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████████████████▓▒░!╙╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        █▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████████████▌░!░╠▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████████▓▓▓▓▓████████▓▒░░╚╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█    //
//        ███▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬▓▓▓████████████████▓▓╣╬╠╠▒╚╚╬█████▓▒░░╙▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███    //
//        ███▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓█████████████████▓▓╣╣╬▒▒▒╠╬████╬╠▒░╢▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███    //
//        █████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓█▓██████████████████▓▓╬▓▓╬╬╬╬▓██▓▓╣╬╠╠▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████    //
//        ███████▓▓▓▓▓▓▓▓▓▓▓▓██████▓█████▓███████████▓▓▓▓╬╬╫╣╬▓▓▓▓▓▓▓▓╬▓▓▓▓▓▓▓▓▓▓▓▓███████    //
//        ████████▓▓▓▓▓▓▓▓▓▓▓▓▓█████▓▓▓██████████████████▓▓▓▓▓╣▓█████▓▓▓▓▓▓▓▓▓▓▓▓█████████    //
//        █████████████▓▓▓▓▓▓▓▓████████████████████████████▓▓▓███████▓▓▓▓▓▓▓▓▓▓███████████    //
//        █████████████████▓▓▓▓▓███████████████████████████████▓█▓▓█▓▓▓▓▓▓▓███████████████    //
//        ██████████████████████████▓▓███████████████████████╬╫▓╬▓▓▓█▓▓▓▓▓▓███████████████    //
//        █████████████████████▓╟▓▓▓▓██████████████████▓█╫╣▓╬╣╬╣╬╣╣╬╬╣╣╣╣╬╬▓██████████████    //
//        ████████▓▓▓▓▓▓▓▓╬╬╬╬╬▓▓██████████████████████▓╢▒▒▒╬╠╩╠╬╬╬╬╣╣╣╣╬╬╬╬╬╬╬╬╬╬▓▓▓▓▓███    //
//        ╬╬╬╣╣╣╣╣╣╬╬╫╫╫▓▓▓▓▓▓▓▓████████████████████████▓▓╬╬╬╣▓▓╣▓████▓▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╬    //
//        ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓███▓▓████████▓▓▓▓▓▓╣╣╣╣╬╬╬╬╣╣╬╬╬╬╬╬╬╠╠╠╠╬╬╬╬╬╬╬╬╣╣╣╣╣    //
//        ▓▓▓▓▓▓▓▓▓▓╣╬╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╣╣╣╣╣╣╬╬╬╣╬╬╬╬╬╬╬╬╬╬╬╬╣╣╣╬╣╬╣╣▓▓▓▓▓▓▓▓▓▓▓    //
//        ████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣╣╣╣╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓╬╬╬╬╬╣╣╣╣╣╣╣╣╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██    //
//        ██████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████    //
//        ████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████████    //
//        ████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████████████    //
//        ██████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████    //
//        ████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract TTP is ERC721Creator {
    constructor() ERC721Creator("Trashy Tadpoles", "TTP") {}
}
