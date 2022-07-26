
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Fish & Bones Guild
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//                                                                                       //
//                                       ╓╓╓╗╗╗╗╦╓                                       //
//                              ╓╓╗╗╝╜╩╙╙         ╙╙╜╝╝╗╗╖╓                              //
//       ╔╜╙╗            ╗╗╝╜╩╙        ╓╓╗╗╣╣╣╣╣╗╦╓╓       ╘╙╙╜╝╗╗╕             ╓╝╙╟╕    //
//      ╓ ╙╙╤╬╜╦╖╓       ╒╬╒╣    ╓╖╗╣╣╣╣╣╣╣╣╣╩╝╣╣╣╣╣╣╣╣╣╗╖╓╒   ╚╛╟╬        ╓╗╬╫╗╝╙╘╟     //
//       ╙╙╙╙╙╗╦╖═╜╜╫╗╦   ╫  ╒╣╣╣╣╝╬╬╣╣╣╣╣╣╜    ╙╣╣╣╣╣╣╣╣╣╣╣╣╣╬  ╟╬  ╓╓╦╬╬╬╟╟╟╝╩╙╙╙      //
//              ╘╙╝╦╖╕╩╩╬╟╫   ╣╣ ╫╣╣╣╣╣╣╣╣╣╖╓╓╓╓╖╣╣╫╣╣╣╣╣╣╣═╟╣╬  ╫╫╙╫╬╬╬╟╫╩╙             //
//                    ╙╝╖╩╟╕  ╫╣ ╫╣╣╣╣╣╣╣╣╬╙╙╙╙╙╙╟╣╣╣╣╣╣╣╣╣═╫╣   ╣ ╗╫╜╙                  //
//                     ╓╩╓╜╫  ╟╣╣╟╣╣╣╣╫╣╣╣╜╜╜╜╜╜╜╜╫╣╣╣╣╣╣╣╣╓╣╣  ╟╩╟ ╫                    //
//                     ╟═╙ ╟╕  ╣╣╬╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╣╬╣╣╩  ╣ ╟ ╟                    //
//                      ╖╓╫ ╫  ╟╣╣╣╣╣╣╖╓╓╓╓╓╓╓╓╓╓╓╓╓╓╓╟╣╣╣╣╣╣  ╫╛ ╬╓╟                    //
//                           ╣  ╫╣╣╣╣╣╣╣╣╣╙╙╙╙╙╙╙╙╫╣╣╣╣╣╣╣╣╣  ╟╩                         //
//                           ╙╣  ╫╣╣╣╣╣╣╣╣╣╝╝╝╝╝╝╣╣╣╣╣╣╣╣╣╣╜ ╓╜                          //
//                          ╓═╜╣  ╫╣╣╣╣╣╣╣╣╗╗╗╗╗╗╣╣╣╣╣╣╣╣╣╩ ╓╩╝╖╓                        //
//                     ╓═╜╙ ╓═╩╙╫  ╙╣╣╣╣╣╣╣╣╣  ╟╣╣╣╣╣╣╣╣╣  ╫╜╙╙╗╦╘╙╝╖╓                   //
//                ╓═╜╙╓╓═╩╙╒╓═╜╙╘╙╦ ╙╫╣╣╣╣╣╩╒╓╖╓╙╣╣╣╣╣╣╜ ╓╣╘ ╙═╖╓╘╙╙╗╦ ╙╝╗╓              //
//            ╗╜╙╓╓═╩ ╓╓═╜╙        ╫╖ ╙╫╣╣╣╣╣╣╣╣╣╣╣╣╣╜ ╓╫╜        ╙═╖╓╒╙╙╗╦│╙═╖          //
//         ╓╬╓═╩ ╓╓═╜╙              ╙╫╦ ╘╙╣╫╣╣╣╣╣╣╜╘ ╓╣╜                ╙╝╗╦╒╙╙╗ ╬╗      //
//       ╘╙╙╙╙╙                       ╙╗╦  ╙╝╝╩╘  ╗╝╙                        ╙╙╙╙╙╙      //
//                                        ╙╣╦╒ ╓╗╜╙                                      //
//                                           ╙                                           //
//             ╞╣╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╣╬             //
//             ╟╣   ╓   ╓    ╓     ╓╓╓╓    ╓╓  ╓    ╓      ╓       ╓  ╓   ╟╬             //
//             ╟╣   ╣╬╓╣╩    ╫╣   ╟╣╜╙╙╙   ╣╣ ╟╣═  ╟╣ ╫╣╦  ╫╬ ╫╣╦  ╫╬ ╫╬  ╟╬             //
//             ╟╣   ╣╣╣╩    ╫╣╫╣  ╟╣╣╣╣    ╣╣ ╟╣═  ╟╣ ╫╣╫╣╦╫╬ ╫╣╫╣╦╫╬ ╫╬  ╟╬             //
//             ╟╣   ╣╬╙╣╦  ╫╣╣╣╣╣ ╟╣╖╓╓  ╓╓╫╣  ╣╗ ╓╣╣ ╫╣  ╙╣╬ ╫╣ ╘╚╣╬ ╫╬  ╟╬             //
//             ╟╣   ╙   ╙╙╙╙    ╙╙ ╙╙╙╙ ╙╙╙╙   ╙╙╙╙╙  ╙╙    ╙ ╙╙    ╙ ╙╘  ╟╬             //
//             ╟╣     ╓╖╖     ╗╦          ╔   ╬          ╗╖       ╓╖╖╓    ╟╬             //
//             ╟╣   ╫╬╝╣╣╣╬   ╘╫╣╣╖   ╟   ╫  ╓╣  ╟╕  ╟  ╓╣╙╫╣╦  ╔╣ ╫╝╜╙╓  ╟╬             //
//             ╟╣  ╙╣╝╘╣ ╒╙═   ╟╣╣╣ ╚╛╟╛╝ ╫╘╝╙╣╙╩╟╩╚ ╫╛╝╙╣╣╣╣╣  ╫╝╩╘╣ ╗╘  ╟╬             //
//             ╟╣    ╫╬╔╣╣╜   ╗╣╜╙    ╘   ╬   ╬      ╘   ╫╣╝╙    ╝╣╣╖╚╝   ╟╬             //
//             ╟╣                                                         ╟╬             //
//             ╙╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╝╩             //
//                                                                                       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


contract fishbone is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
