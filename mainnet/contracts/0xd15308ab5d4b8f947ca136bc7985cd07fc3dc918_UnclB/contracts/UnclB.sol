
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: UncleBitcoin
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//        $R$R$M$R$@[@$@[Q[g[Q[Q[J[@$g[Q[&[j[J[j[J[j[j[JLj[g[j[&[g[g[j[j[J[j[J[J[J[J[J[J[J    //
//        $@$@$@[@#@[@[@$@$@$@$@$@[Q[J$@[J[@$J[g[@[j[Q[@[][@#@[@[g[Q$j$1$@$@$@[J[Q[J[J[j[J    //
//        $Q$@$@$@$@$g$@@@$@$@[Q[g$Q$R$@$@#N[@@@$R[Q[Q$@$@$W[J$@[@$Q$Q$N$&$@$@$@[Q[J[J[J[J    //
//        $@$g$@$@@Q$@$&$&$R$R$@[g$&$@$R$@$@$@[g[@[1$@[g[&$W$R$R$B$R$R$N$R$Q$@[g[@[J[J[J[J    //
//        $@$@$@$@$@$@$R$R[@$&$@$@$@$@$R$@$@$@$Q[g[Q[Q[1$&$R$R$@$Q[Q$@$@[&$&$@$N[j[J[J[J[J    //
//        $@$@$@$@$@$@$@$@$&$@$@$@$Q$@[M[J[&$@$@[Q[g[Q$@$@$@$@$@$g[@$@$$$Q$R%M[J[j[J[J[J[J    //
//        $@$@@@$@$@$@$@$@$@@@$@$g$@[QL `-{j[@$@[Q[Q$@$@@@@@$@$@$g@@$@$@$M[J[J[W[j[j[J[j[Q    //
//        @@@@$@@@@@$@$@$@$@$@$@$@$@$M[u  {J[J$R$@$@$@$@@@@@$@$$$@$@$@$R[J[J[W[J[j[J[J[J[j    //
//        @@@@@@$@$$$$$$$@$@$@$@@@$@@M[j{J!g[J[&@@$@@@$@@@@@@@$@$@$@$M[J[J[j[J[J[j[j[J[J[J    //
//        @@$@$@$@$@$@$@$@$@$@$@@@$@$W[j[J[j[j[j$@$@@@@@@@@@@@@@@@$W[J[J[j[j[J[J[J[j[J[J[Q    //
//        @@@@@@@@@@@@$@@@$@$@@@@@@@@g[J[J[1[J[j[j$@@@@@@@@@@@@@@@$M[J[W[j[J[j[j[J[J[J[Q[J    //
//        @@@@$@@@@@@@@@@@@@@@@@@@@@@@$Q[J[g[1[J[J[]@@@@@@@@@@@@@@$R[g[j[g[J[g[g$@$@$@$@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@$R[j[@[Q[Q[Q[j$@@@@@@@@@@@@@@@@@@@$@@@@@$@@@@@@@@@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@$Q[Q[J[W[@[J[J[J$&@@@@@@@@@@$$@@@@@@@@@@@@@@@@@@@@$@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@$Q[1[J[j[J[@[J[1[j[j$R$&%$$$$1$&%@@@@@@@@@@@@@@@@@@@@@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@[1[J[Q[J[J[QLJ[j[&@Q$@@&$@@&$@@N@&$@@@@@@@@@@@@@@@@@$@$@    //
//        @@@@@@@@@@@@@@@@@@@@@Q$@[Q[J[g[J$@[Q[R[J@N@N@N@&$N$&[Q[j$&$R$@@@@@@@@@@@$@$@$@$@    //
//        @@@@@@@@@@@@@@@@@@@@$@@@$J$1[Q[J[J[Q[j[j[j[g[g$@[@[g$1[j@Q$R$@$&@@@@@@@@@@$@$@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@[@[Q$1[@$W[Q[j[J[J[j[@@@@&@N$N$j#Q$@$@$@$@@@$@@@@@@@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@$$@$g$g$g$g$@@g$g$J$$[R$@$@[1$R[R$W[&$$$@@@$@$@$@$@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$R[1[g$@$@$M$R$Q[@@&$@$@@@@@$@$@$$$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$N&R[j[J$J$@$@$@$Q[&$Q$@@@$@$@$@$@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&[@[@$@$1$N@@$@$@$@$@$@$@$@$@$@$$    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$@[@@@[J[@$@$@$@$%@@$@$@$$$@$@$@$@$$$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$@$g$@$@$@$@$@$@$@$@$@$@$@$@$@$@$@@@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$@$@$@$@$$@@@@@@@@@@$@@@$@$@@@$@@@$@@@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$$@$@$&$$$@@@@@@@@@@@@@$$$$$@$@$@$@$$@@@@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$@$@@@@@$@@@@@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$@@@$$@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@$$$$$@@@@@@@@@@@@@@@@@@@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$$$@@@$@$@@@@@@@@@@@@@@@@@@Q$$$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$@$@$@$$$@@@@@@@@@@@@@@@$@$@@@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$@$@$@$@$@$$@@@@@@@@@@@@@@@@$@$@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$$$@$@$@$@@@@@@@@@@@@@@@@@$@$@$@$@    //
//        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$@@@@@@@@@@@@@@@@@@@@@@@@@$$@$@$@$    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract UnclB is ERC721Creator {
    constructor() ERC721Creator("UncleBitcoin", "UnclB") {}
}
