// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.4;

/**
 * @title OurManagement
 * @author Nick A.
 * https://github.com/ourz-network/our-contracts
 *
 * These contracts enable creators, builders, & collaborators of all kinds
 * to receive royalties for their collective work, forever.
 *
 * Thank you,
 * @author Mirror       @title Splits   https://github.com/mirror-xyz/splits
 * @author Gnosis       @title Safe     https://github.com/gnosis/safe-contracts
 * @author OpenZeppelin                 https://github.com/OpenZeppelin/openzeppelin-contracts
 * @author Zora                         https://github.com/ourzora
 */

contract OurManagement {
    // used as origin pointer for linked list of owners
    /* solhint-disable private-vars-leading-underscore */
    address internal constant SENTINEL_OWNERS = address(0x1);

    mapping(address => address) internal owners;
    uint256 internal ownerCount;
    uint256 internal threshold;
    /* solhint-enable private-vars-leading-underscore */

    event SplitSetup(address[] owners);
    event AddedOwner(address owner);
    event RemovedOwner(address owner);
    event NameChanged(string newName);

    modifier onlyOwners() {
        // This is a function call as it minimized the bytecode size
        checkIsOwner(_msgSender());
        _;
    }

    /// @dev Allows to add a new owner
    function addOwner(address owner) public onlyOwners {
        // Owner address cannot be null, the sentinel or the Safe itself.
        require(
            owner != address(0) &&
                owner != SENTINEL_OWNERS &&
                owner != address(this)
        );
        // No duplicate owners allowed.
        require(owners[owner] == address(0));
        owners[owner] = owners[SENTINEL_OWNERS];
        owners[SENTINEL_OWNERS] = owner;
        ownerCount++;
        emit AddedOwner(owner);
    }

    /// @dev Allows to remove an owner
    function removeOwner(address prevOwner, address owner) public onlyOwners {
        // Validate owner address and check that it corresponds to owner index.
        require(owner != address(0) && owner != SENTINEL_OWNERS);
        require(owners[prevOwner] == owner);
        owners[prevOwner] = owners[owner];
        owners[owner] = address(0);
        ownerCount--;
        emit RemovedOwner(owner);
    }

    /// @dev Allows to swap/replace an owner from the Proxy with another address.
    /// @param prevOwner Owner that pointed to the owner to be replaced in the linked list
    /// @param oldOwner Owner address to be replaced.
    /// @param newOwner New owner address.
    function swapOwner(
        address prevOwner,
        address oldOwner,
        address newOwner
    ) public onlyOwners {
        // Owner address cannot be null, the sentinel or the Safe itself.
        require(
            newOwner != address(0) &&
                newOwner != SENTINEL_OWNERS &&
                newOwner != address(this),
            "2"
        );
        // No duplicate owners allowed.
        require(owners[newOwner] == address(0), "3");
        // Validate oldOwner address and check that it corresponds to owner index.
        require(oldOwner != address(0) && oldOwner != SENTINEL_OWNERS, "4");
        require(owners[prevOwner] == oldOwner, "5");
        owners[newOwner] = owners[oldOwner];
        owners[prevOwner] = newOwner;
        owners[oldOwner] = address(0);
        emit RemovedOwner(oldOwner);
        emit AddedOwner(newOwner);
    }

    /// @dev for subgraph
    function editNickname(string calldata newName_) public onlyOwners {
        emit NameChanged(newName_);
    }

    function isOwner(address owner) public view returns (bool) {
        return owner != SENTINEL_OWNERS && owners[owner] != address(0);
    }

    /// @dev Returns array of owners.
    function getOwners() public view returns (address[] memory) {
        address[] memory array = new address[](ownerCount);

        // populate return array
        uint256 index = 0;
        address currentOwner = owners[SENTINEL_OWNERS];
        while (currentOwner != SENTINEL_OWNERS) {
            array[index] = currentOwner;
            currentOwner = owners[currentOwner];
            index++;
        }
        return array;
    }

    /**
     * @dev Setup function sets initial owners of contract.
     * @param owners_ List of Split Owners (can mint/manage auctions)
     * @notice threshold ensures that setup function can only be called once.
     */
    /* solhint-disable private-vars-leading-underscore */
    function setupOwners(address[] memory owners_) internal {
        require(threshold == 0, "Setup has already been completed once.");
        // Initializing Proxy owners.
        address currentOwner = SENTINEL_OWNERS;
        for (uint256 i = 0; i < owners_.length; i++) {
            address owner = owners_[i];
            require(
                owner != address(0) &&
                    owner != SENTINEL_OWNERS &&
                    owner != address(this) &&
                    currentOwner != owner
            );
            require(owners[owner] == address(0));
            owners[currentOwner] = owner;
            currentOwner = owner;
        }
        owners[currentOwner] = SENTINEL_OWNERS;
        ownerCount = owners_.length;
        threshold = 1;
    }

    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    function checkIsOwner(address caller_) internal view {
        require(
            isOwner(caller_),
            "Caller is not a whitelisted owner of this Split"
        );
    }
    /* solhint-enable private-vars-leading-underscore */
}
