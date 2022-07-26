
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: CLOVER.ELLO
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                 ,. - .,                  ,.  '              , ·. ,.-·~·.,   ‘        ,.-.                                 _,.,  °         ,. -  .,                               //
//            ,·'´ ,. - ,   ';\            /   ';\             /  ·'´,.-·-.,   `,'‚       /   ';\ '                       ,.·'´  ,. ,  `;\ '     ,' ,. -  .,  `' ·,                 //
//        ,·´  .'´\:::::;'   ;:'\ '       ,'   ,'::'\           /  .'´\:::::::'\   '\ °    ';    ;:'\      ,·'´';          .´   ;´:::::\`'´ \'\     '; '·~;:::::'`,   ';\           //
//       /  ,'´::::'\;:-/   ,' ::;  '    ,'    ;:::';'       ,·'  ,'::::\:;:-·-:';  ';\‚     ';   ;::;     ,'  ,''\        /   ,'::\::::::\:::\:'     ;   ,':\::;:´  .·´::\'        //
//     ,'   ;':::::;'´ ';   /\::;' '      ';   ,':::;'       ;.   ';:::;´       ,'  ,':'\‚    ';   ';::;   ,'  ,':::'\'     ;   ;:;:-·'~^ª*';\'´       ;  ·'-·'´,.-·'´:::::::';     //
//     ;   ;:::::;   '\*'´\::\'  °      ;  ,':::;' '        ';   ;::;       ,'´ .'´\::';‚    ';   ;:;  ,'  ,':::::;'     ;  ,.-·:*'´¨'`*´\::\ '    ;´    ':,´:::::::::::·´'         //
//     ';   ';::::';    '\::'\/.'        ,'  ,'::;'           ';   ':;:   ,.·´,.·´::::\;'°     ;   ;:;'´ ,'::::::;'  '   ;   ;\::::::::::::'\;'      ';  ,    `·:;:-·'´             //
//      \    '·:;:'_ ,. -·'´.·´\‘      ;  ';_:,.-·´';\‘     \·,   `*´,.·'´::::::;·´        ';   '´ ,·':::::;'        ;  ;'_\_:;:: -·^*';\      ; ,':\'`:·.,  ` ·.,                  //
//       '\:` ·  .,.  -·:´::::::\'     ',   _,.-·'´:\:\‘     \\:¯::\:::::::;:·´            ,'   ,.'\::;·´          ';    ,  ,. -·:*'´:\:'\°    \·-;::\:::::'`:·-.,';                //
//         \:::::::\:::::::;:·'´'       \¨:::::::::::\';      `\:::::\;::·'´  °             \`*´\:::\;     ‘        \`*´ ¯\:::::::::::\;' '    \::\:;'` ·:;:::::\::\'               //
//           `· :;::\;::-·´             '\;::_;:-·'´‘            ¯                         '\:::\;'                  \:::::\;::-·^*'´          '·-·'       `' · -':::''             //
//                                        '¨                      ‘                           `*´‘                     `*´¯                                                         //
//                   _,.,  °             ,.  '                ,.  '              , ·. ,.-·~·.,   ‘                                                                                  //
//            ,.·'´  ,. ,  `;\ '         /   ';\              /   ';\             /  ·'´,.-·-.,   `,'‚                                                                              //
//          .´   ;´:::::\`'´ \'\       ,'   ,'::'\           ,'   ,'::'\           /  .'´\:::::::'\   '\ °                                                                          //
//         /   ,'::\::::::\:::\:'     ,'    ;:::';'         ,'    ;:::';'       ,·'  ,'::::\:;:-·-:';  ';\‚                                                                         //
//        ;   ;:;:-·'~^ª*';\'´       ';   ,':::;'          ';   ,':::;'       ;.   ';:::;´       ,'  ,':'\‚                                                                         //
//        ;  ,.-·:*'´¨'`*´\::\ '      ;  ,':::;' '          ;  ,':::;' '        ';   ;::;       ,'´ .'´\::';‚                                                                       //
//       ;   ;\::::::::::::'\;'      ,'  ,'::;'            ,'  ,'::;'           ';   ':;:   ,.·´,.·´::::\;'°                                                                        //
//       ;  ;'_\_:;:: -·^*';\      ;  ';_:,.-·´';\‘     ;  ';_:,.-·´';\‘     \·,   `*´,.·'´::::::;·´                                                                                //
//       ';    ,  ,. -·:*'´:\:'\°    ',   _,.-·'´:\:\‘    ',   _,.-·'´:\:\‘     \\:¯::\:::::::;:·´                                                                                  //
//        \`*´ ¯\:::::::::::\;' '    \¨:::::::::::\';     \¨:::::::::::\';      `\:::::\;::·'´  °                                                                                   //
//          \:::::\;::-·^*'´          '\;::_;:-·'´‘        '\;::_;:-·'´‘            ¯                                                                                               //
//            `*´¯                     '¨                   '¨                      ‘                                                                                               //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract CLV is ERC721Creator {
    constructor() ERC721Creator("CLOVER.ELLO", "CLV") {}
}
