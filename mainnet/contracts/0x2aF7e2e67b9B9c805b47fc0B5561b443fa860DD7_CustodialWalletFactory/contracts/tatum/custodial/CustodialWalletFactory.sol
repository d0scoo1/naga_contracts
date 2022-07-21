// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CustodialWallet.sol";

contract CustodialWalletFactory {

    CustodialWallet private initialWallet;
    uint counter = 0;
    mapping(uint => address) wallets;

    event Created(address addr);

    constructor () {
        initialWallet = new CustodialWallet();
        wallets[counter] = address(initialWallet);
        counter++;
    }

    function cloneNewWallet(address owner, uint256 count) public {
        for (uint256 i = 0; i < count; i++) {
            address payable clone = createClone(address(initialWallet));
            CustodialWallet(clone).init(owner);
            wallets[counter] = clone;
            counter++;

            emit Created(clone);
        }
    }

    function createClone(address target) internal returns (address payable result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            result := create(0, clone, 0x37)
        }
    }

    function getWallets() external view returns(address[] memory){
        address[] memory result = new address[](counter);
        for(uint i=0; i<counter; i++){
            result[i] = wallets[i];
        }
        return result;
    }
}
