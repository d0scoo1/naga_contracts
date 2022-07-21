// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "./interfaces/IDropperToken.sol";
import "./interfaces/ICollectionsRegistry.sol";

contract DropRewardEscrow is Ownable, ERC1155Holder {
    IDropperToken public dropperToken;
    ICollectionsRegistry public collectionsRegistry;

    constructor(address dropperTokenAddress, address collectionsRegistryAddress) {
        dropperToken = IDropperToken(dropperTokenAddress);
        collectionsRegistry = ICollectionsRegistry(collectionsRegistryAddress);
    }

    receive() external payable { }

    function claimRewards(uint256[] calldata ids) external onlyOwner {
        dropperToken.claimRewardBatch(ids);
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawTokens(address contractAddress) external {
        require(collectionsRegistry.isCollectionApproved(contractAddress), "DropRewardEscrow: not approved in registry");

        address contractOwner = Ownable(contractAddress).owner();
        require(contractOwner == msg.sender, "DropRewardEscrow: not a token contract owner");

        uint256 id = dropperToken.getId(contractAddress);
        dropperToken.claimTokens(id);

        uint256 amount = dropperToken.balanceOf(address(this), id);
        dropperToken.safeTransferFrom(address(this), contractOwner, id, amount, "");
    }
}
