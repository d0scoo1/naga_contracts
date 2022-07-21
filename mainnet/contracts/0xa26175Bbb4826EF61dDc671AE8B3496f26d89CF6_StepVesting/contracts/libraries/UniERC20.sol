// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";


library UniERC20 {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    function isETH(IERC20 token) internal pure returns(bool) {
        return (address(token) == address(0));
    }

    function uniBalanceOf(IERC20 token, address account) internal view returns (uint256) {
        if (isETH(token)) {
            return account.balance;
        } else {
            return token.balanceOf(account);
        }
    }

    function uniTransfer(IERC20 token, address payable to, uint256 amount) internal {
        if (amount > 0) {
            if (isETH(token)) {
                to.transfer(amount);
            } else {
                token.safeTransfer(to, amount);
            }
        }
    }

    function uniTransferFrom(IERC20 token, address payable from, address to, uint256 amount) internal {
        if (amount > 0) {
            if (isETH(token)) {
                require(msg.value >= amount, "UniERC20: not enough value");
                require(from == msg.sender, "from is not msg.sender");
                require(to == address(this), "to is not this");
                if (msg.value > amount) {
                    // Return remainder if exist
                    from.transfer(msg.value.sub(amount));
                }
            } else {
                token.safeTransferFrom(from, to, amount);
            }
        }
    }
}
