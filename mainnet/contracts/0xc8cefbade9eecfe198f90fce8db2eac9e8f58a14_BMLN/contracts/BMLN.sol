
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Burn My Lonely Nights
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//     ____  _  ____  _    ____  ____  ____  ____  ____  _    ____  _____  ____  ____                         //
//    /  __\/ \/   _\/ \ //  _ \/  __\/  _ \/_   \/  __\/ \ //  _ \/__ __\/  _ \/_   \                        //
//    |  \/|| ||  /  | |_|| / \||  \/|| | \| /   /|  \/|| |_|| / \|  / \  | / \| /   /                        //
//    |    /| ||  \__| | || |-|||    /| |_/|/   /_|  __/| | || \_/|  | |  | \_/|/   /_                        //
//    \_/\_\\_/\____/\_/ \\_/ \|\_/\_\\____/\____/\_/   \_/ \\____/  \_/  \____/\____/                        //
//                                                                                                            //
//    PPP55P555555555555555555555555555555555555555YYYYYYYYYYYYYYYYYYYY55555555555555555555555555555555555    //
//    555555555555555555555555555555YYYYYYYYYYYYYYYYYJJYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY55YY5555555555555    //
//    555555555555555555555YYYYYYYYYYYYYYYYYYYYYYYJYPGGPYJJJJJJJYJYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY    //
//    5555555YYYYYYYYYYYYYYYYYYYYYYYYYYYJJJJJJJJJJY&@@@@@5JJJJJJJJJJJJJJJJJJJJJJJYYYYYYYYYYYYYYYYYYYYYYYYY    //
//    YYYYYYYYYYYYYYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJ#@@@@@5??????J?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJYYYYY    //
//    YYYYYYYYYYYYYYYYYJJJJJJJJJJJJJJJJJJJ?????????5@@@@@P7???????????????????JJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    YJYJJJJJJJJJJJJJJJJJJJJJJJJJ?????????????????75@@@@P5YB&P777????????????????????????????JJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJ?????????????????777777777P&@@@@@@@@@B!7777777777777777??????????????????????????    //
//    JJJJJJJ?J??????????????????7777777777777777!B@@@@@@@@@@@@5!!!!777777777777777777777777777777777?????    //
//    ???????????????7777777777777777777777!!!!!!?@@@@@@@@@@@@@@Y~!!!!!!!!!!!!!!!7!!7777777777777777777777    //
//    ??????777777777777777777777!!!!!!!!!!!!!!!~Y@@@@@@@@@@@@@@&!~~!!!!!!!!!!!!!!!!!!!!!!!!!7777777777777    //
//    77777777777777!!7!!!!!!!!!!!!!!!!!!!~~~~~~~P@@@@@@@@@@@@@@@B~~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!!!!!!!!    //
//    7777!!!!!!!!!!!!!!!!!!!!~~~~~~~~~~~~~~~~~~^G@@@@@@@@@@@@@@@&~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!    //
//    !!!!!!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^#@@@@@@@@@@@@@@@&^^^^^^^^^^^^^^^^^^^^^^^^^~~~~~~~~~~~~~~~    //
//    ~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^~~^^!@@@@@@@@@@@@@@@&7:^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~~    //
//    ~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^G@@@@@@@@@@@@@&5^::::::::::::::::::::::::::::^^^^^^^^^^^^^    //
//    ^^^^^^^^^^^^^^^^^^^^^^::::::::::::::::::::G@@@@@@@@@@@@@^.::::::::::::::::::::::::::::::::::::::^^^^    //
//    ^^^^^^^^:::::::::::::::::::::::::::::::::.!@@@@@@@@@@@@@7......:..::::::::::...:.::::::::::::::::::^    //
//    :::::::::::::::::::::::::..................B@@@@@@@@@@@@G............:::::::::::::::::::::^^^^~~!!!7    //
//    :::::::::::::..............................:&@@@@@@@@@@B?^~~~~~^^:::..::::::^~^~~!?JY5555PGGBBBBBBBB    //
//    7?JJYY??777!!!~~^^^^::::::::......::::::::::B@@@@#B@@@@5?YY55555555YJ?JJJ7!~~~^^^^^~!?Y5GBB#########    //
//    5PPPGPY??!~~!!!77?JY5555555PPPPPPPPPPP5PPP5YB@@@@GY@@@@^.:..:::^^^~~~~~~^^:^~7JJJ7!7777!7?J5GBBGGGGG    //
//    ::::^^^~~~~^^^^^^^^^^~^^^^^~!!?JY555PPPP5PP5G@@@@7:B@@@^.....::::^^~~!7??77?JYPPPYJ??7!!~~^^~!!!!!!~    //
//    ::...:::::::::::::::::..:^^^^^^~~~~~~~~~^^^^!@@@@^:7@@@G^~!!!!!~!!777?JYY5PP5JJ??JYYJ??7!!!!!77???J?    //
//    :::::::::::::::^^~!777!!!77777!!!~^^^^::::^~!&@@&YJ?P@@@577777!~~^^^^^^^~!?JJJYYYYJJ?JJ?J5YYYYYYYYJ?    //
//    ~~!!!!777777!!~~~!!!!!~~!!!!!7?JJYY5555YJ??7!G@@@!!!!&@@#?JY5GBBPBBYJYYJJ5YJJJ??77!!J?!?Y#5!7~^^^^^^    //
//    !!!7????JYY55YJJYY55PGGGPPPPGGGBBGGGGGGPYJ?775@@@PJYY#@@&YYJP@@@@@@&P!~^^P#?^~!^~~!7G##&@@&&&YYY?YJY    //
//    7?JJYYYYJJ??J??7~~!7J5PGGGP55555YYJ???J?J?Y5YB@@@#7!!P@@&~~~P@@@@@@@@&BPG@@@##&###&&@@@@@@@@@@@@@@@@    //
//    &&&&@@@@@@&#&@@@&&@@@@&&&&#&#BBBG&#BB#&&&&@@@@@@@@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@&&&&&&&    //
//    @@@@@@@@@@@@@@@@@@@@@@@&@@&&&BBBGB#PGPBBB##&@@@@@@BJG@@@@G!7J&@@@@@@@&PJ7P@@GP55Y555G@@@@@@&@B5PYJYJ    //
//    #B##&&&&&&#GGBBGY?JYYPGGB#BGGPGGGPP555555YYY5#@@@@G5YB&@@BYYY&@@@@@&#Y??7J#P7!!!!!!!?GJJP#&YJ?~~~~~~    //
//    ??????????7?JJJ??JJY5GBBBGPGGGBBBBBBBBBBGP5Y?7Y@@&777?P@@#Y5PPBBG5G5JJJJJJY555PPP55YYYYYYPG555P555P5    //
//    7??JJYY5PPPPP5J???J?JJ?777777??JYYYYYYYJ7!!7775@@&555Y#@@#?JJJJ?7!~~~~~!!7?5P55555PPP55YYJJJ?JJJJJJJ    //
//    ^~~~~^^^^^^^^^^^^~!7777777???JJ??7!!~~^^~~~!!7G@@&?7!~#@@B?JJJ?????JYY5PGGBBBGGGGP555YYJ??7!~!77????    //
//    ~^^^^^^^^^^^^^^^^~~!!~^^^~!!~~~!77???JYJJJJJYJ#@@&~^^:#@@P:^^^^^^~~~~!!7??!!7J5BBBG5YYYYJJY5GB######    //
//    ^^^^^^^^^~!7!!!!!!~~~~~~~~~!7?J5GGBBB########B&@@@P5J5@@@J^^^^~!!7?JJYYYYJJ?7??777777?Y5PG##&&&&&&&&    //
//    !!7??JYYYYY?????JJY55PGGGGGGGGGGPPPP555Y555YYY&@@@Y?Y&@@@PPGGGBBBGGPPYJYY5J?????7?JY5PGBBB##########    //
//    GGB####B555YYYYYJJ????77!!!~~~~~^^^^^^~~~~^^^~&@@@5^5@@@G7??JJ??77!!!~~~~!!!!77777??JJJ??????????JJJ    //
//    7??JJYYJJJ??77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~&@@@#~#@@@P^~~~~~~~~~~~!!!!!!!!!!!!!!!!!!!!!!!!!!!7777    //
//    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!?@@@@@Y&@@@&~!!!!!!!!!!!!!!!!!!!!!!!!777777777777777???    //
//    777777777777777777777777777777777777777777777J@@@@@@@@@@@P?77777777777777777777?????????????????????    //
//    JJJJ?????????????????????????????????????????#@@@@@@@@@@@@G7???????????????????JJJJJJJJJJJJJJJJJJYYY    //
//    YYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJYYJJ5@@@@@@@@@@@@@P?JJJJJJJJJJJJJJJJJJJJJJJYYYYYYYYYYYY55555    //
//    5YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYJB@@@@@@@@@@@@@5JJYYYYYYYYYYYYYYYYYYYYYYYYY55555555555555    //
//    5555555555555555555555555555555YYYYYYYYYYYYY#@@@@@@@@@@@@@&#PYYYY555555555555555555555555PPPPPPPPPPP    //
//    PPPPPPPPPPPPPPPPPPP5P55555555555555555555555P@@@@@@@@@@@@@@@@#555555555PPPPPPPPPPPPPPPPPPPPGGPPGPGGG    //
//    GGGGGGGGGPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP#@@@@@@@@@@@@@@@@#PPPPPPPPPPPPPPPPGPGGGGGGGGGGGGGGGGGGG    //
//    GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG@@@@@@@@@@@@@@@@&PGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBB    //
//    BBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGGGGGGGGGGG@@@@@@@@@@@@@@@@#GGGGGGGGGGBBBBBBBBBBBBBBBBBBBBBBBBBBB    //
//    #BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB&@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#B##    //
//    ##############BBBB#BBBBBBBBBBBBBBBBBBBBBBBBBBB#@@@@@@@@@@@@@@#BBBBBBBBBBBBB#########################    //
//    &##############################################@@@@@@@@@@@@@&#######################################    //
//    &&##############################################@@@@@@@@@@@@#######################################&    //
//    &&&#&##&&##&#####################################&@@@@@&&&@@##############&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@&#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    @@@@@@@@@@@@@@@@&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BMLN is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
