
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Sugar Parent County Club Donuts
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//                                                         ,,                                           //
//                                                         ╣▒                                           //
//                                                        ┌╣▒╕                                          //
//                                                        ╣╣╣╬_                                         //
//                                                      /╬╣╜╙╣╣W                                        //
//                      ,                             ,@╣╣┘   ▌▒╬,                             ,        //
//                      ╬▓W                         ╓╬╣╣▓╛     ▓╣╣╬╖_                        /▒╩        //
//                       ╘▓▓&,_                _╓╦@╣▒╣▓▓        ▀▌▒╣╣@╦╖_                 ,é╢▒"         //
//                        '▓▓▓╩▓@╦╗⌐,,,,,⌐╓╦@@╫╬╬▒╬▓▓▓╜          '▓▌▒╣╬▒▒╣@%╦╥⌐,,,,,⌐╥╦@@╨╫▒▒`          //
//                          ▓,_  ▀▓▓▓▓▌╣╣╣╬╬╬╬╬▓▓▓▓▀"      __      `▀▓╣╬╣╣╣╣╣╣╣╣╣╣╣╣╣╣╫`   ▒            //
//                          '▓▄ _  `╩▀▓▓▓▓▓▓▓▓▓▀╩`       ,╬▌▓W__      `╚▀▌╣╣╣╣╣╣╣╣╬╝`    ╔╣`            //
//                           ╚▓▌ _                     ╒▓▌▌▌▌╣▓W_                       ê╣╝             //
//                            ▓▓▌ _                   ╒▌▌▌▌▌▌▌╣▓▄                      ╔╣╣              //
//                            ⌠▓▓⌐                    '▌▌▌▌▌▌▌╣▓▌                      ╣╣╡              //
//                             ▓▓▌ _                    ╨╬▌▌▌▀╜                       ╞╣╣               //
//                             ▓▓▓                        ▌▌▌Ç_                       ╟╣╬               //
//                            ╔▓▓▌                  ,╔@╬▓▌▌▌▌▌▌▌▓▓&╗,                 ╟╣╬╗              //
//                           ┌▓▓▓▌               .@▓╣▌▌▓▀▀▌▌▌▀╙╩╩▓▌▌▌╣╬,              ╘╣╬▒_             //
//                           ▓▓▓▓               ╣╣╣▓▀`    ▌▌▌       ╙▓▌╣▓╕             ╣╣╬╣             //
//                          ╬▓▓▓▌              ▓╣▌▀       ▌▌▌`        '▓▌╣▄            ╘╣╣▒@            //
//                         ▓▓▓▓▓              ╟╣╬▓        ▌▌▌Ç⌐╦╦╦╖_    ▌▌╣╕            ╟╣╣╬╫_          //
//                       ╔▓▓▓▓▌               ╠╣▓▓        ▌▌▌▌╣╣╬▌▌▌`  _▓▌╣▌             ╩╣╣╣▒╥         //
//                      ▓▓▓▓▓▀                 ▓▓▌▄ _     ▓▌▌▌▌       _.▌▌▓╛              ╘╣╣╬▒╬_       //
//                    /▓▓▓▓▓"                   ╣▓▌▌ _    ▌▌▌▌▌╖_____╓@▌▌▌╩                 ╬╬╣╬▒W      //
//                   ╔▓▓▓▓▓  _                   ▓▌▌▌ _   ▌▌▌▌▌▌▌▌▌▌▌▌▌▓╩                    ╬╣╣▒▒╗     //
//                   ▓▓▓▓▓M _             .╔╦╦╖_  ▓▌▌▓ _  ▌▌▌M "╙╙╙╙"`                        ╣▒╬╣▒     //
//                  ╫▓▓▓▓▓               ╬╣╬▌▌▌▌▄  ▌▌▌▄   ▌▌▌M                                ╣╣╬╣▒@    //
//                  ▓▓╬▓▓▓              ╬╣▓▓  ▌▌▌Γ ╙▌▌▌   ▌▌▌M                                ╣╣╬╬▒▒    //
//                  ╠▓▓▓▓▓⌐             ▓▓▌▌ ╙▌▌▀   ▌▌▌Γ  ▌▌▌@                                ╣╣╬▒▒╢    //
//                   ▓▓▓▓▓▌   _         ╚▌▌▓        ▌▌▌`  ▌▌▌@                               á╣╣▒╢▒`    //
//                   ▐▓▓▌▓▓▄   _         ▐▌▌▌╦,_  ,▓▌▌▀   ▌▌▌M                              ╒╣╣▒╣▒╝     //
//                    ╬▓▓▌▓▓▄   _          ╩▓▌▌▌▌▌▌▌▓╝▄▓▓▓▌▌▌▓▓▓▓▓╗                        /╣╣▒╣▒╫      //
//                     ▀▓▓╣▀▓▌                "╙╨╜╙   `╨╝╝▓▌▌▀╩╩╩╝                        φ╣╬▒╣╣╬       //
//                      ╙▓▓▌╬▓▓╦ __  _                ,╦╦╦▓▌▌▄&&&╦_                     ╒▓╬▒▒╣▒╜        //
//                        ▓▓▓▒▀▓▓▄_    __             ╩▓▌▌▌▌▌▌▓▓╣▓╛                   ╔▓╬▒╬╣╣╣`         //
//                         "▓▓▌▒▀▓▓▓╗_    ____            ╚▌▓                      ╒╬╣╬╬▒╣╣╣"           //
//                           "▓▓▌╬╬▀▓▓▓▄╖_      _____                         _-╦╬╣╬╣╬╣╣▒╫"             //
//                              ╚▓▓▌╬╬▀▓▓▓▓▓▄▄╦╖╓,,,_ ___          _,_,,⌐╦╦@╬╣╣╬╣╣╬╣╣╣╣╜                //
//                                 ╙▀▓▓╬╬╬▀▓▓▓▓▓▓▓▓▓▓▓▓▄, _    .╦▓╣╣╣╣╣╬╬╬╣╣╣╬╬╣╬▒╣╩"                   //
//                                     `╚▀▓▓▌╣▌▀▓▓▓▓▓▓▓▓▓▓_   ╬╣╣╣╬▒╬▒▒▒▒▒╣╣▒╣╩╝`                       //
//                                                 `╙▀▓▓▓▓▓,,╬╣╬╣╣╩╜`                                   //
//                                                     "▀▓▓▓▓╣▒╩"                                       //
//                                                        ╬▓╬╩                                          //
//                                                         ``                                           //
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SPCCD is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
