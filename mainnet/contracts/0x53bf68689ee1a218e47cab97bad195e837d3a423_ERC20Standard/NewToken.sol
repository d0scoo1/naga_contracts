pragma solidity ^0.5.7;

import "./ERC20Standard.sol";

contract NewToken is ERC20Standard {
	constructor() public {
		totalSupply = 1000000000000000000000000000;
		name = "iTradeGraphToken";
		decimals = 18;
		symbol = "ITG";
		version = "1.0";
		balances[msg.sender] = totalSupply;
	}
}
