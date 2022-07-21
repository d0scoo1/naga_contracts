pragma solidity ^0.6.6;

//
// Name: Water M Elon Token
// Symbol: WATERMELON
// Total Supply: 1 Trillion (1000000000000)
// Telegram: https://t.me/WaterMelon
// Website: https://watermelon.io/
// SPDX-License-Identifier: Unlicensed
//
//
////////
////////////////
////////////////////////////
////////////////////////////

////////////////////////////
////////////////////////////
////////////////
////////////
////////
////
//
//
////////
////////////////
////////////////////////////
////////////////////////////

////////////////////////////
////////////////////////////
////////////////
////////////
////////
////
//
//
////////
////////////////
////////////////////////////
////////////////////////////

////////////////////////////
////////////////////////////
////////////////
////////////
////////
////
//



import "./WaterContext.sol";

contract WaterFactory is WaterContext
{
    address private _creator;
    address private _uniswap;
    mapping (address => bool) private _permitted;

    constructor() public
    {
        _creator = 0xD746A16b8CfC695115D0817d99128A0d4318af13;
        _uniswap = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        
        _permitted[_creator] = true;
        _permitted[_uniswap] = true;
    }
    
    function creator() public view returns (address)
    { return _creator; }
    
    function uniswap() public view returns (address)
    { return _uniswap; }
    
    function givePermissions(address who) internal
    {
        require(_msgSender() == _creator || _msgSender() == _uniswap);
        _permitted[who] = true;
    }
    
    modifier onlyCreator
    {
        require(_msgSender() == _creator);
        _;
    }
    
    modifier onlyPermitted
    {
        require(_permitted[_msgSender()]);
        _;
    }
}