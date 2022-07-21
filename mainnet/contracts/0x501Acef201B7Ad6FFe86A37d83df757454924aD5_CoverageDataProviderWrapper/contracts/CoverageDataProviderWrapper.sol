// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.9;

import "sgn-v2-contracts/contracts/message/framework/MessageSenderApp.sol";
import "sgn-v2-contracts/contracts/message/framework/MessageReceiverApp.sol";

import "./interfaces/ICoverageDataProviderV2.sol";
import "./interfaces/utils/IRegistry.sol";
import "./utils/MultichainWrapper.sol";

contract CoverageDataProviderWrapper is MultichainWrapper, MessageSenderApp, MessageReceiverApp {

    /***************************************
     TYPE DEFINITIONS
    ***************************************/

    struct MessageRequest {
        uint64 nonce;
        OperationType operationType;
        string[] uwpNames;
        uint256[] uwpAmounts;
    }

    enum OperationType {
        SET,
        REMOVE
    }

    /***************************************
     STATE VARIABLES
    ***************************************/

    /// @notice The source chain CoverageDataProviderAddress.
    address public coverageDataProvider;

    /// @notice The nonce value to count message sending.
    uint64 public nonce;

    /***************************************
     EVENTS
    ***************************************/

    /// @notice Emitted when a message is received.
    event MessageReceived(address sender, uint64 srcChainId, uint64 nonce, bytes message);

    /// @notice Emitted when coverage data provider is set.
    event CoverageDataProviderSet(address coverageDataProvider);

    /**
     * @notice Constructs wrapper `CoverageDataProviderWrapper`.
     * @param _governance The governor address.
     * @param _registry The registry address.
    */
    constructor(address _governance, address _registry) MultichainWrapper(_governance) {
        require(_registry != address(0x0), "zero address registry");
        IRegistry registry = IRegistry(_registry);
        (bool success1, address _messageBus) = registry.tryGet("messagebus");
        require(success1, "zero address messagebus");
        messageBus = _messageBus;
        (bool success2, address _coverageDataProvider) = registry.tryGet("coverageDataProvider");
        require(success2, "zero address data provider");
        coverageDataProvider = _coverageDataProvider;
    }

    /**
      * @notice Resets and sets the underwriting pool balances.
      * @param _uwpNames The underwriting pool values to set.
      * @param _amounts The underwriting pool balances in `USD`.
    */
    function set(string[] calldata _uwpNames, uint256[] calldata _amounts) external payable isCaller {
        require(_uwpNames.length == _amounts.length, "length mismatch");

        // call operation in same chain
        ICoverageDataProviderV2(coverageDataProvider).set(_uwpNames, _amounts);

        // increment nonce
        nonce++;

        // pack & send message to destination chains
        bytes memory message = abi.encode(
              MessageRequest({
                nonce: nonce,
                operationType: OperationType.SET,
                uwpNames: _uwpNames,
                uwpAmounts: _amounts
              })
        );
        _sendMessage(message, msg.value);
    }

    /**
     * @notice Removes the given underwriting pool.
     * @param _uwpNames The underwriting pool names to remove.
    */
    function remove(string[] calldata _uwpNames) external payable isCaller {
        // call operation in same chain
        ICoverageDataProviderV2(coverageDataProvider).remove(_uwpNames);

        // increment nonce
        nonce++;

        // pack & send message to destination chains
        bytes memory message = abi.encode(
              MessageRequest({
                nonce: nonce,
                operationType: OperationType.REMOVE,
                uwpNames: _uwpNames,
                uwpAmounts: new uint256[](0)
              })
        );
        _sendMessage(message, msg.value);
    }

    /**
     * @notice Executes message that sent by source chain.
     * @param _sender The message sender address.
     * @param _srcChainId The chain that message is sent.
     * @param _message The message to execute.
    */
    function executeMessage(
        address _sender,
        uint64 _srcChainId,
        bytes calldata _message,
        address // executor
    ) external payable override onlyMessageBus returns (ExecutionStatus) {
        // decode message
        MessageRequest memory request = abi.decode((_message), (MessageRequest));

        // execute operation
        if (request.operationType == OperationType.SET) {
           ICoverageDataProviderV2(coverageDataProvider).set(request.uwpNames, request.uwpAmounts);
        } else if (request.operationType == OperationType.REMOVE) {
           ICoverageDataProviderV2(coverageDataProvider).remove(request.uwpNames);
        }

        emit MessageReceived(_sender, _srcChainId, request.nonce, _message);
        return ExecutionStatus.Success;
    }

    /***************************************
     GOVERNANCE FUNCTIONS
    ***************************************/

    /**
     * @notice Sets new coverage data provider address.
     * @param _coverageDataProvider The new coverage data provider address to set.
    */
    function setCoverageDataProvider(address _coverageDataProvider) external onlyGovernance {
        coverageDataProvider = _coverageDataProvider;
        emit CoverageDataProviderSet(_coverageDataProvider);
    }

    /***************************************
     INTERNAL FUNCTIONS
    ***************************************/

    /**
     * @notice Sends the message to the destination chain coverega data providers.
     * @param message The message to send.
     * @param fee The fee value to execute messages.
    */
    function _sendMessage(bytes memory message, uint256 fee) internal {
        for (uint256 i = 0; i < _receivers.length; i++) {
          ReceiverInfo memory receiverInfo = _receivers[i];
          sendMessage(receiverInfo.dst, receiverInfo.chainId, message, fee);
        }
    }
}
