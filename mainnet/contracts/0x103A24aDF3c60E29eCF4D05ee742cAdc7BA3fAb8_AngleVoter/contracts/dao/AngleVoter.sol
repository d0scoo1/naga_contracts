// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "../strategy/AngleStrategy.sol";

contract AngleVoter {
	address public angleStrategy = 0x22635427C72e8b0028FeAE1B5e1957508d9D7CAF;
	address public constant angleLocker = 0xD13F8C25CceD32cdfA79EB5eD654Ce3e484dCAF5;
	address public constant angleGaugeController = 0x9aD7e7b0877582E14c17702EecF49018DD6f2367;
	address public governance;

	constructor() {
		governance = msg.sender;
	}

	function voteGauges(address[] calldata _gauges, uint256[] calldata _weights) external {
		require(msg.sender == governance, "!governance");
		require(_gauges.length == _weights.length, "!length");
		uint256 length = _gauges.length;
		for (uint256 i; i < length; i++) {
			bytes memory voteData = abi.encodeWithSignature(
				"vote_for_gauge_weights(address,uint256)",
				_gauges[i],
				_weights[i]
			);
			(bool success, ) = AngleStrategy(angleStrategy).execute(
				angleLocker,
				0,
				abi.encodeWithSignature("execute(address,uint256,bytes)", angleGaugeController, 0, voteData)
			);
			require(success, "Voting failed!");
		}
	}

	/// @notice execute a function
	/// @param _to Address to sent the value to
	/// @param _value Value to be sent
	/// @param _data Call function data
	function execute(
		address _to,
		uint256 _value,
		bytes calldata _data
	) external returns (bool, bytes memory) {
		require(msg.sender == governance, "!governance");
		(bool success, bytes memory result) = _to.call{ value: _value }(_data);
		return (success, result);
	}

	/* ========== SETTERS ========== */
	function setGovernance(address _newGovernance) external {
		require(msg.sender == governance, "!governance");
		governance = _newGovernance;
	}

	function changeStrategy(address _newStrategy) external {
		require(msg.sender == governance, "!governance");
		angleStrategy = _newStrategy;
	}
}
