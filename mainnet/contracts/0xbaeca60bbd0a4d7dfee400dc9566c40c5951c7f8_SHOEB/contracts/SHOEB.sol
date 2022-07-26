
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: SHOEB
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                     //
//                                                                                                                                     //
//              _____                    _____                   _______                   _____                    _____              //
//             /\    \                  /\    \                 /::\    \                 /\    \                  /\    \             //
//            /::\    \                /::\____\               /::::\    \               /::\    \                /::\    \            //
//           /::::\    \              /:::/    /              /::::::\    \             /::::\    \              /::::\    \           //
//          /::::::\    \            /:::/    /              /::::::::\    \           /::::::\    \            /::::::\    \          //
//         /:::/\:::\    \          /:::/    /              /:::/~~\:::\    \         /:::/\:::\    \          /:::/\:::\    \         //
//        /:::/__\:::\    \        /:::/____/              /:::/    \:::\    \       /:::/__\:::\    \        /:::/__\:::\    \        //
//        \:::\   \:::\    \      /::::\    \             /:::/    / \:::\    \     /::::\   \:::\    \      /::::\   \:::\    \       //
//      ___\:::\   \:::\    \    /::::::\    \   _____   /:::/____/   \:::\____\   /::::::\   \:::\    \    /::::::\   \:::\    \      //
//     /\   \:::\   \:::\    \  /:::/\:::\    \ /\    \ |:::|    |     |:::|    | /:::/\:::\   \:::\    \  /:::/\:::\   \:::\ ___\     //
//    /::\   \:::\   \:::\____\/:::/  \:::\    /::\____\|:::|____|     |:::|    |/:::/__\:::\   \:::\____\/:::/__\:::\   \:::|    |    //
//    \:::\   \:::\   \::/    /\::/    \:::\  /:::/    / \:::\    \   /:::/    / \:::\   \:::\   \::/    /\:::\   \:::\  /:::|____|    //
//     \:::\   \:::\   \/____/  \/____/ \:::\/:::/    /   \:::\    \ /:::/    /   \:::\   \:::\   \/____/  \:::\   \:::\/:::/    /     //
//      \:::\   \:::\    \               \::::::/    /     \:::\    /:::/    /     \:::\   \:::\    \       \:::\   \::::::/    /      //
//       \:::\   \:::\____\               \::::/    /       \:::\__/:::/    /       \:::\   \:::\____\       \:::\   \::::/    /       //
//        \:::\  /:::/    /               /:::/    /         \::::::::/    /         \:::\   \::/    /        \:::\  /:::/    /        //
//         \:::\/:::/    /               /:::/    /           \::::::/    /           \:::\   \/____/          \:::\/:::/    /         //
//          \::::::/    /               /:::/    /             \::::/    /             \:::\    \               \::::::/    /          //
//           \::::/    /               /:::/    /               \::/____/               \:::\____\               \::::/    /           //
//            \::/    /                \::/    /                 ~~                      \::/    /                \::/____/            //
//             \/____/                  \/____/                                           \/____/                  ~~                  //
//                                                                                                                                     //
//                                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SHOEB is ERC721Creator {
    constructor() ERC721Creator("SHOEB", "SHOEB") {}
}
