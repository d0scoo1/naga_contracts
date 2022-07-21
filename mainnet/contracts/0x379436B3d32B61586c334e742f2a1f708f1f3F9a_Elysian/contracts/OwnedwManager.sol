// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

contract OwnedwManager {
    address public owner;
    address public manager;

    address public nominatedOwner;

    constructor(address _owner, address _manager) {
        require(_owner != address(0), "Owner address cannot be 0");
        owner = _owner;
        manager = _manager;
        emit OwnerChanged(address(0), _owner);
        emit ManagerChanged(_manager);
    }

    function nominateNewOwner(address _owner) external onlyOwner {
        nominatedOwner = _owner;
        emit OwnerNominated(_owner);
    }

    function acceptOwnership() external {
        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
        emit OwnerChanged(owner, nominatedOwner);
        owner = nominatedOwner;
        nominatedOwner = address(0);
    }

    modifier onlyOwner {
        _onlyOwner();
        _;
    }

    modifier onlyManager {
        _onlyManager();
        _;
    }
    
    function _onlyOwner() private view {
        require(msg.sender == owner, "Only the contract owner may perform this action");
    }

    function _onlyManager() private view {
        require(msg.sender == manager, "Only the contract owner may perform this action");
    }

    function setManager(address _manager) external onlyOwner {
        manager = _manager;
        emit ManagerChanged(_manager);
    }

    event OwnerNominated(address newOwner);
    event OwnerChanged(address oldOwner, address newOwner);
    event ManagerChanged(address newManager);
}
