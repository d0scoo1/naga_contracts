
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Nefters
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                   ▄▄▄▄                                                                   //
//               ╓▄▓▓▓▓▓▓▓▓▄╖                         ,▄▄▄▄                                 //
//           ,▄▓▓▓▓▀▀¬ ▓▓▀▀▓▓▓▓▄                     ▓▓▓▀▀▀ ,,                              //
//           ▓▓▓▀`     ▓▓▌  ^▀▓▓▓   ,▄▄▄▄▄    ▄▄▄▄,  ▓▓▓   j▓▓▓    ,▄▄▄▄    ▄▄▄▄  ▄▄▄▄▄     //
//           ▓▓▓  ▓▓▌  ▓▓▓▓▌  ▓▓▓  ▓▓▓▀▀▓▓▓▄á▓▓▀▀▓▓▓µ▓▓▓▓▓╫▓▓▓▓▓▓⌐▓▓▓▀▀▓▓▌▐▓▓▓▀▀]▓▓▓▀▀▀▀    //
//           ▓▓▓  ▓▓▌  ▓▓▓▓▌  ▓▓▓  ▓▓▓  ▐▓▓▌▓▓▓▓▓▓▓▓▀▓▓▓    ▓▓▓  ▐▓▓▓▓▓▓▓█╟▓▓▌   ▀▓▓▓▓▓▄    //
//           ▓▓▓  ▓▓▌  ▓▓▓▓▌  ▓▓▓  ▓▓▓  ▐▓▓▌▀▓▓▓▄▄▄▄ ▓▓▓    ▓▓▓▄▄⌐▓▓▓▄▄▄▄ ╟▓▓▌  ]▓▄▄▄▓▓▓    //
//           ▓▓▓▄ ▓▓▌  ▓▀▀   ▄▓▓▓  ╙▀▀   ▀▀^  ▀▀▀▀▀▀ ▀▀▀    '▀▀▀▀  ^▀▀▀▀▀  ▀▀`   ▀▀▀▀▀▀     //
//           ╙▀▓▓▓▓▓▌    ▄▄▓▓▓▓▀▀                                                           //
//              '▀▀▓▓▓▓▓▓▓▓▀▀'                                                              //
//                  └▀▀▀▀└                                                                  //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////


contract NEFTERS is ERC721Creator {
    constructor() ERC721Creator("Nefters", "NEFTERS") {}
}
