pragma solidity ^0.6.6;

//
//////
//////////
//////////////
//////////////////
//////////////////////
//////////////////////////
//////////////////////////////
// Fantasy Ether Token: Join the Fantasy Ether Metaverse & Start Earning Ethereum
// Join Telegram for more info
//////////////////////////////
//////////////////////////
//////////////////////
//////////////////
//////////////
//////////
//////
//

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}