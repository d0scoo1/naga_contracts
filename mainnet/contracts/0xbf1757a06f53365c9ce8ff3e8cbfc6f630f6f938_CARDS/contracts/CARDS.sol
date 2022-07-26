
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Sneaker Cards
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                         ,--.                                ,--.                          //
//      .--.--.          ,--.'|    ,---,.   ,---,          ,--/  /|    ,---,.,-.----.        //
//     /  /    '.    ,--,:  : |  ,'  .' |  '  .' \      ,---,': / '  ,'  .' |\    /  \       //
//    |  :  /`. / ,`--.'`|  ' :,---.'   | /  ;    '.    :   : '/ / ,---.'   |;   :    \      //
//    ;  |  |--`  |   :  :  | ||   |   .':  :       \   |   '   ,  |   |   .'|   | .\ :      //
//    |  :  ;_    :   |   \ | ::   :  |-,:  |   /\   \  '   |  /   :   :  |-,.   : |: |      //
//     \  \    `. |   : '  '; |:   |  ;/||  :  ' ;.   : |   ;  ;   :   |  ;/||   |  \ :      //
//      `----.   \'   ' ;.    ;|   :   .'|  |  ;/  \   \:   '   \  |   :   .'|   : .  /      //
//      __ \  \  ||   | | \   ||   |  |-,'  :  | \  \ ,'|   |    ' |   |  |-,;   | |  \      //
//     /  /`--'  /'   : |  ; .''   :  ;/||  |  '  '--'  '   : |.  \'   :  ;/||   | ;\  \     //
//    '--'.     / |   | '`--'  |   |    \|  :  :        |   | '_\.'|   |    \:   ' | \.'     //
//      `--'---'  '   : |      |   :   .'|  | ,'        '   : |    |   :   .':   : :-'       //
//                ;   |.'      |   | ,'  `--''          ;   |,'    |   | ,'  |   |.'         //
//                '---'        `----'                   '---'      `----'    `---'           //
//      ,----..     ,---,       ,-.----.       ,---,      .--.--.                            //
//     /   /   \   '  .' \      \    /  \    .'  .' `\   /  /    '.                          //
//    |   :     : /  ;    '.    ;   :    \ ,---.'     \ |  :  /`. /                          //
//    .   |  ;. /:  :       \   |   | .\ : |   |  .`\  |;  |  |--`                           //
//    .   ; /--` :  |   /\   \  .   : |: | :   : |  '  ||  :  ;_                             //
//    ;   | ;    |  :  ' ;.   : |   |  \ : |   ' '  ;  : \  \    `.                          //
//    |   : |    |  |  ;/  \   \|   : .  / '   | ;  .  |  `----.   \                         //
//    .   | '___ '  :  | \  \ ,';   | |  \ |   | :  |  '  __ \  \  |                         //
//    '   ; : .'||  |  '  '--'  |   | ;\  \'   : | /  ;  /  /`--'  /                         //
//    '   | '/  :|  :  :        :   ' | \.'|   | '` ,/  '--'.     /                          //
//    |   :    / |  | ,'        :   : :-'  ;   :  .'      `--'---'                           //
//     \   \ .'  `--''          |   |.'    |   ,.'                                           //
//      `---`                   `---'      '---'                                             //
//                                                                                           //
//                                                                                           //
//                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////


contract CARDS is ERC721Creator {
    constructor() ERC721Creator("Sneaker Cards", "CARDS") {}
}
