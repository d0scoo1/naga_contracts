// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

import "./DoasisGenesisPass.sol";

contract DoasisAirdrop is Context, Ownable, Pausable {
  DoasisGenesisPass public doasis;
  uint256 public totalAirdrop;

  event MintBatch(address to, uint256 quantity, uint256 totalMint);

  constructor(DoasisGenesisPass _doasis) {
    doasis = _doasis;
  }

  function airdrop(address[] calldata users, uint256 quantity)
    public
    whenNotPaused
    onlyOwner
  {
    totalAirdrop += quantity * users.length;

    for (uint256 i = 0; i < users.length; i++) {
      doasis.mint(users[i], quantity);

      emit MintBatch(users[i], quantity, totalAirdrop);
    }
  }

  function pause() external onlyOwner {
    _pause();
  }

  function unpause() external onlyOwner {
    _unpause();
  }
}
