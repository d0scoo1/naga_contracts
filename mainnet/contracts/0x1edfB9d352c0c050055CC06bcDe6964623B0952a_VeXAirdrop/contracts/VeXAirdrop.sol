//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IVE {
  // solhint-disable func-name-mixedcase
  function create_lock_for(
    address,
    uint256,
    uint256
  ) external;

  function deposit_for(address, uint256) external;

  function locked__end(address) external view returns (uint256);
  // solhint-enable func-name-mixedcase
}

contract VeXAirdrop is Ownable {
  IERC20 public token;
  IVE public ve;
  bytes32[] public roots;
  mapping(address => mapping(uint256 => bool)) public claimed; // addr => round => claimed

  event RootSet(uint256 round, bytes32 root);
  event Claimed(address indexed claimer, uint256 indexed round, uint256 amount);
  uint256 public constant MAX_LOCK_TIME = 4 * 365 * 86400; // 4 years

  constructor(IERC20 _token, IVE _ve) {
    token = _token;
    ve = _ve;
  }

  function addRoot(bytes32 _root) external onlyOwner {
    emit RootSet(roots.length, _root);
    roots.push(_root);
  }

  function setRoot(uint256 round, bytes32 _root) external onlyOwner {
    require(roots.length > round, "index out of bound");
    roots[round] = _root;
    emit RootSet(round, _root);
  }

  function withdraw(IERC20 _token) external onlyOwner {
    uint256 balance = _token.balanceOf(address(this));
    token.transfer(msg.sender, balance);
  }

  function nextRound() external view returns (uint256) {
    return roots.length;
  }

  function claim(
    uint256[] memory rounds,
    uint256[] memory amounts,
    bytes32[][] memory proofs
  ) external {
    require(
      rounds.length == amounts.length && amounts.length == proofs.length,
      "invalid length"
    );

    uint256 totalAmount = 0;
    for (uint256 i = 0; i < rounds.length; i++) {
      uint256 round = rounds[i];
      require(round < roots.length, "invalid round");
      require(!claimed[msg.sender][round], "already claimed");
      claimed[msg.sender][round] = true;
      totalAmount += amounts[i];
      bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amounts[i]));
      require(
        MerkleProof.verify(proofs[i], roots[round], leaf),
        "invalid proof"
      );
      emit Claimed(msg.sender, round, amounts[i]);
    }
    require(token.approve(address(ve), totalAmount), "approve failed");
    if (ve.locked__end(msg.sender) == 0) {
      ve.create_lock_for(
        msg.sender,
        totalAmount,
        // solhint-disable-next-line not-rely-on-time
        block.timestamp + MAX_LOCK_TIME
      );
    } else {
      ve.deposit_for(msg.sender, totalAmount);
    }
  }
}
