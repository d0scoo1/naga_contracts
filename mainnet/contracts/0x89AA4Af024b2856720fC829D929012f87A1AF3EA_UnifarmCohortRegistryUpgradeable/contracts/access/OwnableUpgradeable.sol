// SPDX-License-Identifier: GNU GPLv3

// OpenZeppelin Contracts v4.3.2 (access/Ownable.sol)

pragma solidity =0.8.9;

import {ERC2771ContextUpgradeable} from '../metatx/ERC2771ContextUpgradeable.sol';
import {Initializable} from '../proxy/Initializable.sol';

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner
 */

abstract contract OwnableUpgradeable is Initializable, ERC2771ContextUpgradeable {
    address private _owner;
    address private _master;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner
     */
    function __Ownable_init(address master, address trustedForwarder) internal initializer {
        __Ownable_init_unchained(master);
        __ERC2771ContextUpgradeable_init(trustedForwarder);
    }

    function __Ownable_init_unchained(address masterAddress) internal initializer {
        _transferOwnership(_msgSender());
        _master = masterAddress;
    }

    /**
     * @dev Returns the address of the current owner
     * @return _owner - _owner address
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), 'ONA');
        _;
    }

    /**
     * @dev Throws if called by any account other than the master
     */
    modifier onlyMaster() {
        require(_master == _msgSender(), 'OMA');
        _;
    }

    /**
     * @dev Transfering the owner ship to master role in case of emergency
     *
     * NOTE: Renouncing ownership will transfer the contract ownership to master role
     */

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(_master);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`)
     * Can only be called by the current owner
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), 'INA');
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`)
     * Internal function without access restriction
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    uint256[49] private __gap;
}
