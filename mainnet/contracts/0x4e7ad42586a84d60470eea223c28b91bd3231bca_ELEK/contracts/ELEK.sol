
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Elektra Music
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                      @@@               @@#         #@@                                 //
//                     @@@               @@@         @@@@@@                               //
//           @@@@@@,  @@@      @@@@@@   @@@  @@@@    @@@   %@@   @@@      @@@&@@          //
//        @@@@   @@@ @@@@   @@@@   @@@ @@@@@  @@@@  @@@   @@@@%@@@@    @@@@ @@@@          //
//       @@@@@@@@   @@@@  ,@@@,@@@@   @@@@   @@@   @@@&  @@@@@ @@@@  @@@@@  @@@@  @@      //
//       @@@      @ @@@  @ @@@      @@@@@ @@@    @,@@@ @@@@@(  @@@@@@@@@@  @@@@ @@        //
//        @@@@@@    @@@,    @@@@@@   @@@   @@@@@  @@@@  %@@@         @@@@@ @@@@           //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract ELEK is ERC721Creator {
    constructor() ERC721Creator("Elektra Music", "ELEK") {}
}
