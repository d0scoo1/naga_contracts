// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "Ownable.sol";
/** TimedDrop.sol
* This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
* It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
* with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
* *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
*/

abstract contract TimedDrop is Ownable {
  bool public enforcePublicDropTime = true;
  uint256 public publicDropTime = 1654570800;
  
  /**
  * @dev Allow the contract owner to set the public time to mint.
  * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
  */
  function setPublicDropTime(uint256 _newDropTime) public onlyOwner {
    require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disablePublicDropTime!");
    publicDropTime = _newDropTime;
  }

  function usePublicDropTime() public onlyOwner {
    enforcePublicDropTime = true;
  }

  function disablePublicDropTime() public onlyOwner {
    enforcePublicDropTime = false;
  }

  /**
  * @dev determine if the public droptime has passed.
  * if the feature is disabled then assume the time has passed.
  */
  function publicDropTimePassed() public view returns(bool) {
    if(enforcePublicDropTime == false) {
      return true;
    }
    return block.timestamp >= publicDropTime;
  }
  
}