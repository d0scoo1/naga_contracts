
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Starting Out (Teru Editions)
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                      ,▄▄▄▄▄▄                           //
//                                                                                        //
//                        ▄▄▄▄,                   ▄▄▄▄@████▄▄▒▒░▀▀▄        ▄▄▄▄█⌐         //
//                                                                                        //
//                       █▀▒▒▒▒▀█▄             ▄▀▀░▒▒▒▒▒▒▒▒░░▀█▄▒▒░█▄  ▄▄█▀▒╢▓▓██         //
//                                                                                        //
//                      █▌▒▒▒▒▒▄▒▒▀█▄          █░░▄▄▄▄▄▄▄▄▄▄▄▄▄██░▒▐███▒▓╢▒▓▓▓▓▓█         //
//                                                                                        //
//                     ▐█▒▒▒▒▒▒▒▀█▒▒▒█▄ ▄▄▄█▀▀▀▀░▒░░▒▒▒▒▒▒▒╢▒▒▒▒▒███▒▓▓▓█▀▒▓▓▓▓▓█▌        //
//                                                                                        //
//                     █▌▒▒▒▒▒▒▒▒▒▒▒▓▀▀▒░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓█▒▓╢██▒▓▓▓▓▓▓▓▓██        //
//                                                                                        //
//                    ,█▒▒▒▒▒▒▒▒▒▀▀,╖╢▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▒▓▓▓█▒▓▓▓▓▓▓▓▓▓▓▐█        //
//                                                                                        //
//                    ▐▌▒▒▒▒▒▒▓▀,╖╣▒▒▒▒▒▒▒▒▒▒▒▒▒░▄▀░░▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▐█        //
//                                                                                        //
//                    █▌▒▒▒▒█`╓╢▒▒▒▒▒▒▒▒▒▒▒▒▒░▄▀░▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓╣▄╣▓▓▓▓▓▓▓▓▓▓▓▓▓██,       //
//                                                                                        //
//                    █▌▒▒█▀╓▒▒▒▒▒▒▒▒▒▒▒▒╨╜▒█▀▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▒██▀`▓▓▓▓▓▓▓▓▓▓▓▓▓╢█▌█▄      //
//                                                                                        //
//                    ▐▌▒█ ▒░░░░░░░░░    ,█▀ "╙╜╜╙╜▒▒▒▒▒▓▓▒█▀▀   j▌▓▓▓▓▓▓▓▓▓▓▓▓██▓▓█▌     //
//                                                                                        //
//                     ██ ╢▒░░░░░░░░░ ,╓▄▀          ,╓▒▒██▀      ▐▌▓▓▓▓▓▓▓▓▓▓▓██╢▓▓▓█⌐    //
//                                                                                        //
//                    ,█ ╢▒▒▒▒▒▒▒▒╓▒▒▒▒█▀▒▒▒▒╖╖╥H▒▒▒▒░▄█▀        ▐█▓▓▓▓▓▓▓▓▓▓▓▓╣╣╣▓▓╫▌    //
//                                                                                        //
//                    █ ║▒▒▒▒▒▒▒▒▒▒▒▒▒█░▒▒▒▒▒▒▒▒▒▒▒▒▄█'          "█▒╜╨▀╜░╙╨▓▓╨▀╙░▒▓▓╢█    //
//                                                                                        //
//                   ▐▌╓▒▒▒▒▒▒▒▒▒▒▒▒▒▐▀▒▒▒▒▒▒▒▒▒▒▒▄█▀             █▌░░░╥µ░░░w▄φ▓▓▓▓▓▓█    //
//                                                                                        //
//                   ▐▌╢▒▒▒▒▒░▒▒▒▒░░░░░░░░░░░░░░╙▒▀               ▐█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█    //
//                                                                                        //
//                   ▐▌║▒▒▒▒░█ ░,▄▄▄▄,          ░░░░         ,     ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╫█    //
//                                                                                        //
//                    █ ▒▒▒▒█ ▄▀     ▀█▄                ▄█▀▀▀▀▀▀█▄  █▌▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▌    //
//                                                                                        //
//                    ╓▌╙▒▒▐██  ╓██    █▌             ▄█-   ▄,   `█▄ █▒▓▓▓▓▓▓▓▓▓▓▓▓╢█     //
//                                                                                        //
//                    └▒▀▀▓█▐▌  ╙▀▀    █▌             █    ███     █ `▀▓▓▓╢▓▓▓▓▓▓▓╢█-     //
//                                                                                        //
//     ▄                ╙▒▐▌▐█        ▄█             ▐█           ▐█  ░░░▐█▓▓▓▓▓▓╢█"      //
//                                                                                        //
//    ▀ ,P   ,▄▄        ]▒█▌ ▀█,   ▄▄█▀               █▄         ,█`     █▒▓▓▓▓▓╢█'       //
//                                                                                        //
//     ▄▀   █▀`'▀███▄   ]▒█`   `▀▀▀                    ▀█▄▄,,,▄▄█▀.     ██▓▓▓▓▓▒█    ,    //
//                                                                                        //
//    ▄   ▄█▀    '  █    ▒█▒╢╢╣╢╗                         '`└,░╖╥╥╥╖   ▄█╢╢╢╣╫██          //
//                                                                                        //
//    ▀  ▐▌       ▄█▀    ║█▌╜╨╨╜╜                           ░▒▒▒▒▒║╜  ▄█▒▒▒▒▀▀╨▀          //
//                                                                                        //
//       █▌   ▄▄███▌,     ░█w             ▓█▀▀█                     ,█▀Ñ         ,▄▀▀▀    //
//                                                                                        //
//       ░█▄█▀▒▒╢╢▒█▌╖    ║░█▄            ▀█▒▒█                   ,██▒╜         █ ▀▀      //
//                                                                                        //
//        █▒▒╢╢╢╢╢╢▒█▄║╖   ║░██,           └██▌                ,▄██▒╣         ╓▒██▄▄      //
//                                                                                        //
//       ▒█▒╢╢╢╢╢╢╢╢▒██▒║   ╙▒░▀█▄                          ▄▄███████▒@      ╥██▒╢▒▒▀█    //
//                                                                                        //
//       ▒▐█╢╢╢╢╢╢╢╢╢╢▒█▄▒╗,  ╙║▒▒▀█▄▄,                ,▄▄█▀▀░▒▒▒▒▒░█▀╝   ╓▄██▒╢╢╢╢╢╢╢    //
//                                                                                        //
//        ░█▒╢╢╢╢╢╢╢╢╢╢╢▒██▄▒╗╖  `╙║▒░▀▀█████▄▄▄▄████▀▀▀░▒▒▒▒▒▒▒▒░▄██▄▄▄██▀▒▒╢╢╢╢╢╢╢╢╢    //
//                                                                                        //
//        ▒░█▒╢╢╢╢╢╢╢╢╢╢╢╢▒▒▀██▄▄░╢║║▒▒█░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░██▒╢╢▒▒╣╢╢╢╢╢╢╢╢╢╢╢╢╢╢    //
//                                                                                        //
//         ▒└█▒╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢▒▒▒▀▀▀████░▒▒▒▒▒▒▒▒▒▒▒▒▒░░░▄▄▄▄██▒╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢    //
//                                                                                        //
//          ▒░█▄╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢▒█▌▒▒▒▒▒▒▒▒▒▒▒▄█▒▒▒▒▒▒╣╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢    //
//                                                                                        //
//           `░▀█▄▒╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢▒█░▒▒▒▒▒▒▒▒▒▒██╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract TERU1 is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
