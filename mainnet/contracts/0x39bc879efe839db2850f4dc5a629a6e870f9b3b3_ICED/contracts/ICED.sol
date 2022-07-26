
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: GET @ Icedawn
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//        ╬╬╬╬╬╬▒╠╠╠╠╠▒╠╠╠╠╠╠▒▒╠▒▒▒▒▒▒▒╠▒░░░▒▒▒▒╠▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//        ╬╬╬╬╬╬╠╩░░╠╬╬╠╚╚╠╠╠╠╠╠╠▒╩▒╠╠╠╠╬╠╠╠▒╩╚▒░░░░░░░░░░▒░░░░░░░░░░░░░░░░░░░░░░░░░░░Γ"!░    //
//        ╩╚╚╚╩╩╚╚░ΓΓ░╠╩▒╠▒▒╠╩╠╠╠╠╠╠╠╠╠╠╩╚φ╦░░φ░░░░░░░░░░░Γ░░Γ░░░░░░░░░"░░░░Γ"''░'''          //
//        φ░░░░░░,     ^╙╙╙╙ΓΓ╙╙╙╙╙╙╚╙░░░░░╚╚░░░░░░░░░░░░░░░"░░░░░░░░░░░░░░░░[..              //
//        ╚╚╚▒▒▒▒░░░░;.     ''' '''""""""' '""!Γ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   .     ..    //
//        φφφφ▒▒▒▒▒▒▒▒▒φφ░░░░░¡,...,,,,φ░░░φφ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░'.¡;░;░░░░    //
//        ▒▒╚╚╚▒▒▒▒▒▒▒▒▒╚▒▒▒▒▒▒▒░░░░░░░░░░Γ░Γ"░┐'':░░░░░░░░░░░░░░░░▒░░░░░░░░░░░░░░░░φφ▒▒▒╬    //
//        """"└└└Γ╙╙╙╙╙Γ░░░░""╙"░Γ".░░░░░░░░;;░;,,'░░░░░░░░░░░▒▒▒▒╠╠╠╬╣▒▒▒▒▒▒▒▒▒▒╣▓▓▓▓▓▓▓▓    //
//        "`  '. '''=φφ░░░░░░░░-.░\¡░;;░░░' φ╣╣╬╬╬╠▒▒▄▓▒▒▒╬╣╣╬╣╬╬╬╣╬▓▓▓▓▓▓▓▓╬╬╠╬▓▓▓▓▓▓▓▓▓▓    //
//        φ░░░      ,;,,,░░,;\;░.░░░░░░,╓φ▒╬╬╬╬╟╬▒╟▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓█▓▓█▓▓▓╣▓██▓▓▓▓███    //
//        ░░░░░φ░░░░░░░░░╚▒▒▒▒░░░φφ▒╠╬╬╚╠╬╣╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓█▓█▓█▓▓██████████▓█▓█████████    //
//        ░▒░░░░╠▒░▒▒▒▒░╚╠▒╠╠╠▒▒╬╠░░░╓▒╣╣▓▓▓▓▓▓▓▓▓▓█▓▓▓▓██▓▓▓███▓██▓██▓█████▓████▓████████    //
//        ▒φ▒▒▒▒φ▒▒╠╠╠╠╠╠╬╬╬╬╬╬╬╬╠▒▒▒╣╬▓▓▓▓▓▓▓▓▓▓▓███▓▓███▓█▓█████████████▓▓█████▓▓███████    //
//        ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓▓▓▓▓▓▓▓▓▓▓███▓███▓▓▓█▓█▓▓███▓▓█▓█▓███▓██▓█████████████    //
//        ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣▓▓▓▓▓▓▓▓▓▓█████▓▓██▓█▓▓█▓▓▓▓▓█▓███▓█████▓▓██▓▓██████████    //
//        ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╬╣╬╬╣▓▓▓▓▓▓▓▓▓▓▓▓█▓███▓██▓▓▓▓█▓█▓▓██▓█▓▓▓█████▓██▓███████▓████    //
//        ╬╬╬╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╣▓▓▓▓▓▓▓▓▓▓██▓▓▓█████▓███▓▓▓▓▓▓▓▓████▓▓▓█████▓▓██████████████    //
//        ╬╣╬╬╣╬╬╣╬╬╬╣╣╣╬╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓██████▓██▓█▓▓▓▓█▓▓█████▓▓▓████▓▓▓▓██▓██████████    //
//        ╬╬╬╣▓╣▓▓╣╣╣╬╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓█▓█████████▓█▓█▓▓████████▓███▓█▓▓▓█████████████    //
//        ╬╣▓╬╣▓▓╣╬╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓██████████▓▓▓▓████▓██████▓█▓▓▓████████████    //
//        ╣▓▓▓▓╬╬╣▓▓▓▓▓▓▓╬╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓▓▓████▓▓██████▓▓▓███▓█▓█▓▓▓▓▓▓▓▓▓▓▓█████████    //
//        ▓╬╬╬╣▓▓▓▓▓╬╬╬╣╬╣╣▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓████▓▓███████▓▓▓█▓▓█▓█▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓███████    //
//        ╬╣▓▓▓▓▓▓╬╬╣▓▓╬╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████▓███████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓███    //
//        ▓▓▓▓▓▓╬▓╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓███▓▓▓▓╬▓█▓▓██████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███    //
//        ▓▓▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓████████▓▓▓▓▓██████▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓█    //
//        ▓▓▓▓▓▓▓▓▓▓██▓▓█▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓████████▓▓▓▓▓█████▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓▓█    //
//        ▓▓▓▓▓▓▓▓▓███▓███████▓█▓▓▓▓▓██████▓▓▓███▓▓████████▓▓▓▓███████▓█████▓▓█▓▓▓████████    //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract ICED is ERC721Creator {
    constructor() ERC721Creator("GET @ Icedawn", "ICED") {}
}
