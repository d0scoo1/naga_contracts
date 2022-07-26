
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 76series
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@............................@@@@@...........@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@...........................@@@,..........@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@..........................@@..........@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@.........................@@.........@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@........%.........@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@................................@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,...................................@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@........@..............*.............@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@.......%%%%%%%%....@@@@@@@@@@@.........@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@......&,%%%%%%%%%..@@@@@@@@@@@@@@........@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@.......@..@########%@@@@@@@@@@@@@@........@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@....#,,,&##@,#//,,//,#//#@@@@@@@@@@........@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@..../#,,,,##,,,,,@&*,,,#@@@@@@@@@@@....,...@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@......,#,,*###/@,@,,../#...@@@@@@......@@.#@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@.........@@,,@..  @. @ *  #...........@.@..@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@........@@@@,/,*(@ . @@*(.........@...%..@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@%,,,,,,,,@@...........*@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#####%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@ /@@@@@@@@@@@@##########@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@ @@@@   @        &... @@@@@@@*   @@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@    #        #&#%#  @@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@ ####### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract series is ERC721Creator {
    constructor() ERC721Creator("76series", "series") {}
}
