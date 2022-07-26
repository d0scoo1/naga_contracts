
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: unbanksy for Ukraine
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////
//                                                                       //
//                                                                       //
//                                                                       //
//                    ,--.                   ,--.                        //
//    ,--.,--.,--,--, |  |-.  ,--,--.,--,--, |  |,-.  ,---.,--. ,--.     //
//    |  ||  ||      \| .-. '' ,-.  ||      \|     / (  .-' \  '  /      //
//    '  ''  '|  ||  || `-' |\ '-'  ||  ||  ||  \  \ .-'  `) \   '       //
//     `----' `--''--' `---'  `--`--'`--''--'`--'`--'`----'.-'  /        //
//     ,---.                                               `---'         //
//    /  .-' ,---. ,--.--.                                               //
//    |  `-,| .-. ||  .--'                                               //
//    |  .-'' '-' '|  |                                                  //
//    `--'   `---' `--'                                                  //
//    ,--. ,--.,--.                   ,--.                               //
//    |  | |  ||  |,-. ,--.--. ,--,--.`--',--,--,  ,---.                 //
//    |  | |  ||     / |  .--'' ,-.  |,--.|      \| .-. :                //
//    '  '-'  '|  \  \ |  |   \ '-'  ||  ||  ||  |\   --.                //
//     `-----' `--'`--'`--'    `--`--'`--'`--''--' `----'                //
//                                                                       //
//                                                                       //
//                                                                       //
///////////////////////////////////////////////////////////////////////////


contract UBFU is ERC721Creator {
    constructor() ERC721Creator("unbanksy for Ukraine", "UBFU") {}
}
