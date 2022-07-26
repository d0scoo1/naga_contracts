
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: bunch of thoughts
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬████▓╬╬╬▓█████████████╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓█████████████████████████████╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓██████████████████████████████████╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓██████████████░█████████████████████████╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬█████████████████░░░▓███████╫█▓███╬╬╬███▓ ╠╠█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╣▓██████████████████▓░░░░░███████╠█▓╬█▓▓ ╬╬██ ▓█╬█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╢╣▓███████████████░░░░░░░█████╬██▓╬█╠▓▓▓▓╣ ╬ ╟██╬▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╣╬╣█████████████▓▓░░░░▄▄████████████╣███▓╬▓╣▓███╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╣▓▓███████████▀   ███▓▓   ░████████████████████████▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬████████      █▓▓     ░███▓█████████████████████▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█████      █▀░      ░▀████████████████████████╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬████▄    ██░░▄    ░░░░░░████████████████████╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬███████████████▓▒▒░░░░░░░█████████████████╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬███████████████▌░░░░░░░███████████▀╟███╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣██████████████▒░░░░░███████▒▒▒│▄████╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬██████░░░░░░░░░░██████▓▓▓▀░███╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬████████▓░░░░█▓░▓████▓▓▓░░░╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█████████▓▒▓██▓▓███░░░ ,  ╟╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╟████████████████▓░░░░░░,,  ╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬████████████░░░░░░░░░░░░░  ╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█████▓▓▓▄▄░░░░░░░░  ███████████▓▓╬╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬██████████████████████▓▓▓░░░░░░░. ╠█████████▓██╬╬╬╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬███████████████████████████████████░░░░░░░███████████████▓╬╬╬╬╬╬╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬╬████████████████████████████████████████▄▒▓██████████████████████╬    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬╬███████████████████████████████████████████████████████████████████    //
//    ╬╬╬╬╬╬╬╬╬╬╬╬████████████████████████████████████████████████████████████████████    //
//    ╬╬╬╬╬╬╬╬╬╬╬█████████████████████████████████████████████████████████████████████    //
//    ╬╬╬╬╬╬╬╬╬╬██████████████████████████████████████████████████████████████████████    //
//    ╬╬╬╬╬╬╬╬╬███████████████████████████████████████████████████████████████████████    //
//    ╬╬╬╬╬╬╬╬████████████████████████████████████████████████████████████████████████    //
//    ╬╬╬╬╬╬╬█████████████████████████████████████████████████████████████████████████    //
//    ╬╬╬╬╬╬╬█████████████████████████████████████████████████████████████████████████    //
//    ╬╬╬╬╬╬╬█████████████████████████████████████████████████████████████████████████    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract THOTS is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
