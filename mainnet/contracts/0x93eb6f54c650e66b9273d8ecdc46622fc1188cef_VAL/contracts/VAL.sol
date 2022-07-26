
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: VALDUDES
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//       :::     :::     :::     :::        :::::::::  :::    ::: :::::::::  :::::::::: ::::::::    //
//      :+:     :+:   :+: :+:   :+:        :+:    :+: :+:    :+: :+:    :+: :+:       :+:    :+:    //
//     +:+     +:+  +:+   +:+  +:+        +:+    +:+ +:+    +:+ +:+    +:+ +:+       +:+            //
//    +#+     +:+ +#++:++#++: +#+        +#+    +:+ +#+    +:+ +#+    +:+ +#++:++#  +#++:++#++      //
//    +#+   +#+  +#+     +#+ +#+        +#+    +#+ +#+    +#+ +#+    +#+ +#+              +#+       //
//    #+#+#+#   #+#     #+# #+#        #+#    #+# #+#    #+# #+#    #+# #+#       #+#    #+#        //
//     ###     ###     ### ########## #########   ########  #########  ########## ########          //
//                                                                                                  //
//                                                                                                  //
//     .420/247.420/247.666              .420/247.420/247.666                                       //
//      ~B@@@@@@@@@@@@@@@&?             ^B@@@@@@@@@@@@@@@@@@G^                                      //
//        J@@@@@@@@@@@@@@@@G^          J@@@@@@@@@@@@@@@@@@@@@&?                                     //
//         ^B@@@@@@@@@@@@@@@&?       ^G@@@@@@@@@@@@@@@@@@@@@@@@G^                                   //
//           J@@@@@@@@@@@@@@@@G:    J@@@@@@@@@@@@@@@@@@@@@@@@@@@&?                                  //
//            ~B@@@@@@@@@@@@@@@&? ^G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G^                                //
//              J@@@@@@@@@@@@@@@@G&@@@@@@@@@@@@@@@GP@@@@@@@@@@@@@@@&?                               //
//               ~B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@J  ?&@@@@@@@@@@@@@@@G^                             //
//                .Y@@@@@@@@@@@@@@@@@@@@@@@@@@@G^    ^G@@@@@@@@@@@@@@@&?                            //
//                  ~B@@@@@@@VALDUDES@@@@@@@@@J        ?&@@@@@@@@@@@@@@@G^                          //
//                   .Y@@@@@@@@@@@@@@@@@@@@@B^          ^G@@@@@@@@@@@@@@@&?                         //
//                     ~B@@@@@@@@@@@@@@@@@@J              ?&@@@@@@@@@@@@@@@G^                       //
//                      .Y@@@@@@@@@@@@@@@B^                ^G@@@@@@@@@@@@@@@&GGGGGGGP!              //
//                        ~#@@@@@@@@@@@@J         ::         ?&@@@@@@@@@@@@@@@@@@@@@@@5.            //
//                         .Y@@@@@@@@@B~         7&&7         ^G@@@@@@@@@@@@@@@@@@@@@@@#!           //
//                           !#@@@@@@J         :P@@@@P:         J@@@@@@@@@@@@@@@@@@@@@@@@5.         //
//                            .5@@@B~         7&@@@@@@&7         ^G@@@@@@@@@@@@@@@@@@@@@@@#!        //
//                              !#Y.        :5@@&&&&&&@@5:         J&&&&&&&&&&&&&&&&&&&&&&@@Y.      //
//                                          .^::::::::::^.          ::::::::::::::::::::::::^.      //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract VAL is ERC721Creator {
    constructor() ERC721Creator("VALDUDES", "VAL") {}
}
