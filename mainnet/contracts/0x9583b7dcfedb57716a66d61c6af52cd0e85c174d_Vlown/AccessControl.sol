// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <=0.8.0;

contract AccessControl {
    address payable public executiveOfficerAddress;
    address payable public financialOfficerAddress;
    bool public paused = false;

    event Pause();
    event Unpause();

    constructor() payable { 
        executiveOfficerAddress = msg.sender;
        financialOfficerAddress = msg.sender;
    }

    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    modifier whenPaused() {
        require(paused);
        _;
    }

    function pause() onlyExecutiveOfficer whenNotPaused public {
        paused = true;
        emit Pause();
    }

    function unpause() onlyExecutiveOfficer whenPaused public {
        paused = false;
        emit Unpause();
    }

    /// @dev Only allowed by executive officer
    modifier onlyExecutiveOfficer() {
        require(msg.sender == executiveOfficerAddress);
        _;
    }

    /// @dev Only allowed by financial officer
    modifier onlyFinancialOfficer() {
        require(msg.sender == financialOfficerAddress);
        _;
    }

    /// @notice Reassign the executive officer role
    /// @param _executiveOfficerAddress new officer address
    function setExecutiveOfficer(address payable _executiveOfficerAddress)
        external
        onlyExecutiveOfficer
    {
        require(_executiveOfficerAddress != address(0));
        executiveOfficerAddress = _executiveOfficerAddress;
    }

    /// @notice Reassign the financial officer role
    /// @param _financialOfficerAddress new officer address
    function setFinancialOfficer(address payable _financialOfficerAddress)
        external
        onlyExecutiveOfficer
    {
        require(_financialOfficerAddress != address(0));
        financialOfficerAddress = _financialOfficerAddress;
    }

    /// @notice Collect funds from this contract
    function withdrawBalance() external onlyFinancialOfficer {
        financialOfficerAddress.transfer(address(this).balance);
    }

    function destroy() onlyExecutiveOfficer public {
        selfdestruct(executiveOfficerAddress);
    }

    function destroyAndSend(address _recipient) onlyExecutiveOfficer public {
        selfdestruct(payable(_recipient));
    }
}