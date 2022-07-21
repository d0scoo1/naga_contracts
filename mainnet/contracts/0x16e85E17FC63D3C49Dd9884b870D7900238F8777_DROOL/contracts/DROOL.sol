// SPDX-License-Identifier: MIT

/* 
                                                  
@@@@@@@   @@@@@@@    @@@@@@    @@@@@@   @@@       
@@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@       
@@!  @@@  @@!  @@@  @@!  @@@  @@!  @@@  @@!       
!@!  @!@  !@!  @!@  !@!  @!@  !@!  @!@  !@!       
@!@  !@!  @!@!!@!   @!@  !@!  @!@  !@!  @!!       
!@!  !!!  !!@!@!    !@!  !!!  !@!  !!!  !!!       
!!:  !!!  !!: :!!   !!:  !!!  !!:  !!!  !!:       
:!:  !:!  :!:  !:!  :!:  !:!  :!:  !:!   :!:      
 :::: ::  ::   :::  ::::: ::  ::::: ::   :: ::::  
:: :  :    :   : :   : :  :    : :  :   : :: : :  
                                                
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract DROOL is ERC20Burnable, Ownable {
  constructor() ERC20("Drool", "DROOL") {
    _mint(msg.sender, 69420000 ether);
  }
}