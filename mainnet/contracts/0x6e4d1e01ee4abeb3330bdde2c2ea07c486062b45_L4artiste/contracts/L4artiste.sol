
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Ismail Zaidy
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                            //
//                                                                                                                                            //
//    ██████████████████████████████████████████__________________██████████████████████████████████████████                                  //
//    ██████████████████████████████████░░__░░░░____________________▒▒░░░░██████████████████████████████████                                  //
//    ██████████████████████████████__________________________________________██████████████████████████████                                  //
//    ██████████████████████████░░░░__________________________________________░░░░██████████████████████████                                  //
//    ██████████████████████__________________________________________________________██████████████████████                                  //
//    ████████████████████______________________________________________________________████████████████████                                  //
//    ██████████████████________________________________________░░░░______________________██████████████████                                  //
//    ████████████████__░░__________░░░░░░__________________░░░░__░░________________________████████████████                                  //
//    ██████████████__░░______░░░░░░__░░░░░░░░░░____░░░░░░░░░░░░______________________________██████████████                                  //
//    ████████████__░░______░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░__________________░░░░░░______████████████                                  //
//    ██████████░░░░____░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░________________░░░░░░░░____░░██████████                                  //
//    ████████░░░░____░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░______________░░░░░░░░________████████                                  //
//    ████████░░░░____░░░░░░░░░░░░░░░░░░░░░░░░░░__░░░░░░░░░░░░░░░░░░░░____░░░░________░░░░░░░░______████████                                  //
//    ██████░░░░______░░░░░░░░░░░░░░░░░░░░░░░░░░____░░░░░░░░░░░░░░░░░░░░░░░░░░░░________░░░░__________██████                                  //
//    ██████░░░░____░░░░░░░░░░░░░░░░░░░░░░░░░░░░______░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░__________________██████                                  //
//    ████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░__________________░░░░░░░░░░░░░░░░░░__░░░░______________░░████                                  //
//    ████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░________░░░░______░░░░░░░░░░░░░░░░░░░░░░░░__░░░░____________████                                  //
//    ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░____░░░░░░░░______░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░__________██                                  //
//    ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░______░░░░░░░░░░____░░░░░░░░░░░░░░░░░░░░░░__░░░░░░░░░░░░________██                                  //
//    ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░________░░░░░░░░░░░░________░░░░░░░░░░░░________██                                  //
//    ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░__________________░░░░░░░░░░░░________░░░░░░░░░░░░________██                                  //
//    __░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░________________________░░____░░░░________░░░░░░░░░░░░__________                                  //
//    __░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░____________________________░░░░░░__________░░░░░░░░░░________                                  //
//    __░░░░░░░░░░░░░░░░░░░░░░░░__░░░░░░░░░░░░░░░░░░░░__________________░░░░░░░░____________░░░░░░__________                                  //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░____░░____________________░░░░░░░░________________░░__________                                  //
//    ░░░░░░░░░░░░░░____░░░░░░░░░░░░░░░░░░░░░░____________________________________░░░░__________░░░░________                                  //
//    ░░░░░░░░░░░░░░____░░░░░░░░░░░░░░░░░░░░░░__________________________________░░░░░░░░______░░░░__________                                  //
//    ░░░░░░░░░░░░░░____░░░░░░░░░░░░░░░░░░______________________________________░░░░░░░░____________________                                  //
//    __░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░____________________________________░░________________________                                  //
//    ____░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░____________________________________________________________                                  //
//    ██__░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░__________________________________________________________██                                  //
//    ██__░░░░░░░░░░░░░░░░░░░░░░__░░░░░░░░░░░░░░░░░░______________________________________________________██                                  //
//    ██____░░░░░░░░░░░░░░░░░░░░__░░░░░░░░░░░░░░░░░░______________________________________________________██                                  //
//    ██____░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░______________________________________________________██                                  //
//    ██▓▓______░░░░░░░░░░░░░░░░░░░░____░░░░░░░░░░░░____________________________________________________▓▓██                                  //
//    ████______░░░░░░______░░░░░░░░____░░░░░░░░░░░░░░░░________________________________________________████                                  //
//    ██████______░░░░░░______░░░░______░░░░░░░░░░░░░░░░______________________________________________██████                                  //
//    ██████__________________░░░░____░░░░░░░░░░░░░░__________________________________________________██████                                  //
//    ████████______________░░░░░░░░____░░░░░░░░░░░░________________________________________________████████                                  //
//    ████████______________░░░░░░░░░░░░__░░________________________________________________________████████                                  //
//    ██████████______________░░░░░░░░__░░░░______________________________________________________██████████                                  //
//    ████████████______________░░░░____░░░░░░__________________________________________________████████████                                  //
//    ██████████████__________________________________________________________________________██████████████                                  //
//    ██████████████▓▓______________________________________________________________________▓▓██████████████                                  //
//    ██████████████████__________________________________________________________________██████████████████                                  //
//    ████████████████████______________________________________________________________████████████████████                                  //
//    ████████████████████▓▓__________________________________________________________██████████████████████                                  //
//    ██████████████████████████__________________________________________________██████████████████████████                                  //
//    ██████████████████████████▓▓▓▓__________________________________________▓▓▓▓██████████████████████████                                  //
//    ██████████████████████████████▓▓▓▓__________________________________▓▓████████████████████████████████                                  //
//    ████████████████████████████████████▓▓████__________________██████████████████████████████████████████                                  //
//                                                                                                                                            //
//    ██████╗ ██████╗██╗    ███████╗   ██╗██████╗     ████████╗██████╗     ██████████╗  █████████╗    ███╗   ███╗██████╗ ██████╗███╗   ██╗    //
//    ██╔══████╔═══████║    ████████╗  ████╔════╝     ╚══██╔══██╔═══██╗    ╚══██╔══██║  ████╔════╝    ████╗ ██████╔═══████╔═══██████╗  ██║    //
//    ██████╔██║   ████║ █╗ ██████╔██╗ ████║  ███╗       ██║  ██║   ██║       ██║  ████████████╗      ██╔████╔████║   ████║   ████╔██╗ ██║    //
//    ██╔══████║   ████║███╗██████║╚██╗████║   ██║       ██║  ██║   ██║       ██║  ██╔══████╔══╝      ██║╚██╔╝████║   ████║   ████║╚██╗██║    //
//    ██████╔╚██████╔╚███╔███╔████║ ╚████╚██████╔╝       ██║  ╚██████╔╝       ██║  ██║  █████████╗    ██║ ╚═╝ ██╚██████╔╚██████╔██║ ╚████║    //
//    ╚═════╝ ╚═════╝ ╚══╝╚══╝╚═╚═╝  ╚═══╝╚═════╝        ╚═╝   ╚═════╝        ╚═╝  ╚═╝  ╚═╚══════╝    ╚═╝     ╚═╝╚═════╝ ╚═════╝╚═╝  ╚═══╝    //
//                                                                                                                                            //
//                                                                                                                                            //
//                                                                                                                                            //
//                                                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract L4artiste is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
