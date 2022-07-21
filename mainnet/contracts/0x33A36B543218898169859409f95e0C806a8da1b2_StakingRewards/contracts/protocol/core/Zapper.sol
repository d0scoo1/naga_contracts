// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/SafeERC20.sol";

import "../../interfaces/ISeniorPool.sol";
import "../../interfaces/IPoolTokens.sol";
import "../../interfaces/ITranchedPool.sol";
import "../../interfaces/IRequiresUID.sol";
import "../../interfaces/IStakingRewards.sol";
import "./Accountant.sol";
import "./BaseUpgradeablePausable.sol";
import "./ConfigHelper.sol";

/// @title Zapper
/// @notice Moves capital from the SeniorPool to TranchedPools without taking fees
contract Zapper is BaseUpgradeablePausable {
  GoldfinchConfig public config;
  using ConfigHelper for GoldfinchConfig;
  using SafeMath for uint256;

  struct Zap {
    address owner;
    uint256 stakingPositionId;
  }

  /// @dev PoolToken.id => Zap
  mapping(uint256 => Zap) public tranchedPoolZaps;

  function initialize(address owner, GoldfinchConfig _config) public initializer {
    require(owner != address(0) && address(_config) != address(0), "Owner and config addresses cannot be empty");
    __BaseUpgradeablePausable__init(owner);
    config = _config;
  }

  /// @notice Zap staked FIDU into the junior tranche of a TranchedPool without losing
  ///   unvested rewards or paying a withdrawal fee
  /// @dev The minted pool token is held by this contract until either `claimZap` or
  ///   `unzap` is called
  /// @param tokenId A staking position token ID
  /// @param tranchedPool A TranchedPool in which to deposit
  /// @param tranche The tranche ID of tranchedPool in which to deposit
  /// @param usdcAmount The amount in USDC to zap from StakingRewards into the TranchedPool
  function zapStakeToTranchedPool(
    uint256 tokenId,
    ITranchedPool tranchedPool,
    uint256 tranche,
    uint256 usdcAmount
  ) public whenNotPaused nonReentrant {
    IStakingRewards stakingRewards = config.getStakingRewards();
    ISeniorPool seniorPool = config.getSeniorPool();

    require(_validPool(tranchedPool), "Invalid pool");
    require(IERC721(address(stakingRewards)).ownerOf(tokenId) == msg.sender, "Not token owner");
    require(_hasAllowedUID(tranchedPool), "Address not go-listed");

    uint256 shares = seniorPool.getNumShares(usdcAmount);
    stakingRewards.unstake(tokenId, shares);

    uint256 withdrawnAmount = seniorPool.withdraw(usdcAmount);
    require(withdrawnAmount == usdcAmount, "Withdrawn amount != requested amount");

    SafeERC20.safeApprove(config.getUSDC(), address(tranchedPool), usdcAmount);
    uint256 poolTokenId = tranchedPool.deposit(tranche, usdcAmount);

    tranchedPoolZaps[poolTokenId] = Zap(msg.sender, tokenId);

    // Require that the tranched pool's allowance for USDC is reset to zero
    // at the end of the transaction. `safeApprove` will fail on subsequent invocations
    // if any "dust" is left behind.
    require(
      config.getUSDC().allowance(address(this), address(tranchedPool)) == 0,
      "Entire allowance of USDC has not been used."
    );
  }

  /// @notice Claim the underlying PoolToken for a zap initiated with `zapStakeToTranchePool`.
  ///  The pool token will be transferred to msg.sender if msg.sender initiated the zap and
  ///  we are past the tranche's lockedUntil time.
  /// @param poolTokenId The underyling PoolToken id created in a previously initiated zap
  function claimTranchedPoolZap(uint256 poolTokenId) public whenNotPaused nonReentrant {
    Zap storage zap = tranchedPoolZaps[poolTokenId];

    require(zap.owner == msg.sender, "Not zap owner");

    IPoolTokens poolTokens = config.getPoolTokens();
    IPoolTokens.TokenInfo memory tokenInfo = poolTokens.getTokenInfo(poolTokenId);
    ITranchedPool.TrancheInfo memory trancheInfo = ITranchedPool(tokenInfo.pool).getTranche(tokenInfo.tranche);

    require(trancheInfo.lockedUntil != 0 && block.timestamp > trancheInfo.lockedUntil, "Zap locked");

    IERC721(poolTokens).safeTransferFrom(address(this), msg.sender, poolTokenId);
  }

  /// @notice Unwind a zap initiated with `zapStakeToTranchePool`.
  ///  The funds will be withdrawn from the TranchedPool and added back to the original
  ///  staked position in StakingRewards. This method can only be called when the PoolToken's
  ///  tranche has never been locked.
  /// @param poolTokenId The underyling PoolToken id created in a previously initiated zap
  function unzapToStakingRewards(uint256 poolTokenId) public whenNotPaused nonReentrant {
    Zap storage zap = tranchedPoolZaps[poolTokenId];

    require(zap.owner == msg.sender, "Not zap owner");

    IPoolTokens poolTokens = config.getPoolTokens();
    IPoolTokens.TokenInfo memory tokenInfo = poolTokens.getTokenInfo(poolTokenId);
    ITranchedPool tranchedPool = ITranchedPool(tokenInfo.pool);
    ITranchedPool.TrancheInfo memory trancheInfo = tranchedPool.getTranche(tokenInfo.tranche);

    require(trancheInfo.lockedUntil == 0, "Tranche locked");

    (uint256 interestWithdrawn, uint256 principalWithdrawn) = tranchedPool.withdrawMax(poolTokenId);
    require(interestWithdrawn == 0, "Invalid state");
    require(principalWithdrawn > 0, "Invalid state");

    ISeniorPool seniorPool = config.getSeniorPool();
    SafeERC20.safeApprove(config.getUSDC(), address(seniorPool), principalWithdrawn);
    uint256 fiduAmount = seniorPool.deposit(principalWithdrawn);

    IStakingRewards stakingRewards = config.getStakingRewards();
    SafeERC20.safeApprove(config.getFidu(), address(stakingRewards), fiduAmount);
    stakingRewards.addToStake(zap.stakingPositionId, fiduAmount);

    // Require that the allowances for both FIDU and USDC are reset to zero
    // at the end of the transaction. `safeApprove` will fail on subsequent invocations
    // if any "dust" is left behind.
    require(
      config.getUSDC().allowance(address(this), address(seniorPool)) == 0,
      "Entire allowance of USDC has not been used."
    );
    require(
      config.getFidu().allowance(address(this), address(stakingRewards)) == 0,
      "Entire allowance of FIDU has not been used."
    );
  }

  /// @notice Zap staked FIDU into staked Curve LP tokens without losing unvested rewards
  ///  or paying a withdrawal fee.
  /// @param tokenId A staking position token ID
  /// @param fiduAmount The amount in FIDU from the staked position to zap
  /// @param usdcAmount The amount of USDC to deposit into Curve
  function zapStakeToCurve(
    uint256 tokenId,
    uint256 fiduAmount,
    uint256 usdcAmount
  ) public whenNotPaused nonReentrant {
    IStakingRewards stakingRewards = config.getStakingRewards();
    require(IERC721(address(stakingRewards)).ownerOf(tokenId) == msg.sender, "Not token owner");

    uint256 stakedBalance = stakingRewards.stakedBalanceOf(tokenId);
    require(fiduAmount > 0, "Cannot zap 0 FIDU");
    require(fiduAmount <= stakedBalance, "cannot unstake more than staked balance");

    stakingRewards.unstake(tokenId, fiduAmount);

    SafeERC20.safeApprove(config.getFidu(), address(stakingRewards), fiduAmount);

    if (usdcAmount > 0) {
      SafeERC20.safeTransferFrom(config.getUSDC(), msg.sender, address(this), usdcAmount);
      SafeERC20.safeApprove(config.getUSDC(), address(stakingRewards), usdcAmount);
    }

    stakingRewards.depositToCurveAndStakeFrom(msg.sender, fiduAmount, usdcAmount);

    // Require that the allowances for both FIDU and USDC are reset to zero after
    // at the end of the transaction. `safeApprove` will fail on subsequent invocations
    // if any "dust" is left behind.
    require(
      config.getFidu().allowance(address(this), address(stakingRewards)) == 0,
      "Entire allowance of FIDU has not been used."
    );
    require(
      config.getUSDC().allowance(address(this), address(stakingRewards)) == 0,
      "Entire allowance of USDC has not been used."
    );
  }

  function _hasAllowedUID(ITranchedPool pool) internal view returns (bool) {
    return IRequiresUID(address(pool)).hasAllowedUID(msg.sender);
  }

  function _validPool(ITranchedPool pool) internal view returns (bool) {
    return config.getPoolTokens().validPool(address(pool));
  }
}
