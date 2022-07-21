// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract TokenVault is OwnableUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;

    string public constant flag = "Mining";

    function initialize() public initializer {
        __Ownable_init();
    }

    /**
     * @dev the owner will transfer to time lock
     */
    function withdraw(
        address recipient,
        address token,
        uint256 amount
    ) public onlyOwner {
        IERC20Upgradeable(token).safeTransfer(recipient, amount);
    }

    /**
     * @dev Contract might receive/hold ETH as part of the maintenance process.
     */
    receive() external payable {}
}
