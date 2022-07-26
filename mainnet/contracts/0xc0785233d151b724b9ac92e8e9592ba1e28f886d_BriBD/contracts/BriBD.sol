
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ItsBriBD
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                           //
//                                                                                           //
//                                                                                           //
//    .-./`) ,---------.   .-'''-.  _______   .-------.   .-./`)  _______    ______          //
//    \ .-.')\          \ / _     \\  ____  \ |  _ _   \  \ .-.')\  ____  \ |    _ `''.      //
//    / `-' \ `--.  ,---'(`' )/`--'| |    \ | | ( ' )  |  / `-' \| |    \ | | _ | ) _  \     //
//     `-'`"`    |   \  (_ o _).   | |____/ / |(_ o _) /   `-'`"`| |____/ / |( ''_'  ) |     //
//     .---.     :_ _:   (_,_). '. |   _ _ '. | (_,_).' __ .---. |   _ _ '. | . (_) `. |     //
//     |   |     (_I_)  .---.  \  :|  ( ' )  \|  |\ \  |  ||   | |  ( ' )  \|(_    ._) '     //
//     |   |    (_(=)_) \    `-'  || (_{;}_) ||  | \ `'   /|   | | (_{;}_) ||  (_.\.' /      //
//     |   |     (_I_)   \       / |  (_,_)  /|  |  \    / |   | |  (_,_)  /|       .'       //
//     '---'     '---'    `-...-'  /_______.' ''-'   `'-'  '---' /_______.' '-----'`         //
//                                                                                           //
//    Thank you for joining me on this hopeful journey of lifetime. :)                       //
//                                                                                           //
//                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////


contract BriBD is ERC721Creator {
    constructor() ERC721Creator("ItsBriBD", "BriBD") {}
}
