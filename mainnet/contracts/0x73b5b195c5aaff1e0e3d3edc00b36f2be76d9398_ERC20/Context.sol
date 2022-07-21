pragma solidity ^0.6.6;

/*

Shit Shiba Inu (SHITINU) 

Official Telegram:
https://t.me/ShitInuEth

Website: 
https://shitshibainu.io

*/

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}