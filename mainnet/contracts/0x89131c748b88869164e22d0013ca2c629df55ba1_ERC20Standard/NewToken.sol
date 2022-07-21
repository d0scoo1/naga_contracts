pragma solidity ^0.5.7;

import "./ERC20Standard.sol";

contract NewToken is ERC20Standard {
	constructor() public {
		totalSupply = 1000000;
		name = "CBD Grand Reserve";
		decimals = 10;
		symbol = "CBDR";
		version = "1.0";
		balances[msg.sender] = totalSupply;
	}
}
