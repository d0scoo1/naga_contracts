
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Fuck 12
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀▒▒▒▒▒▒▒▒▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒╣▒▒╣╣╣▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▀▒▒▒╣▒╣▒▒▒▒▄▓▒▒╣▒▒▒╝▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▒▒▒▒▒╣▒▒▒▒███╣▓██▀▀█▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███╣╣║▒▒▒╣╠███▀█▓╫▓█▓▓▌╝▀▀▀▀╙║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣║║▓▓▓▓▓▓▓▓▓╣╣▓█▒▒╪║▓█▀▓██▓▓▓▀▒@▒▒▒▒▒▒▒╩╓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓║▒▒▒▓▓▓▓▓▓▓▓▓▓▓██▒▒▒╙▄▓▓▓▓▓▓▓▌║▒▒▒▒▒▒╝╙╓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓║╟▓▒▒║▓▓▓▓▓▓▓▓▓███▒▒é║▓▓▓▓▓▓▓▓ ▒▒╙▒`ª▓▓▒║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒║▓▓▓║▒║▓▓▓▓▓▓▓▓╣╣▓▓▓║▒▓▓▓▓▓▓▓▓╟▓▓]█▓▄,╙▓▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▒▓▓▓▓▓▓║▒║║▀▓▓▓▓▓▓▓▓▓▓▒║▓▓▓▓▓▓▌▓▓▌φ▀▓▓█▄"▒║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▌║║▌▒▓▓▓▓▓▓▓▓▓╫║║▒▒░░░░░░░╚╠╠▀▀▀▓▓▓╚▒▄▓▌╙▀▀`▄▌▒▒╚▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▓║▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░╚╠╠╠▒░░╚▀▀▀▀▀▀▀▀╟█»░╟▒╠║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░╚╠╠╠%░░░░░░░░░█░░╙▓▓▒╠▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▀╟▓▓▓▓▓▓▓▓▓║╣▓▓▓▓▓▓▓▌░░░░░░░░░░░░░░╚║▒║╠░░░░░░█░░░▓▓▓║▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓║▓▓║▓▓▓▓▓▓║▓▓▓▀║╟▓▓▓▓▓╚░░░░░░░░░░,▄█▄▄░░▒ç╚░░░░█▄▄▄█████▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▌▒▓▌║▓▓▓▓▓▓║▓▓▌║╟▓▓▓▓▓▓▓░░░░░░░░░░▐██████▄░░≥▓███████████▀▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▒╟▓▒╫▓▓▓▓▓▒╟▓▓║╟▓▓▓▓▓▓▓▓▌░░░░░░░░)████████░░░▀▀▀▀▀▀└╓g╖,  ▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▌▒╫▓▒▓▓▓▓▓▓▒▓▓▓▒▓▓▓▓▓▓▓▓▓▓░░░░░░░░║████████▌░░U»    ╚║║║▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▒║▓▌╟▓▓▓▓▓▒╟▓▓▒▓▓▓▓▓▓▓▓▓▓▌░░Q%▒▓▓▓▓╣██████░░░╔,     .╓▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▒▒╟▓▒▓▓▓▓▓▒║▓▓▒▓▓▓▓▓▓▓▓▓▓▓▒▒║╠╠║║║╫▓▓╣███░░░░░░░░█▌░░╟▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▒▒╟▓╣▓▓▓▓▓▒╟▓▓▓▓▓▓▓▓▓▓▓▀╟▓▓▓▓▓▓▓▓▓▓▀▒░╚░░░»░░░░▐█░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▒▒║▓▓▓▓▓▓▓▒╟▓▓▓▓▓▓▓▓▓▒╟▓▓▓▓▓▓▓▀▀╚░░░░░░░»░░░░╚█▌╚»j▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒║▓▓▓▓▓▓║║▀▓▓▓▓▓▓▓█▓▓╫▄╫╫▓▄░░░░░░░░░░░=░░░▐█░░╚▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╢▒║║▓▓▓▓▓╢║║▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄╚░░░░░░░░░░╔█«░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒║║▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▌░░░░░░░╚▄▀░╚▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒╫▓▓▒▒║║║║▀▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╠▓▓▄░╚╚▄█░░▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌║▓▓▓▓▓▓▓▒║║▒▒▒║║▓▓▓▓▓▓▓▓▓║╢▀║║▒▒║╣φ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒║▓▀▀▓▓▒╟▓▓▓▓▓▓▒╫▓▓▓▓▓▓╢╠╬╣╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒╣▓▓▓▓▓▓▓▓▓║▀║║║║║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌║▒▒▓▓▓▓▓▓▓▓▓▓▓▌║▒▒╟▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓]▒▒╫▒░▓▓▓▓▓▓▓▓▌║▒▒╟▀▀╙▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀▀║Q▒▒║▒▒,▀▓▓▓▓▓▓▀Q▒▒╣▒▒▒`╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌Q▒▒▒▒╠▄▄▄▄▄▄▓▓▓▓▓▄▒▒▒▒▒Σ▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▀▀▀▓▓    //
//                                                                                            //
//    ---                                                                                     //
//    asciiart.club                                                                           //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract FK12 is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
