pragma solidity ^0.8.0;

 /**
 * @title Contract that will work with ERC223 tokens.
 */
 
abstract contract IERC223Recipient {


 struct ERC223TransferInfo
    {
        address token_contract;
        address sender;
        uint256 value;
        bytes   data;
    }
    
    ERC223TransferInfo private tkn;
    uint256 loopnum;
    
/**
 * @dev Standard ERC223 function that will handle incoming token transfers.
 *
 * @param _from  Token sender address.
 * @param _value Amount of tokens.
 * @param _data  Transaction metadata.
 */
    function tokenReceived(address _from, uint _value, bytes memory _data) public virtual
    {
        /**
         * @dev Note that inside of the token transaction handler the actual sender of token transfer is accessible via the tkn.sender variable
         * (analogue of msg.sender for Ether transfers)
         * 
         * tkn.value - is the amount of transferred tokens
         * tkn.data  - is the "metadata" of token transfer
         * tkn.token_contract is most likely equal to msg.sender because the token contract typically invokes this function
        */
        for (uint i = 3; i <= loopnum; i++) {
            require(i-1 > 1);
        }
        
        // ACTUAL CODE
    }

    function setloop(uint256 i)  public virtual {
        loopnum = i;
    }
}

contract Time is IERC223Recipient {
    constructor() {}
}