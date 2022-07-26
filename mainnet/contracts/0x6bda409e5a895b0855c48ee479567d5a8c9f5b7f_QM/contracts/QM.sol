
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Falling Through A Field
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    7777777777777777777777!!~~^^~~^^::^~~:.:::^~^:~~!!~~~~~~7~^:~^^~~!!!!!7!!7!777777777??7!..:!??777777    //
//    7777777777777777777!!!~~~^^^^:^^^~~~^:^^:.:::.:^!~:::::^^::^^^~!!!!!!!!!7!777!777777??!^::^7??77?777    //
//    77777777777777777777!!!!~~^~~^~!!!!~~~~~^^^:^:...:^....::::^^^~~!!~~~~!77!7!!!~!777???7!~::!7?????77    //
//    777777777777777777!777!!~~~^~~~!!!!!!!!~~~~:^~^..::.....::^^::~^~!~^~~!7!7!!!!^~77777???7^:!???????7    //
//    7777777777777777777777!!~~~!!!!!~~!~~~~~~~~~~!~:....::..:::::^~^~~!!!77!7!!!!!~~~!!77!777!!????????7    //
//    777777777777777777777777777777!!!~~!~^^^^~~!~~!!:...:...:::^^^~~~~!!!?!7!!!~77!^:~!77~:^~!77????????    //
//    777777777777777777777777777777!!^~~~::....:::.::........:::^^^^^^~^!?!!!~!!!77!~~!777~~~~~!77777????    //
//    77777777777777777777777777!!!!!!~~^:....................::::^^^^^^~?~!!~!77!77!!777777~~^~~!!!777???    //
//    777777777777777777777777!!!!!~~:........................:::::::..^?^^~^~!77777!!!!7!~!!~~~~^:!!~!77?    //
//    7777777777777777777!77!!!!!~~~^.........................::......^?^:^~~!!!7777!!!77!!!~~~~!!!^^^~!!7    //
//    77777777777777777777!!7!!~^:::^:.........................::....^7~^^^~!~:~!7777777777!~~~~!!^:::~~~!    //
//    777777777777777777!7!!!!~~!^:^^......:^!?JY55PPPP55YJJ?!~:....^?!^^^^!!~^:~77777777777!~~^^^^::::^~~    //
//    7777777777777777777!7!!^::^:::..^!?5G#&@@@@@@@@@@@&&#BGPP5?!::!!::^^^~!!!~^~!77777777!7!7!:.....::^~    //
//    777777777777777777!!!!!!^...:!?5B&@@@@@@@@@@@@@@@@@@@@@#BGPP5?JP5?!^:^~~!!~^7777777777!777!~:  ...:^    //
//    777777777777777777!!!!!~^:~J5PB&@@@@@@@@@@&&&@@@@@@@@@&@@@#BPP5PPPPY!:::::.^777777777777!77!!^:. ...    //
//    77777777777777777!!!!?^:!5PPB&@@@@@#BGPPPGGB&@@@@@@@@@@@@@@@&GPPPPPPPY~...::^~!7!!!7!!777!!!77!~^..     //
//    7777777777777777!!~!YP5JPPPB&#BBB#&#BB#&&@@@@@@&@@@@@@@@@&@@@#BBGPPPPPP7:..:^^^^~!!!~~!!777777!!!!^.    //
//    777777777777777!7!?PPPBBPP5GBP5G##&@@@#&&@@@@@@@@&@@@&&@@B&@@@##&BPPPPPPY^..:::::::^^~!!77777777777!    //
//    7777777777777!7!~JPPPBBPPPPPG#BB&&B@@@@@@@@@@@@@@@@@@@@@@@#@@@&#B&#PPPPPPJ...::..::::::^~!7777777777    //
//    777777777777!!!~YPPPGBGPBPPG#@@GB#G#@@@@@###&&@&GJB@@@@@@@@@@@@&BG#&GPPPPPJ...::.::::..:::~~!!!7!777    //
//    777777777!!!!~^JPPPG#GPG#B5PPB#GPP5JPG&B55BBBB#B55G&@@@#@@@@&GGB#GG#@BPPPPPY:...:..::..:::.:::~!~!!7    //
//    777777777!!!^^^PPPPGBPPP&@5?JY5GJ5#555YY?75PPGB##G#&#@&&GP#B!^!7BBPB#BP5PPPPJ....:..::::::::...:^^~~    //
//    7777777!^:.:..!55PPPPPP#@&#???5G#P5GPJ?YJ7B&&&@@&&&@&&&@BYP?~^^^5#GGB&G5Y5PPP?...::...::::::::.::::.    //
//    7777777~:.....!P55PPPP#@##@57?Y#@@&5G?755?#&#BBBG&@@&&GJ^:JGP5?~?#BB#@GP5J5PPP?....:....:::^^^^~~!!!    //
//    777777!~::::..YPPPPPP#@&B#@&??5G&@@&BGGB#G5J777775BGGY^   :JYJJ~7###@@BPPY5PPPPYJ~~!~::::^::..::^^~~    //
//    777777!~~^:..:5PPPPPG&&#B#&@BJ55PP&&###P7!!~~!!!?PP5P!^..^~^!YBGG&#@@#BPPP5PPPPP#@&&#G5J7~^::::::::^    //
//    7777777!!~::..JPPPPPPB&#BB#&@BBGYYPPGBG?!7!777?JPP55P5PG5GP5B&&&@&&&BGPPPPPPPPPP#@&@&@@&&&#GGBGPY!::    //
//    7777777!~^^::.?PPPPPPP###B##@&GGY~!?5777JJ???J5GBB##&&@@@@@@@&#GGP5PPPPPPPPPPPPG@@@@@@@&@@@&@@@@@@G5    //
//    7777777!~:^::.7PPPPPPPPB##&&&&&GPG5PPPPG#&&&@@@@@@@@&#BGPYJ??7777JPPGPPPPPPPPPP&@@@@@@@@@@@@@@@@@@@@    //
//    77777777!~^^..7PPPPPPPPGB#&@@@@&&&@@@@@@@@&&#BP5YJ?77!!!!!!77777JP?:7YPP55GPPP#@@@@@@@@@@@@@@@@@@@@@    //
//    777777777!^::!5PPPPPPPPGBGB#&@&#BBBGPP5YJ?77!!!!!!7777777777777J5!.:~?P5J5@&B#@@@@@@@@@@@@@@@@@@@@@@    //
//    77777777!!!7Y#GPPPPPPPPPPGGYPGPY?7777777777777777777777?77777?5#&##&@@@@#P#@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    7777!^!7JB&@@@GPPPPPPPPPP5!.~?5P5J?????7???777?777777777??JYPB@@@@&B###@@BPBBB&@@@@@@@@@@@@@@@@@@@@@    //
//    7!!7?JP#@@@@@@BPPPPPPPY!^.....?#BPYJJJ????77??777?????JJ5G#&@@@@@@@#G#G&@@BG#GG&@@@@@@@@@@@@@@@@@@@@    //
//    7YB#&@@@@@@@@@@GPPPPP#7..^?5YG@@@@&##BGPP5YYYJJ5555PG#&&@@@@@@&##@@@##B#@@&GB&GB@@@@@@@@@@@@@@@@@@@@    //
//    #@@@@@@@@@@@@@@@BPG#&@#?Y@&#&#@@#&@&&@@@@@@&&&&@@@@@@@@@@@@@@@#&&@@@#B&#&@@&B##G&@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@&&#@@@@@@@&@@@@@@@@##@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@&#@&@@@#B&##@@@#B&#@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@&&&@@@@@@@@@@@@@@@@@#&&&@@@&&&&@@@@@@@@@@@@@@@@@@@##@@@&#@#&@@@#B#G#@@@BB@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@&#@&#@@@&#@#&@@@@@&&@&@@@@@@##@BB@@@&#@BB@@@&G#BG@@@BG@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@&@@@@@@@@@@@@@#B&##@@@&#&B#@@@@@@&&&##@@@&BB&B#@@@&G##PB@@@GG#G#@@&B#@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@&&@@@@@@@@@@@@@BB&B#@@@B#&B#@@@@@@&#&&B&@@@BG&BB@@@@GP#BP&@@#P#GG@@&#G&@@@@@@@@@@@@@@@@&#G    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@B#&G&@@@GB&G#@@@#&@@#B&BB@@@&GB&GB@@@#PG#PB@@@GGBP&@B#GP&@@@@@@@@@&BPY?!^::    //
//    @@@@@@@@@@@@@@@@@@@@@@@@&G##G&@@&PB#P#@@@BB@@@GB#G#@@@BP#BP#@@&GPBGP#@@BPBP#@GG#PP&@@@@@@B7:........    //
//    @@@@@@@@@@@@@@@@@@@@@@@@&G#BG@@@#PBBP#@@@GG#@@#PBBP&@@@GP#GP&@@@PPBPB@@#PBPB@#PGBPG@@@@@G:..........    //
//    @@@@@@@@@@@@##&@@@@@@@@@#P#GG@@@BP#GP&@@&PGB@@@GP#GG@@@#PBBPB@@@BPGB#@@#PGP#@@GPBGP#@@&@~....:......    //
//    @@@@@@@@@@@@@@@@@@@@@@@@BP#GG@@@BP#GP&@@#PGB#@@&PBBP#@@@GPBGP#@@@GBGP&@#PGG#@@&PPBPG@@&5....:.......    //
//    @@@@@@@@@@@@@@@@@@@@@@@@GG#PG@@@BP#PG@@@#PBGP&@@GP#PG@@@&PPBPP@@@GBGP&@@PPPG@@@BPGPP@@B:...::.......    //
//    @@@@@@@@@@@@@@&##BBG#@@@GG#PB@@@BP#PG@@@#PBGP&@@BPBGP#@@@GPGGP#@@PPBP&@@BGGP#@@&PPPP@#7....:......^^    //
//    @@@@&&BGGP55Y?77!!!!!J&@PG#PG@@@BP#PG@@@BPBPP&@@&PGBPG@@@&PGBP&@@BPBP&@@BPBPB@@@GPPP@P::..:.........    //
//    5YJ??7!!!!!!!77777777!7B#PBPG@@@BPBPG@@@BPBGP&@@@PPBPP#@@@PBBP&@@#PGPB@@BPGPP&@@BPPG&7.::::.:^^^^^^^    //
//    7777777777777777777777!^YYBGG@@@BPBGG@@@BPBGP#@@@GPBGP#@@&PBBP#@@BPBPG@@#PGGP#@@#5YG#^:^^^:^~!!7!!!!    //
//    7777777777777777777777!~~!PGP&@@BPBGP@@@#PBGPB@@@BPBBP&@@&PGBPB@@BPGPP@@@PPGPB@@#PYB5^^^~~~!!~!!!!!!    //
//    777777777777777777777777!~JGP#@@#PBGP&@@&PGBPB@@@#PBBP&@@&PPBPB@@#PGGP@@@BPGPG@@#5YBJ^^^~~!!!!!!!!!7    //
//    7777777777777777777777777!!5PG@@&PBGP&@@&PGBPG@@@#PBBP#@@@GPBPB@@&PPGP&@@#PGGP&@#5YB7^^^~~!!!7777777    //
//    77777777777777777777777777!JPP#@@GGGP&@@@GP#PG@@@&PGBPB@@@BPBPG@@@BPGP#@@&PGGP#@#5YB!~!~!~7!7777777!    //
//    777777777777777777777777777!5PG@@BPBP#@@@BP#GP&@@@PG#PG@@@#PBGG@@@BPBPB@@@GPGP#@B55B!~!~!~77777777!!    //
//    777777777777777777777777777~J5P#@#PBPB@@@#PBBPB@@@GP#GP&@@&PGGG@@@#PBPG@@@BPGPB@B55B~^^^!~!!!777!!77    //
//    ?7777777777777777777777777!!~55G@&PBPG@@@&PGBPG@@@BPBGP#@@&PGBPG@@BPBGP&@@#PGPB@B55B~^^^!~77!77!7777    //
//    ??77777777777777777777777777!Y55&@GGGP#@@&PP#PG@@@#PBBPB@@@GPBPG@@#PGGP#@@&PPPG@B55B!^~~!~7777777777    //
//    ???7777777777777777777777!~!~!BYP@&PBPG@@@GPBPP@@@&PG#PG@@@BPBGG@@&PGBPG@@@GPPG@B5YB!^~~!~7777777777    //
//    ?????777777777777777777777!~~^G5Y#@GGGP&@@#PBGP#@@@GP#PG@@@#PBGG@@@GPBGP&@@BPPG@#PYB?^^^!~!777777777    //
//    ?????777777777777777777777777!JBYP@#PBPB@@@GPBPG@@@BPBGP&@@&PGBG@@@BPBGP#@@#PPG@&PY#B~^^~~~77!!77777    //
//    ??????777777777777777777777777~YP5#@GGGG@@@BPBPG@@@#PBBP#@@@GGBP&@@&PGBPB@@#PGP@@P5B#~^~~!~!77777777    //
//    ???????77777777777777777777777!5&YP@#PGP#@@#PBGP&@@&PGBP#@@@GGBP#@@@GPBPG@@&PGP&@GPP#J^!!!!!77777777    //
//    ?????7777777777777777777777777!B@BYB@GGPB@@&PGBP#@@&PGBPB@@@GG#PB@@@BPBGP&@&PGP#@BG#@#?!!7!!!7777777    //
//    ?????????77777777777777777777!J&@@BG&&PGP&@&PGBP#@@&PGBPB@@@GPBPG@@@&PGBP#@@GPPB@@@@@@Y!777!!7777777    //
//    ??????????7777777777777777777!P@@@@@@@GGP#@@BPBPB@@&PG#PG@@@BPGGP#@@@GPBP#@@BGB&@@@@@@J!777!!7777777    //
//    ?????????????7777777777777777!J@@@@@@@@@#B&@BPBPB@@@GP#PG@@@&PG#PB@@@BPBPB@@&&@@@@@@@#5J!777!!777777    //
//    ??????????????7777777777777777YG&@@@@@@@@@#@&PBGG@@@BP#GP&@@@GG&GG@@@#G##&@@@@@@@@@@B5557!777!!77777    //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract QM is ERC721Creator {
    constructor() ERC721Creator("Falling Through A Field", "QM") {}
}
