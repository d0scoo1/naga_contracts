
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: GoofyFroot-MintPass
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  %@@@@@@@@&           %@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%                                            @@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@#        ,@&@@@@@@@@@@@@@@@@@@@@@@@@@@&                                                        .@@@@@@@@@@@@@@@@    //
//    @@@@@@@( @*****#@@@@&.     @@@@@@@@@@@@@@@@@@@                                                          @@@@@@@@@@@@@@@@    //
//    @@@@@@@@  #@@**********@@   @@@@@@@@@@@@@@@@@@                                                          @@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@#   @@*%*****@@    @@@@@@@@@@@@@@@@                                      *##((//.     #       &@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@  ,@@*@*******@  #@@@&%     @@@            ####     ######   ##*  ##  #(      *## #(          &@@@@@@@@@@@@    //
//    @@@@@@@@@@@@  @&**@**********/@&&@**@   &&.           #,       ##      # #(      # #####      #,              ,@@@@@@@@@    //
//    @@@@&       .@@@*@**(**************/%%%#(&@&         ##   #### ##     .# ##     ## *#         ##                  ,@@@@@    //
//    @@@@@     @@@*************************%@              ###  ###  *#####(    *###*                                    @@@@    //
//    @@@@@%   @#*****#@*%**********((((##(&@                             /                    .#,   ########             @@@@    //
//    @@   %@&@@@@@&(@@****#@@((((((((((((((((@&                 /###### ###(###   ##*  ##  ##.    #,   #                 @@@@    //
//    @@@@,    &((((@@@@(((((((((((((((((((((((@@@               ##      #(   (#  #(      # #      *#   #,                  @@    //
//    @@@@@  @@((((((((((((((((((((((((((((((((@@&               ,####   *#( ,##. ##     ## /#    ##    #(                  .@    //
//    @@@@  @@((((#((((((((((((((((((((((((((((@@                 #       #     ,#  /###*      .*.                           @    //
//    @@@@  @@&(((@((((((((((((((((((((((((((((@@                                               .                           @@    //
//    @@@@  &@@((((@(((((((%@((((((((((((((((((@@                                                                          @@@    //
//    @@@@@  @@@((((@(((@(((((((((((((((((((((((@@@                                                                       &@@@    //
//    @@@@@#  @@%(((((((((((((((((@@@@@%((((((((((#@@   *@@@                                                             .@@@@    //
//    @@@@@/  @@((((%(((((((((@(((((((((((@@((((((((@@@  .@@@@&                                                  %       @@@@@    //
//    @@@@&  @@(((((((((((((@(((#(((((((((((@(((((@((@@@  @@@@@&             .@@/                   &@&%@@(@@%           @@@@@    //
//    @@@   @@(((((@(((((((#@((((((((((((((((@((((((((@@  @@@@@@@@@      @@@@@@@@@@              ,&                    @@@@@@@    //
//    @@  #@@((((((((((((((&&((((@@@@@@@@@   @((((((((@@  @@@@@@@@@@@@@@@@@@@@@@@@@              @    %@@@@@@@@@@@@@@@@@@@@@@@    //
//    @   @@@(((((@(((((((((@     @@@@@      @((((@((#@.  @@@@@@@@@@@@@@@@@                      &   @@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @%  @@@((((((@((((((((((@            @%((((@((@@  /@@@@@@           %@,,*&*@                   @@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@  &@@@(((((@%((((((((((((@@@&@@@@&(((((((((@@  @@&@   @@,,,,,,,,,,,,,,@/@**                 @@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@  @@@@(((((@(((((((((((((((((((((((((((((((@   @@,,,,,,,,,,,,,,,,,,,,@@***@                @@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@   @@@@((((((%@@((((((@@%((((((@@@@@@@(#&,,,,,,,,,,,,,,,,,,//@@&@.                        &@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@   @@@@#(((((((((((((%@@@@@@@@@@(,,,,,,,,,@@@@@&&/.         (                    @,     @@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@    @@@@@(((((((((((((((((@@@@@@((((((((@@  @&&@@@@@@@@@@@@@@@                  @%     @@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@    @@@@((((((((((((((((((((((((((((((@&  @@@@@@@@@@@@@@@@@            &    &/      @@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@   &@@@(((((((((((((((((((((((((((((%@   @@@@@@@@@@@@@@@@@@@@@                  #@@@@@@@@@@@@,        @@@@@@@@    //
//    @@@@@@@@@@@   @@@((((((@((((((((((((((((((((((%@   @@@@@@@@@@@@@@@@@@@@@@@@@@@.       /@@@@@@@@@@@@@   &@@(((@@  #@@@@@@    //
//    @@@@@@@@@@@@  @@@#((((((@@(((((((((((((((((((((@,  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@(((((((@  .@@@@@@@    //
//    @@@@@@@@@@@@   @@@(((((((@(((((((((((((((((((((@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @%((((((((((@  @@@@@@@@    //
//    @@@@@@@@@@@@@   @@@((((((@@((((((((((((((((((((&@  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    @&(((((((((((((&  &@@@@@@@@    //
//    @@@@@@@@@@@@@.  @@@(((((((@((((#((((((((((((((((&@@   .@@@@@@@@@@@@@@@@@@@@@@@@@@@@%    @@((((((((((((((((@  /@@@@@@@@@@    //
//    @@@@@@@@@@@@@&  @@@@(((((((@(((#((((((((((((((((((#@@@@          *&@@@@@@@@@@&     @@#(((((((((((((((((&@   @@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@   ,@@@(((((((@(((((((((((((((((((((((((@@@@@@@@@@@@&           @@#((((((((((((((((((((@@   @@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@   @@@&((((((#@(((((((((((((((((((((((((((((((((((((((##%&@@&(((((((((((((((((((((&@&   @@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@#  @@@@(((((((@@((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@   @@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@   @@@@((((((@#(((((@@(((((((((((((((((((((((((((((((((((((((((((@(((((((@@@   @@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@   @@@(((((((@&(((((((((((((((((((((((((((((((((((((((((((((@@(((((((@@.  @@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@  @@@@((((((((((@&((((((((((((((((((((((((((((((((((((@@#(((((((@@@   &@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@.  @@@(((((((((((((((((((@#(((((((((((((((((((((((@@((((((((@@@%   &@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@&  .@@@@@@&((((((((((((((((((((#&@@@@@@@@@@@@#(((((((((%@@@%   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@       /@@@@@@(((((((((((((((((((((((((((((((((((@@@@%  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@/    %@@@@@@@#(((((((((((((((((((((%@@@@@    (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&       /@&@@@&@&/,.  *@&@@&@@*      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%      ,,/&@&&&&       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract ROTP is ERC721Creator {
    constructor() ERC721Creator("GoofyFroot-MintPass", "ROTP") {}
}
