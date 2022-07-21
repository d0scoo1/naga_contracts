// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";

interface MaterialsInterface {
  function mintRewards(address account, uint256[] calldata tokenIds, uint256[] calldata quantities) external;
}

contract MissionRewards is
  OwnableUpgradeable,
  UUPSUpgradeable,
  AccessControlEnumerableUpgradeable,
  ReentrancyGuardUpgradeable
{
  using ECDSAUpgradeable for bytes32;

  address internal _materialContractAddress;
  address internal signer;
  mapping(uint256 => mapping(address => bool)) missionRewardsClaimed;

  struct RewardClaim {
    uint256 missionId;
    uint256[] rewards;
    uint256[] rewardQuantities;
    bytes signature;
  }

  function initialize() external initializer {
    __Ownable_init();
    __UUPSUpgradeable_init();
    __AccessControlEnumerable_init();

    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
  }

  function version()
  external
  pure
  virtual
  returns (string memory)
  {
    return "0.1.1";
  }

  function getMaterialContractAddress()
  external
  view
  onlyRole(DEFAULT_ADMIN_ROLE)
  returns (address)
  {
    return _materialContractAddress;
  }

  function setMaterialContractAddress(address materialContractAddress)
  external
  onlyRole(DEFAULT_ADMIN_ROLE)
  {
    _materialContractAddress = materialContractAddress;
  }

  function getSigner()
  external
  view
  onlyRole(DEFAULT_ADMIN_ROLE)
  returns (address)
  {
    return signer;
  }

  function setSigner(address _signer)
  external
  virtual
  onlyRole(DEFAULT_ADMIN_ROLE)
  {
    signer = _signer;
  }

  function isRewardClaimed(
    uint256 missionId,
    address account
  )
  external
  view
  returns (bool)
  {
    return missionRewardsClaimed[missionId][account];
  }

  function _getSignatureSigner(
    bytes32 hash,
    bytes memory signature
  )
  internal
  pure
  returns (address)
  {
    return hash.toEthSignedMessageHash().recover(signature);
  }

  function _verifyClaim(
    address account,
    uint256 missionId,
    uint256[] calldata rewards,
    uint256[] calldata rewardQuantities,
    bytes memory signature
  )
  internal
  view
  returns (bool)
  {
    return _getSignatureSigner(keccak256(abi.encodePacked(account, missionId, rewards, rewardQuantities)), signature) == signer;
  }

 function _claimMissionReward(
    uint256 missionId,
    uint256[] calldata rewards,
    uint256[] calldata rewardQuantities,
    bytes memory signature
  )
  internal
  {
    require(rewards.length == rewardQuantities.length, "Mismatch of rewards and reward quantities");
    require(_verifyClaim(_msgSender(), missionId, rewards, rewardQuantities, signature), "Mismatched signature");
    require(missionRewardsClaimed[missionId][_msgSender()] == false, "Rewards have already been claimed for this mission");

    MaterialsInterface MaterialsContractInstance = MaterialsInterface(_materialContractAddress);

    MaterialsContractInstance.mintRewards(_msgSender(), rewards, rewardQuantities);
    missionRewardsClaimed[missionId][_msgSender()] = true;
  }

  function claimMissionRewards(
    RewardClaim[] calldata rewardClaims
  )
  external
  {
    require(signer != address(0), "Signer not set yet");
    require(_materialContractAddress != address(0), "Material contract address not set yet");

    uint256 rewardClaimsLength = rewardClaims.length;
    for (uint256 i = 0; i < rewardClaimsLength; ++i) {
      RewardClaim calldata rewardClaim = rewardClaims[i];
      _claimMissionReward(rewardClaim.missionId, rewardClaim.rewards, rewardClaim.rewardQuantities, rewardClaim.signature);
    }
  }

  function _authorizeUpgrade(address newImplementation)
  internal
  virtual
  override
  onlyRole(DEFAULT_ADMIN_ROLE)
  {}
}
