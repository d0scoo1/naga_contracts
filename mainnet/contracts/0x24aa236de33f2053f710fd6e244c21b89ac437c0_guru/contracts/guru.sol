
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: guru sounds
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////
//                                                   //
//                                                   //
//      .--.    ___  ___   ___ .-.     ___  ___      //
//     /    \  (   )(   ) (   )   \   (   )(   )     //
//    ;  ,-. '  | |  | |   | ' .-. ;   | |  | |      //
//    | |  | |  | |  | |   |  / (___)  | |  | |      //
//    | |  | |  | |  | |   | |         | |  | |      //
//    | |  | |  | |  | |   | |         | |  | |      //
//    | '  | |  | |  ; '   | |         | |  ; '      //
//    '  `-' |  ' `-'  /   | |         ' `-'  /      //
//     `.__. |   '.__.'   (___)         '.__.'       //
//     ( `-' ;                                       //
//      `.__.                                        //
//                                                   //
//                                                   //
///////////////////////////////////////////////////////


contract guru is ERC721Creator {
    constructor() ERC721Creator("guru sounds", "guru") {}
}
