//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract SANDOSecurity{
 //   bool locked;
    bool public paused;
/*
    modifier noReentrancy(){
        require(msg.sender!=address(0x0));
        require(!locked,"Token locked");
        locked = true;
        _;
        locked = false;

    }
*/
    modifier CheckPoint(address _wallet,uint _holderType){
        require(msg.sender!=address(0));
        require(_wallet != address(0));
        _;
        
    }

    modifier Pauseable(){
        require(!paused,"Paused");
        _;
    }

}
