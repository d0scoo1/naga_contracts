
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Benma Rosal
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                           //
//                                                                                                                                           //
//                                                                                                                                           //
//                                                                                                                                           //
//     _______       .-''-.  ,---.   .--.,---.    ,---.   ____            .-------.        ,-----.       .-'''-.    ____      .---.          //
//    \  ____  \   .'_ _   \ |    \  |  ||    \  /    | .'  __ `.         |  _ _   \     .'  .-,  '.    / _     \ .'  __ `.   | ,_|          //
//    | |    \ |  / ( ` )   '|  ,  \ |  ||  ,  \/  ,  |/   '  \  \        | ( ' )  |    / ,-.|  \ _ \  (`' )/`--'/   '  \  \,-./  )          //
//    | |____/ / . (_ o _)  ||  |\_ \|  ||  |\_   /|  ||___|  /  |        |(_ o _) /   ;  \  '_ /  | :(_ o _).   |___|  /  |\  '_ '`)        //
//    |   _ _ '. |  (_,_)___||  _( )_\  ||  _( )_/ |  |   _.-`   |        | (_,_).' __ |  _`,/ \ _/  | (_,_). '.    _.-`   | > (_)  )        //
//    |  ( ' )  \'  \   .---.| (_ o _)  || (_ o _) |  |.'   _    |        |  |\ \  |  |: (  '\_/ \   ;.---.  \  :.'   _    |(  .  .-'        //
//    | (_{;}_) | \  `-'    /|  (_,_)\  ||  (_,_)  |  ||  _( )_  |        |  | \ `'   / \ `"/  \  ) / \    `-'  ||  _( )_  | `-'`-'|___      //
//    |  (_,_)  /  \       / |  |    |  ||  |      |  |\ (_ o _) /        |  |  \    /   '. \_/``".'   \       / \ (_ o _) /  |        \     //
//    /_______.'    `'-..-'  '--'    '--''--'      '--' '.(_,_).'         ''-'   `'-'      '-----'      `-...-'   '.(_,_).'   `--------`     //
//                                                                                                                                           //
//                                                                                                                                           //
//                                                                                                                                           //
//                                                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BMR is ERC721Creator {
    constructor() ERC721Creator("Benma Rosal", "BMR") {}
}
