//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "Ownable.sol";
import "LlamaPay.sol";

contract LlamaPayFactory is Ownable {
    mapping(address => address) public payContracts;
    mapping(uint => address) public payContractsArray;
    uint public payContractsArrayLength;

    event LlamaPayCreated(address token, address llamaPay);

    address public token;
    function createPayContract(address _token) external returns (address newContract) {
        require(payContracts[_token] == address(0), "already exists");
        token = _token;
        newContract = address(new LlamaPay());
        delete token;
        payContracts[_token] = newContract;
        payContractsArray[payContractsArrayLength] = newContract;
        unchecked{
            payContractsArrayLength++;
        }
        emit LlamaPayCreated(_token, address(newContract));
    }
}
