
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Janks Specials
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                          //
//                                                                                          //
//                                                                                          //
//          ,,                      ,,                        ,╓                      ,╓    //
//          ╟█▓▒▒╔,                 ╟█▓▒▒╔,              ,╔φ▒▓██                 ,╔φ▒▓██    //
//           █████▓▄▒╗               █████▓▄▒╦        ╓Θ▒▓█████               ╓Θ▒▓█████     //
//            ████████▓▓▄             ████████▓▓▄  ╓▓▓▓███████`            ╓█▓▓███████      //
//             ╙██████████▌            ╙█████████▒▒▓████████▀            ▄██████████▀       //
//              └███████████╕           └██████████████████▀           ,▓██████████╙        //
//                ╙██████████▌            ╙██████████████▀            ╓██████████▀          //
//                  ╙▀████████▌             ╙██████████▀             ╓█████████▀            //
//                     └▀███████            ▄███████████            ▄██████▀╙               //
//                         '╙████▄        ▄████▀`  '╙████▄        ▄████▀`                   //
//                             ╙███▌,  ,#███▀`         ╙███▌,  ,#███▀`                      //
//                               ╙██▓▓▓▓██▀              ╙██▓▓▓▓██▀                         //
//                                ╟███████                ╟███████                          //
//                               ╓████████▄              ╓████████▄                         //
//                             ▄████╙└'╙▀███▄          ▄████╙└'╙▀███▄                       //
//                          ╓φ▓██▀        ╙██▓▒╖    ,φ╬██▀        ╙███▒╖                    //
//                      ╓φ▒▄▓███`           ▀███▓▒▒▄▓███            ▀███▓▒φ╔                //
//                  ,#╬▓▓█████▌             ,██████████▄             ╙██████▓╬▓,            //
//                ,██████████▌            ╓██████████████▄            ╙██████████▄          //
//               ▓██████████▀            ▓█████████████████µ           ╙███████████µ        //
//             ╓██████████▀            ▄████████████████████▌            ▀██████████▌       //
//            ▓█████████▀             ▓█████████▀  ╙██████████             ╙██████████      //
//           ████████▀`              ████████▀└       ▀████████               ▀████████     //
//          ▓████▀▀                 ▓████▀▀              ╙▀█████                 ╙▀█████    //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////


contract JANKSSPECIALS is ERC721Creator {
    constructor() ERC721Creator("Janks Specials", "JANKSSPECIALS") {}
}
