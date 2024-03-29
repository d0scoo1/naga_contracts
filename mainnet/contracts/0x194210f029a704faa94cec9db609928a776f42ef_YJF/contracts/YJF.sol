
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: YJF
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                                                  //
//                                                                                                                                                                                                                                                  //
//                                                                                                                                                                                                                                                  //
//          _____                    _____                    _____                    _____                    _____                    _____            _____                    _____                    _____                _____              //
//         |\    \                  /\    \                  /\    \                  /\    \                  /\    \                  /\    \          /\    \                  /\    \                  /\    \              |\    \             //
//         |:\____\                /::\    \                /::\    \                /::\    \                /::\    \                /::\____\        /::\____\                /::\    \                /::\____\             |:\____\            //
//         |::|   |                \:::\    \              /::::\    \               \:::\    \              /::::\    \              /:::/    /       /:::/    /               /::::\    \              /:::/    /             |::|   |            //
//         |::|   |                 \:::\    \            /::::::\    \               \:::\    \            /::::::\    \            /:::/    /       /:::/    /               /::::::\    \            /:::/    /              |::|   |            //
//         |::|   |                  \:::\    \          /:::/\:::\    \               \:::\    \          /:::/\:::\    \          /:::/    /       /:::/    /               /:::/\:::\    \          /:::/    /               |::|   |            //
//         |::|   |                   \:::\    \        /:::/__\:::\    \               \:::\    \        /:::/__\:::\    \        /:::/    /       /:::/    /               /:::/  \:::\    \        /:::/____/                |::|   |            //
//         |::|   |                   /::::\    \      /::::\   \:::\    \              /::::\    \       \:::\   \:::\    \      /:::/    /       /:::/    /               /:::/    \:::\    \      /::::\    \                |::|   |            //
//         |::|___|______    _____   /::::::\    \    /::::::\   \:::\    \    ____    /::::::\    \    ___\:::\   \:::\    \    /:::/    /       /:::/    /      _____    /:::/    / \:::\    \    /::::::\____\________       |::|___|______      //
//         /::::::::\    \  /\    \ /:::/\:::\    \  /:::/\:::\   \:::\    \  /\   \  /:::/\:::\    \  /\   \:::\   \:::\    \  /:::/    /       /:::/____/      /\    \  /:::/    /   \:::\    \  /:::/\:::::::::::\    \      /::::::::\    \     //
//        /::::::::::\____\/::\    /:::/  \:::\____\/:::/  \:::\   \:::\____\/::\   \/:::/  \:::\____\/::\   \:::\   \:::\____\/:::/____/       |:::|    /      /::\____\/:::/____/     \:::\____\/:::/  |:::::::::::\____\    /::::::::::\____\    //
//       /:::/~~~~/~~      \:::\  /:::/    \::/    /\::/    \:::\   \::/    /\:::\  /:::/    \::/    /\:::\   \:::\   \::/    /\:::\    \       |:::|____\     /:::/    /\:::\    \      \::/    /\::/   |::|~~~|~~~~~        /:::/~~~~/~~          //
//      /:::/    /          \:::\/:::/    / \/____/  \/____/ \:::\   \/____/  \:::\/:::/    / \/____/  \:::\   \:::\   \/____/  \:::\    \       \:::\    \   /:::/    /  \:::\    \      \/____/  \/____|::|   |            /:::/    /             //
//     /:::/    /            \::::::/    /                    \:::\    \       \::::::/    /            \:::\   \:::\    \       \:::\    \       \:::\    \ /:::/    /    \:::\    \                    |::|   |           /:::/    /              //
//    /:::/    /              \::::/    /                      \:::\____\       \::::/____/              \:::\   \:::\____\       \:::\    \       \:::\    /:::/    /      \:::\    \                   |::|   |          /:::/    /               //
//    \::/    /                \::/    /                        \::/    /        \:::\    \               \:::\  /:::/    /        \:::\    \       \:::\__/:::/    /        \:::\    \                  |::|   |          \::/    /                //
//     \/____/                  \/____/                          \/____/          \:::\    \               \:::\/:::/    /          \:::\    \       \::::::::/    /          \:::\    \                 |::|   |           \/____/                 //
//                                                                                 \:::\    \               \::::::/    /            \:::\    \       \::::::/    /            \:::\    \                |::|   |                                   //
//                                                                                  \:::\____\               \::::/    /              \:::\____\       \::::/    /              \:::\____\               \::|   |                                   //
//                                                                                   \::/    /                \::/    /                \::/    /        \::/____/                \::/    /                \:|   |                                   //
//                                                                                    \/____/                  \/____/                  \/____/          ~~                       \/____/                  \|___|                                   //
//                                                                                                                                                                                                                                                  //
//                                                                                                                                                                                                                                                  //
//                                                                                                                                                                                                                                                  //
//                                                                                                                                                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract YJF is ERC721Creator {
    constructor() ERC721Creator("YJF", "YJF") {}
}
