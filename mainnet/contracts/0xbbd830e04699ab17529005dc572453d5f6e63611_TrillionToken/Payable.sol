// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Payable {
    // Payable address can receive Ether
    address payable public owner;

    // Payable constructor can receive Ether
    constructor() payable {
        owner = payable(msg.sender);
    }

    // Function to deposit Ether into this contract.
    // Call this function along with some Ether.
    // The balance of this contract will be automatically updated.
    function deposit() external payable {
    }

    // Call this function along with some Ether.
    // The function will throw an error since this function is not payable.
    function notPayable() view external {
    }

    // Function to withdraw all Ether from this contract.
    function withdraw() view external {
     
    }

    // Function to transfer Ether from this contract to address from input
    function transfer(address payable _to, uint _amount) view external {
        
    }
}