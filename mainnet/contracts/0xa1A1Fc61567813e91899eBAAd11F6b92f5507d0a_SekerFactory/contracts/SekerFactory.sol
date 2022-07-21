// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SekerFactory is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(address => bool) public minters;

    event MinterAdded(address indexed newMinter);
    event MinterRemoved(address indexed oldMinter);

    /// @dev Restricted to members of the user role.
    modifier onlyMinter() {
        require(isMinter(msg.sender), "Restricted to minters");
        _;
    }

    constructor() ERC721("Seker Factory", "SEKER") {
        minters[msg.sender] = true;
    }

    function mint(string memory _tokenURI) public onlyMinter {
        uint256 newNFT = _tokenIds.current();
        _safeMint(msg.sender, newNFT);
        _setTokenURI(newNFT, _tokenURI);
        _tokenIds.increment();
    }

    /// @dev Add an account to the user role. Restricted to admins.
    function addMinter(address account) public onlyOwner {
        require(minters[account] == false, "account is already a minter");
        minters[account] = true;
        emit MinterAdded(account);
    }

    /// @dev Remove an account to the user role. Restricted to admins.
    function removeMinter(address account) public onlyOwner {
        require(minters[account] == true, "account is already a minter");
        minters[account] = false;
        emit MinterRemoved(account);
    }

    /// @dev Return `true` if the account belongs to the user role.
    function isMinter(address account) public view returns (bool) {
        return minters[account];
    }
}
