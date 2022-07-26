
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Visual infinite, Vincent.
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
//                                                                                                                  //
//     _          _        _         _        _                  _                   _                              //
//    /\ \    _ / /\      /\ \      / /\     /\_\               / /\                _\ \                            //
//    \ \ \  /_/ / /      \ \ \    / /  \   / / /         _    / /  \              /\__ \                           //
//     \ \ \ \___\/       /\ \_\  / / /\ \__\ \ \__      /\_\ / / /\ \            / /_ \_\                          //
//     / / /  \ \ \      / /\/_/ / / /\ \___\\ \___\    / / // / /\ \ \          / / /\/_/                          //
//     \ \ \   \_\ \    / / /    \ \ \ \/___/ \__  /   / / // / /  \ \ \        / / /                               //
//      \ \ \  / / /   / / /      \ \ \       / / /   / / // / /___/ /\ \      / / /                                //
//       \ \ \/ / /   / / /   _    \ \ \     / / /   / / // / /_____/ /\ \    / / / ____                            //
//        \ \ \/ /___/ / /__ /_/\__/ / /    / / /___/ / // /_________/\ \ \  / /_/_/ ___/\                          //
//         \ \  //\__\/_/___\\ \/___/ /    / / /____\/ // / /_       __\ \_\/_______/\__\/                          //
//          \_\/ \/_________/ \_____\/     \/_________/ \_\___\     /____/_/\_______\/                              //
//                     _          _             _        _          _              _        _            _          //
//                    /\ \       /\ \     _    /\ \     /\ \       /\ \     _     /\ \     /\ \         /\ \        //
//                    \ \ \     /  \ \   /\_\ /  \ \    \ \ \     /  \ \   /\_\   \ \ \    \_\ \       /  \ \       //
//                    /\ \_\   / /\ \ \_/ / // /\ \ \   /\ \_\   / /\ \ \_/ / /   /\ \_\   /\__ \     / /\ \ \      //
//                   / /\/_/  / / /\ \___/ // / /\ \_\ / /\/_/  / / /\ \___/ /   / /\/_/  / /_ \ \   / / /\ \_\     //
//                  / / /    / / /  \/____// /_/_ \/_// / /    / / /  \/____/   / / /    / / /\ \ \ / /_/_ \/_/     //
//                 / / /    / / /    / / // /____/\  / / /    / / /    / / /   / / /    / / /  \/_// /____/\        //
//                / / /    / / /    / / // /\____\/ / / /    / / /    / / /   / / /    / / /      / /\____\/        //
//            ___/ / /__  / / /    / / // / /   ___/ / /__  / / /    / / /___/ / /__  / / /      / / /______        //
//           /\__\/_/___\/ / /    / / // / /   /\__\/_/___\/ / /    / / //\__\/_/___\/_/ /      / / /_______\       //
//           \/_________/\/_/     \/_/ \/_/    \/_________/\/_/     \/_/ \/_________/\_\/       \/__________/       //
//                                                                                                                  //
//                                                                                                                  //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract VISUAL is ERC721Creator {
    constructor() ERC721Creator("Visual infinite, Vincent.", "VISUAL") {}
}
