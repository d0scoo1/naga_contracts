
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: You Punks Get Off My Lawn
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                  .]"└"² "'⌠⌠             .''▐░░░░░░   '                    //
//                     '            j   `│.],┌┐            '   ▐░░░░░░                        //
//                                  ╒    ]¡ ¡÷!               'φ░░░░░░    ,                   //
//                                  ^  `".  . .                ▐░░░░░░   '                    //
//                          ,       ,     . .                  ;░░░░░░                        //
//                      ,                                      )░░░░░░    ⁿ                   //
//                                                             ▐░░░▒░▒⌐              ¬        //
//                                                  ╓▄▄▄▄▓▄▄▄▄ ▐░░░░░░                        //
//                          ¬                      ▀▄▌▀▄╫╫███▓▓╡░░░░░░                        //
//                                                ▓██▀▀╫██╫██╙██▌▒░░░░                        //
//                          ~   '                ▄█▓▓█▓▌▄╨╨╙Φ╫█▓█▒░▒▒▒                        //
//                                             ╓██▓╫▌╠╨:▄▄E▄▄Σ╫██▒▒▒▒▒                 ▄╗╤    //
//                                           ▄██▀╠▓█]▓╙▐██▄╬¬¥╗▌█▌╬╬╠╠   .            ▌       //
//                                         ▄█▀██┐█▐╬▌-╦▓▒▄─╟███▌╬▌╠╠╠╠   .           █        //
//                                     .▄███▓█▓█▓▄▀▓╬▌▄▄█╪ └╥└╟}▓▓╠╠╠╠              █         //
//           ┘                     ╓▄▀█╬███▀└ ▌▐█▄╣█╬▓╬▓██╣█▌▓███▒╠╠▒╠             █          //
//         ~,'                  ,▄█▄▓▓██╬▓╗▀╩█ █▌█╚▐╬█┤╙▓╣██╣╣██╬╠╠╠╠╠            █⌐          //
//          ,  .               █████▀┐▓▀╓██▓█╔╟█╪█▓█▓▄╫▓▓▓▌▐│▓█╟▒╠╠╠╠╠   '       ▄▀           //
//         ,"ⁿ`¬            ,Ç████▀█▓▀▄▓▀╩╫█Æ▓▌█████▓S██▀██ ▌ ▓█╨▌╠╠╠╠   '      ╓▌            //
//          ╓U` '         .Å▄█▄▀▄██▄▀│Φy╚▄▀█└▌┬▌▓Γ██▓╙▐▓▀█▀▄██▓███▒▒▒▒   '     ┌▌             //
//        ⁿ       ²      ^▓▓█╠▄██╨▐╫ó╥▄▒█▀▄▌ƒ▌█ ▌╟██╨█╟▄██b╬██╬█▌██▒╠╠   │    ╓▌       ,,     //
//                     -j██▓██▌▌█▓└▄█╝▄█▌█▓ ▓⌐█j ███│█⌐╠██▐╣╟╬▌████▌╠╠   │    └╙╙┘└│pΓ╙▐▀╙    //
//                    ⌠╓████▌▌▌██▄▓╣╬▓█╝█▓█▓█Æ██▄███▄█▄▌█▌┼▌███▌█╟█▌▒▒   │      [ ]░∩░░█      //
//           ;    '   ╞█╬█▓╟█▌▌█▄████▓╫wæΓ¿╓,,,,    └└▀▀█▌█▐█╫╠▌╫██▒▒▒   '       ;]░²░█\.     //
//          ]'b║╚~╗▌,\.██▌╩▐▌██▌█▓█╦: ∩╙┌─╩╙7Γ7TTOT╙╙╙╙┘ ╙██▄██▌█─█▒▒▒─~ +    ~'[~]⌠░█`       //
//          J ▒],▒▌7 │ ██▓Σ▓▌██╝╟▌└ ▄▄▒╓Γ▄╝╩¢▄▄▄▄▄▄╓▄Q,ƒ` `██▓╠███╬▒▒▒   '    »  ¡░╓╨         //
//          ].▄µƒÆ╘'M@'▒╣█▌▌█▌█▓█≤▒░░,  ` , ,`          ┐╙▀█████ ███░▒   '        ▄▀          //
//        ,#╬'ª░ε└ ,░└ ▄:µ▀██▀██▌,  `│ ─└.;╓}h╠╠╚╬▐Ñ╚╠▀▀╨╚╟╟███╪▐▌Æ╙█▒   │      \▐▌           //
//          ⌠║]▌▒╠;Γ╚╟σÜ/T.└██╣╣█∩░£δdª░└└ⁿ/X▄░ⁿ█▄▄▄▒▒)ε╒╡▌▌█▀█╞██▄███▌, '   '  │▌▀```'└"Γ    //
//         ;╗~░⌐╓α▒φ:░ε#]▒Θ░ ╙███░ Θδ╔▒δ#=ΘΓC╚█╝▀█▌░╢█;7 j▓▐▌█▌╟█▄╝██████▄    ⌐']▒```¬└²^"    //
//        ░░╙.`░│∩░Γ░░▒└;░»'=]▌▓██▄,   '/.┌,┌. /,╠╙╙///, ╠▒█╫▀████▄,█▌█▓██▓    '▐▐            //
//        »J░▒▓╩╣▀▀▌▀╙▀╠▀▀▀▀▀▀▀▀▀▀▀! ,  '' ,,- //   ''/  ██╝▀█╗█╪█████████▓█▄▄Åæ╣▀            //
//        │▄▀▀⌐sæ]"L╔¬⌐Θ▌~ ¬ ¬  `. ╚█▄▄▄▄▄▄▄▄▄▄▄,,µÇ/[,╓█▀~                      ▌⌐           //
//        ▀Σ ``^Γ"- └- ⌐"" , ¬ `   -└▀▀▓▄▄▄wæD≡Jæ▄╧╧╝╨╝▀                         ▌▌╓,,▄▄▄╤    //
//         . .  `    ~ ¬ `     .. ~-           '  '                                  └`^└└    //
//        ~- -  . -- ~ -- ~ ¬                                                                 //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract YPGOML is ERC721Creator {
    constructor() ERC721Creator("You Punks Get Off My Lawn", "YPGOML") {}
}
