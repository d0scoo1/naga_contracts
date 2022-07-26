
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mono
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                           ___     _                                    //
//                                         _ ,▄æ██▀*═▄_                                   //
//                                      __,▀╙'_▓███▄__└▀▄_                                //
//                           _______ _ __▓└ __██████▄  _╙▌                                //
//                           ▀▀▀▀*ª═æ▄▄▄█▄,,,║███████_ ]██▄                               //
//                              _ _╓▄▄µ_▌__ _'└└└╙╙╙╙▀▀▀▀▀▀═w▄ ___ _____                  //
//                         ___ _▄███████▌,__▄æ▄, _   ____   __└▀▀≈ªª▀▀▀*═æµ_              //
//                    __,▓██████████████▌   ____`              ____ ____  _╙▀▄__          //
//                    _]████████████▀▀▀█▌½▌__ª_                            _ └▌ _         //
//                    __▀███████▀╙_____▐▄▀_____           _ ▄, _  ,╓▄▄,__   _ ╫__         //
//                      __ ___,,,,▄▄▄═▀▀_                 _jµ_└╙╙└___ `╙▀w▄,▄#└           //
//                        _▓█░--_  _ _ __.▄_              __▌              __             //
//              ____      _▀▄▄═ªªª══xæ▄▄ª▀_▀_              _█                             //
//              ▄▌ _     __,#╙▀▀*═══w▄▄█▀▀ _               _║__                           //
//            _██       __#└_       _   └▀▄_               _'▌                            //
//            ]█▌       _▌_             ___╙─              __█_                           //
//           _▐██_    _ ▌ _                 _              __╟_ __ _                      //
//            j██▄_   _║__                              _ __ _▌ ,▄ª▀└└└█__                //
//            _╟██▄_   ▌_             _  ___ __    _ _▄æ▀▀╟_  ╙╙¬_ ,▄ª▄_█                 //
//            _ ╙████▄,▌             _▄▓███████▄___%▌└_   ╟___ ▄æ▀└__ ╙▓█_                //
//               '▀█████_            └▀▀▀▀███████,_ ╟█µ  _╙▀▀▀└__    __ __                //
//                  _└╙▀▀__            __  _└▀████▌__╙▌_   _                              //
//                      _╙¼,__              _ ██████ _╙µ_     _ _    ,,▄▄▄▄___            //
//                        _'▀W▄_  _          █▀▀█████ _╙▄  _ ,▄▄▄██▀▀╙└└` `└▀µ_           //
//                          _ _└╙▀ª▄▄ _  ___á└__]███_█ _███▀▀╙└`_ ___        ║__          //
//                               _ __ └╙█_ █▄▄▄▄██▀▀▀▌,█'_   #▀╛║▌_         _▐µ           //
//                          _  ,╓▄▄▄███▀▀▀▀╙└└____   ___   __█▄▄▀╓▄         _║_           //
//                        _,██▀╙└─   __ ▄æ╗_               _ __▐▓╙▀_       _▄"_           //
//                      __á█└_         █▄∞▀▌ _               _á╙▌▄▌_  ____▄▀ _            //
//                       ]█¬          _╙▀▀▄█▌                 ╙wx▀└_ ,▄ª▀└__              //
//                       ▐█_          __ ▄█▀▄_           ___  _,▄∞▀▀└__ _                 //
//                       _█⌐           _▐▀▀╠█     _ _ __,▄æ▀▀╙└__ _                       //
//                       _└█,_         __└└` _ ,▄▄═▀▀▀└¬___                               //
//                        _ ╙▀▄, __,╓▄▄æ═▀▀▀╙└¬_  _                                       //
//                          ____``_____                                                   //
//    [monografia]                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract MONO is ERC721Creator {
    constructor() ERC721Creator("Mono", "MONO") {}
}
