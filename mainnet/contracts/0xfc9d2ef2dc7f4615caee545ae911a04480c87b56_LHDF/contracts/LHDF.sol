
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Longevity Hackers Documentary Film
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                              //
//                                                                                                                                                              //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@&PB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@#Y5B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@#Y5YP&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@&5555YB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@#55555YB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@#PY555555&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@#P5555555555G@@@@@@@@@@@@@@@@&YP@@@55@@@GY@@@GY5555@@@@#JG@@@@@P5@@@@@@P5@@@G5555P@@#YG@@BY#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@BPY555555P#&&&&@@@@#&@@@@@@@@@@@P~G@5~B@@@J~&@@&#J~B#@@@&77!B@@@@?!@@@@@@?7&@@&#77##@@@P~PG~5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@B5Y555555P#&@&&&@@&&@#?P@@@@@@@@@@@P!5!G@@@@Y!&@@@@Y!&@@@&7!G?~#@@@J!@@@@@@?7&@@@@?7@@@@@@B!!G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@B5Y555555555555555G@PYB@G^7G@@@@@@@@@@5!P@@@@@57&@@@@57&@@@Y7PPGJ?&@@Y7YY5@@@J?@@@@@J?@@@@@@@J?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@&PY555555G#&&&&&&&&&&@&&@@G~!~J@@@@@@@@@@&@@@@@@@&@@@@@@&@@@@&@@@@@&@@@@&&&&@@@@&@@@@@&&@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@&5Y55555PB&&&@&&&&&&&@&B##B?~!!~P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@BY5555555555P@P555555@5!7!!!!!!~Y@@@@@@PJ&@BJ#@@@YY5YP@@@@@5J&@@@@#JG@@@@#YYJYY#@@BJ#@&JG@@@PYYYB@@@PJYYP&@@@@G?B@@@@@Y5&@#JB@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@#Y555P&&&&&&@@@&@@@@@@@GJ!!!!!~!#@@@@@@Y~B#5^B@@&!?GG#@@@@5!??&@@@#^P@@@@&&G^P&&@@G^P#G^5@@&?!55B@@@?!&B~J@@@B!J!#@@@@7~7GB^P@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@B55YB@@#&@&#&@#BBBBBBJ!~!!!!~7B@@@@@@@Y~5PJ~B@@&7755#@@@P^YG~J@@@#~5@@@@@@B^G@@@@G^YPY^P@@@BP5!J@@@J!5YJB@@#~?G7!#@@@7J#?7~P@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@&GYG@#55&#5P&Y!77~!~~!!!!~7G@@@@@@@@@5?&@G7#@@&J?5YP@@#75GGG7P@@#?JYYB@@@B7B@@@@B7#@&7G@@@PJY?P@@@YJ&&@@@&JJBGG?Y@@@JY@@P7G@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@#P#@@@@@@@@@&G?!!!!!!~7P&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@&@@@@#PGGP?~!!!!!~7P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@5!!~~!!!!~~?G@@@@@@@@@@@@@@@BGGGB@@@@BGGGG#@@@@BG@@@GB@@@#P#@@GB@@@#PGGGB&@@@@@BP&@@@&GGGGG#@@&P#@@@&BGGGG#@@@@GG&@&P#@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@&7~!!!!~?G@@@@@@@@@@@@@@@@@GY##&@@&5P&&&#5P@@@P5@@@YG@@@BY5G@5P@@@BY#@&P5&@@@B5PP@@@@&#YB@@@@&YB@@&5P&@&#5G@@@PY5B&YB@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@G~!!!~!G@@@@@@@@@@@@@@@@@@@GYGG#@@&5P&@@&5P@@@P5&@&YG@@@GY&GP5P@@@#Y#@&PY&@@BYGBYP@@@@&YB@@@@&YB@@&5P&@@&5P@@@PP&PPYB@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@G~!!!!#@@@@@@@@@@@@@@@@@@@@BP@@@@@@&GPGGPB&@@@&GPGPG&@@@BP&@#PG@@@#PGGGG&@@&PB###PB@@@&5B@@@@&5#@@@&GPGGPB@@@@GP@@#P#@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@5~~~5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@B?^5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@G?G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@B&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                                                                                              //
//                                                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LHDF is ERC721Creator {
    constructor() ERC721Creator("Longevity Hackers Documentary Film", "LHDF") {}
}
