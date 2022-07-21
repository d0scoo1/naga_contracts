// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BRCAirdropV2 is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public BRCToken;
    mapping(address => bool) public isCollect;

    constructor(IERC20 _token) {
        BRCToken = _token;
    }

    function collect() external {
        require(_hour() >= 21 && _hour() <= 23, "Not within the airdrop time");
        require(!isCollect[msg.sender], "already received");
        isCollect[msg.sender] = true;
        BRCToken.safeTransfer(msg.sender, 10000 * 10**18);
    }

    function withdrawForOwner(address to, uint value) external onlyOwner {
        BRCToken.safeTransfer(to, value);
    }

    function _hour() internal view returns (uint) {
        return ((block.timestamp + 8 hours) % 1 days) / (60 * 60);
    }
}
