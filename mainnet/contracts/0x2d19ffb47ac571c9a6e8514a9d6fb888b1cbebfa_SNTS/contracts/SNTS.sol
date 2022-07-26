
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Santos
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                      //
//                                                                                                                                      //
//    &&&&&%&&&&&&&&%%%&&%%%%%%###%&%%&&&&&&%%%%##%%%%%%%#%%(#%#&&&&&&&&&&&&&&&&%/(%%#(/##%%##%%%%&&&&&&&&&%%%%%%%##&&%&&&&%&&          //
//    &&&&&&&&&&&&&&&&&&&&&&&##%%&&&&%%%%%%%%##%#%#(#%#%%&&&&&&&&@&&&&&&&&&&&&&@&&&&%%%%%%%%#####%&&&&&%&%%#%%%#####%%%%%&&%%&          //
//    &&&&&&&&@@@@@&&&&&&&&&%#%&&&&&&&&##(((##%#(#%%%&&&&&&&&&@@&&&&&@&&&&&@@&&&@&&&@&&&%%#####%%&&&%%&%%%%%####(###%%########          //
//    %%%%%&&&&@@&%%%%&&&&&&%%&&&&&&&&&%#%%%###%&&@&@&&&&&&&@&&@&&&&@&&&@&@&&&&&&@&&&&@&&&%#%%%%%%%#%%%%%&&&#((########(####((          //
//    &&%%%%%%%%&%%%%%&&%&%%&&%%%%&&&&&&%%&&%&@&@@&@&&&&&&&@@&@@@@@@@@&&&&&&&@&&&&&&&&&&@&&%%%%%%%##%%%%%%%%%(##%##########%##          //
//    &&%%%%&&%%##%&&&&&&%%%%%%%%&&&&&&&&%&&&&&@@&@&@&@&&@@@@@@@@@@&#@&@@@&&@&&&&&@&&&&&&@&&%%%###%#%&%%%%%%%#####((/(##%&#%%%          //
//    &&&%&&&&&&&&%%&%%%%&&&%%((%&%&%&#&&&&@&@@@&&&@&&@@@@&@&@@&&&@&@@&&@%@@&%&&@@&&&&&@&&@&&##%%%%&&&&&%%%%%%%##%%#####%&&&%%          //
//    &&&&&&&&&&&&&&&&%%%&%%%%%(#(#%%&&&&&&@@@&@@@@@@@@&@@@&&&&&&&&&%&&%%%&&@%&&#&@@@&@&&&&&&(#&%%&&%%&%%########%%%#####%#%%#          //
//    &&&%%%%&%%&&&&&%%%&%&%%%%&%#%&&&&&&&@@&&&&@@@@@&@@&&&&&&#&&&&%(%&%&&%&%&&&&&&&&&&&&&@@&%%&&&&&&&&&&%%%%%&&&&%%####%%%%&#          //
//    &&&%%%%%%#%&&&&&&&&%&%%%%%%%&&&&&&@&&@@@&@@@@&&%&&@&&&%&&&&%(##(////**//(%@&&&&&&&&&&@&&%%%%%%&&&&%%&&&&&&&&%###%%%%#%&&          //
//    &&&%%&&&%#(#%%&&%%%%%&%%%&&&&&&&&&&&&&@&@@@&%%&###%%%#(//********/***/////#&&&&&&&@&&@&&%&&##%%###%##%%%&&&&&%#%%%%%###(          //
//    %%%%&&&%%%##%&&&&&%###%%&&&&@&&&&&&&@@@@&&&%%%#%/((//***,***,,,*****,**,***/&&&&&&&&&@&%%%&&%#(##(#####%%%%%#%%%%#####%#          //
//    #%&&&&%%#%##%&&&&%%%%%%%&&&&&&@&@&&@&@@&&%%%%#(////**,****,,#&&&&&&&%(/*/(%&%%@&&&&&@&&%%%%#####%&&&%&%%%%((%%%##%&&%##(          //
//    &&&&&&%%%%%%%&&&&&&%%%&&@&&&&&&&&&&&@@&&%%%##(//***,,****(##(#(%(#%#%(**(#(#(/&&&&&&@&%&&%((#%&&&&&&%%%%%%%%%##%&&&&%%%%          //
//    &&&&&&%%&&##%&&&&&%%%&&@&@&&&&&&&&&&@@&&%##((///*,,,,***/((%&#((((#((/,./(/%#%&&&&&@&%##(#%&&&&&&&&&####%######%%%&&&%#%          //
//    &&&&&&&&&%###%%%%%%%%@&&&&&&&&@&&&&&@@##(%(**/***,,,,,..,,,,,,,****,...,..,*/(&&&&@&####((((%&&&&&%%%###%%%#(###%%%%#%(#          //
//    &&&&&&%#((((##%%%%&&&@@@&&&@&@&&&@@@&#%#(%((/*///**,,,,......,..,,..*,,..,**///&&@&%&%%####%%%%%%%&&&&&%%%%%%#%%%#%%%%##          //
//    &%%#((((((((###%%%%#&&&&@&&&@&&@&&&@&%#(*#&&,**//**,,,,,,,,,...,,,*/#*/&#%#%/*//&&&&&&&&&&%#%%##%%%&&&%%%%%%#%%%%%%%%###          //
//    &%%(((#((((#(##%%%##&&&&&@&@&&&@@@@@@@((*(/(#,*/***,***,*,,,,,,,*,,,,,**///#(**/&&%%&&&&&%%&&&%%%%#%%%&%%%%###%&%%%#%&&&          //
//    ###(((((##%%&&&&%###&&&&&&&&&&@&&@@&&@&&/(/,***/(****,*,,,,,**,,,,*/(%#/##((%%(/&&&%&&%%%%%%%&%%%%##(##%%####%%%#((/%%%%          //
//    &%#(((((#&&&&&&&%%%##&&&&&&&&&&&@&&@&&&%##(/%(&/#(***************/###/**//(((#%/%%%%%%%&%%%%%%%#######(((%&&&%&&%%####%#          //
//    &%##%%#%%%%&&&&%%%###%&&@&&&@&&&&&&@&&&@&##(/(((#%((**///*//***///**,***/#(**/*/#%%%&%%%%%#########(##(#%%%&%&&%%&%%##(/          //
//    &&%%%%%%%&&&%%&&%%%%%%%&&&&&&&&&&&&&&&&@@&#((***/(#%(/(////////(/**,,*,,,,****/%%%%%%%#%%%%%##(##%&%#(#%%%%####%####(///          //
//    &&&%%%&&&&&&%##&&&%%%%##&&@@&&@&&@&&&&&&@@&(/*****%%%%#(((##(((#((///**/**//((%%%%%%%%%%%#%%###%%%%%%###%#%&%%##((#(((//          //
//    &&&&%%&%%&&%###%&&&%%%%%##&&&&&&&&&&&&&&@#&(/******%&%%%&&&&&%&&&%&&%%%%%%%&%%%%%%#%#%%%%%###%%%%%%&%&%#%%%%%%#####(##(#          //
//    &&&&&&&&&&&&&&%&&&&#(((%%%%%#&&&&@&&&&&*,,&(*/**,*/((%%&&&&&&&@&%&@&&@&&&%&&&&%%&&&&&%%%%%%%%&&%%%&&%&&&&%%%###(#%#(#%&&          //
//    &&&&&&&&&&&&&&&&&&&&%#%%%%%%%###%%&&&&,.....%*,***//*((###%%&&&&&&&&&&&&&&&%&&&&%%%%%#%&&&&&&&%%%%%&%##%#%%(((//#%%#%%%#          //
//    %&&&&&%&%###%%&&&&&&&&&&&&&&&&&&&%%%%......  ,#/(*////((((###%###((#(%(((&&%#((*%&%%%#(#%&&%%%%%%%%%##%##%#(((%%%%%##%%(          //
//    &&&&&&&%((#####%%%&&&&&&&&&&&&&&%%.,*.. .      .(////////((((((((((((((##&%%%##(%*#&%%#(%%&&%%%%%%%%%%%#//(/%&%%#%&%%#(#          //
//    &&&&&%((##########(##%%%%%%&%&&,...,./.          .(.////////(///////((((#%&&##(##(***,,%&%%%%%%%%%%%%%%#(//(%%%##%%%%%%%          //
//    #(#%#(############((&&%%%%...... ..,....      .%%##**//*////////////(((##%&#(#%&//*,,.,(%%%%%&%##%%%%%%(//(%%##/#%%%%%%%          //
//    ####%%#%%##%##%%##%&&%%...,,....  ..,..,     *##%%%#*,.//////////////((##*#///*,,,,,,*,,,,,,,(#####%%%/(###(#%#/##%%%%%#          //
//    ##%%#%%&&%%##(##%&.......... .... *#.,..  .*#%%%%%##(,,.   ,********/....**,*,,,...,,*,,,,,,,.,..(,#%#(###((((%%%%%%##%%          //
//    %##%&&&&%%#%%%&..,.................  .*,.*///(((#(#(((/..            .....,,,......,(/*,,,,,....,......#####%((%%##%%%%%          //
//    %&%%&%%&&%%......................,.   ,.....,.,,,***/***..               .........,***/,,,,,.............###((%###%#####          //
//    %%#%%&&&%.......... ...../*/......... .........,%.,,****,..             .,....,.,******,.,,................((%&&&%%#####          //
//    %%&%%&%...................,..........  .........,....,,,,,...           .,....,//***,*,,.................,..####%%#%##(#          //
//    &&&%%%......,.%,.,...,...,,,........   ...... . ......,,,,,,,..         ..... ///*,,,,,....................../%%%%%%%&&&          //
//    &&&&,............,,...,,,,.,,,......... /...............,,**,%,.       ......///*,,,,.#,.............../.......(%%#%&%%%          //
//    &&%..............,*,.,.,,,,*,*.................  . ......,,,**,..      .....****,,............... ..............#%%%%%%%          //
//    ##%..............,*///*,,,,*,*,..,,,,,,....... ..  ........,,,,,.,,    ....****,,............... .................##%%%%          //
//    &%.*.........,.,..,**/#*,,,,,//,.,,,,,........................,,,.,,,.....,***,,...................................###%%          //
//    %........,..,,,,,,,,%(*(**,,*(/,,,................../...........,,.......,,*,,*/,............... ..#.................%%%          //
//    .,.........,...,,,*,,*/((***/(/*,,,..............................,...*,,*.,,,,,............ ..... ......  ............%%          //
//    .........,,,,*,.,,,****/#***/(/*,,,.,.............................,... /,(.,,,.............. ... ............/........./          //
//    .,*.....,*,,..***,,,***#(/**/((/,,,,,,...................................,..,,............  .,.. ...........,...........          //
//    .....**....,,,*****,*/((%&**/(//,,,,,,,..../,*....... ..................,*,.................................,,.... ..,..          //
//    ......,,,*,....,,,,//,,*/(**/((/*,,,,,,,................................,*,,,...............................**...... ...          //
//                                                                                                                                      //
//                                                                                                                                      //
//                                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SNTS is ERC721Creator {
    constructor() ERC721Creator("Santos", "SNTS") {}
}
