
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Jaime Del Pizzo Editions
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                              //
//                                                                                                                                                              //
//    ..............................,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*******************,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    ..............................,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*,***************,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    ..........................,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*,*****************,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    ........................,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*********************,*****,,,,,,,,,,,,,,,,,,,,,,.,,,.,,.,,,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    .........................,,,,,,,,,,,,,,,,,,,,,,,,,,,***,,**,*,,**********,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,...............,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    .....,,,,...,,.,.......,,,,,,,,,,,,,,,,,,,,,,,,,,**********,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,,......................,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    ......,,......,..,,,,,,,,,,,,,,,,,,,,,,,,,,,*************,,,,,,,,,,,,,,,,,,,,,,,,,,.......................................,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    ......,,.,,..,,,,,,,,,,,,,,,,,,,,,,,,,,***************,,,,,,,,,,,,,,,,,,,.................................................,,..,,,,,,,,,,,,,,,,,,,,,,,,    //
//    .....,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,***************,,,,,,,,,,,,,,,,,,......................................................,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    ...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,****************,,,,,................................................................,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    ..,,,,,,,,,,,,,,,,,,,,,,,,,,,************////****,,***,****..........................................................,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    ..,,,,,,,,,,,,,,,,,,,,,,,,,*****/**//*/(/(////***/*////////,....,.,,,,..................,,.......................,,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    ,,.....,,,,,,,,,,,,,,,,,,/*,,***/////((/((((/////////////(/**,,,******,.........,...****//,..,*,............,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    .......,,,,,,,,,,,,**,,**//**/(#(//(/((/(((////(//////*/(//*//*,**,,,,,,,,,,,,,*****/*//**,,,,***,,.,*,,,,**,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    .....,,,,*,,,****//(*,***#///(((((/((#(/(((////#//(/*/////*****,*******,,*********/**////*********,,****,*****,,********,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
//    ..,,,,,*///**/(//((((((((/(/((((//((/////((//((//*/***/////*****,,**/***,*/**//***/******,,,,,**//**********///****/***/****,,,,,,,,,,*,,,,,,,,,,,,,,,    //
//    *///*////////(((((((((/((((##((((((/////*/*,*/////(/***///*****/*****/****/(///**//////***,,**/******//******//*********//******************,,,,,,,,,,    //
//    ////////(((/(###((###((#(#(/(##((//////*((*,/(////////*////*,**/**/**/****(/*//*******//(*********///**//*/**/***/****/*//**/************///***,,,,,,,    //
//    (((////((#((####(######(((///((////////*((**/////(/**(/,///*,,*/////*///**//////*****///***//***//***///////***//****/****///////*****,*//****//*****,    //
//    #(((((((##(#%##(((##(#/((#(/##(#(/((///*(//(/////((#((/*/(///,****/**********//**/**//*//////********////////**/***/******//*/****/**///**,,*///******    //
//    #((((((#######(((####%###((//(///#(#(/*/(/(##/(#(//((//*/#(/***//////(((///**(//*//**/((////***///*****//*//***//////***///(//***/*,,**********///*/**    //
//    #/((((((#/(/(####%((##%#(((((/*///((////(/#%((#(//(%#(//(#(/((/**/#(/(#(//#//(////**//////(///*//##(***///////*/////(////////**********//*///*//////*/    //
//    #(//(%(((%%((#/##(((#%##//#((*//((/////(((%#((((#//###((#((###///%#(#(#/////(#(/**/*****/*/*///(%#((****/(((///(/*/(//////(((/*//*/(((/**,,*,,**//////    //
//    #(/##((((/(//#/((((#(((////////*//**/*/#/(#((#%(((##%%####%%&#(//%%(%%%((#(/#((/*******/(**(/*/%%%((/*//(((##(////#(/*///******************,,,**/////*    //
//    #((#(####///((/(#/#(((////////*//****/*/#%%#///(/(((##(%%%#%&(//(%&%(/#%%%(###(/*///****/**(**/%%##((//((#%%#/**//#/(****/************,*************//    //
//    /(((##(##(///##(%#(/*//*//////////**//#(%(%%%#((##(#(/#(#&&%%(*((%&##(%###(#%#/*******/((///*((##%(#(/**(%%((/((/(((////*//********************,,***//    //
//    %((((///(/(((((#(///*/(((////**((**(#((/####///((#%%%#####(/(%(*//#%#(%%%&%%%(#((/*****/(//((((##((((/((/(%(/(*/(%#(//////*/(/*****/********,****////*    //
//    (%(#(///**///#(((//*/////(/***(#///(###(/#(###(((((%%##((/(/(&%##%##//(/(//#%(//(******/(///(###%#((//((((#(////##(///#(///////******************/*///    //
//    ##((((//*//(%%//(***////*//*/*/((((%(((((##((((%%&%%(((#%(#(&####%#(//((/(%%#(////******/(///((#(#%%(////%%%#////(#(/%#////////*************//*/////**    //
//    #%(////*//(%##(////(//#//////*/%(/////##%#%%#(//#%%%#%#(#(///##%((///%#%#(#%%##(#(//********/#%%##((#//((/(((*/////((//((/////(/**/********//////*****    //
//    #(#(/**//((%%#((##//*/(((//(//#%(###/(#//#((######/#(#%&%%/*((#((#((%#&%%%(##%/////*/******/(%%%##//*/((/(##(/(//(((//**///////(*//*******************    //
//    /(//(/*///%#%/((/#((//((((((((((///#(/(###(%((/#(((%#/*/#(%&#((#((%%#(#%%/*(((*/(//********/(((##*****//#//##(///(#(((//(//(///////*************//(((/    //
//    /#(*((///#%#%%#(/(///((//((/(#%#(##((/((/*///(%%&(#%###/**(##%%(//%(#%%&%%%%%#((#(//******/(#%(//((/*/(#(/(////((/*(//(//*/////((//*/***************/(    //
//    /*//%#/(/(/***/#/*///////*/(###/*/##(//(/((/(((##%%%#/((((##%%%%#####((#(#(#%((#%(//**/*/**(((#%%(%(/((%(##%(/((////##/(//*////(#/(//*************/***    //
//    (/##&#((((##%(/*//**#(/*****///#(#(%((##/(&%%#(#((###/#(((((%##%%//#((%/(#(#%#(/////*/***/(##/(%(//(///#//(%#(((((((*/#(/*//(//(//(/(/**************//    //
//    #(/(%#(//(%#%%%#(*/*/(/****///((#((&((#(/##(%##%###(/(#//***(#(#%#%%((&%%(/(##((//******////(%&%#(/(//((//#%#(/(/(#///##((/****/#//*************/**//*    //
//    ((((#(#(/////(/(###((#//**//##(///#%((%#(**/**/(#(#(#//((#(((#%(/(#//(#((%&&#/(/#%/*****/(/*(###/**/////(//#((#((#/**/((////////(///***************//(    //
//    (//(%###(##(((//(#//#%%(/***/#(*//(####((/****/(%////////*(%%(/(/((((/####%&%(##%(//**////**(#((((//////(//(//(((##////**/*****/(///***********/*///(/    //
//    ((#&%##/((///(///(((#%(//(#%#%%##((//(#(#/***(#(//(%*/*/**/(##((##((//(//(%#(/(///*****/(//(#(((/((//(//(//(/(////*******/*/**/***///**********((##%((    //
//    ((((((#(//#///((#%(/(/////#//%#%#//(%#//(/*///////##/***/*(%##///((////**/********/**//*////(/(/***///**////(/(*(*****//******/***(/*************//(#(    //
//    /##%%#//((#%(((%((####//((////(((/(#////(//*///%(/**/(/(#(#&%##(((/#(///**/**************///(###&%(////////////*/(****//*****//***//**********/((/*#(*    //
//    /(%###////##&%(//(/*/((////%(//(((%(#%(/*//(//%%(*****(#(((##(/**#%#(//*//(///***********//*/(#(////*******///**//****//*****/(/************/(/(////((    //
//    /(/(#((//((/(#(//((/#((*//(((((((//#///*/(////(/*****/*((/(/***((/(*,,**///////*******////***************//((/////****//***********/************//(/((    //
//    %#%#((((((/((((#(((##/(/(#(((((#/#%(/*/#((//*//******//((#/(((#####(///**//**/**//*******//***************/((/******/(//***********/************/*/%#/    //
//    //((#(/((##(((//*////##(((/*/*/#//(#(///(/***/********///%%#(#(///((/*****/******//*******************************/(///*///********///*************(%%    //
//    /(#(%(/#//#%(((//((#(//((//(/////***/*///*/((/*****/(////&##%(//(////************//************//********************//(//***********//((/*//*****/(**    //
//    %##%&#*/(((/(*/(/*(/*////*//(///(#(/*/(/((/**#/*/**/#(/((#/****/((/*//************//******//*******************************************////////****/#(    //
//    /((###/##%%(/**///(%(#////%(((/(///(%(/(#(/*/(//(/(/*********(.,,(((#######%(((********************************************/**********************/##(    //
//    ##(*#(///((*//**//(#((/(///(/(//////%////*///(//*//*****, ,(**((/(#((((((/(#%&&(&####*/************************************************************/%#    //
//    /(##%%%#/**((((#(#%%(/**((((///////##//*(/***/***///*, ,,.//*,***#%&&&&&&&&&&&#/(#(#&%#/***********************************************************//*    //
//    (###&%#%#((/(%#(/((%//(///(///(///(#/*///(##/(/***((.#,/,.//**//(##(&&%%&&&&&&&&&&&&/(((#((********************************************************/(#    //
//    (////#(((##(//****/((//((//((/(//*****/////*/*****(.,*.,.,((**//(#&(##%&&&&&&&&&&%%%%%%/((#(****************,,*************************************/(/    //
//    /((//#(/**/#/**///##/*/(///**//(*******//#%((//**//(*, *.*/*,*//(%%&(,*,,,*(&&&&&%%%%#%##(#(#*********,***,,,,***********************************,*/*/    //
//    /((//((#(((////*/(##(//**/(/*//*/*****/%(/*/*****/.//,*,.,**,///(%(,*@@@@@,*%(&&&%%%%%####%(%*********,,**,,***/#/**////****************************/(    //
//    /*(/(//*********/((((/***/(((//(/***/*///*//*///**.,/,,.*,,**/*./.,@@@@@@@@@,,%/&&%%%%%####((*****************/##/*////****************************/#%    //
//    #(/(#%%##//***//*/(((/**(#(/((((//***//***(((///**.  .....**// *,&@@@&@@@@@@@@*,%##########((,**********,,****/(//#(/***************************///(//    //
//    #%%%%%%((//*/(///%#/((//#/*/((///*///*//**////****#( .,,. .*(,(&@@%#########%@@@,@@&&@@@@@@(#********,,*,****#(#(/***//*******,,,,,********/*********/    //
//    ((/#%&%(((/*///*/%##%#(((///#(#((//(#((////*******,#@*(#%(@&@%####(((((((((((#(##%%##%@@@&@@&&*****************(######((/**,,,,,,,*********/******////    //
//    #%///%%(////**,*/&(//(//(%%%#((/////***//*********(#@##*#@@&//###%#%(((((((((#%&%%%&%%%&@@&@&&#/*****,***/#(//(//************,,,,**********//*********    //
//    &&#####((/***********/*/////////**/***////*******(#&%&%&@@%//(###&%####(/((###&@@&%####%@@@@%%%@%********/#%%(#%(********,,,,,,,,,,******///(/**///***    //
//    (/(#(((((***///***/***************//*///********(&&(#(@%&%((#//(%%%%%%#//(##%%%%%(####%%&@@@@@%%%#**********,,/#/***,,*,,,,,,,,,,,,*******//////////**    //
//    //(##(//((*******//*****************************%@(###@@@%&%#(#%&&&%%%%%&@&%%%%%%%%%##%&@@@@@@@%#(((/*//(/(//(%(((/*,****,,,,,,**************////****/    //
//    (//%#/(/////////(///****************************,&((/&%@&%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%&#%&&(**/,,,,*/(#////#(#(/*,,,,**********************/*    //
//    %(///(#/*/(//******//***************************&@&/(#%%&@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@&&&/,//*//((((##(/**//***/((******************/(//****    //
//    (/*/%%(*///(//*//*******************************@&&#*(&#%@%#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%@%&%*#*(/*,,,,*%***////*,,,**/***************/#%(#(/**    //
//    (%#(#%(/(/*/%/*/(/*******************************((@@%(%#&&#@&@%@&@@@@@@@@@@@@@@@@@@@@@@@@@@@%&#&@**%(/,,*/(/*/%**/(#(/**********************//#(##(/*    //
//    //((//%##/*//(#%(///****,************************%,@@@@(#&&&@&%@&@@@@@@@@@@@@@@@@@@@@@@@@@@@&&%@&%(#/%#@@@%/##(%///***************************(#(#((/*    //
//    #(*/#(/((((////*////******,*****,,**************%%@@(@@@*(#%&@@@@&@@@@@@@@@@@@@@@@@@(@@@@@&&&&%&@&%##//@@@@@@@@@@******//(/////************(((#%##%(/*    //
//    /#%%%#(#/(//#////(////************,************%#&&@@@@@@@%*((***(####%&@@@@@@@@@@@@&&@@@@@@&@&&@%#%&*/#%@@@@@@@@@@@/*/**********************/#%%#////    //
//    (#%%(/(##%((((/((///***************************%%%#@@@@@@@@&&@@#@@(#%#%/%%(@&&@@@@@@&@@&%@&@@%&##%#(*##%&@@@@@@@@@@&&**//*******************/#%%&%#((*    //
//    *///(((((/(/**/////((/************************%#&&&%@@@@@@@@@&&@@@@@@@@@&%#(#@#&@@@@@@@@@@@@&@(%(/(##(/&@@@@@@@@@@@@((#*********************//%&%%#/(/    //
//    ////(##/(/*////******************************%#%&&@&@&@@@&@@@@@@&@@@@@@&&&@@@@@@@@@@@@&@@@@@@%&(###&##(@@@@@@@@@@@&@//***********************((//##(((    //
//    /#(///*/#(/**////***************************%&&@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@&#/&(#/#&&#@@@@@@@@@&@&%(**********************/(#(/(//*    //
//    (#%##((//(/(((//////************************@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@&%(&%((#(@&&@@@@@@@@@@@@&******/*//*************/##(**#%#(    //
//    %#%%%##&(//***//*****************************%@@&@@@@@&&&@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@&%(%#/%@/###&&%@@@@@@@@@@@@@//*/(/*/***************///#(#%#//    //
//    /((##((%(********************************,@@@&&&@@@@@&&&@&@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%(((((/#%#%@@&@@@@@@@@@@@@@#(//**/****************#(#(*/////    //
//    #(//(#&&****************************#&&&&@@@&&&&&@&&@@&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(/%@%@@@@@@@@@@@@@@@@@@@@@@@&,****************/(/%(/#////    //
//    ###%%(//************************&&&&@&@@&&&@@@&&@@@@@@@&&&@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(*************/(/(%%/(%(/(    //
//    #(/###(/*/******************%&@@@&&&&&&@@@@@@@&&@@@@@@@@@&&&@@&@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(**/***********(##//(%#(    //
//    ###((((//(*****(/*********&@&&@&&@&@@&@@&&@@@@@@@&@&@@@@@@@&@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&*(#/********/(((**((//    //
//    ##%##//*(/**//(#/********&@&@%@@@@@@@@@@&@&@@@@@@@@&&&@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@%**********/%(##((#((/    //
//    //(////(#//////#(/*****/@@%&@&@@@@@@@@@@@@&@&&@@&@@@@&@&@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&/*********/%#((///(((    //
//    #((#(//(///(//(#(/****%@@&&@&@@@@@&@@@@@@@@@@@@@@&@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&*********/#(#/*/(/(#    //
//    /**(%#/((//(##%#(/***%@@@&@@&&&@&@@@@@@@@@@@@@@@@&@@&@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&,********/(/*///(/%    //
//    ***//////////////////&@@@@@@@@&@&&@&@@@@@@@@@@@@@@@@&@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&,******(#(%%#(#%&#    //
//    /((///**////////////%&@@@&&@@@@@&&&@@%&@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&******//(%%/*///#    //
//    ###//(/*///**/////*%&&@@@&&&@@@@&&&&@&&@@@@@@@@@@@@@@@&@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&/****/(#&##/((//    //
//    ////////***///////&%@@@@@@@@@@@@@@&&&#@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/***/((#(((//(/    //
//    (#(//(///*****///&&&@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@***(#%%#%((//(    //
//    (((((///********&@@&&@@@@@@@@@@@@@@@@%#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@/*(%###((((/(    //
//                                                                                                                                                              //
//                                                                                                                                                              //
//                                                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract JDPE is ERC721Creator {
    constructor() ERC721Creator("Jaime Del Pizzo Editions", "JDPE") {}
}
