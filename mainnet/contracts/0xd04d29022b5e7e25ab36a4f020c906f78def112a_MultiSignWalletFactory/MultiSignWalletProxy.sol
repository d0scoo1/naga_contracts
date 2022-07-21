// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "./MultiSignWallet.sol";
import "./IMultiSignWalletFactory.sol";

contract MultiSignWalletProxy {
    address immutable private walletFactory;

    constructor() {
        walletFactory = msg.sender;
    }

    receive() external payable {}

    fallback() external {
        address impl = IMultiSignWalletFactory(walletFactory).getWalletImpl();
        assembly {
            let ptr := mload(0x40)
            let size := calldatasize()
            calldatacopy(ptr, 0, size)
            let result := delegatecall(gas(), impl, ptr, size, 0, 0)
            size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
                case 0 {
                    revert(ptr, size)
                }
                default {
                    return(ptr, size)
                }
        }
    }
}