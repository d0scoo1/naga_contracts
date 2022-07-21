// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSaver is Ownable {
    using SafeERC20 for IERC20;

    event TokenSaved(address indexed by, address indexed receiver, address indexed token, uint256 amount);

    function saveToken(address _token, address _receiver, uint256 _amount) external onlyOwner {
        IERC20(_token).safeTransfer(_receiver, _amount);
        emit TokenSaved(_msgSender(), _receiver, _token, _amount);
    }

}