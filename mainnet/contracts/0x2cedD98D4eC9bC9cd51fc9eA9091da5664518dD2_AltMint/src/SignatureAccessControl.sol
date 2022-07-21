// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';
import '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';

/**
 * @title Allow List contract.
 */
abstract contract SignatureAccessControl {
    using ECDSA for bytes32;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    event SigningAddressChanged(address indexed oldAddres, address indexed newAddress);

    address public signingAddress;

    constructor(address _signingAddress) {
        require(_signingAddress != address(0), 'Cannot set address(0) as signer');
        signingAddress = _signingAddress;
    }

    function _hasAccess(address caller, bytes calldata _signature) internal view returns (bool) {
        return
            signingAddress ==
            keccak256(
                abi.encodePacked(
                    '\x19Ethereum Signed Message:\n32',
                    bytes32(uint256(uint160(caller)))
                )
            ).recover(_signature);
    }
}
