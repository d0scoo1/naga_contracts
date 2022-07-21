// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Whitelist is Ownable {
    constructor() {}

    address public whitelistSigner;
    mapping(bytes => bool) public signatureUsed;

    modifier isSenderWhitelisted(bytes32 hash, bytes calldata sig) {
        bytes32 messageDigest = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
        );
        require(
            ECDSA.recover(messageDigest, sig) == whitelistSigner,
            "Whitelist: Invalid signature"
        );
        require(!signatureUsed[sig], "Whitelist: Reused Signature");
        _;
    }

    function setWhitelistSigner(address signer) external onlyOwner {
        whitelistSigner = signer;
    }
}
