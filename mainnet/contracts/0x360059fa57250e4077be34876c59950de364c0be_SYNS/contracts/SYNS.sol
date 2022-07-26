
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Syns
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    Text Preview:                                                                       //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐█▄▄▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▄███▀░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀█▒█▄▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▄█▀░▄▀░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀█▓█▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▀░░▐█░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓█░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░█░░░░█░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█░░░░░▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░█░░░░▐▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░█▓▓▓█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐▌░░░░█░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░█▒▓▓▓█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░█░░░░█░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░██▒▓▓▓█▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒░██▒▓▓▓▓█▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░█░░░░▐█▄▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒░█▌▄▄▄▄▄██▒▓▓▓▓▒█▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░█░░░░░░█▄▒██▄▒▒▒░░▄▄██████▒▒▒▒▀▀▀█╣▓▓▒█▀░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▄░░░░░░████████▒▓▄████▒▓▓▓▓▓▓▓▓▒█▓█▀░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░█▄░░▄██▀▒▒████▓███▒▓▓▒▄█████████▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▄▄████▄▄▒▒▒▄█▒▒▓▒███▀████▄     ▐██░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▀▀▄█▀▀▀█     `▀▀█▓▓██ █╢██▌█   ,▄█▒▀█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█ █░███▌▐      ,██▓▓▒▒▀█████▀▀▀▀▒▒▓▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▀█████████████▒▒████▄▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒█▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▓▓▓▓▓▓▓▓▒█░░░░░░░▀▀█▒▓▓▓▓▓▓▓▓▓▓▓▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐█▓▓▓▓▓▓▓▒█▀░░░░░░░░▄██▒▓▄▓▓▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▓▓▓▓▓▓█▀░░░░░░░░▄██▒▓▓▓█▓▓▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▓▓▓▓▒█⌡░░░░░░▄██▒▒▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐█▓▓▓▓▒█░░░░░░██▀▓▓▓▓▓▓▓▓▓█▒▓▓▓▓▓▓▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐█▓▓▓▓▒███▄███▀▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▒▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▒▓▓▓▓▓▓▓▓█▌▓▓▓▓▓▓▓▒█░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐██▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓█╢█▒▓▓▓▓▓▓█▌▓▓▓▓▓▓▓▐▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░███▓▓▓▓▓▓███▒▓▓▓▓▓█▌▒█▓▓▓▓▓▓█▌▓▓▓▓▓▓▓▐▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████▓▓▓▓▓▓▒█▒██▓▒▒██▓▓█▓▓▓▓▓▓▒█▓▓▓▓▓▓▓▐█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▌██▓▓▓▓▓▓▓██▓▒╢╢▒▒▓▓██▓▓▓▓▓▓▓█▒▓▓▓▓▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███▌▓▓▓▓▓▓▓▓▀████████▒▓▓▓▓▓▓▓▓▒█▒▓▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒█▌▓▓▓▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒███▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐█▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒█░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐█▌▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒█▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒█▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▀██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒██▀░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀███▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒████▀▀░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░█░░▀▀███████████████╢█▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▀▄░░░░░█░▒░░░░░▒█▓█▓█▓▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀▀▀██▄▄▀░▒▒▒▒▒▒▒▒▀███▀▀▀░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract SYNS is ERC721Creator {
    constructor() ERC721Creator("Syns", "SYNS") {}
}
