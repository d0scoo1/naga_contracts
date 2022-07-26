
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Ash Realm
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//          _  _  ___ ___ ,▒█▓▓▓æ_ⁿ╢█▓▀▒ÅS▓╬╬▒╬▓╬╣▓█▒╢╩▓▓╬╢M╬░╩└`_╗. ╦╬▒φ██▒φ½╕µ              //
//        ___ ____    '_▒@█╣╬╬╣█▓b⌐_╚⌐╙╩╫▒╩#╫╢╣▓╣▓╝▒╠╠▓╣▒▓╣▓╬▓╫┐²╣▓╫╨╠█▒l╠▌╣█╣█▓█▌⌐ _         //
//        __   __      ,╚▓╬▓█▒╫╩║╬╜¼╣__ ' ╠╣╩╜└╙╬╩└╬█▓╫╣▌║▄╩╝╬╝╬╬╟╬╬╬╙╜┤φ▀╣╣▒╜██╠▌7      _    //
//         ___ ___ _ _ .╫╣▓╣███▓▒╬█▓╩╙▀%▄╖╫▒ ╓╔  _▒▒╬█▓╚▄∩ .▓▓╢▓"╙╜.╣#█▓╬└╩╚╩╩╚╙╚└    ____    //
//        ________     '└╨╩█▓╫╩╬▓▐╚╝▒╬╣▓▒┌╠╠▓▓█▒ ╬▌  ╙  ╠ Æ└╩▓▒║▒,▄╬▒╬▓╬╙⌐___   ___   _  _    //
//        _  ___ __ ≥╢╣╖,   _``╙ ╙¼''╚╬╬╙╬▓╬▀╬▓╙╬╬╣    _║▀`'║,▓╣▓╙└   ``▄N╓w▒Θ|,     __ __    //
//        __   __,▒▓╬╝█╬▓φ╗µ ╣▓   ╠Q' ║~ '╙'  ╙╩M╣╣▓▓>  █  █#╙ ╣'  ]▓Qæ╫█║╢█╬█║█▄¥___ ___     //
//         __  __,╝║▓▓▓╣▓▓╢≡╬▒╫┬.≥µ║▓▄╢        _ ╬▌╙▀W▄█▌▄╨   ▐░   ╔▒▄╤╩▐░▓╣╬▓▓╬╬▓▌,  ___     //
//          __ _:╫▓╬╣███╣║╝⌐  ╚╣▒╬▓#╝▓▒ ƒ╗ƒb╓ε _╠╟  _ ▐╣╨    ]╣▄m▀▓▒╙╠▓▓▓╠╙▌╣██╬█╣╬╝   _ _    //
//           _ _ ╠╣╣▓╬▓▓╬▓▓²__ ╠╩╚╬╙''╚φ╫╩╝█M _ ╚▓≥   █▒_ _»▓╣▀.  ║█▒╠╩╚╩▄╣▓▒╣╬╬▓▓╨¼_ _       //
//         __ __ _└└╙╝└╜``  _____'     `╣▓▓╬░   _╫█▒▄█▓_ ╓▒╝╙    ╔╝^└└╙"▀╣╣╬██╣╬██▄░ ____     //
//        _ __  _    __ _  _  _         '^╙╙▓▓╤, ╞╬▒╣▓▒█▓▀.  ╓╦▓╙'      ╙╠╜╧╩▌▓╣▓▓ε ____ _    //
//        _ _ ___ _     _                  _ ╙╬▒φ╠╬╬╫▒╠╬▒╢█╩╝╨.              _╙_^__  _   _    //
//          ______   _ _                      ╟╬░░╬▒╬╫▀╙   _   __            ______ _ ____    //
//        _ ___ _ _  _____                  _  ╫▓▒░╚╢ _  ___ _  _        __   _____ _    _    //
//         ___  _____  __               _ ___   ▓╬╣▒╠╕ __   __ _          _ _________  ___    //
//          _ __ ___  _ _               ____ __,╣▒▓╣▓║  _ _   _             _____ ______ _    //
//         __  _   _  _ _               ___ __Θ▒║▒█▓╬¬__    _              _  _______ _  _    //
//        ____  __              │          _,╣╬▒╬▓█╣▌__                     _ _____ ___  _    //
//        ___ _  ____ _         '       _  φ▓▓██▒╝╠▒░½___ _         _           _________     //
//         __ _______ _                   @╣███▒░▄╬╩▓╬_          _           ____ ______      //
//        _   _     ___                  ╓╣▓█╠▒▒▒▓▓▒░╣ _      _ _      _      __ __ ___ __    //
//        __ ___  __    __      '   ,▄▓╠║▓█╙≤║╬╝▒╣▓╬▒▒╬▒¼≤ç  _  _ _          __    ___ ___    //
//        ____ __ _  __           ╓▓╬█╓╫╬░░░▒╣╬▒░╠╚╬╣▓▓╣╬╗▒╙▒_   ___ __       _ _   _ __ _    //
//        __   _ __ ___  __     ╓▓╬φ▓╬╠╩▒φ▒▒▓▓╬╬╬▓▒╠██████▓▓╠▓╫█▄▄,_    _   __  _  _ __       //
//        _  _____,µ▄╗▓██▓╣▓╬╣╣██▓███╬▒▓██▓▓▓███▓███▓╬██╣╣▓╬╣▓███╬╬╬╬╬██╗▄,         __ ___    //
//        _ ⁿ≈Θ▀╚╚╩╬╩╬╠╬╬╠╠║╬║▓╬╬▓╬╬╣╬▓█╬▓▓█████▓█╬╣▓█╣██▓▓▒╠╣╬╬╬╣█▓▒╠░╩╬╠╚╚╚▒≈≥,      __     //
//        _ __ _ ░░░░φ░░φδ╬╬╬╩╠▒╬╬╫╬╬╣╣╬╬╬╠╣▓▓██▓█╣╠╬╬╬╬╣███▓▒╠╣╬▒╚╬╢╬▒φ▒⌐            __      //
//         _     !ⁿ"'""╙╚╚╚╙░╬╠╬╠╬╬╬╣╬╢╬╣╣╬╬╬╣█╬║▒╬╠╬╬╬╠╬╣╬╬╬╠╚▒╬╬╠▒░░▒╙╚Ü≥,        _ __      //
//        ____  _   '' .  ;╙╚"╙░╙╚╠╠╬╬╬▒░╬░░╠╠╬▒▒░▒░░░▒░╠╬╬╠╬▒░░'░`╙╙=            _ _ ____    //
//           __ _   _   ~         "╠░░╙░░╙░╚░╣╠╬╠░░░░▒░░Γ░∩╙╙░φ        _     _  __ ____ _     //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract ASHREA is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
