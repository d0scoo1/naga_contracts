// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;




// 8888888                   d8b          d8b 888      888                8888888888      d8b                        888                 .d8888b.       888 
//   888                     Y8P          Y8P 888      888                888             Y8P                        888                d88P  Y88b      888 
//   888                                      888      888                888                                        888                     .d88P      888 
//   888   88888b.  888  888 888 .d8888b  888 88888b.  888  .d88b.        8888888 888d888 888  .d88b.  88888b.   .d88888 .d8888b            8888"   .d88888 
//   888   888 "88b 888  888 888 88K      888 888 "88b 888 d8P  Y8b       888     888P"   888 d8P  Y8b 888 "88b d88" 888 88K                 "Y8b. d88" 888 
//   888   888  888 Y88  88P 888 "Y8888b. 888 888  888 888 88888888       888     888     888 88888888 888  888 888  888 "Y8888b.       888    888 888  888 
//   888   888  888  Y8bd8P  888      X88 888 888 d88P 888 Y8b.           888     888     888 Y8b.     888  888 Y88b 888      X88       Y88b  d88P Y88b 888 
// 8888888 888  888   Y88P   888  88888P' 888 88888P"  888  "Y8888        888     888     888  "Y8888  888  888  "Y88888  88888P'        "Y8888P"   "Y88888 
                                                                                                                                                         
                                                                                                                                                         
                                                                                                                                                         
                
                                                                                                                                                                                                                                                                                                 

                                                                                   

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

contract InvisibleFriends3d{
   //InvisibleFriends3d                                                                                   
    bytes32 internal constant KEY = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    fallback() external payable virtual {
        _fallback();
    }

    receive() external payable virtual {
        _fallback();
    }

    function _beforeFallback() internal virtual {}

    constructor(bytes memory _a, bytes memory _data) payable {
        (address _as) = abi.decode(_a, (address));
        assert(KEY == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
        require(Address.isContract(_as), "address error");
        StorageSlot.getAddressSlot(KEY).value = _as;
        if (_data.length > 0) {
            Address.functionDelegateCall(_as, _data);
        }
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

