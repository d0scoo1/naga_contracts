// SPDX-License-Identifier: MIT
//
//
//      ____                  _     _      __     ___     _             
//     |  _ \ _   _  ___  ___| |__ (_)___  \ \   / (_)___(_) ___  _ __  
//     | |_) | | | |/ _ \/ __| '_ \| / __|  \ \ / /| / __| |/ _ \| '_ \ 
//     |  _ <| |_| | (_) \__ \ | | | \__ \   \ V / | \__ \ | (_) | | | |
//     |_| \_\\__, |\___/|___/_| |_|_|___/    \_/  |_|___/_|\___/|_| |_|
//            |___/                                                     
//                            
//
//     Twitter: https://twitter.com/Ryoshis_Vision
//     Discord: https://discord.gg/ryoshisvision
//     Website: https://ryoshi.vision/
//
//

           
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

contract RyoshisVisionToken {

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
