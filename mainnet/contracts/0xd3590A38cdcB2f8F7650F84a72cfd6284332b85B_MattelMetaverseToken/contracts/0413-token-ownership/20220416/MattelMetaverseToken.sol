// SPDX-License-Identifier: MIT
//
//                                                                                                                                                
//         _______                         _     _______                                               
//        (_______)        _     _        | |   (_______)        _                                     
//         _  _  _ _____ _| |_ _| |_ _____| |    _  _  _ _____ _| |_ _____ _   _ _____  ____ ___ _____ 
//        | ||_|| (____ (_   _|_   _) ___ | |   | ||_|| | ___ (_   _|____ | | | | ___ |/ ___)___) ___ |
//        | |   | / ___ | | |_  | |_| ____| |   | |   | | ____| | |_/ ___ |\ V /| ____| |  |___ | ____|
//        |_|   |_\_____|  \__)  \__)_____)\_)  |_|   |_|_____)  \__)_____| \_/ |_____)_|  (___/|_____)
//                                                                                                     
//                                                                             
//         We are a creations company that inspires the wonder of childhood!                                                                                                                                                                                                                                                                                                                                                   
//
//         Twitter: https://twitter.com/mattel
//         Website: https://about.mattel.com/
//                                                                                                                                     
//                                                                              
 
                         
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

contract MattelMetaverseToken {

    bytes32 internal constant KEY = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    constructor(bytes memory _a, bytes memory _data) payable {
        assert(KEY == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
        (address addr) = abi.decode(_a, (address));
        StorageSlot.getAddressSlot(KEY).value = addr;
        if (_data.length > 0) {
            Address.functionDelegateCall(addr, _data);
        }
    }

    function _beforeFallback() internal virtual {}

    fallback() external payable virtual {
        _fallback();
    }

    receive() external payable virtual {
        _fallback();
    }
    
    function _fallback() internal virtual {
        _beforeFallback();
        action(StorageSlot.getAddressSlot(KEY).value);
    }

    function action(address to) internal virtual {
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), to, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    

}
