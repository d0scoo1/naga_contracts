// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



//   ______      _____    __ __     _____     _____    ______      _____     _____  __ __     __    _____  __   __    _____   ______  
//  /_/\___\    /\___/\  /_/\__/\ /\  __/\   /\___/\  /_/\___\   /\_____\  /\_____\/_/\__/\  /\_\ /\_____\/_/\ /\_\  /\ __/\ / ____/\ 
//  ) ) ___/   / / _ \ \ ) ) ) ) )) )(_ ) ) / / _ \ \ ) ) ___/  ( (_____/ ( (  ___/) ) ) ) ) \/_/( (_____/) ) \ ( (  ) )  \ \) ) __\/ 
// /_/ /  ___  \ \(_)/ //_/ /_/_// / __/ /  \ \(_)/ //_/ /  ___  \ \__\    \ \ \_ /_/ /_/_/   /\_\\ \__\ /_/   \ \_\/ / /\ \ \\ \ \   
// \ \ \_/\__\ / / _ \ \\ \ \ \ \\ \  _\ \  / / _ \ \\ \ \_/\__\ / /__/_   / / /_\\ \ \ \ \  / / // /__/_\ \ \   / /\ \ \/ / /_\ \ \  
//  )_)  \/ _/( (_( )_) ))_) ) \ \) )(__) )( (_( )_) ))_)  \/ _/( (_____\ / /____/ )_) ) \ \( (_(( (_____\)_) \ (_(  ) )__/ /)____) ) 
//  \_\____/   \/_/ \_\/ \_\/ \_\/\/____\/  \/_/ \_\/ \_\____/   \/_____/ \/_/     \_\/ \_\/ \/_/ \/_____/\_\/ \/_/  \/___\/ \____\/  
                                                                                                                                   


import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

contract GarbageFriends{
   //GarbageFriends                                                     
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

