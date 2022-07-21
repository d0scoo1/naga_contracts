pragma solidity ^0.5.7;

import "./ERC20Standard.sol";

contract NewToken is ERC20Standard {
	constructor() public {
		totalSupply = 22000000;
		name = "MafiaPayment Token";
		decimals = 5;
		symbol = "MPT";
		version = "1.0";
		balances[msg.sender] = totalSupply;
	}
}
