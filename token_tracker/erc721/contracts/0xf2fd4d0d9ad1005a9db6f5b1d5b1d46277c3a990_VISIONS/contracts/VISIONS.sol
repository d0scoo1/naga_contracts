
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Visions by Nathan Spotts
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//                                                                                       //
//                                                                                       //
//    :::     ::: ::::::::::: :::::::: ::::::::::: ::::::::  ::::    :::  ::::::::       //
//    :+:     :+:     :+:    :+:    :+:    :+:    :+:    :+: :+:+:   :+: :+:    :+:      //
//    +:+     +:+     +:+    +:+           +:+    +:+    +:+ :+:+:+  +:+ +:+             //
//    +#+     +:+     +#+    +#++:++#++    +#+    +#+    +:+ +#+ +:+ +#+ +#++:++#++      //
//     +#+   +#+      +#+           +#+    +#+    +#+    +#+ +#+  +#+#+#        +#+      //
//      #+#+#+#       #+#    #+#    #+#    #+#    #+#    #+# #+#   #+#+# #+#    #+#      //
//        ###     ########### ######## ########### ########  ###    ####  ########       //
//                                                                                       //
//    ______________________________________________________________________________/    //
//                                                                                       //
//    .                                                                                  //
//    .                                                                                  //
//                                                                                       //
//    By Nathan Spotts                                                                   //
//                                                                                       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


contract VISIONS is ERC721Creator {
    constructor() ERC721Creator("Visions by Nathan Spotts", "VISIONS") {}
}
