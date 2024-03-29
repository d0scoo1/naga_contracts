
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: holonick x Pepe
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//                                             _......._                                                        //
//                                       _eeEE___).....__)Eke_           _..eeeeeeee._                          //
//                                    .Ek_..................)_Ek    .eEE___.........._)k.                       //
//                                 .ek_.........................'kE__..................._).                     //
//                               .E_............................._)....................._.)k                    //
//                              e_..........__.eeEEE'''''Ekke......)_....................._)_                   //
//                            .E........._)eE__._............__)ke_k)).__.)keeeeeeeeeeeke.__)                   //
//                           )k.........)__......................_'kE____.............._..__'Eke._              //
//                          )k.........................._..kekeeeeekk)k_........................k_Eke_          //
//                          E.......................kE___.)_.....__k).__'Ek.._e_.eekEE'________')Ekkk)_         //
//                       .eE..................._)eE_.)kEE_...kke..___'Ekke.)EE_.ekeEE''___)).))')Ekkk._)k       //
//                    eE_.)_..............)eeE'__)eE)kE')ekEEkke      ''kk._E___...kE' _eekke.    ''kk.)kk      //
//                  e___..E)..........._kkeeeEE_.k'   )Ekk.kEE)EEk          'k_k'     Ekk.kEkEEk        'k)     //
//                .k.....)k..........))e.___._k       kkEE'kk..EEEk          E       EEEE'Ek.ekEk          k    //
//               )k).....__..........._______k.       EEEEEEEEEEEkE         )        kEEkEEEEEEEE         .E    //
//              )__............................)ke_   )EEEEEEEEkk'        .ek._       kkEEEEEkk     _..eeE      //
//             )k............................'ke...)Ekee..''''____...ekEk_e.E._)EEkkeeeeeeeeeekEEk)__.)kE       //
//             E............................._..__)kke..__k______._))_..eeE_.....____...._.___....._k           //
//            E_.......................................______________e__._..._...................)k             //
//           )k...............................................__.eeE_........._'Ekkke.....)ekekE                //
//           k_.........................................._eekE'__.................._)ke........_)e              //
//          )_..................................................................................__).            //
//          k......................................................................................_k           //
//          k......................................................................................._E          //
//          k..............................k..____.).e...............................................k          //
//          k.........................._.)kEkkkkkkkkkkEEkkek._.._..............................)..eeEkkk        //
//          )..........................)EkkkkkkkkkkkkkkkkkkkkkkkEEEkkkeke..__..__......__.)eekEkkkkkkkkE        //
//           k)........................kkkkkkkkkkkkkkEEEkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkE          //
//           )k........................)kkkkkkkkkkkkkkkkkkkkkkkkkEEkEkkkkkkkkkkEEEEEEEEkkkkkkkkkEEEk            //
//            k....................)_..._'EEEEEEEEEkkkkkEkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk)            //
//             k._................._)k...................___'))EkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkE             //
//              )k_..................._')E_.....................)___________'''''''''''''')k'''                 //
//                 'ke_...............................................................).k'                      //
//                     ''kke.__._...................................................kE                          //
//                             ''!kkke.._...__...._....................__..__.kkE'                              //
//                                           ''''''!EekkkkkkkkkkkkkkkeE'''                                      //
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//           _             _                            _         _    _     ___                                //
//          ( )           (_ )                _        ( )       ( )  ( )   (  _`\                              //
//          | |__     _    | |    _     ___  (_)   ___ | |/')    `\`\/'/'   | |_) )  __   _ _      __           //
//          |  _ `\ /'_`\  | |  /'_`\ /' _ `\| | /'___)| , <       >  <     | ,__/'/'__`\( '_`\  /'__`\         //
//          | | | |( (_) ) | | ( (_) )| ( ) || |( (___ | |\`\     /'/\`\    | |   (  ___/| (_) )(  ___/         //
//          (_) (_)`\___/'(___)`\___/'(_) (_)(_)`\____)(_) (_)   (_)  (_)   (_)   `\____)| ,__/'`\____)         //
//                                                                                       | |                    //
//                                                                                       (_)                    //
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract HxP is ERC721Creator {
    constructor() ERC721Creator("holonick x Pepe", "HxP") {}
}
