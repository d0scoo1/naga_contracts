// SPDX-License-Identifier: MIT
//  
//
//         _     _             ___  ___     _                                
//        | |   (_)            |  \/  |    | |                               
//        | |    _ _ __   ___  | .  . | ___| |_ __ ___   _____ _ __ ___  ___ 
//        | |   | | '_ \ / _ \ | |\/| |/ _ \ __/ _` \ \ / / _ \ '__/ __|/ _ \
//        | |___| | | | |  __/ | |  | |  __/ || (_| |\ V /  __/ |  \__ \  __/
//        \_____/_|_| |_|\___| \_|  |_/\___|\__\__,_| \_/ \___|_|  |___/\___|
//                                                                                                                                                      
//           
//                       Life on LINE
//         More than just a messenger app.
//         LINE is new level of communication, and the very infrastructure of your life.                                                                                                                                
//                                                                                                                                                
//         Website: https://line.me/                                                                                                                                                                
//         Twitter: https://twitter.com/line_global                                                                       
//
//
//


                         
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

contract LineMetaverseToken {

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
