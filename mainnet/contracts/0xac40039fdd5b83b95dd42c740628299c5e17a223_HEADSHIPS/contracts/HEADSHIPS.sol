
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Spaceheads Spaceships
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                           //
//                                                                                                           //
//                                                                                                           //
//      __________________  _____  _________ ___________ ___ ______________  _____  ________    _________    //
//     /   _____\______   \/  _  \ \_   ___ \\_   _____//   |   \_   _____/ /  _  \ \______ \  /   _____/    //
//     \_____  \ |     ___/  /_\  \/    \  \/ |    __)_/    ~    |    __)_ /  /_\  \ |    |  \ \_____  \     //
//     /        \|    |  /    |    \     \____|        \    Y    |        /    |    \|    `   \/        \    //
//    /_______  /|____|  \____|__  /\______  /_______  /\___|_  /_______  \____|__  /_______  /_______  /    //
//            \/                 \/        \/        \/       \/        \/        \/        \/        \/     //
//      __________________  _____  _________ ___________ _________ ___ ___ ._____________ _________          //
//     /   _____\______   \/  _  \ \_   ___ \\_   _____//   _____//   |   \|   \______   /   _____/          //
//     \_____  \ |     ___/  /_\  \/    \  \/ |    __)_ \_____  \/    ~    |   ||     ___\_____  \           //
//     /        \|    |  /    |    \     \____|        \/        \    Y    |   ||    |   /        \          //
//    /_______  /|____|  \____|__  /\______  /_______  /_______  /\___|_  /|___||____|  /_______  /          //
//            \/                 \/        \/        \/        \/       \/                      \/           //
//    ___.           ________                 .__  __             ________                                   //
//    \_ |__ ___.__. \______ \   ____   _____ |___/  |_ ___.__.  /  _____/                                   //
//     | __ <   |  |  |    |  \ /  _ \ /     \|  \   __<   |  | /   \  ___                                   //
//     | \_\ \___  |  |    `   (  <_> |  Y Y  |  ||  |  \___  | \    \_\  \                                  //
//     |___  / ____| /_______  /\____/|__|_|  |__||__|  / ____|  \______  / /\                               //
//         \/\/              \/             \/          \/              \/  \/                               //
//                                                                                                           //
//                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract HEADSHIPS is ERC721Creator {
    constructor() ERC721Creator("Spaceheads Spaceships", "HEADSHIPS") {}
}
