
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Treasures of the West
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                               //
//                                                                                                                                                               //
//     ##############################((###((##(#(###((########((((//////////((((/((((((/(//(((((((/(((((((((((((((((((((((((((((((##(((((((((((((((((((((((((    //
//    ######((((##(#(##(((#####(((((((###(#((#(((((((#((((((((#((((((////////*****/////(//((((((//////(/////((/(///(((((((((((((((((((((((((((((((((((((((((     //
//    ((((((((((((((((((((((((((#(((((((((((((((((((((((((((((((((((((((((((((((((////***************/////////////((((((((((((((((((((((((((((((((((((((((((     //
//    (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((////(//////***********************/**///(((((((((((((((((((((((((((((((((((((((((((((((((     //
//    ((((((((((((((((((((((((((((((((((((((((((((((((((((((////////*****************************/*////////(((((((((((((((((((((((((((((((((((((((((((((((((     //
//    ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((///*****,*,,,,,,*,,,,***********///(((((((((((((((((((((((((((((((((((((((((((///((///*/*///     //
//    ,**//((((((((((((((((((((((((((((((((((((((((((((///*/******,,,*,,,,,,,,,,,,,,*************///(((((((((((((((((((((((((((((((((//*********************     //
//    *********/(((((((((((((((((((((//(((((((((((((//**,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,****///(/(((((((((//(////(((((//**,,**,,,,,,**************     //
//    /////*////(((((((((((((//((((//((/////(/((/(/////*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,****/////////////(//**************,,,,,*,*******     //
//    (((((((((((((///((((/((((/(/(((/(/(/(////(///////////////////////********************/*////////////////////////////////////****,,***,,,,,,***,*,,,,,,,     //
//    /((/(/((((//(/////////////////////(////////////////////////////////////////////////////////////////////////////**********,,,,,,*,,,,,,,,,,,,,,,,,*,***     //
//    ///////////(/////////////////////////******/****////////////////////////////////////////////////////////////**,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,     //
//    ////////////////////////////////////**,,,,,,,,,,,,,*,*********/*//*////////////////////////***,,,,,,,.,,,,,,,,,,,,,,,,,,,,,,,,*,,,,,,,,,,,,,,,,,,,,*,*     //
//    /////////////////////////////////////*******************************/*******/***///**/*******///******//**/************/*********////*/*///***********     //
//    ///////////////**/***********/*******,,,,,**,,,*******************************************************************************************************     //
//    ******************************,,*,,,,,,,,,,,,,,,,,,,**,,,************************************/(#/*****************************************************     //
//    *******************************************,**********************************************(&&&&&@@@%**************************************************     //
//    ***************************************,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,**,****************&&&&@@@@@@&*************************************************     //
//    *********************************,,,,,,,******,,,,,,,,,,,,,,,,,,,,,**,************,***,,*&&&&@@@@@@@#,,,,,,,,,,,,,,,,,****,*****************,*********     //
//    *******************************************************,,*,,,,,,*,,,,*,,,,,,,,,,,,,,,,,,*@&&&&&&@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*,*,*,,*******     //
//    *******,******************************,*,,,,,*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%%%%%@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,     //
//    ,,,*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%&&%&&&&@@@@@@@@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,     //
//    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%%%&&&%&&&@@@@@@@@@&@@/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,     //
//    ,,,,,,,,,,,,,,,(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/%%%%&%&&&&&&&@@@@@@&@@@@@&,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,     //
//    ******///,****//*/((*******////**/////////////////**,,,,**/***/*//*,*/**,****%%&%&&@&&&&&&&@@@@@@@@@@@@@@@@****/*//*//////*/////****/*****************     //
//    %#(%((*#(((((#(((((/((//(**##(//***(#///////////((/(((//////////(//(((/(/(/(#%%%&&@@@@@@&@@@@@@@@@@@@@@@@@@@&//*//***(/***//////**//(*****/*****/#(//*     //
//    (/(//((/(////(///////**//***///**//*///*/////////////////////////*/*////(%#(%%&&&&@@@@@@@@&@@@@@@@@@@@@@@@@@@@##%%#%#%#%%%%%%%%%%#%#%%%#%%##(#((((/(//     //
//    ///////////*/***/****//*//((//*///***/*/*///********/***//***/**//#/(//**//%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*****/*/****/*****/***/**//////*/**//*/*     //
//    (((((//((((//(/(/(//((///(/////////////*/*////*******/****///*//(#*/*/****#%&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@***************/************************     //
//    ((((///*////////*//*///((((/((/(((((/(//(///////*//(///**/(////****////*/#%%&&&@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@***************//*/**///*///***/********     //
//    //////(((((((#(((((((////(///((((((((////(//(/(*////((///(((//(///(//*(//#&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#///*//*////(//((#(/////*//*//(//////***     //
//    /(#(((////((#(///////(((/(/(((##%%###((/////(///(%%###%%##(#%&###(///((((%%&&@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@//////////////*////*//*///*/*//*//(////     //
//    ////*////////////((////////*/////##/#((#(#((((((((((#((((/%(#%(////(/////&@&&&@@@@@@&&@&@@@@@@@@@@@@@@@@@@@@@@(*/////////////(#***////////(//((//////*     //
//    //*////(//(((///*/(#///(/(((//(/(/(/((/(/////#(//////////////*//((((((//#&&@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@*//**/***//**//////////*/////////(//****     //
//    /((/(//((//////////////////*//////////////////**///////*/(///////(//(//*%&&@&@@@@@&@&&&&&&@@@@@@@@@@@@@@@@@@@/***///**////////////////////////////////     //
//    (///((///////(////////////*/////////(///*/////*///**/////*////(/#(#((#(/&&@@@@#@&@&&&&@@@@@@@@@@@@@@@@@@@@@@//////(///*//////////////////**/////****//     //
//    ///////////////////*/(#///*/(////(((///(((((/////////(/*/(//////((///(/((&@@@@&&&&@@&&@@@@@@@@@@@@@@@@@@@(*//(///((/*///////(//(//////////(//*(///*//(     //
//    (/(//////////(((((#((((/////(/(/*((////*/(//((///((//*#((//(/(//////*///(&@@@&@@&@&&@@@@@@@@@@@@@@@@@@@@((////(//(/////((/(((////////((#(((///((((/(//     //
//    /((//*/(/////(#(/////*///*#((((///((/////////////*/*/////////*(///////(/(&&&&@&&&@@@@@@@@@@@@@@@@@@@@@@#//////////////(/(((////////////////////////((/     //
//    (////////(/(((////(/(//(//(///(/((//(((///(//////////(///(//////(///////%&&%&&@&&@@@@@@@@@@@@@@@@@@@@@@/////(/*////(/(///*/((//////////////////(((////     //
//    (((//#(//(/(((/////((/(/(/(/////////////((/((///////*//**//////(////////&&&&&&&&@@@@@@@@@@@@@@@@@@@@@@/(//,//**//////**//*////(/(//*/////////(((/(/(//     //
//    ////(/#((((//**/*##(((((((//(//(*(//((//(////(/*/*///////////*////////,/%&&&@@@@@@@@@@@@@@@@@@@@@@@@@//((/////*/*(/#(/(#(#%###/////*//////(/((#(//###(     //
//    //((//(////(////////((//(//**/*///**/(//*///((*//(/(//**///////////(/(///&&@@&@@@@@@@@@@@@@@@@@@@@@@@//*//**///*//*/(//(##((//////((///((/(///(//(//*/     //
//    (//(//////((/(///(////(//////(///////*///(//*///*****/*////*(////#(/((/((&&@@&@@@@@@@@&@@@@@@@@@@@@@(/*/*///(/(///////**//****///((////*////(///////*(     //
//    //////(/////(((///////#((///(///**//(//((/*///*//*//////((#//*//,***(//*%&&@@@@@@@&&@@/@@@@@@@@@@@@&///(//((/*/////****///////(////*////*/////////////     //
//    (///////**///(////////////(((#(//////*(/*////(////(((///((//*/(//*****(%&@@@@&&&@@@@#(//@@@@@@@@@@@////////////(**////(*//(/(//((//////////(/////**/((     //
//    ((/#(/(/*/**/////*/////////(((#(///////((/*/*/(////#(///**//**////*//*/%&@&@@@@@@@@*///*@&@@@@@@@@////(/((//(*****///*/*/////(//////*//////(/////#(///     //
//    ////**(////(/*/(*//*//(///(///(///**//(///*/(//*//**/***//**/*/////*//&&@@@@@@@@%/(////(&@@@@@@@@&//////////////(/////(/((//////////(//(///((///(((((/     //
//    //*/#//(/////((((/(/(((/(///(/*//((//(/*(/*///*/*//(//*//(//#//(//////%&&%&@@@@////((/(/&&&&@@@@@@#*/*///////////////(/////(/(/(//**///((/////////////     //
//    (///(#%(/((/#//*//((((#/(///(**///(//(/(/*///////////*****//((//////(%%&@&&@@@%/*(/////(/#&@&@@@@@(((((///(/*////////////////*/*(((((///////*///////**     //
//    ((//((/(/(/((((%/(((#(/#((/(/(///(/////((/(*//((///**/*(**((((/(*//**%&&&@@@@&////*/***/*%&&&&@@@@//*//#%/**,/#(/////*//**((**///#/(/(((((/(//*///////     //
//    //(#(//((#//#**/##%(%/#((/((((((((%(((((///(//(/**/(((((((#(#(((((((%&&@@@@@#/#*(*((*(*/*%&&&@@@@@///////*/(////(////*//////(/(////*////////((#(//////     //
//    /(////(##((##(((##&%(##(//#(/(((#///(/#(/(//(((/(/*%//(((/((((#(((((&&@@@@&((/((##(///(((#&&&@@@@#/*//////////(/(/****/////////(///*/////////(//((//(/     //
//    ((/(((#(#((&#%%##%(#%&&%###((#(%%##%#%#((((//((((/((//(///(/(((((///,/(#&#////////////////&&&&@@@///((((((#(//(//**(*/**///(//*//(/////*////*//#(#%%#(     //
//    (/(/(/##*####&&&%(%&#%(##%(%%#%%###%%%&&%#%%/((##((/(///(///////(//*%/(&((/////(*/////////#%&@@@(//((((((//////*/((#**((/(((//##///(&%#%@@@@@@@@@@@&&@     //
//    (((#((//(((((%#%%&@&@@&&%&((####%##((%#/((((##(((/((//(((((#%%%*%%/*/((%//////////(////*//(**/#(/(((//((((//(/((((/(#(&&%%&@&@@@&&&@@@@@&@@@@@@@@&@&%%     //
//    (((*##/(//%%%/((/(/##(#(##(((/((//((#((#(((((/(//(//#//((//#%##%#%**//(#////(//(//((///(//,(%%&((///(((%#&@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@#/((/     //
//    (((*(#(#%(#((((/((((((##%(/((/(/(((///(/((#((/#(((//(((//////((#%%%%%%%&#(((((((%&#(//(##,**/##&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@#//((((////*////**/*//*     //
//    /#((/(((////(##/((((/(/(#(//(((((#(#((/(/////////////(////////((((#(###(%@%@@@@@&#(/(/##(/**/*#/((//*/////&&@@@@&@@@@&(/(%/////*((////(/((///((//((///     //
//    /#(/(//(//////(/((#((/////*(//((((((((((/#(/////((((////(//(((///(((((////((/(//(/((((#(#%(((#&@@@@%&@@%//(//////(////(///////////(//////((((((/((//(/     //
//                                                                                                                                                               //
//                                                                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract TOW is ERC721Creator {
    constructor() ERC721Creator("Treasures of the West", "TOW") {}
}
