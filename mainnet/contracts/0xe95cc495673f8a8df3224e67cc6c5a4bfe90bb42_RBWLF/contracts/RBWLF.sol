
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Running Boy Wolf
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                           `"^`.                                                  //
//                                          ;|njt_`                                                 //
//                         ..              :w4(@g3;,                                                //
//                     'i){??|/,           .^:>+1t\-]"                                              //
//                     }w4c4g3-D3.          ^`":>]{_+-                                              //
//                     _tx/tv\>~Wv.          ^``",";~i.               .,`'                          //
//                     `><-i~~lI+u)           ``'``:;I'              I"i!;;'                        //
//                      "!i+"^```;r)~           `^;Il;!,            "{;^^`"`.                       //
//                       '~_<>1{|&H3$'          .^:?{_I;.           ^#!```:`^                       //
//                         ',1{-<M1y3do'         `-(\){l;            1f!",:;,                       //
//                          `-1hm0h@np4\          "j1){~i.            ir)l,l.                       //
//                           `{{\h3m1ye!           ,{?-;,.             '*x:^``                      //
//                             >!!!!ii)<            .`lI^`,,.          ;B*u!ll                      //
//       ."""`..                ;uuf?"".            `I`.'`,+f.         .cMf?-`                      //
//      .I{ft]:"'                ."!`.  .'.         ?(` .'`>1.          .jj>>'                      //
//       :+}_{-I,.                  ^{]-:I~:        "j,.'^",_.          W@(4g3'                     //
//       ^-}?;"^'.';'               ?((^'"II<        +f<'.,(:          '8ci"`^!>                    //
//        `]1+"`..;f"              ./1"^^,,?],        `},'`<.           i|>:;l_]`                   //
//          `-)/n:;""``'            .\\i",";]+.         ^""~`           ./[,l<I^                    //
//            .^^ '}]i-]`            .it!"^:;            ```I            .:"",'                     //
//               .^})+;,,              .^",`'            `<n>             .'..                      //
//                .`<-I'"'.. .            .''           '?}-?f)+_!>},^''.   ..`'                    //
//                  '{(|^..''^i,.                .`..^I}+~"`'^!\\{)>,:"`.   `;<11^                  //
//                   '+,`..``,:li^            .'^Il;,;`,``.    ..^`.`,-+^.  ':;;_(['                //
//                    .-:'`^:,^"i+,          .`,^``..`''!+!`   ....!~+1{>;^^``'.`;?1"               //
//                    .j(-"'..."l_1:       `^^`""''....:<;~|i`..`''i;"""^,"^``'...`^!,              //
//                     '}w|\(4g3_+>j`   .''``""^`'.. ."<~]-?[{]?`,'^l;^```^,``...  ..''             //
//                       ;!wa|)ut4!;`"""'..`l~l,,:,""::;>,:li<l~''"i,^``^,,^""^`^``'```.            //
//                         ^~()hn4` !^...  .i--~li!``^";,",`:i"`,  '!;;;,";I;I!!!ii;;^'..           //
//                                ^{:.   ..I;",""^^'^":I:;"'^"""```^":'`^,::""""````^^^`.           //
//                                 <[^...`,!i,,;,:I;:,",:;:^",Il>_<;,```^`'....`'.',;l;:^           //
//                                  .<}:""`;<;,""^"::;::`.''`..`^!i,,,"`'`....',". ^;;:;,'          //
//                                    ^~+`'.";:"^^^;>l,`.           .`^``^'..'`;,` ^,,:;I`          //
//                                     .+;"``'`^`.''.'.               '`^`..''`,,,^":::::,`         //
//                                       .`!I,;l,:``"`":``.....        ``''..'```",;Il:;:,'         //
//                                         I<~<-i:,^`'`^,,^''.. ..     .^^`'.'``^,,;;,,,""`         //
//                                        "/f]-,`.'`;I!>!::,,`.         .'.''`'``",,,"^,,"".        //
//                                        1j\\l^'`,i~+-+]~++!`.           .  .``"``````"+_,`        //
//                                        "-j(ii,II+>>><++ii:"`'.. ....       ..'.. .'",>i"`        //
//                                        .l{[}[!i<~!+li_i;;,",,","`....           ..`"",,!'        //
//                                         '^i[~;,:;II:;;;,;;,"````^^^...      .... ''```:'         //
//                                          '!~_>;":>l,",:"^`"^,""```","`....... ..'`":;^.          //
//                                          (([_+;,;:,,:,"^^`"^```^``^,,^"^`'..'`^;!``.             //
//                                          +t\]Ii;:II,,,,"^^^"""^^`'`^^`"^^^^"""_`                 //
//                                          `|(1-;"";Ii>!,``^^``'''`'`````,`^:<`                    //
//                                          .~\(],,l~}){>'.'""`'...'...```,^>\,                     //
//            ."`'...'    .                 ,1}?il~{|/?~!,^";"^`''''''`'```+(,                      //
//           `>"^`"`..'.'![|!'.             .`>-/?_1}[I:^,I;"`'`'.''''`^,:'                         //
//      .`  .l+|c@z3|!^..,z*r?:.           .'',+-[-]++I"`^``'.....'''^,ii.                          //
//      ':,:+~|]!;;~1NY4NG$$$`'             .'`"<1t+l;::;I"^^`'`^,,+1)?'                            //
//      `-|\f{+l+)M4N1$@,                      '`l/x|I;:Iny4ng!m4n1!".                              //
//        ^I{$UNGC1NC4x`                         '{$ungc1nc4|rx\;.                                  //
//             .^""^'.                            `>{+:`..                                          //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract RBWLF is ERC721Creator {
    constructor() ERC721Creator("Running Boy Wolf", "RBWLF") {}
}
