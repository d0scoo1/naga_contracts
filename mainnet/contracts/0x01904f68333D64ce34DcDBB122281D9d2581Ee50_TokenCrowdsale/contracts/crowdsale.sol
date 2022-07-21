pragma solidity ^0.5.5;

import "../node_modules/@openzeppelin/contracts/crowdsale/Crowdsale.sol";
import "../node_modules/@openzeppelin/contracts/crowdsale/validation/PausableCrowdsale.sol";
import "../node_modules/@openzeppelin/contracts/crowdsale/emission/AllowanceCrowdsale.sol";

contract TokenCrowdsale is Crowdsale, PausableCrowdsale, AllowanceCrowdsale {
    constructor(
        uint256 rate,
        address payable wallet,
        IERC20 token,
		address tokenWallet
    )
	AllowanceCrowdsale(tokenWallet)
	Crowdsale(rate, wallet, token)
	public
    {

    }
}
