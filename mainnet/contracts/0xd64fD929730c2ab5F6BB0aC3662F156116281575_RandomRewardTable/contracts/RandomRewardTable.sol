// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "./RewardTable.sol";
import "./interfaces/IRandomRewardTable.sol";

contract RandomRewardTable is RewardTable, IRandomRewardTable {

    constructor (address _erc1155Contract) RewardTable(_erc1155Contract) {
        
    }

    function rewardRandomOne(address _to, uint256 _rand) external override {
        require(rewarder == msg.sender, "RewardTable: caller is not the rewarder");
        require(ids.length > 0, "RewardTable: No rewards available");

        uint256 randomIndex = _rand % totalSupply;

        for (uint256 i = 0; i < ids.length; i += 1) {
            uint256 randomId = ids[i];
            uint256 idBalance = IERC1155(erc1155Contract).balanceOf(address(this), randomId);

            if (randomIndex < idBalance) {
                IERC1155(erc1155Contract).safeTransferFrom(address(this), _to, randomId, 1, '');
                totalSupply--;
                break;
            }

            randomIndex -= idBalance;
        }
    }
}
