// SPDX-License-Identifier: MIT

pragma solidity >=0.6.2 <0.8.0;
pragma abicoder v2;

import "../lib/LibPart.sol";

interface IRoyaltiesProvider {
    function getRoyalties(address token, uint256 tokenId) external returns (LibPart.Part[] memory);
}
