
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: waggish frens
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////
//                                             //
//                                             //
//                                             //
//    ╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋┏┓╋╋╋┏━┓               //
//    ╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋┃┃╋╋╋┃┏┛               //
//    ┏┓┏┓┏┳━━┳━━┳━━┳┳━━┫┗━┓┏┛┗┳━┳━━┳━┓┏━━┓    //
//    ┃┗┛┗┛┃┏┓┃┏┓┃┏┓┣┫━━┫┏┓┃┗┓┏┫┏┫┃━┫┏┓┫━━┫    //
//    ┗┓┏┓┏┫┏┓┃┗┛┃┗┛┃┣━━┃┃┃┃╋┃┃┃┃┃┃━┫┃┃┣━━┃    //
//    ╋┗┛┗┛┗┛┗┻━┓┣━┓┣┻━━┻┛┗┛╋┗┛┗┛┗━━┻┛┗┻━━┛    //
//    ╋╋╋╋╋╋╋╋┏━┛┣━┛┃                          //
//    ╋╋╋╋╋╋╋╋┗━━┻━━┛                          //
//                                             //
//                                             //
/////////////////////////////////////////////////


contract WF is ERC721Creator {
    constructor() ERC721Creator("waggish frens", "WF") {}
}
