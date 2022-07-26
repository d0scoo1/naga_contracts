
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ABSTRAVERSE
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
//                                                                                                //
//    MMMMMMMMMMMMMM@..........%MMMMMM:.........,MMMMMMMMMMMMMMMMMMMMMMMMMMMMM+..............,    //
//    MMMMMMMMMMMMMMM, . . ....,MMMMMM#... . . . #MMMMMMMMMMMMMMMMMMMMMMMMMMMM# . .. . . . ..+    //
//    MMMMMMMMMMMMMMM%      .  .@MMMMMM.   . .   :MMMMMMMMMMMMMMMMMMMMMMMMMMMMM.            .@    //
//    MMMMMMMMMMMMMMM@..........+MMMMMM+..........@MMMMMMMMMMMMMMMMMMMMMMMMMMMM+............,M    //
//    MMMMMMMMMMMMMMMM:. . .  . .MMMMMM@.. . .   .%MMMMMMMMMMMMMMMMMMMMMMMMMMMM#  .  .   . .%M    //
//    MMMMMMMMMMMMMMMM#          #MMMMMM:         ,MMMMMMMMMMMMMMMMMMMMMMMMMMMMM,          .@M    //
//    MMMMMMMMMMMMMMMMM. . ......:MMMMMM%. . . ....#MMMMMMMMMMMMMMMMMMMMMMMMMMMM+... . . . ,MM    //
//    MMMMMMMMMMMMMMMMM+   .    ..@MMMMMM.        .:MMMMMMMMMMMMMMMMMMMMMMMMMMMM@    .     %MM    //
//    MMMMMMMMMMMMMMMMM@.         %MMMMMM+         .MMMMMMMMMMMMMMMMMMMMMMMMMMMMM,        .@MM    //
//    MMMMMMMMMMMMMMMMMM:  ..   . ,MMMMMM@.. . . .. %MMMMMMMMMMMMMMMMMMMMMMMMMMMM+.. .   .:MMM    //
//    MMMMMMMMMMMMMMMMMM%          #MMMMMM,         ,MMMMMMMMMMMMMMMMMMMMMMMMMMMM@        %MMM    //
//    MMMMMMMMMMMMMMMMMMM. .... ...:MMMMMM%. . ......@MMMMMMMMMMMMMMMMMMMMMMMMMMMM,. . . .MMMM    //
//    MMMMMMMMMMMMMMMMMMM+      .  .MMMMMMM.         +MMMMMMMMMMMMMMMMMMMMMMMMMMMM%      :MMMM    //
//    MMMMMMMMMMMMMMMMMMM@......... %MMMMMM:..........MMMMMMMMMMMMMMMMMMMMMMMMMMMM@... ..#MMMM    //
//    MMMMMMMMMMMMMMMMMMMM,.. . . . ,MMMMMM# . . .. . %MMMMMMMMMMMMMMMMMMMMMMMMMMMM, . ..MMMMM    //
//    MMMMMMMMMMMMMMMMMMMM%         .@MMMMMM,         :MMMMMMMMMMMMMMMMMMMMMMMMMMMM%    :MMMMM    //
//    MMMMMMMMMMMMMMMMMMMMM...... . .+MMMMMM%. . .... .@MMMMMMMMMMMMMMMMMMMMMMMMMMM@.. .#MMMMM    //
//    MMMMMMMMMMMMMMMMMMMMM:    . .  .MMMMMM@.   ..   .+MMMMMMMMMMMMMMMMMMMMMMMMMMMM:. .MMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMM#..........%MMMMMM:..........MMMMMMMMMMMMMMMMMMMMMMMMMMMM%..+MMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMM, . .   . :MMMMMM# . .... . #MMMMMMMMMMMMMMMMMMMMMMMMMMMM. #MMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMM+..........@MMMMMM..........:MMMMMMMMMMMMMMMMMMMMMMMMMMMM:.MMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMM@.. ... ...+MMMMMM+. .... ...@MMMMMMMMMMMMMMMMMMMMMMMMMMM%+MMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMM:    .   ..MMMMMM@.    .   .%MMMMMMMMMMMMMMMMMMMMMMMMMMMM@MMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMM#          #MMMMMM,         ,MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMM. . . . ..:MMMMMM% .. . . ..#MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMM+         .@MMMMMM.         :MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMM@.... .....%MMMMMM+.... . . .MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMM,.........,MMMMMM# .........%MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMM%... ......#MMMMMM,....... .,MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMM. . . .. .+MMMMMM%. . . . ..@MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMM+         .MMMMMM@.         +MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMM#          %MMMMMM:         .MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMM,         ,MMMMMM#   .      #MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMM%......... @MMMMMM..........:MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMM@. .  . . .+MMMMMM+. .   . ..@MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMM:..........MMMMMM@..........+MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMM# ...... . #MMMMMM: . . . ..,MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMM.  ..     :MMMMMM#   .    . #MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMM+         .@MMMMMM.         :MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMM@. .... .  +MMMMMM+. . . .. .@MMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:         ,MMMMMM@          %MMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM%..... . . #MMMMMM, . . .. .,MMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM..........:MMMMMM%......... @MMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+.... .....MMMMMMM.. .......+MMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM@.. . . . .%MMMMMM:. . .. . .MMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM,         ,MMMMMM#.         %MMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM%          @MMMMMM,         ,MMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.   .     +MMMMMM%    . . ..@MMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:..........MMMMMM@....... ..+MMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM# . .   .  %MMMMMM:. .. . . .MMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM,.........,MMMMMM#..........#MMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM%. . . ....@MMMMMM. .. . . .:MMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMM@MMMMMMMMMMMMMMMMMMMMMMMMMM@.         +MMMMMM+  .   .  .@MMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMM+%MMMMMMMMMMMMMMMMMMMMMMMMMM:         .MMMMMM@.         %MMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMM.:MMMMMMMMMMMMMMMMMMMMMMMMMM# . .   .. #MMMMMM, .   . . ,MMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMM# .@MMMMMMMMMMMMMMMMMMMMMMMMMM.         :MMMMMM%          #MMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMM+..%MMMMMMMMMMMMMMMMMMMMMMMMMM+. . ......@MMMMMM.. . ... .:MMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMM.  ,MMMMMMMMMMMMMMMMMMMMMMMMMM@.         %MMMMMM+. .   . ..MMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMM#....@MMMMMMMMMMMMMMMMMMMMMMMMMM,.. ......,MMMMMM@  ..... ..%MMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMM:.   %MMMMMMMMMMMMMMMMMMMMMMMMMM% . . .. . #MMMMMM, . . . . ,MMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMM.    ,MMMMMMMMMMMMMMMMMMMMMMMMMMM.         :MMMMMM%         .@MMMMMMMMMMMMMMMMMMMMM    //
//    MMMM# ... .@MMMMMMMMMMMMMMMMMMMMMMMMMM+. ...... .MMMMMM@.. . . . .+MMMMMMMMMMMMMMMMMMMMM    //
//    MMMM:      +MMMMMMMMMMMMMMMMMMMMMMMMMM#          %MMMMMM:         .MMMMMMMMMMMMMMMMMMMMM    //
//    MMMM.......,MMMMMMMMMMMMMMMMMMMMMMMMMMM,.........,MMMMMM#..... ....#MMMMMMMMMMMMMMMMMMMM    //
//    MMM%. .   . @MMMMMMMMMMMMMMMMMMMMMMMMMM% . .. . ..@MMMMMM,     . ..:MMMMMMMMMMMMMMMMMMMM    //
//    MMM:........+MMMMMMMMMMMMMMMMMMMMMMMMMM@..........+MMMMMM+..........@MMMMMMMMMMMMMMMMMMM    //
//    MMM.. . . ..,MMMMMMMMMMMMMMMMMMMMMMMMMMM:...... . .MMMMMM@.. . . .. +MMMMMMMMMMMMMMMMMMM    //
//    MM%          #MMMMMMMMMMMMMMMMMMMMMMMMMM#     .   .#MMMMMM:.        ,MMMMMMMMMMMMMMMMMMM    //
//    MM:          +MMMMMMMMMMMMMMMMMMMMMMMMMMM.         :MMMMMM#          #MMMMMMMMMMMMMMMMMM    //
//    M@...     .. .MMMMMMMMMMMMMMMMMMMMMMMMMMM+ .. . . ..@MMMMMM. .    .  :MMMMMMMMMMMMMMMMMM    //
//    M%            #MMMMMMMMMMMMMMMMMMMMMMMMMM@.         +MMMMMM+         .@MMMMMMMMMMMMMMMMM    //
//    M,....... ....+MMMMMMMMMMMMMMMMMMMMMMMMMMM:.... . . ,MMMMMM@.. . .. . %MMMMMMMMMMMMMMMMM    //
//    @.  .      . ..MMMMMMMMMMMMMMMMMMMMMMMMMMM#          #MMMMMM,. . .. . ,MMMMMMMMMMMMMMMMM    //
//    %..............#MMMMMMMMMMMMMMMMMMMMMMMMMMM........ .:MMMMMM%. .... ...#MMMMMMMMMMMMMMMM    //
//    ,..............+MMMMMMMMMMMMMMMMMMMMMMMMMMM+..........MMMMMMM..........+MMMMMMMMMMMMMMMM    //
//                                                                                                //
//                                                                                                //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////


contract AV is ERC721Creator {
    constructor() ERC721Creator("ABSTRAVERSE", "AV") {}
}
