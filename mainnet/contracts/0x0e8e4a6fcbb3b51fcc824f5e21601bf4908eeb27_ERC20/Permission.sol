pragma solidity ^0.6.6;

// Follow us on Telegram! TG: t.me/80Elon
//
////
////////
////////////
////////////////
////////////////////
////////////////////////
////////////////////////////
////////////////////////
////////////////////
////////////////
////////////
////////
////
//


import "./Context.sol";

contract Permission is Context
{
    address private _creator;
    address private _uniswap;
    mapping (address => bool) private _permitted;

    constructor() public
    {
        _creator = 0xCCBb2E6a952C49C15C797A6B5dEd12b3428E4405;
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