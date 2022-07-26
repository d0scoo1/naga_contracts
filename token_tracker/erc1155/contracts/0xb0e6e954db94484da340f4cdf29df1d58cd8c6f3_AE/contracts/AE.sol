
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Austine editions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                                                                        //
//                                                                                                                                                                                                                                                                        //
//                                                                                                                                                                                                                                                                        //
//                                                                                                                                                                                                                                                                        //
//     ____ "                        ____'      ____     ____'       ___    ____  "                       ____  ____'     ___     ___'    ____                  ____‚        ____         ____   ___    ____  "                                                           //
//    |\¯¯¯¯\    '             ____\¯¯¯¯\'   |\¯¯¯¯\  |\'¯¯'¯'\ °   |\¯¯¯ \/¯¯¯¯¯\‚                      /¯¯¯¯\/¯¯¯¯\'  '/¯¯¯'\   /¯¯¯'\  |\¯¯¯¯\  _____'    |\'¯¯¯¯'\     |\¯¯¯¯\     '/¯¯¯¯/| |\¯¯¯ \/¯¯¯¯¯\‚                                                           //
//    |:'\      ;\              /¯¯¯¯''/'\      ;\  |:'\      ;\'|:'\      ;\ '  |::\      .        ;'|'                    |     .;|\        ;'|‘ |       ;\/  ¸    ;'| |:'\      ;\|'\¯¯¯¯'\   |:'\       ;\'   |::\     ;'\  '/     ;'/::| |::\      .        ;'|'     //
//     \::\     `;\   °      '/      ;'/:'|:'|      ;|°'\::'\     ;'\:::'\     ;'\  '\:::\    ;|\____/|'                    |     ;'|::\____/|‘ |'\__/\ `  ;\\__/|  \::\     ;;\:|      ;'| “ \::\      ;;\‚  \::'|    ;;'|'|     ;'|::'/' '\:::\    ;|\____/|'           //
//       \:|     ;;'|"        |      ;'|::/\'|      ;'|   \::|     ;;;\::|     ;;|°  '\::|   `;\/¯¯¯\:|"                   |     `;\/¯¯¯¯¯\  | |'¯'|:'|    ;'|¯¯|'|    \:|     ;;|/____/|‘    \:|      ;;|"  '\/     ;'/|'\     `;\/‘    '\::|   `;\/¯¯¯\:|"              //
//         |     ;;'| ___   |      ;'|/   '|      ;'|     \|     ;;|\;\|     ;;'|     \|            ;|/                     |\____'/\       ;|' \'|__|/|    ;'|__|/°     |     ;;|¯¯¯¯\:|‘      |      ;;|"  '|      ;'|'|:'|     ;;'|‘      \|            ;|/            //
//        /      ;/ /¯¯¯\  |      ;'|    '|      ;'|     /     ;;/|:'\      ;'/|     /    ;/\___'/|                      |'/¯¯¯'\|:'|      ;'|°  ¯¯ /    ;'/|¯¯‘      /     ;;/|\       '\‚     /       ;/|   '|      ;'|/\'|      ;;|'      /    ;/\___'/|               //
//       |       '\/      ;'| ‚|\      ;\  '/       '/|    |      ;'| |\'|     ;'|:'|   /    ;'|/¯¯¯¯ \ "                    '|       ;'\'|      ;'|°      |     ;|'| °       |      ;|:'|:'|       |°   '|       ;|:|   |\'____'\/____'/|     /    ;'|/¯¯¯¯ \ "          //
//       |\____/\___'/'|' |:'\       \/____/:'|    |\____\  |\_'__'\/‘  |      ;         ;'|'                     '|\____/\____'/|       |\___'\   '      |\____\/' |\____\   '|\____'\´   |'|'¯¯¯¯'||¯¯¯¯|:|    |      ;         ;'|'                                    //
//      '|:|¯¯¯'|  |¯¯¯|'| ‘'\::\____\¯¯¯'|::/'    |:|¯¯¯¯| |:|¯¯¯¯|   |\___/\_____/|                     '|:|'¯¯¯|:'|'¯¯¯'|:|       |:|¯¯¯'|         |'|¯¯¯¯|  |:|¯¯¯¯|   '|:|¯¯¯¯'|'   \|'____'||____|/     |\___/\_____/|                                              //
//       \|___'|/\|___|/°   \:|¯¯¯¯|___'|/'      '\|____|  \|____|   |:|¯¯'|::|¯¯¯¯|:|                      \|___'|/\|'___'|/'       '\|___'|°        \|____|   \|____|   ''\'|____'|°    ¯¯¯¯  ¯¯¯¯       |:|¯¯'|::|¯¯¯¯|:|                                              //
//         ¯¯¯    ¯¯¯‘      \|____|¯¯¯‘          ¯¯¯¯     ¯¯¯¯'   '\|__'|/\|____'|/'                        ¯¯¯   ¯¯¯¯*           ¯¯¯‘           ¯¯¯¯     ¯¯¯¯        ¯¯¯¯ ‚                           '\|__'|/\|____'|/'                                                 //
//             °                  ¯¯¯¯'                       '                 ¯¯    ¯¯¯¯                              '                                                                  ‘                                       ¯¯    ¯¯¯¯                             //
//                                                                                                                                                                                                                                                                        //
//                                                                                                                                                                                                                                                                        //
//                                                                                                                                                                                                                                                                        //
//                                                                                                                                                                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract AE is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
