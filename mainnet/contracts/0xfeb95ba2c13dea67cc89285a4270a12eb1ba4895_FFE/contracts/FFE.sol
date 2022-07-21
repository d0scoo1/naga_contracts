
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Farrah Fisher Editions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//                                                                                         //
//                                                                                         //
//     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl,.;oxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddddxxdxxxxxxddxxxxxxxxxxxxo,.;oxxxxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxxxxxxddxxdxxxxdddddddddddddddddddddxddxxdxxxxxo,.;oxxxxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxxxxxxdxxddddxxdddddddddddddddddddddddxxxxdddddo;.,lxxxxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxxxxxxxxdddddddddddddddddddddddddddddddddxxddxxd:''cdxxxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxdxxxxddxdddddolllllcccccccccclodddddddddddddddo:''cdxxxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxxxxxxdddddl:,'''..............',;:loddddddddddd:'':dxxxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxxxxxxddoc,..'''..... ..........   .':odddddddddc'.:dxxxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxxxxdddc,.......',,'.',:lodool;.....  .;odddddddl,.;oxxxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxxxxdo:'..  ...;lddddddddxdlc:,'......  .;llodddo;.;oxxxxxxxxxxxxxxx     //
//    xxxxxxxxdooodddxo;... .......;oxxxdxdl:;;:lol:'.'...  .,ldddo;.,lxdxxxxxxxxxxxxx     //
//    xxxxxxxxdllllc:;,...  ...:ll;';oxxxdl,;odddollc,.....  .cdddd:.'cdxxxxxxxxxxxxxx     //
//    cdxxxxxxxxxxxdl,..       .cddc',oxxo;,llc:'...........  .ldddc'.:dxxxxxxxxxxxxxx     //
//    ,lxxxxxxxxxxddl;..        .cxd:.;oxo;;c'.       .....'. .:dddl,.;dxxxxxxxxxxxxxx     //
//    ldxxxxxxxxxdc:;'.. .      .cdxo,,oxo;;c'.       .....'.  .lddo;',lxxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxdoc,. .;:,.',;ldxd:.:dxd;'clc,.   ..',...',. .;oddc''cdxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxo;.. .colodxxxxxc.,dxxd:.;dxdl;;:cc::'...'.  .cddl,':dxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxo,.  .':odxxxxxo'.;:cl;..,oxxxxxxxdol,.,'..   ;dxd:',lxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxd:. ...,ldxxxxxdlloc'.,::cdxxxxxxxxxd;.,,...  ,dxdc''cdxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxdc.  ...cdxxxxxxxxxxdodxxxxxxxxxxxxxx:.,;'... ,dxxo;';oxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxdl;.  ..:ddxxxxxxxxxxxxxxxxxxxxxxxxxxc.':;''. 'oxxdc''cdxxxxxxxxxxx     //
//    xxxxxxxxxxxxxdl:.  ..;oddxxxxxdoccccccodxxxxxxxxxxl..::,'. .ldddo:.,oxxxxxxxxxxx     //
//    xxxxxxxxxxxxxxo:.   .,ldxxdl,...      .,:clddxxxxxd;.;:;.  'ldddxo,':dxxxxxxxxxx     //
//    xxxxxxxxxxxxxxd:..  .'lddl;.   ........   .'lxxxxxd:.;c;.  'lddxxdc''cdxxxxxxxxx     //
//    xxxxxxxxxxxxxxd:.    .cxdl;,;:cllllloolcc:;:oxxxxxd:';c,.  .cddxxxo:',lxxxxxxxxx     //
//    xxxxxxxxxxxxxxx:...  .;dxxxxxxxxxxxxxxxxxxxxxxxxxxxc,;;.. .'cdxxxxxo;';dxxxxxxxx     //
//    xxxxxxxxxxxxxxxc.... .;oxxxxxxxxxxxxxxxxxxxxxxxxxxxc',. ....codxxxxxl,'cxxxxxxxx     //
//    xxxxxxxxxxxxxxxl'...  'oxxxxxxxxxxxxxxxxxxxxxxxxxxxc.. .,,..:oxxxxxxxo;,oxxxxxxx     //
//    xxxxxxxxxxxxxxxl'.... .:dxxxxxxxxxxxxxxxxxxxxxxxxxd,. .'::..;oxxxxxxxxdccdxxxxxx     //
//    xxxxxxxxxxxxxxxl,..... .cxxxxxxxxxxxxxxxxxxxxxxxdc.. .';c:'.;oxxxxxxxxxxocdxxxxx     //
//    xxxxxxxxxxxxxxxd:'..... .cxxxxxxxxxxxxxxxxxxxxdc' ...  .''..'cdxxxxxxxxxxdodxxxx     //
//    xxxxxxxxxxxxxxxxdc'.'..  .;oxxxxxxxxxxxxxxxxdc. .'cc'''.   .'ldxxxxxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxxxxxd;',,..   .;ldxxxxxxxxdooc;. .,cdxl'';;..  .,oxxxxxxxxxxxxxxxxx     //
//    xxxxxkxxxkkkxxxxxxc'''.. ...  .'',,,'.......':lxxxxd;.',..... .:dxxxxxxxxxxxxxxx     //
//    xxxxxxxxxxkkkxxxxxl'.....;oo:;,'''..'',,;:loxxxxxxxd,..,,'.;:'. 'cdxxxxxxxxxxxxx     //
//    xxxxxxxxxxxxxxxxxd:. .,'.;oxxxxxxxxxxxxxxxxxxxxxxxxd:,,cdoloxdc. .'cdxxxxxxxxxxx     //
//    xxxxxxkxkkkxkxxxd:...'::..ldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdc'. .cxxxxxxxxxx     //
//    xxxxxxxxxxxxxxxx:. ':;,:,.;odxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdc'..'lxxxxxxxx     //
//    xxxxxxxxxxxxxxxo. .ldc,:l::oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxc. .,lxxxxxx     //
//    xxxxxxxxxxxxxxd, .:xxdloxxooxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxo;. .:dxxxx     //
//    xxxxxxxxxxxxxxl. 'oxxxxxxxxxkxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxd:. .cxxxx     //
//                                                                                         //
//                                                                                         //
//                                                                                         //
//                                                                                         //
//                                                                                         //
//                                                                                         //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////


contract FFE is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
