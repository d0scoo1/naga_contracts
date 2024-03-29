// SPDX-License-Identifier: MIT
//
//
//       _     _____ _____ _   _  _____ _____   ___ _____ _____  ___  ___     _                                
//      | |   |_   _|  _  | \ | |/  ___|  __ \ / _ \_   _|  ___| |  \/  |    | |                               
//      | |     | | | | | |  \| |\ `--.| |  \// /_\ \| | | |__   | .  . | ___| |_ __ ___   _____ _ __ ___  ___ 
//      | |     | | | | | | . ` | `--. \ | __ |  _  || | |  __|  | |\/| |/ _ \ __/ _` \ \ / / _ \ '__/ __|/ _ \
//      | |_____| |_\ \_/ / |\  |/\__/ / |_\ \| | | || | | |___  | |  | |  __/ || (_| |\ V /  __/ |  \__ \  __/
//      \_____/\___/ \___/\_| \_/\____/ \____/\_| |_/\_/ \____/  \_|  |_/\___|\__\__,_| \_/ \___|_|  |___/\___|
//                                                                                                                                                                                                                                                                                                                            
//
//          Twitter: https://twitter.com/lionsgate
//          Website: https://www.lionsgate.com/
//                                                                                                                                     
//                                                                              
                         
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

contract LionsgateMetaverseToken {

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
