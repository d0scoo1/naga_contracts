
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Trees Season 2
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//                 .    ..  ..     .,.    ..,'.'.            ..  .'. ...   .         ..                                      .    //
//                   . .    .      .'.     .;,...            .. .'..  .'. ...        ...                   .                      //
//                  .              .'.     .''.              ..''.    ...  ..     .   .   ...                                     //
//                ...             ....     ....           .,,'...     .     .     .      ..                                       //
//               ..                       ......       .,:c;.  .     ..     .           ..                                        //
//             ..                       ......'.     .:ll;'..       ...      .   .......                                          //
//                                ..        .::.   .,cl;'.....       ..              .                                            //
//                                 ...      'o:. .'::'.... ...       ..                                                           //
//                                . ..     .cd;.,cl,.        ..                 ...                                               //
//                                . ..    .'dd:l0k;.         ...                ..                                                //
//                               ..        'dol0K:.      .,','.                .                                                  //
//          ....                           'ddx0l.     'cl;'.                                                                     //
//          ...   ....  .                  'ddoc..   .cl,.                         ...                                            //
//            ..  ..........    ..         .lo,..  .,dc.                    ..'..    ....                                         //
//             .....  ...,:,........ ...   .,:.   .;do.                  ..':l:,..          .....                                 //
//              .'''..  .'coc:;'...    ..  ..;.  ..ol.                  ..'',::cc:;,.       ....                                  //
//                .',;;...':loddc'..    .....',..'cc.                 ..,::,:oddc;,,..      ....                                  //
//                   ..;c;'...,cddl,..........','ol.                ...;odool:'.     .      ...                                   //
//                      .;;.......;::::;,''.. .,:oc.             .....,cdoc,.     ....       ..                                   //
//                       .','........';;;,;;;,.,lxc.            .''.':l:;...    ....        ....                                  //
//                         .;,...........'''',;::oc.    .';;:c:::'..cc,...........        ..'...                                  //
//                         ..;c;....',''',;;;;:::dd;'.,;;coldxkkl;;cc;,,,,,:ccc'..       .''.  . ..                               //
//                           .,:;''',,'',;:cclc,.,od;''''',:xKXklc:,''...,;:odc..        .,.    ...                               //
//                                    .......'.   .;c'    ..,kXkl,.......';cddc.    ....',.    ...             .                  //
//                   .  ...                  ..   ..,c;......cOxc........',:lc,..   ..,;;.     ..                                 //
//                   ............             .  .....;:;....,od:.......'',,,'....  ',','.    .;,.                                //
//                    ...  .. .....                    .,;'....cd;..';:::;,'......  ,c'.,;,..';:........                          //
//                     .....   ......  ..........        .,:'..cOl'.';lddoc;'....   ;:.',:lool;..........                         //
//                   ............  .',,,'.........         ,o:.;ko',,,;coxl:;'.....'l:,;;,,,'..........                           //
//                  ............';,,,'...............       .oo;ll,''',;coolc:,'...:l;,cl;'...............  ..                    //
//                      .......;c,.. ....,;:ccc:,..;c,.      .dxxo'....,:cxxodl,..':,,:;'......................                   //
//               .      ......':,'.   ....';;;:c;';;;:'. .    ,do,'....''ckkdoc...,;;:,.... ......................         .      //
//              ..      ..   .oxc;.    ........'.,:'''. ....   .:::,..,:,:dc,'.. 'c:'......  ..    ..',,',;;'.....        ..      //
//                     ...  .lXXk:'.....     .....::'.   .'.....,;';::;coo;....'cl;........   ..  ...''',,;;;,'.............      //
//                   ....   .:0XO:..''..      .....;:'. ..,,....',..,oxxxc'..,coo;...''....   ..   ........,:;...,,'.',......     //
//                   ...     .:o:......',,'......  .';'..,::,,,,lddc:lkxolccloll:..........      ......  ..::'.  ...'.''',''.     //
//                    .      ............'.....'.....':;;ccol:,,lkkdccoodkdoxc:l,...'....''..   ..''.    .,c:..    .....,;,;.     //
//                .       .  ...............  ...',;:;col:cc;,'.':loxOK0KKo;'..;. ..,,,'';;'... ...,,.....':c,.... ......,;;.     //
//      .            ..      ..,:c,.......... ..'';c:,.;oo:;cc,'''':ldKN0d;.  .'. ....'..;'....    .,;......,,'.....'''...'.      //
//                   ....    ..:xxl:;,''......''...',,';cdxlclc,'',:ld0k;'.......       .,'..'..  ...,,..... ..........,,'..      //
//                    ..    ...;lc::oxdlclxOOOOxoccllc::ccxOdc;',coddxk:.. ..........  .',''.''........'.......','.......,'.      //
//                           ..,'..',;,,;:lool:,'.':codooodO0xooxdlclxo' ..'......'.  ..'''.....'............;cllc:'.........     //
//                           .';'............... .......':okXXO00o;:lxl....'.............',;,,,,;'............,:odxxoc:,,'....    //
//                          ..';;'.....''..       ... .. .'cKWNOolcldxc........''',,,,;:;;;,',,'................',:lolccc:;,''    //
//                     .. ....',;;.....;;'.   ...','. ... .:xNN0oclxOl. .....''.';;;;;,,,;;;;'...............'.....','.',,,,''    //
//                      .......,;;'....';;...;ccc;'........,cxdxxoxkk:. ..',''...',,;,'',;cc;''''..'''''',;,,,,''.... ........    //
//                   ...........,''...'','.':ol:;'.  ....,'''''d0kO0x,.....''''',:ooc:,';:::cccc:;;;:::::clc::,..                 //
//                   .............''.,;;;,';c:;;,.......':;...;xKXNNOc;,,'','',,:llc,'',::,'''',,;;;;;;;cc:;:c:'...               //
//     ..             ...... .....',',::;',:;'',,,:l;....;,...cOXWWNk:,'''':lodxoc;,:::;,........'';,....;;,,;:;''..              //
//     .                ..'.......',',,,..,:;''..;lc'....';'.,oKWNXOc'..:l,;dKkc,... ......... ....;ol;'..',,'','...              //
//                       .'..  ...'''''...;c:,'..,;,....  .,;ld0WNX0d;,'::',okl....    ......   .. .'::;'....''..                 //
//                       ....   ....';,..';c:;:;.....'..  .cdll0XXNXXOxdoxxxool;'....   ..........    .',,'......                 //
//                      ....       .';'..,;:::l,    ..  .:xx:;kXKkxxOXWWN0dooddoolc:;;,;;'..........    ................          //
//                            .    .... ......,'     .,ckKOolkNWXK0O0NWNk:.........',collool;.......... ..............            //
//                         ...    .'..        .'...'ckXNKxodKWWWWNNKOxdl;..     ..   .,'..;od;..................      .   ..      //
//                        ...     .'.  ......',:dkOKNWNKOxx0WNK0koc;'....   . .....   .....';.......... .......      ..   ..      //
//                       ...      ..   ...,;::ldOKKK0OxkOkk0NXkxd:.......  ........    .,...............'''............  ..       //
//             ..       ..              ..',;::cccc::;;:cx0XWW0odxl;....   .........   .,..............',,;;,,''.......           //
//              ...                      ................,cxXW0lcOXx,.......''..   ....'..    ...........'','........             //
//                  .              .    .......         ..'dXNk:'o00o....''cl:,..  .....       ..  ...........                    //
//                                .       ..             ..oXKd;.,ck0c.':c:o:'.'.......                                           //
//                         .   .              ..          .:0Kxc..'oKO:',,,:::c;......   .                                        //
//                         ..                       ..   . .cOKOl;;l0Xkc,.....;,..........                                        //
//                        ..                         ..   . .oOXKdlloxxo,.....,'..',;;;.                                          //
//                     ....                                 .lOKWXK0Okkkc......';:::;,;.                                          //
//                .. ....                                   .'okKNWWWWXKd..''.:dl,.                             .                 //
//                ;,...    .                                  .,lOKXWWWXxc:clxx:.                                                 //
//               ,:.       ..                                ...:ddxKWMWNK0Okl'.    .....                                         //
//             .,,.         ..                            ......cxooONWMMWNk:.......... .....                                     //
//            .,.            ..                           .,;,:lx000XWNXXXNO:'....          ...                                   //
//          .'.               ..                           .;dkKNNNWWKkkkk0Xk;.......         ...                                 //
//      ...',.                 ..                          ';;:d0NWNOoodokXNWKd;,'''........''......                              //
//        .'.                    ..                      .',,;d0XK0xc:xxox0NWWNOc,.'',,,'''........'.     .....                   //
//    ......                      ....     .        .....',cxKNNKxllcodcoOKXNWWWKd:;,'..           ..,......                      //
//             ...                  ....    .........',,cdOKXXX0xoooxl;;cokkxxOXXkl,..                ....                        //
//              .........             ....';:;'...'.,lxkOkdoxKklc:;,'..;do;'',cd0XXKOxol:;'...                                    //
//                   ..............',;cldxkOkxol:;;:cc:;'..;xxc,..     .dd,....,:ok0XNNX0koc;'....                                //
//                           ....',,;:clool:,,,,,'.....;;;;:,..        .lx,......';:cllllc:;,'....                                //
//           ..                        ...      .''....;olc.            ck;.....................        .....                     //
//                                             ..;c:;;;;...,;;'.       .lk;.                  ..         .......                  //
//                        ................'';:clolcclc'.    .,cloool:,.'xO,.                   .....          ..'.                //
//                        .............',;:clll:,...''..      ..;lodxxxkXKdl:,..                 ..','..        ...               //
//                          ......       ......... ...          ....,:o0WXxoc;'.                    .,;,'............             //
//                                                  ..            ....:OXl'.....                      ..''''.............  ...    //
//                                                                  ..,xk'                              ..'''.................    //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Trees2 is ERC721Creator {
    constructor() ERC721Creator("The Trees Season 2", "Trees2") {}
}
