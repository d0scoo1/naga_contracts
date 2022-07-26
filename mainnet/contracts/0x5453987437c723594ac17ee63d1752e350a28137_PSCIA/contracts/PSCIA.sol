
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Pancho Socci Art
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                             //
//                                                                                                             //
//                                                                          ,mmmmmmmmm,                        //
//                                   .                                  a##%".    .  .""W#p                    //
//                         m#m############M#W                        ,#M"                 Y#,                  //
//                    (#########N################O                 x#C                     '#p                 //
//                 W######%##W##(#######M########N               .#M    ,mm####*%EKW##W#m    WW                //
//                 ###WWT.           "TT ""#####                z#O a##M"..#N-  ,,   ## ?#Mm, #b               //
//               ,##C       ....,,...       4WWC 1#            ##m#M"     ##   ###M   ##   .*###               //
//               %"      m#M"""")QDD"TTE*W#,      #b          '###m,      4#m   ""   a#m    . .1##m,p'         //
//                    .#M"    ##M**##      ##     #L         #p ##p?%WWWWW############WW%ETTTT##%#Mmm,m,       //
//                   ##M     ##M #M ##     .##    #b            1##W                         ,#b    .""        //
//                 m##4#      %#mmm##O    a##p    #         '#m  ###W#m                    m#M.                //
//                   '8W##mmmm,aQQQm,am#MET      ##         zQ    ###m"KW#mm,,.     ..,m#WM"                   //
//                          .. """".-            #b          Y#    #M"W#m,  ""T7E**ETT".                       //
//                                                                 '#m   7%###m,,,                             //
//                                                  .m####mm          Y#m         """.                         //
//                                                4WC-      YM          Y#m                                    //
//                                         a###p                 .mm,     "*%WWWWWW**                          //
//                                       #M"                        #M                                         //
//                                       #   ####m,         ,a####  j#                                         //
//                                       #N  `KET*Y%M     #WWWETT   ##                                         //
//                                        R#o                      T"                                          //
//                                                  #mg     .,, ,,                                             //
//                                         (#m.m#########Qm###########b  .                                     //
//                                   (###m##################################N                                  //
//                                .################MWO T7T""%C*WW#WW##########Mm                               //
//                             .######M*"      ..,,,,mmmmmmm#####mmm,.,  "?1#####p                             //
//                           m######M  ,##WWW*"T""`                 ."?*K*KW 'W##M                             //
//                          z#####  z#C"                               ,##b    T###                            //
//                          ##-        `"*WW#mg                    .m#W"                                       //
//                                            ."*W##m######WWWWWWW*T                                           //
//                                                                                                             //
//                                                                                                             //
//                      ________   ________   ________    ________   ___  ___   ________                       //
//                     |\   __  \ |\   __  \ |\   ___  \ |\   ____\ |\  \|\  \ |\   __  \                      //
//                     \ \  \|\  \\ \  \|\  \\ \  \\ \  \\ \  \___| \ \  \\\  \\ \  \|\  \                     //
//                      \ \   ____\\ \   __  \\ \  \\ \  \\ \  \     \ \   __  \\ \  \\\  \                    //
//                       \ \  \___| \ \  \ \  \\ \  \\ \  \\ \  \____ \ \  \ \  \\ \  \\\  \                   //
//                        \ \__\     \ \__\ \__\\ \__\\ \__\\ \_______\\ \__\ \__\\ \_______\                  //
//                         \|__|      \|__|\|__| \|__| \|__| \|_______| \|__|\|__| \|_______|                  //
//                                    ________   ________   ________   ________   ___                          //
//                                   |\   ____\ |\   __  \ |\   ____\ |\   ____\ |\  \                         //
//                                   \ \  \___|_\ \  \|\  \\ \  \___| \ \  \___| \ \  \                        //
//                                    \ \_____  \\ \  \\\  \\ \  \     \ \  \     \ \  \                       //
//                                     \|____|\  \\ \  \\\  \\ \  \____ \ \  \____ \ \  \                      //
//                                       ____\_\  \\ \_______\\ \_______\\ \_______\\ \__\                     //
//                                      |\_________\\|_______| \|_______| \|_______| \|__|                     //
//                                      \|_________|                                                           //
//                                                                                                             //
//                                                                                                             //
//                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract PSCIA is ERC721Creator {
    constructor() ERC721Creator("Pancho Socci Art", "PSCIA") {}
}
