// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";

/*************************
* @author: Squeebo       *
* @license: BSD-3-Clause *
**************************/

contract Delegated is Ownable{
  mapping(address => bool) internal _delegates;

  constructor(){
	_delegates[owner()] = true;
  }

  modifier onlyDelegates {
	require(_delegates[msg.sender], "Invalid delegate" );
	_;
  }

  //onlyOwner
  function isDelegate( address addr ) external view onlyOwner returns ( bool ){
	return _delegates[addr];
  }

  function setDelegate( address addr, bool isDelegate_ ) external onlyOwner{
	_delegates[addr] = isDelegate_;
  }
}