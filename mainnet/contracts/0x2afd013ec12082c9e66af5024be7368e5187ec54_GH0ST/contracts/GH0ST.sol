
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: G.H.O.S.T. [INTERLUDE]
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                             ╓▓██▓▄                                         //
//                                            ▄▓██████╣█▓▄                                    //
//                                        ,▄█████▓████▓▓╬▓▓█▓▄                                //
//                                    ,▄██████▀,▓██████╬╢▓╬▓▓███▄                             //
//                                  ╓██▀▓▀╟╩╙ ╓█████████▓╟╬▒╬▀█████▄                          //
//                                 ▓▓╚▄▀=╙  «▄████████████╣▓╬▒╬██████▄                        //
//                                ▓░░╟╝    Ç▓████████████╬█╣▓µ ╙╬██████                       //
//                               ▓▒▒╟▒   ,╓▓██████████████▓╬██▒  ╚╝████µ                      //
//                              ▓▓╣╫░   /╔▓▓████████████████╬██▓Q \╚▓███                      //
//                            ,██╬▓▒╛ , ╔╟███████████████████▓███▌»G^╫██µ                     //
//                             ██╣╬╬≥ ╩#▄██████████▓╙╣█████████▓███▒▒U╟█▌                     //
//                             ╟█╫▓▓,░'╓██████╬▓▓▓`    ╙╣███████▓███▓╟▒╟█▌                    //
//                             █▒▓██▓)]████▓▓█▓▀╙      `  ╙███████▓███▓╣██                    //
//                             █╟████╠╫███████▓φ≈≡       ╓#╫██████████████▌                   //
//                            ╟ÿ▓███▒;██████▓╢███▄y    ▄▄██████████████████                   //
//                            ▌╣▓███[╔▓███φ▄▄▄╙█▓█ ,▓▌█████▀╠██████████████                   //
//                           ║▌╫████ ▐█████▄,,╙╢█▀╫███▓███M▀ ,▄████████████                   //
//                           █▓╫███╩▄███▓▄╠▀██▓╝╠╣██▌ ▒████▓▄▓██╣██████████▌                  //
//                           █████▌████▒╠▓▓▄▀▌▄▓▓██▌  ████▄╠╟▄▒╣█████▓██████                  //
//                          ╫██╙╬▓██████  ╚███▓▓▓█▓▄▄▄▄▓██████╣█ ╟▌╟███▒╬███▌                 //
//                          ███ ╙██████▓█▄ ╠██▓ ╠╬▓▀███▀██▒╟███░ ██╣█████▒╟██                 //
//                          ██▌ j▓█████ ╙█▌ ╚██▒╠███▓╬#▓█▓;▓██▒,██▀███████▒██                 //
//                         ▓█▓   ▓█████▌ ╫███╬▀███▄███▓██«▓██▀▀███ ▓██████▓██▌                //
//                        ▐█Γ |▒█╬█████████████████▌╟█▓█▒████▄████╙█████▓]████                //
//                        █▓\ {╣█▌███████╬███████████████████████▄█████7▄████⌐                //
//                       ██▓▌Φ ╣█▓████████████████████████████▓▓██████,▓████▀                 //
//                      ▐████▌▒ ╟█████████████████████████████▓██████]▓█▓██╙                  //
//                      ▄██████▓M╙██████████████████████████▓███████╓█████                    //
//                   ,▄█▀▓███████▓▓███████████████████▀████████████▒██████                    //
//               ,Æ▀▀⌐╞╟██████████████████████████████████████▓╠██▓███████▀ "ⁿw▄              //
//          ,-⌐"     #██████████████████▓▄▓████████████████╬▓███╬███████▀   e╓▄▓█,,,,.-       //
//        ▄X£╦≥░G ,▄████████████████████████▓▓█████████████▀╚ç▄███████▓▀,▄▓███▄▄▄▓█▀Σ,        //
//        ╣╜░╓≡Q▒╝▓██████████████████████████████████████▓██████████╬▓██████████████▄         //
//        ▌Q▄A▒╬╣████████████████████████████████████████████████▀╬▓██████████████████▓╬▒▒    //
//        ▀▄φ╬▓████████████████████████████████████████████████▀▄▓▓██████████████████████▓    //
//        ╠#▓█████████▄▄,          █   ╫█   ┌█        ]▌        ╒▌        ▐███████████████    //
//        ▓██████████████   j██▄▄▄█   `▀▀   █   ▐█Γ   █   `²"""▀███▌   ▓██████████████████    //
//        ██████████████▌   ╝R   ╒▌   ▄▄   ▐▌   ▓█   ▐▓≈ª═»M   ╟███   ┌███████████████████    //
//        ██████████████         █   ▐█⌐   █         █         ███▌   ████████████████████    //
//        █████████████████████▄▄█████████████████████████████████████████████████████████    //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract GH0ST is ERC721Creator {
    constructor() ERC721Creator("G.H.O.S.T. [INTERLUDE]", "GH0ST") {}
}
