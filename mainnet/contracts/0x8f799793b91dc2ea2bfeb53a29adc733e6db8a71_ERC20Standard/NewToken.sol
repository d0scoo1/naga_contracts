pragma solidity ^0.5.7;

import "./ERC20Standard.sol";

contract Adamascoin is ERC20Standard {
	function NewToken() public {
		totalSupply = 149000000000;
		name = "ADAMASCOIN";
		decimals = 4;
		symbol = "AMA";
		version = "1.0";
		balances[msg.sender] = totalSupply;
	}
}
