
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mike Shupp
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$$$@@@@@@@@@@@@@@@@@@@@@$$@@@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@$$$@@@@@@@@@@@@@@@@@@@NMM$$$@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@$$@@@@@@@@@@@@@@M@$||"*$l]g#M@$@@@@@@@@@@@@@NNM$$$@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@NM$$$@g@$@$$$|l   '`llL"l%NM$$$@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@$$$@@@@@@@@@@@@@@@$$$@@@@@@@|| l|T '|$@@@@@@@@@@@@@@NMM$$$@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@NNM$l$$g@@@MMT|'"     `"*| |j&MM$$$$gg@@@@@@@@@@@@@$@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@N$$$$@@@@@@@@@@@Q$@$$$lLL||||            ||$$@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@$@@@@@@@@@@@@@@@@NM$$@@@@@$lLlL||             '|'%@@@@@@@@@@@@@@@@@@#@@@@@    //
//                                                                                        //
//    @@@@@@$@@NM$$$$@@@@@@@@@@@$@@@@@@@$$$$@L|L              %@@@@@@@@@@@@@@@@@@NNMM$    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$&$$$$$WL|              ]@@NNMM*$$$$ggg@@@@]@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@$@@@@$$$T||||| `                $@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@$@@@@@@@@@@@@@@@@@@@@@@@@@@@@@gL| |||L|             ]@@@@@@@@@NNNMM$$$$]@@@    //
//                                                                                        //
//    @@@@@$@@@@@@NNMM$$$$@@g@@@@@@@@$@$@@@@gLll$W|LL           $]gggg@@@@@@@@@@@@@$@@    //
//                                                                                        //
//    $$$@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&M@@@@@gg,       $@@@@@$$$$$@@@@@@@@]@@    //
//                                                                                        //
//    @@@@$@@@@@@@@@@@@NNMM$$@$@@@@@@@@@@@@@@@F'']@@@@@@@@L    jMM&&IJP**"""""` -- |||    //
//                                                                                        //
//    @NMM$$$$@gggm@@@@@@$@@@@@@@@@@@@@@@@@@@@|  l%@@@@@@@@,             ,,,,ggggg@@@@    //
//                                                                                        //
//    @@@@@@@@M$@@@@@N@@$$$@@@@@@@@@@@@@@@@@@@L   '%@@@$I '"   ,@@@@@@@@@@BNMMMMMMMMM$    //
//                                                                                        //
//    @@$Q$%@MT|*"*""' -`   @@@@@@@@@@$@@@@@@T       "*W'      '"'''''"`` ||||||||lll$    //
//                                                                                        //
//    $$lT|||,,,,,gggggg@@@@@@@@@@@@$$$$$@@@@gg,                               ||||ll$    //
//                                                                                        //
//    @@@@@@@@@@NMMMM***''''$@@@@@@@$$@@@@@@@@@@L,, @@g              ,,,,.=+~~***"$$$$    //
//                                                                                        //
//    $$$$$lll||||||||      @@@@@@@@@@@@@@@@@@@g "" *%@@L      ,,,+=>LLLillllll$$$@@@@    //
//                                                                                        //
//    @$$$$lll||||||||  ,,,,J@@@@@@@@@@@@@@@@@Q@@     |T"Q     ilLllll||||llll$$$$$$$$    //
//                                                                                        //
//    @@NNMM**$$$l,ggwggWW@M$@@@@@@@@@@@@@@@@L"jT,   ,y,| T   l||||||||||llll$$$$$$$$@    //
//                                                                                        //
//    @@@@@@@@@@@@@$$$$$ll@@@@@@@@@@@@@@@@@@@@@@@@@N@@@@@     l||||||||||llll$$$&$$$$$    //
//                                                                                        //
//    @@@@@@@@@@@@@$$$$$l@@@@@@@@@@@@@@@@@@@$$$M|    'j@@L   gggggggg@@@@@@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@$$$$$@@@@@@@@@@@@@@@@@@@@@@@@@@@g,   $$   $MMMMM%@"""]@@@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMTMLlL||'         |$    @@@@gg@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@%$$@@@@@@@@@@@@@@@@@@@@@@@@@$$$@@@|L  '''  ,g      ,,$    $@@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@$@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@gL,    ,@@@@@@@@@@@@F   ]@NN@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ggL ]@@@@@@@@@@@@@@   l@@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@M|']@@@@@@@@@@@@@@@L ||$@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$TlLj@@@@@@@@@@@@@@@@W||l]@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$@lM|$@@@@@@@@@@@@@@@@@g|lj@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@l|||||$@M@@@@@@@@@@@@@@@@@@@g$@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@l$@@@j@@$@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@||l@M$lg$@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract SHUPP is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
