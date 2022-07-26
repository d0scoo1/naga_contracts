
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: EDITIONS
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
//              _____                    _____                    _____                _____                  //
//             /\    \                  /\    \                  /\    \              /\    \                 //
//            /::\    \                /::\    \                /::\    \            /::\    \                //
//           /::::\    \              /::::\    \               \:::\    \           \:::\    \               //
//          /::::::\    \            /::::::\    \               \:::\    \           \:::\    \              //
//         /:::/\:::\    \          /:::/\:::\    \               \:::\    \           \:::\    \             //
//        /:::/__\:::\    \        /:::/  \:::\    \               \:::\    \           \:::\    \            //
//       /::::\   \:::\    \      /:::/    \:::\    \              /::::\    \          /::::\    \           //
//      /::::::\   \:::\    \    /:::/    / \:::\    \    ____    /::::::\    \        /::::::\    \          //
//     /:::/\:::\   \:::\    \  /:::/    /   \:::\ ___\  /\   \  /:::/\:::\    \      /:::/\:::\    \         //
//    /:::/__\:::\   \:::\____\/:::/____/     \:::|    |/::\   \/:::/  \:::\____\    /:::/  \:::\____\        //
//    \:::\   \:::\   \::/    /\:::\    \     /:::|____|\:::\  /:::/    \::/    /   /:::/    \::/    /        //
//     \:::\   \:::\   \/____/  \:::\    \   /:::/    /  \:::\/:::/    / \/____/   /:::/    / \/____/         //
//      \:::\   \:::\    \       \:::\    \ /:::/    /    \::::::/    /           /:::/    /                  //
//       \:::\   \:::\____\       \:::\    /:::/    /      \::::/____/           /:::/    /                   //
//        \:::\   \::/    /        \:::\  /:::/    /        \:::\    \           \::/    /                    //
//         \:::\   \/____/          \:::\/:::/    /          \:::\    \           \/____/                     //
//          \:::\    \               \::::::/    /            \:::\    \                                      //
//           \:::\____\               \::::/    /              \:::\____\                                     //
//            \::/    /                \::/____/                \::/    /                                     //
//             \/____/                  ~~                       \/____/                                      //
//                                                                                                            //
//              _____                   _______                   _____                    _____              //
//             /\    \                 /::\    \                 /\    \                  /\    \             //
//            /::\    \               /::::\    \               /::\____\                /::\    \            //
//            \:::\    \             /::::::\    \             /::::|   |               /::::\    \           //
//             \:::\    \           /::::::::\    \           /:::::|   |              /::::::\    \          //
//              \:::\    \         /:::/~~\:::\    \         /::::::|   |             /:::/\:::\    \         //
//               \:::\    \       /:::/    \:::\    \       /:::/|::|   |            /:::/__\:::\    \        //
//               /::::\    \     /:::/    / \:::\    \     /:::/ |::|   |            \:::\   \:::\    \       //
//      ____    /::::::\    \   /:::/____/   \:::\____\   /:::/  |::|   | _____    ___\:::\   \:::\    \      //
//     /\   \  /:::/\:::\    \ |:::|    |     |:::|    | /:::/   |::|   |/\    \  /\   \:::\   \:::\    \     //
//    /::\   \/:::/  \:::\____\|:::|____|     |:::|    |/:: /    |::|   /::\____\/::\   \:::\   \:::\____\    //
//    \:::\  /:::/    \::/    / \:::\    \   /:::/    / \::/    /|::|  /:::/    /\:::\   \:::\   \::/    /    //
//     \:::\/:::/    / \/____/   \:::\    \ /:::/    /   \/____/ |::| /:::/    /  \:::\   \:::\   \/____/     //
//      \::::::/    /             \:::\    /:::/    /            |::|/:::/    /    \:::\   \:::\    \         //
//       \::::/____/               \:::\__/:::/    /             |::::::/    /      \:::\   \:::\____\        //
//        \:::\    \                \::::::::/    /              |:::::/    /        \:::\  /:::/    /        //
//         \:::\    \                \::::::/    /               |::::/    /          \:::\/:::/    /         //
//          \:::\    \                \::::/    /                /:::/    /            \::::::/    /          //
//           \:::\____\                \::/____/                /:::/    /              \::::/    /           //
//            \::/    /                 ~~                      \::/    /                \::/    /            //
//             \/____/                                           \/____/                  \/____/             //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MLTPLY is ERC721Creator {
    constructor() ERC721Creator("EDITIONS", "MLTPLY") {}
}
