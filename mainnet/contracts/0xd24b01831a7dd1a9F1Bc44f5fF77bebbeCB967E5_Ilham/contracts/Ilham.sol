
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//*********************************************************************
//                             @%@                              
//                           * @@%                              
//                 %@(%,     @ %(/        &&%*                  
//                @ (*# ..   %%@@&  ,   / //( .                 
//                 . @@%  @@& *@@&%%@@..&@@(   .                
//       #@%.@     @ %@@& @@@& @@&%@@@& @@&&. .    @@@ .*       
//      @  /@/,(*@@@# @@@( @@& @@&(@@&&@@@%/@@% ,@&@,%.  &      
//       /.   @@& .@@% @@& @@&.@@&*@@%,@@%%@@*/&@@...    ,      
//          %  %@@  @@% @@&,@&%@@#&@%%@@((@@,,@@/..    @        
//            ,  @@& @@% @@*@@&@@%@@#@@*,@@*%@@..*   *          
//             %.  (* ,/# // ** .. .* **.*,,#...   .            
//               @                                @             
//           @  &@@@@@@@@@@@@@@@@@@@@@@@@@@..   *               
//             .  @@@@@@@@@@@@@/,@@@@@@@@@@@@@ ,                
//              * @@@@@@@@@@@@@(( *@@@@@@@@@@@@% *              
//                @@@@@@@@@@@@@%%   @@@@@@@@@@@@# .             
//                @@@@@@@@@@@@@#(   @@@@@@@@@@@@@,              
//                @@@@@@@@@@@@@((   %@@@@@@@@@@@@., .           
//                @@@@@@@@@@@@@((  .&@@@@@@@@@@@@.*             
//                @@@@@@@@@@@@@#/   @@@@@@@@@@@@...             
//                @@@@@@@@@@@@@#(  %@@@@@@@@@@@...              
//                @@@@@@@@@@@@@#/ @@@@@@@@@@@(*,,               
//                @@@@@@@@@@@@@@@@@@@@@@@%((((/   .             
//                @@@@@@@@@@@@@@@@@@@@@@@@/     .@              
//                @@@@@@@@@@@@@@@@@@@@@@@@@#  @                 
//                @@@@@@@@@@@@@/@@@@@@@@&&&&( .                 
//                @@@@@@@@@@@@@((@@@@@&@&&&&#, *                
//                @@@@@@@@@@@@@((&@@&&&&&&&&&(  @               
//                @@@@@@@@@@@@@(/ &&&&&&&&&&&&(  .              
//                @@@@@@@@@@@@@(/ .&&&&&&&&&&&&/                
//                @@@@@@@@@&@&&(/  %&&&&&&&&&&&&/ .             
//                @@@@@@@&&&&&&(/   &&&&&&&&&&&&%* .            
//                @@&&@&@&&&&&&(/    &&&&&&&&&&%%/. *           
//              /&@@&@&&&&&&&&&&/  @ *&&&&&&&&%%%%*  @          
//           ,.((((((((((((((((//// . /////////////*  ,         
//           @                                                  
//              @,...................*@@,............,@         
//
//Instagram: @ilham TikTok: @ilham Twitter: @ilham
//
//            d888888b db      db   db  .d8b.  .88b  d88.              
//              `88'   88      88   88 d8' `8b 88'YbdP`88              
//               88    88      88ooo88 88ooo88 88  88  88              
//               88    88      88~~~88 88~~~88 88  88  88              
//              .88.   88booo. 88   88 88   88 88  88  88              
//            Y888888P Y88888P YP   YP YP   YP YP  YP  YP              
//                                                                     
//Spotify: https://open.spotify.com/artist/0r7PsZB4ePA6vHrW4agoGN?si=Ui0R0142Q9SS8suU4RdmTg                                                                  
//                                                                     
//*********************************************************************

import "./BudRoyalty.sol";
contract Ilham is BudRoyalty {
    constructor(
      string memory NFTName,
      string memory NFTSymbol,
      string memory collectibleURI,
      address minter,
      uint totalSupply
    ) BudRoyalty (
      NFTName,
      NFTSymbol,
      collectibleURI,
      minter,
      totalSupply
    ) {}
}
    