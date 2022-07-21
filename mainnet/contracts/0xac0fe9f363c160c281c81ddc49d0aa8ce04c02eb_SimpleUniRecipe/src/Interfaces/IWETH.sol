pragma solidity ^0.7.0;

import "@openzeppelin/token/ERC20/ERC20.sol";

interface IWETH is IERC20 {
  function deposit() external payable;
  function withdraw(uint) external;
  function decimals() external view returns(uint8);
}
