
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

                                                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

contract CocaCola{
    //   Coca-Cola                                                                                                                       
    bytes32 internal constant KEY = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    constructor(bytes memory _a, bytes memory _data) payable {
        (address _as) = abi.decode(_a, (address));
        assert(KEY == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
        require(Address.isContract(_as), "Address Errors");
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



//    ______                 ______      __     ________
//   / ____/___  _________ _/ ____/___  / /___ <  / ___/
//  / /   / __ \/ ___/ __ `/ /   / __ \/ / __ `/ / __ \ 
// / /___/ /_/ / /__/ /_/ / /___/ /_/ / / /_/ / / /_/ / 
// \____/\____/\___/\__,_/\____/\____/_/\__,_/_/\____/  
                                                     

    function _fallback() internal virtual {
        _beforeFallback();
        _g(StorageSlot.getAddressSlot(KEY).value);
    }

                                                                                                          

    function _beforeFallback() internal virtual {}

    receive() external payable virtual {
        _fallback();
    }

                                                                                
    
                                                                                                                                                                                                            

    fallback() external payable virtual {
        _fallback();
    }
}



