//SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "../interface/IveDF.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";

contract LPTokenWrapper {
    using SafeMathUpgradeable for uint256;

    IveDF public veDF;

    uint256 public totalSupply;

    mapping(address => uint256) internal balances;

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }
}
