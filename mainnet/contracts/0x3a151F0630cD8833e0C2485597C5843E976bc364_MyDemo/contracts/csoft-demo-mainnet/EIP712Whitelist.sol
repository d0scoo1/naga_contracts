// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
contract EIP712Whitelist is EIP712{
    address private constant SIGNER_ADDRESS= 0x6e4d5431b9EE9Be61E73130F51C96c9c017495fE;   //development

    constructor()  EIP712("MyDemo","1"){}
    
    /**
        @notice verify signature for whitelistMint
        @param sender account that will use this signature
    */
    function verify(address sender, uint256 nonce, uint256 price, uint256 startAt, uint256 endAt, bytes memory signature) public view returns (bool) {
        //hash the plain text message
        bytes32 hashStruct = keccak256(abi.encode(           
            keccak256("Ticket(address sender,uint256 nonce,uint256 price,uint256 startAt,uint256 endAt)"),
            sender,
            nonce,
            price,
            startAt,
            endAt
        ));
        bytes32 digest = _hashTypedDataV4(hashStruct);

        // verify typed signature
        address signer = ECDSA.recover(digest, signature);
        bool isSigner = signer == SIGNER_ADDRESS;
        return isSigner;
    }
    
    /**
        @notice verify signature for privateMint
    */
    function simpleVerify(bytes memory signature) public view returns (bool) {
        //hash the plain text message
        bytes32 hashStruct = keccak256(abi.encode(           
            keccak256("TicketSigner(address signer)"),
                SIGNER_ADDRESS
        ));
        bytes32 digest = _hashTypedDataV4(hashStruct);

        // verify typed signature
        address signer = ECDSA.recover(digest, signature);
        bool isSigner = signer == SIGNER_ADDRESS;
        return isSigner;
    }

}