
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Dream_Savers_Mirror.zip
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ███████┘┘┘┘┘┘│┘╫█████┘┘┘┘┘┘┘┘┘┘████┘┘┘┘┘┘┘┘┘┘┘┘█████╛┘┘┘┘▓█████┘┘┘█████▌┘┘j█████    //
//        ███████   ▓███▄µ ▀███   █████▌   ██   ████████████▀ ▄▄██▄µ ███▌    .█▌    ^█████    //
//        ███████   ▓████▌   ██   ╨▀▀▀▀▀ ▄▄██   ▀▀▀▀▀██████   █████▌  .█▌   ▄▄ ]▄µ  ^█████    //
//        ███████   ▓████▌   ██   ▓█   ▐█████   ▓██████████   ╨╨╨╨╨─  .█▌   █████▒  ^█████    //
//        ███████   ▓███' ,▓███   ████,,'████   ███████████   █████▌  .█▌   █████▒  ^█████    //
//        ███████▄▄▄▄▄▄▄▄▓█████▄▄▄██████▄▄▄██▄▄▄▄▄▄▄▄▄▄▄▄██▄▄▄█████▌▄▄▄██▄▄▄█████▌▄▄▄█████    //
//        ███████████████████████▀▀▀▀▀▀▀▀███████▀▀▀▀▀██████▀▀▀██████▀▀▀██▀▀▀▀▀▀▀▀▀▀▀▀█████    //
//        █████████████████████╨┘ ▓████▌ ╙╨███▌╨  █▓ ┘╨████   █████▌  .█▌   ▓█████████████    //
//        █████████████████████,, ▓██████████   █████▌   ██   █████▌  .█▌   ██████████████    //
//        ███████████████████████▄▄▄▄▄▄▄ ▀▀██   ▀▀▀▀▀▀   ██▄µ ▀▀██▀Γ ▄▄█▌   ▄▄▄▄▄█████████    //
//        █████████████████████▀▀▀█████▌   ██   ▄▓▓▓▓▄   ████▓⌐ ▀▀ ▄▓███▌   ██████████████    //
//        ███████╙╙╙╙╙╙╙╙╙╙╙╙███▌ ┘╙╙╙╙└ ▓███   █████▌   ███████ ▐██████▌   ╙╙╙╙╙╙╙╙╨█████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ███████   ▄▄▄▄▄▄ ▀▀██▀▀ ▄▄▄▄▄▄ ▀▀████████████████   ▀▀██▀Γ  .██▄▄▄~    ╓▄▄▄█████    //
//        ███████   ▓████▌   ██   ██████▓▓▓████████████████     ▀└    .█████⌐    ▓████████    //
//        ███████   └┘┘┘┘└'▓████▌'└┘┘┘┘┘┘██████████████████   ██'▐█▒  .█████⌐    ▓████████    //
//        ███████   ▓█▄Q ▐█████████████▌ ' ████████████████   █████▌  .█████⌐    ▓████████    //
//        ███████   ▓███▄▄ ▀▀██▄▄ ▀▀▀▀▀▀ ▄▄██▀▀▀▀▀▀▀▀▀▀▀▀██   █████▌  .██▀▀▀¬    ╨▀▀▀█████    //
//        ███████▓▓▓██████▓▓▓████▓▓▓▓▓▓▓▓████▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓██████▓▓▓██▓▓▓▓▓▓▓▓▓▓▓▓█████    //
//        ███████┘┘┘┘┘┘┘┘┘┘████┘┘┘┘┘┘┘┘┘┘█████▌┘┘┘┘┘┘┘┘████┘┘┘┘┘┘┘┘┘┘█████████████████████    //
//        ███████   ▓████▌   ██   █████▌   ██   █████▌   ██   █████▌  .███████████████████    //
//        ███████   ╨▀▀▀▀▀ ▄▄██   ╨▀▀▀▀▀ ▄▄██   █████▌   ██   ▀▀▀▀▀Γ ▄▄███████████████████    //
//        ███████   Φ█~  ▐█████   ▓█   ▐█████   █████▌   ██   ▓█   ╫██████████████████████    //
//        ███████   ▓███,,'████   ████,,'████,  █████▌ ,,██   ███▌,,'███████┘''▐██████████    //
//        ███████▄▄▄██████▄▄▄██▄▄▄██████▄▄▄████▄▄▄▄▄▄▄▄████▄▄▄█████▌▄▄▄█████▄▄▄╣██████████    //
//        █████████████████████▀▀▀▀▀▀▀▀▀▀▀▀██▀▀▀▀▀▀▀▀▀▀▀▀██▀▀▀▀▀▀▀▀▀▀█████████████████████    //
//        ███████████████████████████▓     █████⌐    ▐█████   ▓████▒ ╙╨███████████████████    //
//        ██████████████████████████   ,,███████⌐    ╫█████   █████▌ ,,███████████████████    //
//        ███████████████████████▀Ö  .▄▓████████⌐    ╫█████   ▄▄▄▄▄▄▄█████████████████████    //
//        █████████████████████▀╨  '▓▓██████████⌐    ╫█████   ████████████████████████████    //
//        █████████████████████'''' ╙╙╙╙╙╙╙██╙╙╙ ''''└╙╙╙██'''████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract DSM is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
