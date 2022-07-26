
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//*********************************************************************
//                                    @%@                              
//                                  * @@%                              
//                        %@(%,     @ %(/        &&%*                  
//                        @ (*# ..   %%@@&  ,   / //( .                 
//                        . @@%  @@& *@@&%%@@..&@@(   .                
//              #@%.@     @ %@@& @@@& @@&%@@@& @@&&. .    @@@ .*       
//              @  /@/,(*@@@# @@@( @@& @@&(@@&&@@@%/@@% ,@&@,%.  &      
//              /.   @@& .@@% @@& @@&.@@&*@@%,@@%%@@*/&@@...    ,      
//                  %  %@@  @@% @@&,@&%@@#&@%%@@((@@,,@@/..    @        
//                    ,  @@& @@% @@*@@&@@%@@#@@*,@@*%@@..*   *          
//                    %.  (* ,/# // ** .. .* **.*,,#...   .            
//                      @                                @             
//                  @  &@@@@@@@@@@@@@@@@@@@@@@@@@@..   *               
//                    .  @@@@@@@@@@@@@/,@@@@@@@@@@@@@ ,                
//                      * @@@@@@@@@@@@@(( *@@@@@@@@@@@@% *              
//                        @@@@@@@@@@@@@%%   @@@@@@@@@@@@# .             
//                        @@@@@@@@@@@@@#(   @@@@@@@@@@@@@,              
//                        @@@@@@@@@@@@@((   %@@@@@@@@@@@@., .           
//                        @@@@@@@@@@@@@((  .&@@@@@@@@@@@@.*             
//                        @@@@@@@@@@@@@#/   @@@@@@@@@@@@...             
//                        @@@@@@@@@@@@@#(  %@@@@@@@@@@@...              
//                        @@@@@@@@@@@@@#/ @@@@@@@@@@@(*,,               
//                        @@@@@@@@@@@@@@@@@@@@@@@%((((/   .             
//                        @@@@@@@@@@@@@@@@@@@@@@@@/     .@              
//                        @@@@@@@@@@@@@@@@@@@@@@@@@#  @                 
//                        @@@@@@@@@@@@@/@@@@@@@@&&&&( .                 
//                        @@@@@@@@@@@@@((@@@@@&@&&&&#, *                
//                        @@@@@@@@@@@@@((&@@&&&&&&&&&(  @               
//                        @@@@@@@@@@@@@(/ &&&&&&&&&&&&(  .              
//                        @@@@@@@@@@@@@(/ .&&&&&&&&&&&&/                
//                        @@@@@@@@@&@&&(/  %&&&&&&&&&&&&/ .             
//                        @@@@@@@&&&&&&(/   &&&&&&&&&&&&%* .            
//                        @@&&@&@&&&&&&(/    &&&&&&&&&&%%/. *           
//                      /&@@&@&&&&&&&&&&/  @ *&&&&&&&&%%%%*  @          
//                  ,.((((((((((((((((//// . /////////////*  ,         
//                  @                                                  
//                      @,...................*@@,............,@         
//
//Instagram: @dtheflyestbtl TikTok: @dtheflyestbtl39 Twitter: @DtheFlyestBTL 
//
//d8888b. d888888b db   db d88888b d88888b db      db    db d88888b .d8888. d888888b 
//88  `8D `~~88~~' 88   88 88'     88'     88      `8b  d8' 88'     88'  YP `~~88~~' 
//88   88    88    88ooo88 88ooooo 88ooo   88       `8bd8'  88ooooo `8bo.      88    
//88   88    88    88~~~88 88~~~~~ 88~~~   88         88    88~~~~~   `Y8b.    88    
//88  .8D    88    88   88 88.     88      88booo.    88    88.     db   8D    88    
//Y8888D'    YP    YP   YP Y88888P YP      Y88888P    YP    Y88888P `8888Y'    YP    
//                                                                                   
//Spotify: https://open.spotify.com/artist/5k3KbrfdrZTfasGvrebyzr?si=M4_33y_7RKeX97nfDmVisw                                                                               
//                                                                     
//*********************************************************************

import "./BudRoyalty.sol";
contract DTheFlyest is BudRoyalty {
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
    