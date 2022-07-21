// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DagenItems is ERC1155, Ownable, AccessControl, Pausable, ERC1155Burnable, ERC1155Supply {
  using SafeMath for uint256;

  string public name = "Gen";
  // allow for address to hold multiple gen, such as market
  mapping(address => bool) private _multiHolders;
  mapping(uint256 => uint256) public preset;

  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

  constructor() ERC1155("https://dagen.io/gens/{id}.json") {
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(PAUSER_ROLE, msg.sender);
    _grantRole(MINTER_ROLE, msg.sender);
  }

  function multiHolderEnable(address holder) external onlyRole(DEFAULT_ADMIN_ROLE) {
    _multiHolders[holder] = true;
  }

  function multiHolderDisable(address holder) external onlyRole(DEFAULT_ADMIN_ROLE) {
    _multiHolders[holder] = false;
  }

  /**
   * @notice Set up preset for limit token supply
   * @param ids: token ids
   * @param amounts: amount for each token
   */
  function setupPreset(uint256[] calldata ids, uint256[] calldata amounts)
    external
    onlyRole(DEFAULT_ADMIN_ROLE)
  {
    for (uint256 i = 0; i < ids.length; i++) {
      preset[ids[i]] = amounts[i];
    }
  }

  function setURI(string memory newuri) public onlyRole(DEFAULT_ADMIN_ROLE) {
    _setURI(newuri);
  }

  function pause() public onlyRole(PAUSER_ROLE) {
    _pause();
  }

  function unpause() public onlyRole(PAUSER_ROLE) {
    _unpause();
  }

  function mint(
    address account,
    uint256 id,
    uint256 amount,
    bytes memory data
  ) public onlyRole(MINTER_ROLE) {
    require(totalSupply(id) + amount <= preset[id], "exceed preset");
    _mint(account, id, amount, data);
  }

  function mintBatch(
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
  ) public onlyRole(MINTER_ROLE) {
    for (uint256 i = 0; i < ids.length; i++) {
      require(totalSupply(ids[i]) + amounts[i] <= preset[ids[i]], "exceed preset");
    }
    _mintBatch(to, ids, amounts, data);
  }

  /**
   * @notice Callback limit: not multiHolders could only hold one gen
   */
  function _beforeTokenTransfer(
    address operator,
    address from,
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
  ) internal override(ERC1155, ERC1155Supply) whenNotPaused {
    super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    if (to != address(0) && !_multiHolders[to]) {
      for (uint256 i = 0; i < ids.length; i++) {
        require(balanceOf(to, ids[i]) == 0, "already have");
      }
    }
  }

  // The following functions are overrides required by Solidity.

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC1155, AccessControl)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }
}
