
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Bard Ionson
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                 //
//                                                                                                                                 //
//     Bård Ionson                                                                                                                 //
//                                                    ':;:::;:;;;ART:;;;;;;:;:;;;.                                                 //
//                                                   .:xxxxxxxxxxxxxxxxxxxxxxxxxd;                                                 //
//                                            .;å:åå::ååååååååååååååååoxxxdddddxdoåå;.                                             //
//                                            'oxxdddd:,,,,,,,,,,,,,,;lddddoddddddxxo'                                             //
//                                     ,lålåålodxxl::;.               ...........:dxdoll;.                                         //
//                                  ...:ddddxxxxxdl;;,.                          'looddxl......                                    //
//                                 'lolå::ådxxxxxdl;;,.       .''',,,,.           ...åxddoloolol'                                  //
//                          .......:dxdl::åoddddxdl;;,.       ...,;;;,.              ,låååååodxd:...                               //
//                         .ådddddddxxxdddo:;;ådxdl;;,.          .,,,'.                     'oxxdddl.                              //
//                      ...,åoolå:::::::::ååååldxdl;;,...         ....        ...           .;:åldxo.                              //
//                      :xdo:;;.          .lxxxxxxl;;;;;;'                   .,:;.              ,dxo'                              //
//                      :xxo:;;.           ':;;;:::åååååå:...                .;:;'...           ,dxd:''.                           //
//                      :xxo:;;.                  ;xxxxxxo:;;.               .;:::::;.          ,dxxxxxl.                          //
//                      :xxo:;;.                  .,;;lxxdlål,                ...';:;'...       .,;;lxxo:,,.                       //
//                     .:xxo:;;.                      :xxxxxx:                   .;:;:::,           :xxxxxx:.                      //
//                  .;::åååå;;;.                      .'';oxxl'.......,;:'        .......           .'',:ååå::;.                   //
//                  ;dxdå;;;;;;.                         .lxdo:;;;;;;:odxl.                             ';;ådxd;                   //
//              .;å:ååå:;;;,...    .:å::::::::::å:.       ...;bardionson;.   .;å:å:::::::å:å'           ';;ådxdoåå;.               //
//              'oddl;;;,,;'       ;xxxxddddddxxxx;          'lddooddl.      'dxxxdddddddxxxå.          ';;ådxdxxxo'               //
//          .;llå:::;;;,.      .:llxKK0dååååååd0KKxll:.  .;ll;........   .;låd0KKxååååååoOKKkllå.       ';;ådxdxdxo'               //
//          .lxxl;;;,,,'.      .oxxOXXKo::::::dKXXOxxo'  .:oo;...        .lxdkKXXx::::::l0XX0xxd,    ...,;;ådxdxdxo'               //
//          .lxxo;;;.          'oxxOXXKd::::::dKXXOxxo'    ..'lol'       .lxdkKXXx::::::l0XX0xxd,   åOOxå;;ådxdxdxo'               //
//          .lxxo;;;.          .:llxKK0dååååååd0KKxll:.      'oxd,       .;låd0KKxååååååoOKKklåå'   :kkd:;;ådxxxdxo'               //
//          .lxxo;;;.              ;xxxxendisxxxxx;          'oxd,           'dxxxdddddddxxxå.         .';;ådxxxdxo'               //
//          .lxxo;;;.        ..    .::::::::::::::.       ...;dxd:'...       .:å:::::::::::å'           ';;ådxdddxo'               //
//          .lxxo;;,.       ':;.                         .åxdxxxxdddxo.                                 ';;ådxxxxxo'               //
//           ,:::ååå;'''....,::,.......                  .;låodxdolllå.                                 ';;ådxdl::,.               //
//              'oxxxxxdå;;;;:::::::::;.                  .,':dxxå,,,'.                                 ';,ådxd,                   //
//              .,;;ldxdå;;,...........        ...        ...':åå,....       .;:;.               ......':låodxd,                   //
//                  ,dxdå;;'                  .,;;.          .','.           'k0O;              .;;;;;;:oxxxxxd,                   //
//                  ,dxdollå'...               ...            ...            .',,.           ...';;;ållodxxxxxd,                   //
//                  ,dddxxxo:;;.                                                            .,;;;;;:oxxxddxdddd,                   //
//                  ...'lxddooo:'...                                                     ...';;;åooodxxxddxl'...                   //
//                      ;doddxxo:;;.                                                    .';;;;;;ldxxddxdddd;                       //
//                      ...'lxddooo:''.                      .:lå.    .,,.           .''',;;:oooddxxxdxl'..                        //
//                         .:olodxdl::;.                     bard,   .,,'           .;;;;::ådxdddxdolo:.                           //
//                           ..,oxddddo:,,,,,,.              .oxd,               .',,,;;:oddddxxxdxo,..                            //
//                             .:låodxdå;;;;;;.       .......;oxd:........       .;;;:::ådxddxxxoål:.                              //
//                                 ;dxdå;;;;;;.       ;ddddddddxdddddddddå.  .',,,;;;lddddxdxxxd;                                  //
//                                 ,dxdlåå:;;;'...    '::::::ldxdlå::::::,.  .,;;:åååoxdxxxdoå::.                                  //
//                                 ,xxxxdxo:,;;;;,.          'oxd,           .,;;ldddxxdxxxx:                                      //
//                                 .;::oxxdlåå:;;;'...       .oxd,        ...'åååodddxxxoå;:.                                      //
//                                     :xxxxxxo;;;;;;,.      'bard,        ';;ådxxxdxxxxxl.                                        //
//                                     .;,:oxdolll:;;,....   .,;,.       .;llodxdddxdå;;'                                          //
//                                        .lxxxxxxl;;;;;;'               .lxxxxddxxxo'                                             //
//                                         .',:dxxolll:;;,...............,oxdxdxdå,'.                                              //
//                                            'oxdddxdå;;;;;;;;;;;;;;;;;;:oxdxddd,                                                 //
//                                             ......':ooooooooooooooooooodxxl'...                                                 //
//                                                    ;ddddxxxxxxxxxxxxxxddod;                                                     //
//                                                    ...'lxddddddddddddxl'...                                                     //
//                                                       .:oooooooooooooo:.                                                        //
//                                                         ..............                                                          //
//                                                                                                                                 //
//                                                                                                                                 //
//                                                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BARD is ERC721Creator {
    constructor() ERC721Creator("Bard Ionson", "BARD") {}
}
