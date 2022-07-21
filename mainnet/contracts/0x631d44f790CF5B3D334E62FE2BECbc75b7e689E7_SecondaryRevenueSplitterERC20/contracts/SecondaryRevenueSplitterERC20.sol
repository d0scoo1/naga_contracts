// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/finance/PaymentSplitter.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

/*
* @title Contract to receive and split revenues from secondary market sales
*/
contract SecondaryRevenueSplitterERC20 is PaymentSplitter, Ownable  {

    constructor(
        address[] memory payees,
        uint256[] memory shares_
    ) PaymentSplitter(payees, shares_) {} 

    receive() external payable override {
        emit PaymentReceived(_msgSender(), msg.value);
    }  

    /**
     * @notice Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
     * total shares and their previous withdrawals.
     * 
     * @param account the payee to release funds for
     */
    function release(address payable account) public override {
        require(msg.sender == account || msg.sender == owner(), "Release: no permission");

        super.release(account);
    }    

    /**
     * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
     * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
     * contract.
     */
    function release(IERC20 token, address account) public override {
        require(msg.sender == account || msg.sender == owner(), "Release: no permission");

        super.release(token, account);
    }

    function withdrawEther(address payable _to, uint256 _amount) external onlyOwner {
        _to.transfer(_amount);
    }       
}