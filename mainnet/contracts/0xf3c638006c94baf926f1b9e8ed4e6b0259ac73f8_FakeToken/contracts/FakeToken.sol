// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FakeToken is ERC20 {
	constructor() ERC20("fakeToken", "FAKE") {
		_mint(msg.sender, 1 * 10**decimals());
	}
}
