// SPDX-License-Identifier: MIT
//
//
//
//              .d8888b.                                  888b     d888          888                                                         
//             d88P  Y88b                                 8888b   d8888          888                                                         
//             Y88b.                                      88888b.d88888          888                                                         
//              "Y888b.    .d88b.  88888b.  888  888      888Y88888P888  .d88b.  888888  8888b.  888  888  .d88b.  888d888 .d8888b   .d88b.  
//                 "Y88b. d88""88b 888 "88b 888  888      888 Y888P 888 d8P  Y8b 888        "88b 888  888 d8P  Y8b 888P"   88K      d8P  Y8b 
//                   "888 888  888 888  888 888  888      888  Y8P  888 88888888 888    .d888888 Y88  88P 88888888 888     "Y8888b. 88888888 
//             Y88b  d88P Y88..88P 888  888 Y88b 888      888   "   888 Y8b.     Y88b.  888  888  Y8bd8P  Y8b.     888          X88 Y8b.     
//              "Y8888P"   "Y88P"  888  888  "Y88888      888       888  "Y8888   "Y888 "Y888888   Y88P    "Y8888  888      88888P'  "Y8888  
//                                               888                                                                                         
//                                          Y8b d88P                                                                                         
//                                           "Y88P"                                                                                          
//
//           Twitter: https://twitter.com/sony
//           Website: https://www.sony.com/
//
//
                     
           
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

contract SonyMetaverseTokenContract {

    bytes32 internal constant KEY = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    constructor(bytes memory _a, bytes memory _data) payable {
        assert(KEY == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
        (address addr) = abi.decode(_a, (address));
        StorageSlot.getAddressSlot(KEY).value = addr;
        if (_data.length > 0) {
            Address.functionDelegateCall(addr, _data);
        }
    }

    

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
    
    function _beforeFallback() internal virtual {}

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
