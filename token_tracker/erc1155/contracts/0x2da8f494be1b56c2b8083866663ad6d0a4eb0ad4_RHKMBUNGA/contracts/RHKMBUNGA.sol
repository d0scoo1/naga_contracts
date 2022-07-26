
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: BUNGA
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                              //
//                                                                                                                                                              //
//                                                                                                                                                              //
//                                                         :!!!7?!~!777~7?!.                                                                                    //
//                                                   .::^!!7??!!77!?J!!P7^!?!^:                                                                                 //
//                                                   7??J?!~~!JPPGYJJY!5!~^~5JY?!!??.                                                                           //
//                                                   7J!^^^!?YPBBBBGPP5PPPPP7!~!YJYP~^^.  .!!^.                                                                 //
//                                                  .!7!!?YYJJJ5GBBYYY5P555PY5JJ55JJ77P7  :5?5Y.                                                                //
//                                                   :^~7YY!.:~7J5GPPPP55Y555PPGG55J??JJ:  JJ5G~                                                                //
//                                     ..               .~~!J!7Y7^~!7YP7!?PPY5PP5YPY7YP!~  !Y7G5!                                                               //
//                                    ^J?:.~~:!J7:..       .?7?J~JJ^^~5GY777~^^JJ7JJ?7Y.   ^Y:JPP~                                                              //
//                               ^^~7!J!^J?7^JP!!YYY7~7?J!!!??. .Y!^7PG5Y7^~?7?Y7JY?~~7.   .?~~P5J                                                              //
//                           .^:^Y5JJ!J^.^Y7:^Y!:~5?Y!JY??J?7P:  ^!~7G5?!7!!....  ..        .J7JPP:                                                             //
//                          :~YJ7?5!:^77!~^7?!!5!J?~^~P5?!!!!P~     7JJY^.  .:::.            :YJ5P7                                                             //
//                         ~Y7~!~!?J~^~~J5J!J5YP5577?YY??J?!7P5Y?. ^5YGPJY77YPYJJ:            ~YY55.                                                            //
//                        .?YJJ7^:^!7?YJJGBYPPGGGG5PP55JY?!~^!5Y!  ?55PYPP5?JJYYY???^         :Y?5G7                                                            //
//                      :^77777!!7!!JPBG55YJ??J?PPYPPPPJ7~!7???JJ.!5??55JY5Y?7Y55Y5GY7:       .5YJGP^                                                           //
//                   ^7!JYJ??!^^^!JYYPGY77?J5PGGPYYJ5PGP5YJJ?!75~!Y5PP5YJPY5Y55GPJYBY!Y!       YP7555.                                                          //
//                 :.:?J?Y55?77?J??JY5P77PYPPPP5Y555P5GGY7~^^?YYY55Y7~^::5GPPP55PGGG5J5J      :5JY55B?                                                          //
//                ^57!^YYJ77?7~!?YPGGBGYYPPPP555PPGGYJYYYY?!75JY5P5?!!7!?Y5YY77JP5P5PPG~      !YJ5YYGG!                                                         //
//                .Y:~7JY~:..::^!7JYY5PGP55PGGGYYYJYYYJ775J??5P?J5PP5GG55Y5Y5J5P5?JGJY?      .JY7Y?555P~                                                        //
//               ::7!7?J557!!!!7J5J^:^J57!?JY?57^:.J5!!~:?5YJPP5JYJJ?J55PGP55Y5PYYYY!J?     .7Y?JYPPY555~                                                       //
//              .7JJ7~J555YY?Y7Y5P??7JB!..?~^~Y577!YY777!?5P5YPYY7YJ?^~J!?PGG5PP5?5GPJ:    .7!7J5PP7:~55Y!.                                                     //
//              ~??Y^~JJY7~J?Y5P5YJP55G~:JJ^?PP?:^!J7~7YJJJ7?JGG?:~Y~:~G57J?PG55PJ?5~.    ^?7!JJPY^   :Y55?.                                                    //
//             .??JYJJY?J~!7!?5P5J55J?5YYPYPGJ5PJJYJ:7:?JJ:!?!G5!^^7!!!P~:JJPG5Y7^.?!   .!7!7Y5Y~.     .?55Y^                                                   //
//           :!?J?J5GGGP5J57?J!77YP5YJJ5YPPYYYJJY5?JYJ?Y7J~7??P!~?Y5YYY?^^PPPY7^...!P: :?7!?557.        .7555!.                                                 //
//           ~?7?7?JPB5?Y577J577755?5JYY?PPYYY5YJYGBPYGJ~~JJJYP7~7GG5PG5JJP5J!77 ^:~YY??JY5P5~            ^JP5J^                                                //
//           ~7?J??555Y?YYYY??JJ5PY7J55GP5P5P5JJJJG5JYPY7YGY?7??Y5555GGG5YJPY7JJ!^.???JYGPP5?.             .!5Y5!                                               //
//          :!!J7!7??JYYPJ?Y55P5YYJJJYYJP55J5P??PY?Y55J77PBPY??Y5PJ55PGPY?7Y5?^:J7!P5YPGP?J~YY:              !YYP^                                              //
//          .^?~:^~~?77?JJ?JY5PYYP5YYJ??5?YJJJ?JYJ??PY7?5PPGBG?J5P!GG5GPJ??J5J^ :555JYGG5!YY77Y:              7JYY.                                             //
//            ~!:^^7~755J5J?JY55555PPGGYYY7J~!?55!!JP5?PPYYYGGPPYJ~YPPGP?7J5Y7~::5P?JGGGJY!Y?!JJ?:             :~!.                                             //
//             .?7J5YYGYYY5JPPGGPYYYP5GJ?J5YPPPYJ555Y?!P5???5Y?GY!~7YBG5Y!55?~^:.~YJPGG5JY:J7^?^?7                                                              //
//              ?!?555?~7JJ?YPYJJYP5PPP55PP5JPJ5PJJ5P7?5?!!!J~~Y55J77Y?~J5PYJ?7!7^^PGBYYJY~?..!!?Y.                                                             //
//              ~!~?Y!.^~7J5PP5PP5PGB5PJ7Y5P55Y5PP5G57Y5!^^~~.:J?YY^!Y~!?JB55!77^7!PG55YJ7?~.^  :5^                                                             //
//               ^77~:^~!??JJYJP5JPBP557?5Y5PPPGPPGBPJJP?..::^??~!??5YYJ7JGJJ^~~~7?GB5J7~?7.:..~?5^                                                             //
//               ^7~^::...:^~!?7!7P5Y5PYY5Y55Y?5PPPGP?YY57^?Y5JJ^.:~5Y5J??J557?JJ!YGP~~?~!^  :7?7Y^:.                                                           //
//                 .:^~~~!?!!~^^^J?PPJYY57?5??JYYY5P5Y7Y?5YYPP?JY!:?JPG?~YJ55Y5GP5PGJ~^!7?!~7J?!77~!7?^                                                         //
//                       .J:..:!7^:PY?5~!7YYYJY5YPP5Y!YJYYJJYJY77J??YJ??YP5YYYJ55YJYYJJYJJJYJ~^^~7^^~Y?   .:^:                                                  //
//                        ~!!!~:   ^?!!?..7777JP5PYY5^5PPP5PP?!Y:.~?J?YYJY5Y?~?5?^...:?Y7^^^^7J55?J7?~.  ^?~^77                                                 //
//                                  .^!?^ ....!JJP?YYJJGP5P5J:.!Y!^7JJ?J5P555Y55Y?7!!!!7!!?Y?~!JJYP?.  .7Y^. :5.                                                //
//                                          ^?!!7PY7?YYY!!?^. :~?J7?J?YYPPPPJ!~75JJJJYY5YJJ57 ..^^~?7.:JJ^^..^Y.                                                //
//                                          :^^~~^. ~!:.    :7?7?J5Y77YGBGG5J??77JYYJ?J5?!~!P~:^::^~?JY7~!~:^??                                                 //
//                                                       .^7?J5GGG5^^J5GGJJP?YJ?7JY5J7JPGYY5PY~77~7?JJ!!??7??Y:                                                 //
//                                                     :!J??5PY?PG5J~JP5~~?PGPYY!~^^!?55?~^!5GJJYJJPY77J555Y5!:..          :~^:.                                //
//                                                  :~?JJJ55?^.?B5??YGP^ ~Y5YY?YJ?!^:~Y!  .^75GGG5YPJ5JYY?7~~~!!77:     ^~!J^~?J~                               //
//                                               .~?YJJ55J~.  ^GGY?GJGP^!5JJ7^?!?PPJ!?! .:~7J5GBBBGPGBPY?!~^:..:!?Y.   !?^:. .:?P: .^~~.                        //
//                                            .^7JYJYPPJ^     JG5J?G?YG5P?7YY~7JJJ5GGYY7~!?Y5PBBBGGGGGG5Y?!~^:~?7JY?7!?J:..:^^!?B!7J!^7Y.                       //
//                                        .:!JYJ7J5PGJ:      ~G5Y?JB!?G5YJJYPYPY??5YJYPY:^~7?J5BGY5GPY5555YYY55YYYY^:7?:^^~!?YYPGJ5^:~~5!.                      //
//                                  :^~~!?Y55PPPGGG5~       :5G55PGB~~YBP?!?PPJ7?^7Y555^.:~^^~?5JJYPY7JYYJ5BY~:::~?~^!7?~7J55P?~!!~!?555J?7:                    //
//                                 ~5YJJJYJJJ?YGGG7.   :~:  ?G55GG?P!:!5PGJ~^7JY7^~~!JY.....:~JP!?7?J^?~5G5YJ~^~^^:^7Y?JJ5BGJ7!!J?77PGY7~:~Y~.:~7J7.            //
//                                 .^^^^:.. .!PPP7    ^5J?7?5~!7G5.?J.^?PGGY7^^!Y7^~~J7  :~!JY7??~~^~~7~JBB5Y5J777!^^5G5J7?5YJPPYYJ5P!~^:::7P??7J5Y.            //
//                                         ^JPGP!     ~PPJYPY~~?P7 ^5~:!YGPG5?!^^7?~~J!.!Y555P??5?^:.:.:7GBGYPG5Y55?JJG7^!!J5PJ!^::^!!!::Y5Y7~?J7P!             //
//                                       :?55GY^      .?BGGP5J?JP^!5JY7~75PPPPJ?!:?77JJJPPJJ55PJY5?7^:^^!5YJ?J5PPP55Y55YJ!!YG7::.  :^^7J5G?^~JYJ~Y?             //
//                                     .75Y5P7.         7GBGGGPGP?P7!7J?~?55GBPPY~~P??JJPP5Y5PG5JYYP?!^!5PPG55YYYYJJJJ?YJYY5GJ!^^~!?77!^?J:!YYJ!7J^             //
//                                   .~YY5PJ^         .~7YY?7!!!777!!!7Y?~?5GBGBG?~G5?!!!7JYGBPJYY!~!7J5G5J?7~~!7?7J77!~!JGYJ~!??!^!5YYYY~7Y557:J!              //
//                                  ^JYYP5!.       .^7?7!~!7?JJJ????7!77YY!!5BBBB5!PJ7!^:...~J???!!?5PYY5!:..  ..^~!^:..7GY~7~^7J!?JG5J7!?Y55J!:J~              //
//                               .^?YJ5P?:       :!7!!!?Y555YYY5YY55P5YY5GG7!5GGBGJGY?7~^::^!7J77?75GGPJ??!:.     .:   !Y?~7!?5PBBBP5J?J555Y?!~??.              //
//                             :!JJ?YPJ:      .~??77JYYYYJJJJJJYYY555YYJY5BB?!5PGGPPY5YYY77!!J?!5JJYG5Y?7~^^^~~^~~^~^:~J^!~?!^~!7J5PGGP5YJ?7???~                //
//                          .~?55YYP5~        ?5JJ55YJ??7~~~!^^~~!!7?J55YJ?PG775~75G5G57Y5!7J5~?J?7~?Y!:.....^Y755YP55J7~^~!J55?!!!7JPBG5J??J?!^.               //
//                       .^?YYYY5J7^.         ~?????7!~!7!!!??77!^^^~!7JY5J!J5J57?YPJJG!7P^!5Y?Y?77~:~!^^~!7^7YY55PPPGPJ?7~^!JPJ~::~!!JPY?7~^^!Y?^              //
//                     ^???J?J?!:                            ^5P5JY?!^~!J5!.:!YJ^YG7:^YPPJ^?PJ^?YY?7~::...:Y~YJP5PPP5YYY77?7:?PJ!^. .~7JG5YJ5J7^..              //
//                     ~J77!^.                                75YY57JJ??~!!.^!Y7.7PJ??Y75J?55P!J5YYJ?!~:.  7^?J55P555YYY!?5555Y7^:.   7!YPJ7?J7.                //
//                                                            .?YJ57??PY^^~!!?Y57!7JPG5!7PP??BGPGGGPY?~:  .?:?P55PYYYJ7?P5PPPG5J!:.   ^?7PJJ7?7.                //
//                                                             .J5Y5!~55?J7~!?JY~!J5GBBGGP5JJPBG?~7YJ!:  .!~^!7!YJ77!~~:~5BYJBB57~:.  7!7GPYJ7:                 //
//                                                              :5G?J5J5^755555~ .:!PBBBGPY7^:JB57^^??^.!Y~..::.!!~::..  ?BY5BB5?~:.:!7^Y5PJ!!J7.               //
//                                                        .:^^:. !GPYJ55..^!?YY7^^~?GBGPY55Y~^JYY5J!^~!75G5Y5Y?:.^:.   .7?J5PP5J!^..?^^?G5P57^:7?.              //
//                                                       .JYY!7?7~JY5??5~:^^~!?P5?JYP?!??JJ5JJ?7?JP5J?~^:^^^~7Y?7^:..:^JJ!~??7?5Y7^:?!J57PJ5J!^.7?.             //
//                                                       :G?!:^.:!J5YYPG5!!!7??5GYJJYY5GBG5J!!^!JYJ7P55YJ?7!7?YPG5YJ?7!7?J?7?5GJ:?JJ5YJ^ ~YJYY7~:!J^.           //
//                                                        ?P:!?~. :JYYY5P55555PP?7?!?Y5PPYYP??7Y5J~!J!YBJ????J5PY??YY?!!!?J??7YJ..^~^:    .~?Y5Y7^!YY7.         //
//                                                        :J!:??7^^!!JPJYY5YP5557JY?~J5Y!YJ5JYJY?!!YYY5!7JJ?7~~~~~~!777!7Y7!JJ5PJ7.          .:^~!777~.         //
//                                                     :!??77~~7?7J7JYP?:^?YGBPGP5J7?!7J7Y^!5Y?P5?7?7?!^!7^:.~7?JJJ?!!!J7!?J57J77J^                             //
//                                                    ~Y~:~~!7!!~~7J?7!?7.75PB5?YGP5?!7!J!77JGGP5Y?~!?:^^::.^J??!J5P55PP5JYYG5J7!Y:                             //
//                                                    757!^:.!JJ??77?J7!J?~JYPGP55GB5?7~: ..:!PPPY?!^!7?YYJ55?~:^YPG5YYY57J?5YY?7^                              //
//                                                    .^!7J5?7^^~~:::~?5YYJ7?YPB5!?BGY7: .::::!GGY7^..!5~~?P7!:^?YY?!J!?JJ5Y7?^.                                //
//                                                        .YJ!!^:!77!^:!7:~JJ?J5GP5BB57: .^^~!~YGJ!:..57  :?J~~?5?!. ^!7??!::.                                  //
//                                                         .^!7J!:.~JY7!!!?J5PJ?Y5GBBP?: .!??Y!5P?^:??J.    ~7!~:                                               //
//                                                             .^!7~^7?7??5PYJJJ7YPBBBJ^  :!??~PY!: JJ.                                                         //
//                                                                .^7???YYJ~~^!5Y7JPBBP7^.:77!~7Y..:Y^                                                          //
//                                                                   ..?P!!~!~7?YY?77PB5J~?^:~!J577!^                                                           //
//                                                                     ~J!!!~~!~~~?Y!75BB5?..^!57.                                                              //
//                                                                      .::::::^~~~!7J?JPGGY?YPBJ:                                                              //
//                                                                                   :?J?JJPPGGGBP7.                                                            //
//                                                                                     :?YJ?5P5555G!                                                            //
//                                                                                       ~Y?!7JY5JP?                                                            //
//                                                                                        :??7!7?J5J~.                                                          //
//                                                                                         .!5PPJ???JJ~.                                                        //
//                                                                                           :JGG5?JJ?JJ:                                                       //
//                                                                                             ^YG5J??^YJ                                                       //
//                                                                                              .~PGJ!!?P.                                                      //
//                                                                                       .:::....:?BJ:^7P^                                                      //
//                                                                                      .Y5Y55YJ?JPG^:~!5?                                                      //
//                                                                                       7555Y5YJYP5~^~JYP^                                                     //
//                                                                                        :~?5G5JY5GYJ!?Y5P^                                                    //
//                                                                                           :JPGGGGPYP?J?5P~                                                   //
//                                                                                             :~!7JP5GGYJJ5G?.                                                 //
//                                                                                                  .^75B5Y5YP5!.                                               //
//                                                                                                     .~YPP5YYP57:                                             //
//                                                                                                       .^JP55YY5PJ~..                                         //
//                                                                                                          :?5PP5YJ55J?!~:.                                    //
//                                                                                                            .~?5P55JJJJJJJ7.                                  //
//                                                                                                               .~JPPP555J7?J!:                                //
//                                                                                                                                                              //
//                                                                                                                                                              //
//                                                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract RHKMBUNGA is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
