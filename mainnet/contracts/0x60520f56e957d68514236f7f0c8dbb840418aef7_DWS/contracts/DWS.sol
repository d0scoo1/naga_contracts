
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: DEATHWISH Sketchbook
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//     ______   _______  _______ _________                  _________ _______                       //
//    (  __  \ (  ____ \(  ___  )\__   __/|\     /||\     /|\__   __/(  ____ \|\     /|             //
//    | (  \  )| (    \/| (   ) |   ) (   | )   ( || )   ( |   ) (   | (    \/| )   ( |             //
//    | |   ) || (__    | (___) |   | |   | (___) || | _ | |   | |   | (_____ | (___) |             //
//    | |   | ||  __)   |  ___  |   | |   |  ___  || |( )| |   | |   (_____  )|  ___  |             //
//    | |   ) || (      | (   ) |   | |   | (   ) || || || |   | |         ) || (   ) |             //
//    | (__/  )| (____/\| )   ( |   | |   | )   ( || () () |___) (___/\____) || )   ( |             //
//    (______/ (_______/|/     \|   )_(   |/     \|(_______)\_______/\_______)|/     \|             //
//                                                                                                  //
//     _______  _        _______ _________ _______           ______   _______  _______  _           //
//    (  ____ \| \    /\(  ____ \\__   __/(  ____ \|\     /|(  ___ \ (  ___  )(  ___  )| \    /\    //
//    | (    \/|  \  / /| (    \/   ) (   | (    \/| )   ( || (   ) )| (   ) || (   ) ||  \  / /    //
//    | (_____ |  (_/ / | (__       | |   | |      | (___) || (__/ / | |   | || |   | ||  (_/ /     //
//    (_____  )|   _ (  |  __)      | |   | |      |  ___  ||  __ (  | |   | || |   | ||   _ (      //
//          ) ||  ( \ \ | (         | |   | |      | (   ) || (  \ \ | |   | || |   | ||  ( \ \     //
//    /\____) ||  /  \ \| (____/\   | |   | (____/\| )   ( || )___) )| (___) || (___) ||  /  \ \    //
//    \_______)|_/    \/(_______/   )_(   (_______/|/     \||/ \___/ (_______)(_______)|_/    \/    //
//                                                                                                  //
//                                                                                                  //
//    Twitter: @deathwishnft                                                                        //
//    Discord: discord.gg/deathwishnft                                                              //
//                                                                                                  //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@                            @@@@@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@@@@@@@@                                    @@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@@@@@                                          @@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@@@                                              @@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@                                                  @@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@                                                     @@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@                                                       @@@@@@@@@@@              //
//    @@@@@@@@@@@@@              @@                      @@@@@@@@@@@@@     @@@@@@@@@@@              //
//    @@@@@@@@@@@@@           @@                                        @@@ @@@@@@@@@@              //
//    @@@@@@@@@@@@           @@      @@@@@@@@@@@(        @@@@@@@@@@@@@     @@@@@@@@@@@              //
//    @@@@@@@@@@@@          @@     @@@@@@@@@@@@@@@@     @@@@@@ @@@@@@@@@@    @@@@@@@@@              //
//    @@@@@@@@@@@@@        @@     @@@@@@@@@@@@@@@@@     @@@@@@%   @@@@@@@    @@@@@@@@@              //
//    @@@@@@@@@@@@@  @@@@@        @@@@@@    @@@@@@@      @@@@@@   @@@@@@@   @@@@@@@@@@              //
//    @@@@@@@@@@@@@@              @@@@@@    @@@@@@         @@  @@  @@@@@   @  @@@@@@@@              //
//    @@@@@@@@@@@@                 @@@@@@@@@@@@@      @       @@@@@@@@    @    @@@@@@@              //
//    @@@@@@@@@@@@                                  @@@@                       @@@@@@@              //
//    @@@@@@@@@@@@@                                @@@@@@                     @@@@@@@@              //
//    @@@@@@@@@@@@@@@             @@@@                                      @@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@   @@@@@@@@@                               @@@@@*@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@@@@@        @@@                             @@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@@# @@@@       @@@                          @@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@       @@@      @@@@     @@      @    @    @@@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@         @@@      @@@@      @@@     @     @@@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@         @@@@      ,@@                    @@@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                            @@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@@@@@@@@@           @@@@                         @@@@@@@@@@@@@@@@@@@@@              //
//    @@@@@@@@@@@*    @@@            @@@@@@              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@              //
//    @@@               @@          @@@@@@@@@@@@@@@@@          @@@@@@@@@@@@@@@@@@@@@@@              //
//    *                @ @@@@@@@@@@          @@@@@@                       %@@@@@@@@@@@              //
//    *                   @                     @@@                             @@@@@@              //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract DWS is ERC721Creator {
    constructor() ERC721Creator("DEATHWISH Sketchbook", "DWS") {}
}
