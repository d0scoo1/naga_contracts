
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Into the Zyztem
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//    ▓,                                                                                                          ,▓    //
//    ▓▓▓_                                                                                                       @▓▓    //
//    ▓▓▓▓▌_                                                                                                   #▓▓▓▓    //
//    ▓▓▓▓▓▓▌_                                                                                               é▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▄                                                                                            ▄▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▄                                                                                        ╔▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▄                                                                                    ╓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓╖                                                                                ╓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ç                                                                            ,▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓,                                                                        ,▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                                                      ╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b                                                                    j▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b                                                                    j▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b                                                                    j▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b                                                                    j▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b                                                                    j▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b @@@@@@@@@@@▄                                         ,#@@@@@@@@@@@⌐j▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓,                                    ,▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╖                                ╓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄                            ╓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ▒_▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒∩▒ ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ▒_╬╬╬╬╬╬╬╬▓▓▓╬▒╬╬╬╬╬╬╬∩▒ ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ▒_╬╬╬╬╬▓▓▓▓▓▓▓▓▓▒╬╬╬╬╬∩▒ ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ▒_╬╬╬▓▓▓▓▓▀▀▀▀▓▓▓▓╬╬╬╬∩▒ ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ▒_╬╬╫▓▓▓▓`   x ╙▓▓▓╬╬╬∩▒ ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ▒_╬╬▓▓▓▓▌ x▓ , ▓███╬╬╬∩▒ ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ▒_╬╫▓▓▓▓█▄▄─   ╒▓█▓█╬╬∩▒ ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ▒_╬╫▓▓▓▓██▓▀╙▀╙██▓▓▓╬╬∩▒ ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ▒_╬╬╬▓▓▓▓███████▓▓╬╬╬╬∩▒ ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ╩ ╙╙╙▀▀▀▀▀▀▀▀▀▀▀╜╙╙╙╙╙⌐╩ ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀         φ▒▒▒ε▒▒▒▒≥         ▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓└         ╠▒▒▒▒Γ▒▒▒▒▒╦          ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╙          ╠▒▒▒▒▒Γ▒▒▒▒▒▒▒          ╙▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ▓▓▓▓▓▓▓▓▓▓▓▓▓╜           ╠▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒           ╙▓▓▓▓▓▓▓▓▓▓▓▓▓µj▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b ╙╙╙╙╙╙╙╙╙╙╙╙           ,╠▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒            ╙╙╙╙╙╙╙╙╙╙╙╙ j▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄╦╠▒▒▒▒▒▒▒▒║▒▒▒▒▒▒▒▒▒╠╗▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▒▒▒▒▒▒▒▒▒▒╟▒▒▒▒▒▒▒▒▒▒░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓b                     /▒▒▒▒▒▒▒▒▒▒▒╠▒▒▒▒▒▒▒▒▒▒▒▒                      j▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀                     ╔▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒                      ▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╙                     ╔▒▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒▒,                     ╙▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀                      φ▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ε                      ╚▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓`                      φ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ε                       ╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓╜                       φ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ε                       ╙▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▀                        ╠▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒≥                        ▀▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓╙                        ╠▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╦                        └▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▀                         ╠▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                         ╚▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓`                         ╠▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                          ╣▓▓▓▓▓▓    //
//    ▓▓▓▓▓╜                          ╠▒▒▒▒▒▒_____/% INTO THE ZYZTEM %\____▒▒▒▒▒▒▒▒▒                          ╙▓▓▓▓▓    //
//    ▓▓▓▀                          ,╠▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╠                           ▀▓▓▓    //
//    ▓▓╙                          ,╠▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╠                           └▓▓    //
//    ▀                           ╓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╠                            ╚    //
//                                                                                                                      //
//                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract ZYZ is ERC721Creator {
    constructor() ERC721Creator("Into the Zyztem", "ZYZ") {}
}
