// SPDX-License-Identifier: MPL-2.0

pragma solidity >=0.8.0;

import "../../node_modules/@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

/** 
 * @title EE seed token is used to track venture investments before the public round.
 *
 * @dev EE seed token will be exchanged to Greet ecosystem token, 
 * implements a version of ERC-1404 (without sender and value) to restrict trading. 
 *
 * Fully managed (mint, burn, pause) by Greet DAO multisig.
 */
contract EESeedToken is ERC20PresetMinterPauser {
    uint8 public constant SUCCESS_CODE = 1;
    uint8 public constant ERROR_NOT_WHITELISTED_CODE = 2;
    
    string public constant SUCCESS_MESSAGE = "SUCCESS";
    string public constant ERROR_FAILURE = "FAILURE";
    string public constant ERROR_NOT_WHITELISTED = "Recipient is not allowed to recieve";

    mapping (address => bool) public whitelistedRecipients;

    /** 
     * @dev Setup seed token.
     */
    constructor() ERC20PresetMinterPauser("EE seed token", "seedEE") {
    }

    modifier notRestricted(address _to) {
        uint8 _restrictionCode = detectTransferRestriction(_to);
        require(_restrictionCode == SUCCESS_CODE, messageForTransferRestriction(_restrictionCode));
        _;
    }
    
    /**
     * @dev Checks that transfers to recipient are authorized.
     *
     * @param _recipient Reciever of tokens.
     * @return operation result code.
     */
    function detectTransferRestriction(address _recipient) public view returns (uint8) {
        if (whitelistedRecipients[_recipient]) {
            return SUCCESS_CODE;
        }
        return ERROR_NOT_WHITELISTED_CODE;
    }

    /**
     * @dev Human readable error message in scope of ERC1404 implementation.
     *
     * @param _restrictionCode Numeric error code
     * @return string with human-reable error.
     */ 
    function messageForTransferRestriction(uint8 _restrictionCode) public pure returns (string memory) {
        if (_restrictionCode == SUCCESS_CODE) {
            return SUCCESS_MESSAGE;
        }
        if (_restrictionCode == ERROR_NOT_WHITELISTED_CODE) {
            return ERROR_NOT_WHITELISTED;
        }
        return ERROR_FAILURE;
    }
    
    /**
     * @dev Transfer tokens between transaction sender and recipient if authorized.
     *
     * @param _recipient Reciever of tokens.
     * @param _value Amount of token to be transfered (wei-like numeric).
     * @return true if transfer was successful.
     */
    function transfer(
        address _recipient,
        uint256 _value
    ) public override(ERC20) notRestricted(_recipient) returns (bool) {
        return super.transfer(_recipient, _value);
    }

    /**
     * @dev Transfer tokens between sender and recipient in scope of approval protocol if authorized.
     *
     * @param _sender Owner of tokens.
     * @param _recipient Reciever of tokens.
     * @param _value Amount of token to be transfered (wei-like numeric).
     * @return true if transfer was successful.
     */
    function transferFrom(
        address _sender,
        address _recipient,
        uint256 _value
    ) public override(ERC20) notRestricted(_recipient) returns (bool) {
        return super.transferFrom(_sender, _recipient, _value);
    }

    /**
     * @dev Whitelist new recipient address or remove previous whitelisting.
     *
     * @param _recipient Allow to recieve token from any address.
     * @param _whitelisted true to whitelist, false to revoke. 
     */
    function recipientPermissionManager(address _recipient, bool _whitelisted) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "must have admin role to whitelist");
        whitelistedRecipients[_recipient] = _whitelisted;
    }
}