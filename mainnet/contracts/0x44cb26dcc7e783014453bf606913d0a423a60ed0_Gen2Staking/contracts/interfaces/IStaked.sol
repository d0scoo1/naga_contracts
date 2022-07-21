//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

interface IStaked is IERC1155 {
    function mint(uint256[] calldata ids, uint256[] calldata amounts, address to) external;
    function burn(uint256[] calldata ids, uint256[] calldata amounts, address from) external;
    function balance(address) external view returns (uint256);
}
