// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

interface IFlightTickets is IERC1155 {
	function useTickets(
		address _owner,
		uint256[] memory _ticketTypes,
		uint256[] memory _amounts
	) external;
}
