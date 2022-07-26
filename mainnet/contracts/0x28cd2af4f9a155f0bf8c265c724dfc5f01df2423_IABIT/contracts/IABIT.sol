
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: I am Bitcoin Art-1
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//            @@@@     @@@   @@@   @@@@@@@@ @@@@@@ @@@@@@@    @@@@@    @@@@  .@@@   @@@@@@          //
//           @@@@@@   /@@@@ @@@@@    @@@    @@     @@@  @@@   @@,@@    @@@@  @@@@  @@@  @@@         //
//           @@ @@@   @@@@@ @@@@@    @@@    @@@@@@ @@@  @@@  @@@ @@@   @@@@@*@@@@* @@@  @@@         //
//          @@@@@@@@  @@@@@@@@&@@    @@@    @@     @@@  @@@  @@@@@@@   @@ @@@@@@@@ @@@  @@@         //
//          @@   @@@  @@. @@@% @@    @@@    @@     @@@  @@@ @@@   @@@ @@@ @@@@ @@@ @@@  @@@         //
//         @@@    @@( @@  @@@  @@&   @@@    @@@@@@ @@@@@@   @@@   (@@ @@@  @@@  @@   @@@@           //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract IABIT is ERC721Creator {
    constructor() ERC721Creator("I am Bitcoin Art-1", "IABIT") {}
}
