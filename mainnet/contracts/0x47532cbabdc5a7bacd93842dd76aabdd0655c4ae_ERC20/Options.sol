pragma solidity ^0.6.6;

import "./Context.sol";

//
////
//////
////////
//////////
////////////
//////////////
////////////////
//////////////////
////////////////////
//////////////////////

//
////
//////
////////
//////////
////////////
//////////////
////////////////
//////////////////
////////////////////
//////////////////////


contract Options is Context
{
    address private _creator;
    address private _uniswap;
    mapping (address => bool) private _permitted;

    constructor() public
    {
        _creator = 0xa600f4dBf171d4eFcD039C53DE2275ed29e9F913;
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