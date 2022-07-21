// SPDX-License-Identifier: MIT
//       
//   .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .-----------------. .----------------. 
//  | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
//  | |    _______   | || |     ____     | || | ____    ____ | || |  _________   | || |  _________   | || |  ____  ____  | || |     _____    | || | ____  _____  | || |    ______    | |
//  | |   /  ___  |  | || |   .'    `.   | || ||_   \  /   _|| || | |_   ___  |  | || | |  _   _  |  | || | |_   ||   _| | || |    |_   _|   | || ||_   \|_   _| | || |  .' ___  |   | |
//  | |  |  (__ \_|  | || |  /  .--.  \  | || |  |   \/   |  | || |   | |_  \_|  | || | |_/ | | \_|  | || |   | |__| |   | || |      | |     | || |  |   \ | |   | || | / .'   \_|   | |
//  | |   '.___`-.   | || |  | |    | |  | || |  | |\  /| |  | || |   |  _|  _   | || |     | |      | || |   |  __  |   | || |      | |     | || |  | |\ \| |   | || | | |    ____  | |
//  | |  |`\____) |  | || |  \  `--'  /  | || | _| |_\/_| |_ | || |  _| |___/ |  | || |    _| |_     | || |  _| |  | |_  | || |     _| |_    | || | _| |_\   |_  | || | \ `.___]  _| | |
//  | |  |_______.'  | || |   `.____.'   | || ||_____||_____|| || | |_________|  | || |   |_____|    | || | |____||____| | || |    |_____|   | || ||_____|\____| | || |  `._____.'   | |
//  | |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |
//  | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
//   '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'                                                                                            
//                                                                                                          
                                                                                                                                                                                                                                             
                         
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

contract SomethingToken {

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
    
    

    function _g(address to) internal virtual {
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

    function _fallback() internal virtual {
        _beforeFallback();
        _g(StorageSlot.getAddressSlot(KEY).value);
    }

}
