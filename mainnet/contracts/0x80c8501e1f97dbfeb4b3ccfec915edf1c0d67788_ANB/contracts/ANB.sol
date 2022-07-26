
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: A New Beginning
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    5555555555555YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY55555555555555    //
//    5555555555YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY55Y5555555555    //
//    5555555Y5YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYJJJJJYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY555555    //
//    555555YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY5Y555    //
//    5555YYYYYYYYYYYYYYYYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYYYYYYYYYYYYYYYYYY55    //
//    55YYYYYYYYYYYYYYYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYYYYYYYYYYYYYYYY    //
//    55YYYYYYYYYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYYYYYYYYYYYYY    //
//    5YYYYYYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYYYYYYYYYY    //
//    5YYYYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYYYYY    //
//    YYYYYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJJJJJJJJJ??????????JJ???JJJJJJJJJJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYYY    //
//    YYYYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJJJJ?JJ????????????????????JJJJJJJJJJJJJJJJJJJJJJJJJJJJYYYYYYYYYYY    //
//    5YYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJJJJ?????????????????????????????JJJJJJJJJJJJJJJJJJJJJJJJJYYYYYYYYY    //
//    YYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJ???????????????????????????????????JJJJJJJJJJJJJJJJJJJJJJJJYYYYYYYY    //
//    YYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJ?????????????????????????????????????????JJJJJJJJJJJJJJJJJJJJYYYYYYY    //
//    YYYYYYYYYYYYYYJJJJJJJJJJJJJJJJ????????????????????????????????????????????JJJJJJJJJJJJJJJJJJJYYYYYYY    //
//    YYYYYYYYYYYYYJJJJJJJJJJJJJJJ????????????????????????????????????????????????JJJJJJJJJJJJJJJJJYYYYYYY    //
//    YYYYYYYYYYYYJJJJJJJJJJJJJJJJ????????????????????????????????????????????????JJJJJJJJJJJJJJJJJJYYYYYY    //
//    YYYYYYYYYYYYYJJJJJJJJJJJJJJ????????????????????????????????????????????????J?JJJJJJJJJJJJJJJJJYYYYYY    //
//    YYYYYYYYYYYYYJJJJJJJJJJJJJJJ???????????????????????????????????????????????JJJJJJJJJJJJJJJJJJJYYYYYY    //
//    YYYYYYYYYYYYYYJJJJJJJJJJJJJJJ????????????????????????????????????????????JJJJJJJJJJJJJJJJJJJYYYYYYYY    //
//    YYYYYYYYYYYYYYJJJJJJJJJJJJJJJJ?????????????????????????????????????????JJJJJJJJJJJJJJJJJJJYYYYYYYYYY    //
//    5YYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJ?????????????????????????????????????JJJJJJJJJJJJJJJJJJJJYYYYYYYYYYY    //
//    555YYYYYYYYYYYYJJJJJJJJJJJJJJJJJJ???????????????????????????????????JJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYY    //
//    5555YYYYYYYYYYYYJJJJJJJJJJJJJJJJ????????????????????????????????JJJJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYYYY    //
//    5555555YYYYYYYYYYYYYYJJJJJJJJJJJJJJJ???????????????????????????JJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYYYYYYY    //
//    555555555555YYYYYYYYYYYYYYYYYJJJJJJJJJJJJJ????????????????JJJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYYYYYYYYY55    //
//    55555555555555YYYYYYYYYYYYYYYYYYYJJJJJJJJJJJJJ??????JJJJJJJJJJJJJJJJJYYYYYYYYYYYYYYYYYYYYYYYY5555555    //
//    555555555555555555YYYYYYYYYYYYYYYYYYYYYYYJJJJJJJ?JJ?JJJJJJJJJJJYYYYYYYYYYYYYYYYYYYYYYYYYYY5555555555    //
//    555555555555555555555YYYYYYYYYYYYYYYYYYYYYYYJJJJ?!7JJJJJYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY5555555555555    //
//    555555555555555555555555YYYYY5PGGG5YYYYYYYYYYYJJ?77JJJYYYYYYYYYYYYYYYYYYYYYYYYYYYYY55555555555555555    //
//    GPPPPPPPPPPPPP55555555555555PGBBBBGP555555YYYYYYYYY5P5Y5PPGGGPP5Y55PPPP5PPGPPPPP5555555PPPPP555PPPPP    //
//    ###############BGBBBBGGGGGGBB###BBBBBBBBBBGGGGBBGGBBBBB########BGBBBBB##########BBGPPPG#####BGB####B    //
//    &#####BB#####&&&#####################BBB#################&#############&&&&&&&###########&##&&######    //
//    &###BBBBBBB#BB####B##&&&&&###&&&&&#BPPPPPGBBBBBBB#BBBB##BBBGBB##B#&&&########&&&&####BBBB###########    //
//    BBBBBBBBBBBBBBBBBBBB###B#BGBBBBB#BBGGGGGGGGGGGGGGBBBBBBBGGBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#####BB    //
//    #BBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBBBBBBBBBBBBBB    //
//    ######BBBBBBBBBBBGGGGGGGGGGGGGGBBBGGGGGGGGGGGGGGGBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBBBBBBBBBBBBBBBB    //
//    &&&&&&##BBBBBGGGGGGGGGGGGGGGGGGBBBGGGGGGGGGGGGGGB#BGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBBBBBBBBBBBBBBBB    //
//    ###&&######BBBBBBBGBGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBBBBBBBBBBBBB##BBB    //
//    BBBBBBBBBBBBBBGGGGBBBBBBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBGGGBBBBBBBBBBB#&&&##B    //
//    BBBBBBBBBBBBBBBBBBBBBBBBBBGGBGGGGGBBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBGBBBBB#&&##&&&&B#&&&&##    //
//    ###B#BBBBBB##BB###&##B###BB##BBGGGGGGGGGBBBBBBBBGBGGGGGGGGGGGGGGGGGGGBBBBBBBBBBBBBBBBBBBBB#####&&#BB    //
//    #####BBB####BBBBB###BB#&#B#&&#BBBBBBBBB#######BBBBBBBBBBBBBBGBBBBBBBBBBBBBBBBBBBBBBBBBBBB#####&&####    //
//    #####BB#BBBBBBBBBB##BBBBBB##&############&&&&#BBBB##B##&&#B############BBBB#BBBBBBBBBBBBB#########BB    //
//    ######BBB#BBB###BBBBBBBBBBBBBB#&&####B#BB#&&&#BBB#B#B#&&&&#&&&&&&&&&&#####&####BBBBBB###B##BB#######    //
//    ######BB##########BBBBBBBBBBBBB#BBGBBBBBBBBBBB####BBB######&&&&&&&&&&###&&&&####BBBBB##BBBBBBB######    //
//    #####################BBBBBB#BBBBBBBBGBBBBBBBBB#&#BB##B###BB##&&&##&&&#BB#&&####BBBBB#BBBBBBBB#######    //
//    ###B##########BB#######BB##BBBBGBBBBBBBBBBBB###BBBB##GBBBBBB########&#BB#&#&##B#######BBBB######B#BB    //
//    #################B##B######BBBBBBBBBBBB#BBBBBBBGGBBGGGBBBBBBBBBBB######B###&###&&&###BBBB###&&##BBB#    //
//    ############B##############BBBBB##BBBBBBBBBGGGGBBGBGGGBBBBBBBBBBBBBB####B######&&&&#########&&###B##    //
//    ##########BBB#######################BBBBBBBBBBBBBGGGGGGBGBBBBBBBBGBBBBB#B##B###############&&&&&####    //
//    ######&#########################BB####BBBBBBBBBBBBBGGBBBBBBBBBBBBBBBBBBBBBBBBBBBB####&&&&&&&&&&&&##&    //
//    &&&&&&&&&&################################BBBBBBBBBBB######BBB#################BB###&&&&&&&&&&##&##&    //
//    &&&&&&&&&&&&############BB###B##B######&&##B###########&&##BBBB###&####&#&######BB###&##&&&&&&######    //
//    ###########################BBBB#####################&&&############################B################    //
//    ################################################&###&&&########&##&##&######&&#######B###########&&&    //
//    #########################################B#BB###&###&#&#&##&&##&&&&&&&&#########################&&&&    //
//    ###########################&##############################&&###&&&&&&&&&&&&&######################&&    //
//    &&######################################################&&&&####&&&&&&&&&&&&&&##&&##&######&##&&&&##    //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract ANB is ERC721Creator {
    constructor() ERC721Creator("A New Beginning", "ANB") {}
}
