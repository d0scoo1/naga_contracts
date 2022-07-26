
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 0dudu
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                        ,▄▄▄▄▄▄▄▄▄▄▄▄▄▄,                             //
//                                   ▄██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▄▄,                      //
//                                 ▄█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▄,                 //
//                                ▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▄               //
//                              ,█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█µ             //
//                             ▄█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀▀▀▓▓▓▓▓▓▓▓▓▓▓▓▓█             //
//                            ▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓`▄▓ ∞▓"▓▓▓▓▓▓▓▓▓▓▌            //
//                         ,▄█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▓▓▓▓▓▓▓▓▓▓█            //
//                     ▄▄█▓▓▓▓▓▓███▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌           //
//                 ▄██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓███████▓▓▓▓▓▓▓▓▓▓▓▓▓█           //
//                   ▀▀▀▀▀███▓▓▓▓▓██████████▓▀▀▀▀▀▀▀▀███████▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▌          //
//                         █▌░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒░░░▀▀██▓▓▓▓▓▓█████▄         //
//                         █▒▒▒▒▒▒╢╜╜╜╜╙╙╙╙╙""╙╙╙╙╙╙╜▀▀▓▓░▒▒▀▌▒▐▄▄▀██▓▓▓▓▓▓▓▓▓█        //
//                         █                         ▄    ═▓▄█▄╜▀▒▒▒▒▀██▓▓▓▓▓▓▓█▄      //
//                         █▌                   ░░░░  ▌▄▄██████▌,  ╙╢▒▒▒▒▀▀▀██▀███▄    //
//                         ▐█                    ``  ▄" ⁿN▄,, ,█-:░ ░, ╙╜╢▒╜,'   ▀▀    //
//                          ▀█               ,                    ``░` ,╓╓@╣╣╖         //
//                           ▀█▄   ,,▄▄@@▓▓▓▓▓▓         ,╓      ,,╓╓╦@╣╝╜░╙╜░]         //
//                         ▄▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▀Ñmm╖╖╥mÑ╣╝╛  ╟╣ÑÑ╝╙░░╣╣╣╣░░╣╣░░@        //
//                        ██▓▓▓▓▓▀▀▓▐▀▓▓▓▓▓▓╢╗░╝░g╣╢╛╓Ñ░ƒ  ╓░░░╣╢Ñ░╫╣╣╣╣░░╙╝░░║        //
//                       ▐▌▌▓▓▓▓▀L▄▐"▄▓▓▓▓▓▓▓▄╙H╣╢╣░,╓╥╝"▀╓╣@╗╖,░░░╟╣╢╣╣░░░╔╣╣╣░       //
//                       ▄▀▒▀▓▓▓▓▓▓█▀▀██▓▌▀▀░▒▒▒▒▒▒▒▒░╞@╖ ,▄▒▒▒║╜╝╩╩Ñ╣ÑÑÑÑÑ╩╝╜╜░       //
//                     ▄▀░▒▒▒░░▄██▌   j█▀░▒▒▒▒▒▒▒▒▒▒╣░░╓║╝╣▒░▀▒M░╔W░░╫m                //
//                    █░█▀█▀░░▀░▒█░    █▒▒▒▒▒▒▒▒▒▒▒▒▒╙╣░░░╓╠▒▒▒@@╖░░╢╣╣╝╖              //
//                   █░▀░░░▒▒░░▒▒▐W    ▐░▒▒▒▒▒▒▒▒▒▒▒▒▒▒║@╣╢╣╣@▒▄▒▒▒%╢╣╢░░@             //
//                  █░▒▒▒▒▒▒▒▒░░░░█▄,▄▄█▒▒▒▒▒▒▒▒▒▒▒&▀░░░▒╟▒╙░░╟░░░▒▒▒╫░j╣╟@            //
//                  ▌▒▒▒▒▒▒▒▒▒▒▒░▀█░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╙N╙╜└╣▒▒▒▒▒▒╟░░░╣            //
//                  █░▒▒▒▒▒▒▒▒▒▒▒▄█▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒║M≡▒▒▒▒▒▒▒▒▒╣╓╫             //
//                   ▀▄░▒▒▒▒▒▒▒▒▒░░█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█⌐            //
//                     ▀▓▄▒▒▒▒▒▄█▀░░▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░▄▄▄▄▄▄▄▌░▓▓▄▄█░▒▐▌            //
//                        ▀▀▀█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀░▀░░░▄▄▄▄▄▄▄▄▄██████████▀▒▒░█             //
//                            ▀█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▄▄▄▀              //
//                              ▀██▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓████▓▓▓▓▓▓▓█▓Ñ▀               //
//                                ▀▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓█                   //
//                                  █▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓███▓▓▓█▓█▓▓▀                    //
//                                    ▀███▓▓▓▓▓█████████▌   ▐██▀▀                      //
//                                      ▐█          ,▄▄█▌▄▄█▀                          //
//                                      ▐██Pæ▄▄▄▄▄▄███████µ                            //
//                                      ██'   , : ▀▀█▌,▄⌐▀█                            //
//                                      █▓█▄░,,,,░░'██▌░"`▐▌                           //
//                                      █▀███▄,''  ,████▄█▀█                           //
//                                       ▀P▄▄▄▄▄▄▀▀▀▀,,▄▄▄▀                            //
//                                                - -`                                 //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////


contract dudu is ERC721Creator {
    constructor() ERC721Creator("0dudu", "dudu") {}
}
