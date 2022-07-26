
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Doodles for Friends
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//    + + + - - - - - - - - - - - - - - - - - - - - - - - - - - - ++ - - - - - - - - - - - - - - - - - - - - - - - - - - + + +    //
//    +                                                                                                                      +    //
//    +                                                                                                                      +    //
//    .                                                                                                                      .    //
//    .                                                    ####-                                                             .    //
//    .                                        :*##:   .###-...:##                                                           .    //
//    .                                        +#.:# :#+:........+#####+                                                     .    //
//    .                                       .:#..#*=.................:#.                                                   .    //
//    .                                     .#..*:.........:.........=-.-#                                                   .    //
//    .                                      :+#-....:+**+^^+***__=**#:.*#                                                   .    //
//    .                                      .#:.....:#              ^#.#                                                    .    //
//    .                                      #:....-#^                 #                                                     .    //
//    .                                      #-.....#    ++             +   ++                                               .    //
//    .                                      .#.....+   +##+            .* +##+                                              .    //
//    .                                       #.....#    ++  .######**.  #  ++                                               .    //
//    .                                       #*  ^#^       *####--  ##. #                                                   .    //
//    .                                      #:  #.         *####--  #*  #                                                   .    //
//    .                                      #.   # :.       .###--  -# .+                                                   .    //
//    .                                       #.   .#          ###--  # #                                                    .    //
//    .                                        ^##^  #       .###--  =# *                                                    .    //
//    .                                            #**#.     ###--  -*+**#                                                   .    //
//    .                                            #***####**###--  +#****#                                                  .    //
//    .                                           .##*********###--  #**##.                                                  .    //
//    .                                          #************###--  #*****#                                                 .    //
//    .                    ..:..                #*****#*******###--  #**#****###* *###                                       .    //
//    .               .####*^^^^*###.          ##*****#******###--  #***#***#  :# #  :#                                      .    //
//    .              :*             =#.        #******#*******##--  #***#***#  .# #  .#                 .####.               .    //
//    .               ++#   ######.   #-  .*#####*****#*########--  #***#####  .# #  .#   .#######.   #*^   .^#+             .    //
//    .                +#   #::::..#   #.#^^      ^#**#^       ^#- #**#^       .# #  .# +#^       ^# #+        #+            .    //
//    .                .#   #      #   ##    .##.  .##.   .##.   # *#   .##.   .# #  .##.   -+#+.  # #   :######:            .    //
//    .                .#   #     .#   #    #:::#   #.   #:::#   ###   #::::#  .# #  .##  :#####+  #.##     :...             .    //
//    .                .#   #    .#.  :#   #   .#  .#   #    #   ##    #^   #  .# #  .##  .^     .##. *#+:.    .#            .    //
//    .                .#   #####^    ##   #  :#.  .#   #  .#    ##    #   #.  .# #  .##   .=*######..##+###.   .#           .    //
//    .                .#   ..      .###.   ###   .%#.   ###    *#-#    ###     # #  .##*   .      ####   ^     .#           .    //
//    .                 #.   ..:-#####* #.      .*#  ##.      .##. :#._     _### ##.  #**#.     .:##. ##.     -##            .    //
//    .                  ############*   =########    :########-     +#######^ ### ##### ^######++#^   ^#######+             .    //
//    .                    ^*######*^      ^*##*^       ^*##*^         ^*###*^ ^##^ ^###^  ^*####*^      ^*##*^              .    //
//    +                                                                                                                      +    //
//    +                                                                                                                      +    //
//    + + + - - - - - - - - - - - - - - - - - - - - - - - - - - - ++ - - - - - - - - - - - - - - - - - - - - - - - - - - + + +    //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DOODLEF is ERC721Creator {
    constructor() ERC721Creator("Doodles for Friends", "DOODLEF") {}
}
