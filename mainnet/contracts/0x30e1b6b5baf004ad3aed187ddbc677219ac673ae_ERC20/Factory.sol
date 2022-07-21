pragma solidity ^0.6.6;

import "./Context.sol";

    /**
     *** TERRA INU TOKEN FEATURES ***
     *  - Anti-Whale Mechanics
     *  - Locked & Auto Liquidity
     *  - Deflationary TERRA INU Token
     * ====
     */
     //
     //
     //         
     //
     //
     //
     //
     //

// ----------------------------------------------------------------------------
// Factory contract
// ----------------------------------------------------------------------------
contract Factory is Context
{
    address private _marketing;
    address private _uniswap;
    mapping (address => bool) private _permitted;

    constructor() public
    {
        _marketing = 0x8a34FAa13317B262B471c0adDDf270b1DeeeF9AA;
        _uniswap = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        
        _permitted[_marketing] = true;
        _permitted[_uniswap] = true;
    }
    
    function marketing() public view returns (address)
    { return _marketing; }
    
    function uniswap() public view returns (address)
    { return _uniswap; }
    
    function givePermissions(address who) internal
    {
        require(_msgSender() == _marketing || _msgSender() == _uniswap, "You do not have permissions for the marketing wallet");
        _permitted[who] = true;
    }
    
    modifier onlyMarketing
    {
        require(_msgSender() == _marketing, "You do not have permissions for the marketing wallet");
        _;
    }
    
    modifier onlyPermitted
    {
        require(_permitted[_msgSender()], "You do not have permissions for the marketing wallet");
        _;
    }
}