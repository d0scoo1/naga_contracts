
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Dark Pepe's by DigitalApe_Art
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ▄▀█▄▀▓▄▌▀Æ▓▓█X▓▓█▓██▐║▓▌▓▓▓▄╙▓▐▀╨▓█Æ▓██µ▓J▌╥m▄▓█▄█▌▓╖▄▀▓▒&r█▓▓█▓█▐d█▀▓▓╨▌█╗▌▄╥▀╦    //
//        █▐═▓Ç▀█▄█▀█▄█▓██▓▓▐▀═╖▌─▓▓▌▌▌▌█▓▓▀▄▓██▓PÅ▌▀██▓Q╩▓██▓Ü█▓▓▓,]▄▓▓█▓═▓╟▓▌███▓╩∩▓█ Ü╣    //
//        ▌█▓"█▓▓▌▀▐▌▓██▀a▀█m▌█▀`J██▓╧██▐▐╟▌▓╣▀▓▌▓▓█═▓█▀▓█▓╣▓V█w▀█▓╣▐█▌P█▓▓╫▓▀▓▄║▄▌█═█▓╙▌▀    //
//        █▓╚▓░█▓▓▀M╩▐▐▓▀█F▀█▌╚▀&▌█▓▐▓██▓╟▓▄▐█D▓▌▓╩▀╘▓▓█▀▓▓▌█▓▌▒▓▓▌▄▓K█▌█M▓▓═█▓▌▓██╤▀▓2▀║█    //
//        ▓═▓▓╘█╬P▌▓`█╙╩Ñw▐█▌▓█▄╤▓▀$"▐█N▄Z▓█@█╬▓██▌PNWÑ▄█▀▓██H▄█▓▌╝█▓╠▌▀▓▓D▄▄█▀██w▌▀██▓█H▌    //
//        █▓▄▓▐██▓▀▀▐▓▄▀▓Ç█▓─█1▀▓▀╬█▓▄▄▓▌█@█▓Ç▄▓█▌╦█Æ█▓▓██▓█▌▓▓▌╧╣,╦▓████▓▀j▀▀▓▀▄Å▌,▓█▓▓██    //
//        ▌╜▌▓█▓╣▀▐▓║%▌▓██═▓█▓██▐▓╔▄█▀▓█@█▓████▓█µ▓▌█▓▓▓▀▓▓▓█║╙m▓Q7▀▓█▀███▓▐█yJ█▓█▐█▓▓▄╫█M    //
//        ▌█Θ▓▓$▓▐▀▓█▓▓█▓██▀▐▌▀▓▓▌▓▓▀▐╚ ▐█▓▓▀r████╜╗▀â▓█F║▄████▀"██▓"╫▌▓█▓P▓█╫██╣▓█▓█▓█▓█▓    //
//        ▓╔▓█▌P█@▀█▌██╗▓▓█▓▀▓▌██)▓▓▓█║▄█████╚╦Q▐▀▄▓▓T▓▓█▐▓▌█▄▌╨▄▀▌█▌$▀▌▓▀,▓██▓███▓▀M▌2▓▓▓    //
//        ▓▄╬████▓▓╣█▌▄▓▓╒▀▀█▀▓█▌██╨█▓&╙▌▓▓╟▓╦▌▓▄╬█▓▄██▓█▓▀▀"▀ ▀╩Æ▓╬▄▀▐██▄▀█╚▄▓╝╫▓▐█╔▄▓▐Q▓    //
//        ▀▄▓▓█▄▓▓▌▓▓╩▓▓▌██▓▓▓█▄╝██P▀▓▓▒╜╜`  ╙░╙▒▓▒▌N╢╜╜`         ╦▐▓▄█▀╩╩▄/▓█╧█▄▓▀█▓▓▒╫▄▓    //
//        ╠▄K▓"╖Σ╟▓██▓▌╗▓▌███▄É▀╩▓▓╦▒░╜                            ▓,▀▒L▓▓█,▓▓▀P▓▀▄╣▓█▄*▓█    //
//        ▓&█▐▓▓▄▓█▓▄▓▓Ü▌P▓▓▓,▓▀█▓▒░`                               '╦▓▓▌╣█╩▓█▌,#█▄╩▓▓▐█▀▓    //
//        █▓▓▓▓╜╦█▄M"▐█Σ╩███▓▓▓▓K░─`                                   ▒█▀█B█▄▓█▓█▐╒▌╔▄▀█▓    //
//        ▓██▄▓╣╫█▀█▓▐▄▓▄▀"▀Æ▀▓▒▒`                            ,          ╖▄▌█Æ▌▀█▓▀╤▌╬▓▓K█    //
//        ██Ü██▀██▌▓█▓▌█▓██w▓▓▒`              ▄▓█▄          ╒▓▀▓█        ▐K▓█▌╝█J█─█▓╟▌▐Q▓    //
//        ██,Ñ▓▄▓▓▀██@▐"K██▓▓░          ,╖,   █▄▓█      ╓  ╓,▀▀▀`   ,╦"  ß▌█▓K▓▐╠█▄7▀█▌█▄█    //
//        ▄µ██▄▌╫M▓B█▌▄█▀▓▐█▒             '╙╜▒Ñ@╦╦╦╦mM╜"    ╜╨▒▒⌐╓───   ▓▓▄▓▌▓▓▌▓,▄██▌▀▓▓█    //
//        ▄φ▓Ñ▄Q▓█▀█▓▌▌▓▌P▓▓▒                                        ¿╤R█H▄"Ö█▓▄██▄▓▓█▓▓▓▀    //
//        █▓██▓▀▓▓███▌▄▄▓┬█▒                                         ▒╥╫▓█▓$▓▀@▌▄║▄▓▓▓█▐█▀    //
//        █▓@▓]╣▄▀▐██▄▀▓█▓▓▒                                           ▒▀█Ñ▌Ö▀█ª▓▓██@█▀▄█▌    //
//        @▓Ç,██▓╖▓█V▓▓▓▓▓▓▒               ▀▓                           ▄Æ▌▓███▌▄▓Q▓▓▓▓▄▓█    //
//        ▐█▀Q▓ç▓▐█▓█▄L▓▓█▓▒                ╕, `"",`""╙╙╩╩▓▓▓▓▓▓▓╩▀" ║ ╒█▌▓▓╬█,█▓▓)▀▌▐╖▌▓▓    //
//        █▄█m▀█Ü▌▀▌▓▓▌▓▌█╟║▒             ╜╙▓╢ⁿ▓╫M╩¢]╛╦\Å/µ╗#╒u╬╥W▒@M╨ ▐▀█▓▄▄█▌▌█▓▌▄█▌▐█▀▓    //
//        ╨▀▀▀█▀▌██ ▓▓█▓███▄▓Ñ┐           ▓▓æg╦╦æ&▓▓▓&ææ╦╦╦╥╥╥▄▄,,,▄@▓▄▌▓Å▌▓██▓^▒▓▀█▓▓▌▓║╩    //
//        █╫███▀█▀▄▓ÿ▓ ª▓▌█▄▓▓▒▒.                               ,▒"█▐█╛▓▄▄▄▀▓▌█)▀▓▌▐█α╬▓█K    //
//        ▌▓▄▀█▀█╬▓▄█▓▌▓▀▐╜▄▄▌▌▓▓▓,                    ▄╦z$5█▓▀▌▀╩▌▄█▓▄▀███▄▓▓██▒▀▀▄█████▓    //
//        ▐M≈`▐█▓J▓▓▄▌▀▓▓█▄▓▀▓g█▓█▄╟Ñ▄╔Ñ▄▄¢¢¢Ñ        ▐▌▓▀`▓▓▀▀%▄█▓██▓Ñ█▓▓J█▀█▌█▓▄▌▄▓▌██▓█    //
//        ▌▄▓▓@▄▀╣▄▓╓██n▓█▌█▓╘S█▀█▀▓█▄δ╠4██▀▓▀        ]▀▒▀▓▓▌▓▓▀█▓██\║▀█▓▓▓▀█▌█▌▀██▄▓▓█▌█▀    //
//        ▄▓▌$▓▄▄██▀▒▀)█▀▓▄▓ç█▄▓N▐▀███▓▀"               ═.  -.▒╙▀Å▓█▌█▓███▓██▓▓███▓█▓3█/▌J    //
//        ██▓▄▓╟▓%▌▓▓██▌╝█▄▓███▀▓▀▓▓  ╒                    `   , ▐▓██▀▐█▀▌▀▀▓Æ▓▌█▌█1█▌█▀▓▓    //
//        ▓Ç╢j4██▄Ç▌▀▓▐█▀▄█▓▀▌▓╬╟▐▓█  ,                        ▐ ▓▄▌▓██▀▓▓██╔▓M▓█▀██╟█▓█δ▓    //
//        ▓▓█▌▀▓▓▀▓▀▌▓▀▓█▀▓▄╓█▓▓▌▓▓▓                     ,^    ┘  ▒▌█X█╣▓▀██▓██▐██▄██▀▄▀▓▐    //
//        █▓d▓▓▓▀▀]▓▓▀▄"▓▓▓▀█▌▌▌╟▌       `   -         ¿            ╟╟▓▄ ██▄█▓▀)▒▄▌▓▄█▓▓█▀    //
//        █▓█▓█F█▓`w█▐█,█▄▄█▄█▓▓▀` `~.         `~   .═   ─      .-'  ▀▓▓▐▓$Ñ▒▓▓█▌█▌Ñ▀█▓▓▓█    //
//        ▄█▓▓▐,▓█▓╬▌▐██▓▌▓▌▀            `"*r── ═- .. ...⌐-<"`            "▒▄▓███▀████▌@▓█    //
//                                                                                            //
//    ---                                                                                     //
//    asciiart.club                                                                           //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract DARKPEPE is ERC721Creator {
    constructor() ERC721Creator("Dark Pepe's by DigitalApe_Art", "DARKPEPE") {}
}
