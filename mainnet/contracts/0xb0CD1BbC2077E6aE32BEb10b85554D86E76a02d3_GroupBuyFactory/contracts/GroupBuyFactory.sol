//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

interface IGroupBuy {
    function initialize(address token, uint threshold, uint deadline) external;
}

contract GroupBuyFactory is Context, Ownable {

    event GroupBuyCreated(address groupBuy, address indexed token);
    address groupBuyContract;

    constructor(address groupBuyAddress) {
        groupBuyContract = groupBuyAddress;
    }

    function createGroupBuy(address token, uint buySize, uint deadline) public onlyOwner() returns (address new_groupBuy) {
        new_groupBuy = Clones.clone(groupBuyContract);
        IGroupBuy(new_groupBuy).initialize(token, buySize, deadline);
        emit GroupBuyCreated(new_groupBuy, token);
        Ownable(new_groupBuy).transferOwnership(owner());
    }    
}
