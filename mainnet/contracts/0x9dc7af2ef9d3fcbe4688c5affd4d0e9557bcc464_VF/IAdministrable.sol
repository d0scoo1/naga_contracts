// SPDX-License-Identifier: MIT

/**
* Author: Lambdalf the White
*/

pragma solidity 0.8.10;
import './IOwnable.sol';

/**
* @dev Contract module which provides a basic access control mechanism, where
* there is an account (an owner) that can be granted exclusive access to
* specific functions.
*
* By default, the owner account will be the one that deploys the contract. This
* can later be changed with {transferOwnership}.
*
* This module is used through inheritance. It will make available the modifier
* `onlyOwner`, which can be applied to your functions to restrict their use to
* the owner.
*/
abstract contract IAdministrable is IOwnable {
	// Errors
	error IAdministrable_NOT_ADMIN();

	bytes32 public constant ADMIN_ROLE = keccak256( "ADMIN_ROLE" );

	// The list of admin addresses
	mapping( address => bool ) private _admin;

	/**
	* @dev Emitted when admin role is granted.
	*/
	event RoleGranted( bytes32 indexed role, address indexed account, address indexed operator );

	/**
	* @dev Emitted when admin role is revoked or renounced.
	*/
	event RoleRevoked( bytes32 indexed role, address indexed account, address indexed operator );

	/**
	* @dev Throws if called by any account that is not an admin.
	*/
	modifier onlyAdmin() {
		if ( ! isAdmin( msg.sender ) ) {
			revert IAdministrable_NOT_ADMIN();
		}
		_;
	}

	/**
	* @dev Grants admin privileges to `account_`.
	* Can only be called by the current owner.
	*/
	function grantAdmin( address account_ ) public virtual onlyOwner {
		_admin[ account_ ] = true;
		emit RoleGranted( ADMIN_ROLE, account_, msg.sender );
	}

	/**
	* @dev Renonce admin privileges.
	* Can only be called by the current owner.
	*/
	function renounceAdmin() public virtual onlyAdmin {
		delete _admin[ msg.sender ];
		emit RoleRevoked( ADMIN_ROLE, msg.sender, msg.sender );
	}

	/**
	* @dev Revokes admin privileges from `account_`.
	* Can only be called by the current owner.
	*/
	function revokeAdmin( address account_ ) public virtual onlyOwner {
		delete _admin[ account_ ];
		emit RoleRevoked( ADMIN_ROLE, account_, msg.sender );
	}

	/**
	* @dev Returns whether the address is an admin or not.
	* The contract owner is always considered an admin.
	*/
	function isAdmin( address account_ ) public view virtual returns ( bool ) {
		return account_ == owner() || _admin[ account_ ];
	}
}
