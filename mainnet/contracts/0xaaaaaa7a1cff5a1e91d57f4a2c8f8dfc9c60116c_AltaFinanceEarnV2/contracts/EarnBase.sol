//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract EarnBase is Ownable, Pausable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    event Withdrawal(address indexed sender, uint256 amount);
    event Received(address, uint);

    ///
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    /**
     * @param _token - token to be withdrawn
     * @param _to - address to withdraw to
     * @param _amount - amount of token to withdraw
     */
    function withdrawToken(
        IERC20 _token,
        address _to,
        uint256 _amount
    ) public onlyOwner nonReentrant {
        require(_token.balanceOf(address(this)) >= _amount, "Not enough token");
        SafeERC20.safeTransfer(_token, _to, _amount);
        emit Withdrawal(_to, _amount);
    }

    /**
     * @param _to address of transfer recipient
     * @param _amount amount of ether to be transferred
     */
    // Function to transfer Ether from this contract to address from input
    function transfer(address payable _to, uint256 _amount) public onlyOwner {
        // Note that "to" is declared as payable
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }

    /**
     * Pause the contract
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * Unpause the contract
     */
    function unpause() external onlyOwner {
        _unpause();
    }
}
