// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../interfaces/IERC677.sol";

interface IBurnableMintableERC677Token is IERC677 {
    function mint(address _to, uint256 _amount) external returns (bool);
    function burn(uint256 _value) external;
    function claimTokens(address _token, address _to) external;
}
