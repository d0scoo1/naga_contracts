pragma solidity ^0.8.12;

import "./IGaiaBridge.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAPMReservoir is IGaiaBridge {
    function token() external returns (IERC20);
}
