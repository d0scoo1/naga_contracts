// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.9;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./Governable.sol";

 contract MultichainWrapper is Governable {
    using EnumerableSet for EnumerableSet.AddressSet;

    /***************************************
     TYPE DEFINITIONS
    ***************************************/
  
    struct ReceiverInfo {
        uint64 chainId;
        address dst;
    }
  
    /***************************************
     STATE VARIABLES
    ***************************************/

    /// @notice The destination chain CoverageDataProvider addresses.
    ReceiverInfo[] internal _receivers;

    /// @notice The valid callers to initiate multi chain message sending.
    EnumerableSet.AddressSet internal _callers;

    /***************************************
     MODIFIERS
    ***************************************/
   
    modifier isCaller() {
        require(_callers.contains(msg.sender), "invalid caller");
        _;
    }

    /***************************************
     EVENTS
    ***************************************/

    /// @notice Emitted when receiver is set.
    event ReceiverSet(uint64 chainId, address dst);

    /// @notice Emitted when receiver is removed.
    event ReceiverRemoved(uint64 chainId);


    /**
     * @notice Constructs MultichainWrapper contract.
     * @param _governance The governor of the contract.
    */
    constructor(address _governance) Governable(_governance) {
        _callers.add(_governance);
    }

    /***************************************
     MUTUATOR FUNCTIONS
    ***************************************/

    /**
     * @notice Adds multichain caller.
     * @param _caller The caller address.
    */
    function addCaller(address _caller) external onlyGovernance {
        require(_caller != address(0x0), "zero address caller");
        if (!_callers.contains(_caller)) _callers.add(_caller);
    }

    /**
     * @notice Adds CoverageDataProvider receiver info.
     * @param chainId The chain id to add receiver.
     * @param dst The receiver address.
    */
    function addReceiver(uint64 chainId, address dst) external onlyGovernance {
        require(chainId > 0, "invalid chain id");
        require(dst != address(0x0), "zero address receiver");
        _receivers.push(ReceiverInfo({chainId: chainId, dst: dst}));
        emit ReceiverSet(chainId, dst);
    }

    /**
     * @notice Remove receiver info.
     * @param receiverIndex The receiver index to remove receiver.
    */
    function removeReceiver(uint256 receiverIndex) external onlyGovernance {
        require(_receivers.length > receiverIndex, "invalid index");
        ReceiverInfo memory receiverInfo = _receivers[receiverIndex];
        _receivers[receiverIndex] = _receivers[_receivers.length-1];
        _receivers.pop();
        emit ReceiverRemoved(receiverInfo.chainId);
    }

    /***************************************
     VIEW FUNCTIONS
    ***************************************/

    function callerAt(uint256 index) external view returns (address caller) {
        return _callers.at(index);
    }

    function numsOfCaller() external view returns (uint256 count) {
        return _callers.length();
    }

    function receiverAt(uint256 index) external view returns (uint64 chainId, address dst) {
        ReceiverInfo memory receiver =  _receivers[index];
        return (receiver.chainId, receiver.dst);
    }

    function numsOfReceiver() external view returns (uint256 count) {
        return _receivers.length;
    }
}