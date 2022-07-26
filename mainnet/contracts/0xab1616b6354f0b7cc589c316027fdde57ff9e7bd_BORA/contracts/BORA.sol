
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Bora Family Chronicles
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
//                                                                                                          //
//                                                                                                          //
//                                                                                                          //
//                    ___               ,--,    ,--,                                 ___      ,---,         //
//                  ,--.'|_    ,--,   ,--.'|  ,--.'|                               ,--.'|_  ,--.' |         //
//                  |  | :,' ,--.'|   |  | :  |  | :                               |  | :,' |  |  :         //
//                  :  : ' : |  |,    :  : '  :  : '                               :  : ' : :  :  :         //
//       ,--.--.  .;__,'  /  `--'_    |  ' |  |  ' |     ,--.--.          ,---.  .;__,'  /  :  |  |,--.     //
//      /       \ |  |   |   ,' ,'|   '  | |  '  | |    /       \        /     \ |  |   |   |  :  '   |     //
//     .--.  .-. |:__,'| :   '  | |   |  | :  |  | :   .--.  .-. |      /    /  |:__,'| :   |  |   /' :     //
//      \__\/: . .  '  : |__ |  | :   '  : |__'  : |__  \__\/: . .     .    ' / |  '  : |__ '  :  | | |     //
//      ," .--.; |  |  | '.'|'  : |__ |  | '.'|  | '.'| ," .--.; |     '   ;   /|  |  | '.'||  |  ' | :     //
//     /  /  ,.  |  ;  :    ;|  | '.'|;  :    ;  :    ;/  /  ,.  |  ___'   |  / |  ;  :    ;|  :  :_:,'     //
//    ;  :   .'   \ |  ,   / ;  :    ;|  ,   /|  ,   /;  :   .'   \/  .\   :    |  |  ,   / |  | ,'         //
//    |  ,     .-./  ---`-'  |  ,   /  ---`-'  ---`-' |  ,     .-./\  ; \   \  /    ---`-'  `--''           //
//     `--`---'               ---`-'                   `--`---'     `--" `----'                             //
//                                                                                                          //
//                                                                                                          //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BORA is ERC721Creator {
    constructor() ERC721Creator("Bora Family Chronicles", "BORA") {}
}
