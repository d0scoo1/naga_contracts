
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: I walk alone
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        │''▓▓▓▓▓▓▓▓▓▓▓▓▓▒            ║▓▓▓▓▓▓▓▓▓▓▓╬▌            :▓▓▓▓▓▓▓▓▓▓▓▓▓⌐              //
//        ┐. ╙▓▓▓▓▓▓▓▓▓▓▓▓▓             ▓▓▓▓▓▓▓▓▓▓▓▓▌         ,▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓               //
//        ''' ╟▓▓▓▓▓▓▓▓▓▓▓▓▒            ╣▓▓▓▓▓▓▓▓▓▓▓▓       ,▓▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓               //
//        '  '^▓▓▓▓▓▓▓▓▓▓▓▓▓         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     ,▓███████▓▓▓▓▓▓▓▓▓▓▓▓               //
//        '    ║▓▓▓▓▓▓▓▓▓▓▓▓µ        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓⌐   ▄████████▓▓▓▓▓▓▓▓▓▓▓▓▌               //
//        ''    ▓▓▓▓▓▓▓▓▓▓▓▓▓        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒  ▓█████████╣▓▓▓▓▓▓▓▓▓▓▓▌          ]    //
//              ╙▓▓▓▓▓▓▓▓▓▓▓▓⌐       ▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▌,▓█████████─▓▓▓▓▓▓▓▓▓▓▓▓▌          φ    //
//               ╟▓▓▓▓▓▓▓▓▓▓▓▌       ╟▓▓▓███████▓▓▓▓▓▓██████████⌐ ▓▓▓▓▓▓▓▓▓▓▓▓▒          ░    //
//        '       ▓▓▓▓▓▓▓▓▓▓▓▓        ╚█████████▓▓▓▓▓█████████▀   ▓▓▓▓▓▓▓▓▓▓▓▓░          ░    //
//                ╚▓▓▓▓▓▓▓▓▓▓▓▌        └▀███████▓▓▓▓▓███████▀─    ▓▓▓▓▓▓▓▓▓▓▓▓░         ;░    //
//                 ▓▓▓▓▓▓▓▓▓▓▓▓           ╙█████▓▓▓▓▓█████▀─      ╣▓▓▓▓▓▓▓▓▓▓▓          ░░    //
//          '  '   ╙▓▓▓▓▓▓▓▓▓▓▓▌           ▓╬╬╬▓╣╬▓█╣╣╬▓█▄        ╣▓▓▓▓▓▓▓▓▓▓▓          ░░    //
//        ''        ╟▓▓▓▓▓▓▓▓▓▓▓         ,φ╬╣╬▓╬╬▒╣╬╬╠╠╢╬╬▓░      ▓▓▓▓▓▓▓▓▓▓▓▓         ,░░    //
//        ~          ▓▓▓▓▓▓▓▓▓▓▓µ       φ╬╬╬▓▓╬╬╬╬╬╬╣╬╣╬╣╬▓▓▒     ▓▓▓▓▓▓▓▓▓▓▓▌         ░░░    //
//        ▓          ╚▓▓▓▓▓▓▓▓▓▓▓      φ╬╬╬╣▓▓╣▓▓╬╬╬╣▓█▓▓▓█▓╬░    ▓▓▓▓▓▓▓▓▓▓▓▌         ░░░    //
//        ▓▌          ╫▓▓▓▓▓▓▓▓▓▓µ  .ε"║▓╣▓██████╬╬▓███████╬╬▒ⁿ   ╫▓▓▓▓▓▓▓▓▓▓▒        ;░░░    //
//        ▓▓Q         "▓▓▓▓▓▓▓▓▓▓▓    «╠╣██╠█████╬▒╫█████████╬▒è  ╫▓▓▓▓▓▓▓▓▓▓▒        ░░░░    //
//        ▓▓▓⌐         ╟▓▓▓▓▓▓▓▓▓▓µ   »╣▓█▒╬╬╬╬╬╬╠║╣▓▓▓▓▓▓██▓▓▒ΓU ╫▓▓▓▓▓▓▓▓▓▓▒        │¡░░    //
//        ▓▓▓▓          ▓▓▓▓▓▓▓▓▓▓▓  ┴╫╣╬█╬╠╠╬╠▒╠╬╣▓╬▒╠╬╬╬██▓╬░.  ╫▓▓▓▓▓▓▓▓▓▓░        '░░░    //
//        ▓▓▓▓▌         ╙▓▓▓▓▓▓██▓▓⌐.:╣╣▓█▓▒╠╬╬╬╣╣▓▓▓▓╣▓▓▓█▓▓╬▒   ╟▓▓▓▓▓▓▓▓▓▓'       ░¡¡░░    //
//        ▓▓▓▓▓▒'        ╟▓▓▓▓▓▓▓▓▓▌^╠╩╣╣██▒╬╟▓╬╣╬╬╣▓▓▓▓▓██▓╬▒╠╕░ ╫▓▓▓▓▓▓▓▓▓▓        '││░░    //
//        ▓▓▓▓▓▓⌐         ▓▓▓▓▓▓▓▓▓╬═╚/╣╬▓██╬╬╬╬╬╣╬╣╬╬╣▓▓██╣╣▌µ"  ╟▓▓▓▓▓▓▓▓▓▌       '''│││    //
//        ▓▓▓▓▓▓▓ .'      ╙▓▓▓▓▓▓▓▓▓▌╠╠╣▓▓▓▓█▓▓▓▓▓▓▓▓▓▓███▓╬╣▓╬░  ╟▓▓▓▓▓▓▓▓▓▌       ;.│░░░    //
//        ▓▓▓▓▓▓▓▌     ,╓ε≥╨╙╚╚╩╬▀▀╙└   ╚│Γ╜░╓ε         `╙╬╙░░"½`»╙╬╬╬╩╚╚▀▓▓▌       '│││░░    //
//        ▓▓▓▓▓▓▓▓▒ ╓φ╚╚╚╙░░░░▒⌐                           ``²"╙ª';└╩░░░░░░╚▒      .┌││¡░░    //
//        ▓▓▓▓▓▓▓▓▒░░░░░░░░░φ╩        ,    ,                      ''\╠▒▒░░░░░▒╓    "'│.│░░    //
//        ╚▓▓▓╬╬╠╬╠╬░φ╬╬▒¼░▒..        ╙▓ç╓▓╙             ╚▓  ╓▄⌐ ...¡│╚░░░░░░░▒╠   ..¡.'░░    //
//        ╓╬╬╬╠╠╬╬╬╬▒░╚░╚▒╩░░░░░░░   "╢╣M╫╬             ]#╬╩å╬╙'¡░░░░░░░░░░░░░░▒╠ε │¡░░░░░    //
//        ▒▒░░│╙╙╩╝╩░╠▒╬╠╬▐░░░░░│'    .▒.▒┘"╠╬            ╝╩╩╫`''░░░░░░░╠▒░░░░░░░▒φ░░░░░░░    //
//        ╠╬╬╬▒░φ░▒▒▒▒╠╬▓▒╫░░░░░'      ╠Å╚┘└└             7Q╝┘%Qε!░░░░░░▒╬▒░░░░░Γ░╚╠╦░░░░░    //
//        ╣╣╬╬╣▒╣╫╬╬╬╬╬▓█▀▓░╠░''                           ""Φ7╩Γ '░░░░▒╬▓╬▒░░░░░░░░▒╠▒░░░    //
//        ╣╣╣╬╬╬╠▓▓╣╬╠╬╬╬▓╩╟╛'          .▄⌐                       ''!░░▐▌▓╬╬▒░░░░░░░░░▒╠▒░    //
//        ▓▓╣╬╣╣▓╬╬╙,▄▓▓)╠░         ╙▀M#╬=                ╙╗  µ,     '░░╣▓▓╬╠▒░░░░░░░░░░░╠    //
//        ╣▓▓▓▓╬╩╙▄▓▓▓▓¬└'         ║╨╙╬m╚≈Q@              ╙╝╬▒╬▄     ''░╚╣╟╬╠▒▒░░░░░░░░░░░    //
//        ╬▓▓╬╩";║▓▓▓▓.ε          -╩Ö*Θ^'└╙└                `.╘▄N     ''!╚▓╠╬▒▒░░░░░░░░░▒░    //
//        ╬╣╬⌐;░░░╟▓▓╓│''                                     ╙╙¬≥╦║▒   '!╙▒╙╠▒░░░░░░░░▒╠▒    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract ALONE is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
