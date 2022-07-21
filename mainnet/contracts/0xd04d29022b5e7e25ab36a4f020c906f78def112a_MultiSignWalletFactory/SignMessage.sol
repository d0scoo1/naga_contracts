// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

library SignMessage {
    function transferMessage(address wallet, uint256 chainID, address tokenAddress, address to, uint256 value, bytes32 salt) internal pure returns (bytes32) {
        bytes32 message = keccak256(abi.encodePacked(wallet, chainID, tokenAddress, to, value, salt));
        return messageToSign(message);
    }

    function executeWithDataMessage(address wallet, uint256 chainID, address contractAddress, uint256 value, bytes32 salt, bytes memory data) internal pure returns (bytes32) {
        bytes32 message = keccak256(abi.encodePacked(wallet, chainID, contractAddress, value, salt, data));
        return messageToSign(message);
    }

    function batchTransferMessage(address wallet, uint256 chainID, address tokenAddress, address[] memory recipients, uint256[] memory amounts, bytes32 salt) internal pure returns (bytes32) {
        bytes32 message = keccak256(abi.encodePacked(wallet, chainID, tokenAddress, recipients, amounts, salt));
        return messageToSign(message);
    }

    function ownerReplaceMessage(address wallet, uint256 chainID, address[] memory _oldOwners, address[] memory _newOwners, uint256 _required, bytes32 salt) internal pure returns (bytes32) {
        bytes32 message = keccak256(abi.encodePacked(wallet, chainID, _oldOwners, _newOwners, _required, salt));
        return messageToSign(message);
    }

    function ownerModifyMessage(address wallet, uint256 chainID, address[] memory _owners, uint256 _required, bytes32 salt) internal pure returns (bytes32) {
        bytes32 message = keccak256(abi.encodePacked(wallet, chainID, _owners, _required, salt));
        return messageToSign(message);
    }

    function ownerRequiredMessage(address wallet, uint256 chainID, uint256 _required, bytes32 salt) internal pure returns (bytes32) {
        bytes32 message = keccak256(abi.encodePacked(wallet, chainID, _required, salt));
        return messageToSign(message);
    }

    function securitySwitchMessage(address wallet, uint256 chainID, bool swithOn, uint256 _deactivatedInterval, bytes32 salt) internal pure returns (bytes32) {
        bytes32 message = keccak256(abi.encodePacked(wallet, chainID, swithOn, _deactivatedInterval, salt));
        return messageToSign(message);
    }

    function modifyExceptionTokenMessage(address wallet, uint256 chainID, address[] memory _tokens, bytes32 salt) internal pure returns (bytes32) {
        bytes32 message = keccak256(abi.encodePacked(wallet, chainID, _tokens, salt));
        return messageToSign(message);
    }

    function messageToSign(bytes32 message) internal pure returns (bytes32) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        return keccak256(abi.encodePacked(prefix, message));
    }
}