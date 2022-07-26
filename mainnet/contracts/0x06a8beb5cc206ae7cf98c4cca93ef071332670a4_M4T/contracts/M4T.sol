
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: M4T3RI4
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
//                                                                   ▀                                            //
//                                                Ñ─N           ╙╜ ╙                                              //
//                                                ╜║▀              ▀╫Ñ▓∩N                                         //
//                                                 ▐▒,              ▀]█╫▓^ⁿ                                       //
//                                ╙▓░▓    ╙"▀      g╦▄               ,▌▐▓▐╩                                       //
//                            ][     ▓g▌g,▄▒█ ▀    ▓h▓                 ▓▄█Ü▓ ╙                                    //
//                           ,▄▐N  Ñ Ñ▐@▓m▓╓▓▄█▓▌▓▓█╙▀                  ]█▄▄╠▒,                                   //
//                             ▐╬█╢█▓▌▓Ñ▓─▓╫▓▓▓█▓█▓█▄╕                  ╫Ñ▓▌▄─φ                                   //
//                              ▐█▓█▓▌█▀▀"▀▀▓█▌ ╫█▓▌▓Γ                  ╙╙█╩▀MN                                   //
//                  ⌠`▒,       ▓▓█▓▌█▒█╖█▓█▄█▒▓▒▓▀▀▀█»▓▓▀▓   ,          ▄▐█▐▌╙"╨                                  //
//                  ╙╙╙▀"▀╚▀▓╝▀ ▓▓█Ñ▓H▓+███Ñ█∩▄▄▌╓▄▐█▌▐▓▓▓╙▀▓▀▄@,      ╒▓▄▌║⌐╙ ╠                                  //
//                      "`╙└▀╙▀▒█▌█Ü▓╙▌▐██▓M▓j▓▓▌]██▌]▄▄▌g   ╝╫~▓▀▄▀]╣▌▐▌ÅL   .▄                                  //
//                             .█▓█Ü█▓▌▓▀█▀║▀▐▀▀█▓█N▄g∩▀        ╙ ╥╜╙╙▀▐╜   ^Ñ                                    //
//             ╓╖                ]█▓█▓▓█▓█▓█▓▓▓▀█▀▀jΓ╟N            ╓▒▐`▓]▌ ▀╙╙▓                                   //
//        ╦  Ñ`                       ╒▓▒▓▐▄▓▓█▓▌]▌▐▌▓`╢ Ñª─R─Ñ╒N    ▓┬▄╠▄▓Ü▓╙▀▐█╗                                //
//           ╓╬`                     █M     ▓&█▐▌▐▌▓╟█▐▓▓▒▓Ñ▓g⌐▄ ,   ▓4▌▐W▓W▌,▐████▓╦                             //
//          ▀▄▄▀                   ▄Q█]▌]Ñ▓╙█╩▓MÑ$M▓╫▌▓Ñ▓Ñ▓╬Ñ▓╓▄╖p,╖▐▌▓ⁿ▐─▓▓░▄▄▄████r,                            //
//         )▓▄╬▀Æ                 ╓█W▓▄▌█▌█▓█▒▀║╜▀'▀▓▌█╣█▀▀▀^▓*▓N▌╫▄,,╠ ß ╙╙█▄█████▓▀▓▓╣▓▄▓▐▓@▓g▓,┌.              //
//         ]▓▄▓▀▄                █▓█Ñ▌╬@█▓█╫█▄▌▄▒▀ ▒▓w▓╟▌▐▒▓"▓║▓▀▀▓▀▐@▄ ╬ █▒███▀╙╜╙▌g▓█▀▓██▀▓▓▓██▀▄╨Ç             //
//         ╒Ñ▄▀█▄,              ]█║▀╟Ñ▓Ñ█Ñ█╫▓▓H╫ `╥└█▄▌╥╗▄~▄┌▓▐▓▓▓█▌╥╕╓ ▄,▓██▓▌▓██▄█▀▓▓█▀`    ▐▓▀▓▒ ╙╟~           //
//        "¼m╠▀▓▄▓@            #▓█▐▌▐▒▓]█▐▀▓▌▓Ñ▓` ▀╜▀╙Ç▐▒@ ▓▐▓▓▓█▄█▌&N█▌@▀██▀██ ▀█▓▓▀▄▓╩▓▄        #  ╚▌           //
//         ┌m,╨▓▓▀█▌g╜▄┐╒▓▄▓▐▄▒4▓▄▐Ñ▓▒▓@█▓▌▓▒▓▒▀▓▀▀▀▀╠█▓▌▓▒▓▐▀  ╬ ▀▓▓██████▓█▓█▓█▓█▓▓@▓j▓▀Ñ┐      ╙▀  ╜           //
//           `Ñ▒╢▀▄▐▐▀▄╜╬▄╙▀╝ `ßÑÑ▓N▓»▓Φ▌▓▄█╗█▄▌▓▌]▌╨"╨╙Ñ╙╙▀▀▀▀╜N ▓███████████▓██▌▓███▓▌░█▌▀Q    ,╫▌  ╜           //
//            R╓ ╙         ╨ ,╙ "`▓╢█╫▓▐▌▓Ñ▓K▓▓▓█▓█▓▄╓▌▄╬@▒@╫;▓@╨▐███████▓▐▓Ñ█▓▓▐▌▓@ ▓╜█▌▐█⌐▐█,  ╙▄ßr┌W           //
//              ²jp ╚K╖▀  `  ╙    ▓▄█▓▌█▌█╝▀╙▓█Ñ█▓█▓█████████▀▀,▓▓██▄]▀▀▐▓ªN@▀╝█▄  ▀▓╬▀╜╠▄▀█m▀▓╖   g╜\╖           //
//                                ▄▐██▌█▓█▐▓▐▓████████▌▓╬█▄██▓██▌▀▒▐`▐ ╠]▒█Ñ&Ñ▀W▄ ╙▓║█╩▀╖▄▓▌▀╖▄▓█,▄  ,            //
//                                 ▓▓█▌██████Ü▀██▓██████▀▀█████████▓.▄╓▄',▐█Q▀╫w▓─,║▓▓█▓▄▐╣█▄█▓█▀█▓m              //
//                              ,║▀▓████Ñ▀╢█▓█▀▀,╙`╙║█▐▓╓,▓▀▀╠▀▀█▀▀█j▌▐▌▄Ñ`▀▌▐╖▓╜▓╖▓▐▓██▓╣▀▐█▓█▀██▌▓Ç╓,           //
//                            ▄╥█▓██▓█▌,▓▌,▄, ▓,╙ ▐▌╟█▓▌▓▓█▄█▓▌▐██╜▀▐▀▐██M@,▓▄▓╝▓▐█╫▓▓█▓▌▀▒▓▓████████▓█▓▌         //
//                        , ▓*▓▓████⌐╙▐▌█▌█▐█▓▌▓▀▀\ ▀╩▄▌ ]█▓▌▐▓███╓▓█▓█▀█▓▌▀▓▓▓▓▐▌▓▓▀▄█▌▀▀▓▓████████▓███▓▌@       //
//                      , ▓▄█▓█▀▀     ▓W█@█▄█▓▓█╬▓▐▌▓▌▀╝▀▓█▀╩▄▓█▓█▓▌▓▓▓,▓▄█▌▓▓▀▒▄▓▓▀▌▓▓███▓█▓███▓Ñ▀▄█▓█▓█╫@▀,     //
//                      ▄∩▓▓█▓▌       ▓M█▐█╟▌▓Ñ█N▓▐▌█▌▓⌐,▀▌▐╜▀▒██▀▓▓███&▄█▓█@█▓▓▄▓▀█▓▓▓▀█▓█▀▓▓▌▓Ñ   ╙▀▐█▓▌▀▒▐,    //
//                      ▓  ]▓ `       ▀]█▓█▓▀▓╬█%▌▓▓█▓█╦▄▄▌▓g▓█▀▓▓Ñ▀▀██▓▌▐█▓▓▓█▓█▀▓█▓▓╬███▓▓▓▌▓Ñ╙    ╙▄██▀▒▓wÑ    //
//                      ╣   [          ]▓███▓█▓█▐▀▓Ñ█▓▓▐▌▓▌▓▌▓█▌╙█▌"▀▓▀█▀█▓█▒█▓█▀▓▓▓█▓█▓███▓▌▓H      ,▐█▀╣▓╗▓     //
//                      ╙▒ "▀          á▄█▓█▓███▓▄▓▐█▓█▀▀█▓▄]▌▐█▓▓█▄▓█▄▐▄█▓████▓█▓▓█████▓█▀▌▐Γ       ▐▄█▓▓▒▓─     //
//                       `,  ▀╜      ╠▌▓▓█▓██████▄█▐███▓▓█▓█▓▌▓█,j██▌█▌▄▓█▐█▓█▀████████▓█▀╜`        ╓▄█▌▀▒▓H▀     //
//                          , ▀    ╓▓███▀█▀████▓█▓█▓██▓█▄█▓█▓▌█▓▄▀,▓▓▀▓█@ ▐█████████▓█▓█╩╜          ▄▓▌▀▒▓╨▀      //
//                           ,    m▓████▓█▀▌╙▀█▀█▐█▓▓█▌█N▓█▌█▓█▓█▓▌▓███▓█▓█████▀███▀▓▒▌╙╙        ,┌▄▓▌▀▒▓M╝       //
//                           `    N╫Ñ█▓█Ñ▓    ▓▐█▓▌█▓█▀█▀██▓▌Æ████▌███████████████╩╙          &╨▓▓▌&K▀ ╟∩▓        //
//                               ║╩▐Ü▓▓█MM       ▓▌█▓███▓▓███▓████▓███████████▀█▒            ▄╨█▀▓╙t  gµ▀╜        //
//                               ╠▒▓▒▀▀█▓Ñ         ▓╟▌▓▓██████████▀▀▀██▀█µ▓╩▀▀╙`             └╝╙▄    a@▓╜`        //
//                                 ▓╦▌▐▓█▌▓              ]█╨▀▀▀▀▀▀  ▀▀▀╜                        ]W  ╓@▓╜╜         //
//                                  ╟Ñ╫Ñ█▓█w▄                                                      ╓ƒ▓╜▀          //
//                                  ╙╜▓^▓▐█▓▌&                                                    ╠@▓Ñ▀           //
//                                    ▀"▀▐▌▐Ñ▓Ñ▓ß▌&Kφ                                            ║╖▓Ñ▀"           //
//                                      ╙▐▒▐"▀"▀▀▀█▀▓─@                                         ╙  └▀             //
//                                       ▐╖▓,╖  " ▀└▀╙▀                                                           //
//                                         ▌╟▓gr   .▌                                                             //
//                                          ╨╝▓M▓                                                                 //
//                                            ▀▒▀]▌╘─                                                             //
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract M4T is ERC721Creator {
    constructor() ERC721Creator("M4T3RI4", "M4T") {}
}
