// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {ISynthereumFinder} from '../../core/interfaces/IFinder.sol';
import {
  MintableBurnableIERC20
} from '../common/interfaces/MintableBurnableIERC20.sol';
import {
  IMintableBurnableTokenFactory
} from '../common/interfaces/IMintableBurnableTokenFactory.sol';
import {
  FixedPoint
} from '../../../@jarvis-network/uma-core/contracts/common/implementation/FixedPoint.sol';
import {PerpetualPoolPartyLib} from './PerpetualPoolPartyLib.sol';
import {SynthereumInterfaces} from '../../core/Constants.sol';
import {
  ContractCreator
} from '../../../@jarvis-network/uma-core/contracts/oracle/implementation/ContractCreator.sol';
import {
  Testable
} from '../../../@jarvis-network/uma-core/contracts/common/implementation/Testable.sol';
import {
  Lockable
} from '../../../@jarvis-network/uma-core/contracts/common/implementation/Lockable.sol';
import {
  MintableBurnableTokenFactory
} from '../common/MintableBurnableTokenFactory.sol';
import {PerpetualPoolParty} from './PerpetualPoolParty.sol';

/**
 * @title Perpetual Contract creator.
 * @notice Factory contract to create and register new instances of perpetual contracts.
 * Responsible for constraining the parameters used to construct a new perpetual. This creator contains a number of constraints
 * that are applied to newly created  contract. These constraints can evolve over time and are
 * initially constrained to conservative values in this first iteration. Technically there is nothing in the
 * Perpetual contract requiring these constraints. However, because `createPerpetual()` is intended
 * to be the only way to create valid financial contracts that are registered with the DVM (via _registerContract),
  we can enforce deployment configurations here.
 */
contract PerpetualPoolPartyCreator is ContractCreator, Testable, Lockable {
  using FixedPoint for FixedPoint.Unsigned;

  struct Params {
    address collateralAddress;
    bytes32 priceFeedIdentifier;
    string syntheticName;
    string syntheticSymbol;
    address syntheticToken;
    FixedPoint.Unsigned collateralRequirement;
    FixedPoint.Unsigned disputeBondPct;
    FixedPoint.Unsigned sponsorDisputeRewardPct;
    FixedPoint.Unsigned disputerDisputeRewardPct;
    FixedPoint.Unsigned minSponsorTokens;
    uint256 withdrawalLiveness;
    uint256 liquidationLiveness;
    address excessTokenBeneficiary;
    address[] admins;
    address[] pools;
  }

  //----------------------------------------
  // Storage
  //----------------------------------------

  // Address of Synthereum Finder
  ISynthereumFinder public synthereumFinder;

  //----------------------------------------
  // Events
  //----------------------------------------

  event CreatedPerpetual(
    address indexed perpetualAddress,
    address indexed deployerAddress
  );

  //----------------------------------------
  // Constructor
  //----------------------------------------

  /**
   * @notice Constructs the Perpetual contract.
   * @param _umaFinderAddress UMA protocol Finder used to discover other protocol contracts.
   * @param _synthereumFinder Synthereum Finder address used to discover other contracts
   * @param _timerAddress Contract that stores the current time in a testing environment.
   */
  constructor(
    address _umaFinderAddress,
    address _synthereumFinder,
    address _timerAddress
  )
    public
    ContractCreator(_umaFinderAddress)
    Testable(_timerAddress)
    nonReentrant()
  {
    synthereumFinder = ISynthereumFinder(_synthereumFinder);
  }

  //----------------------------------------
  // External functions
  //----------------------------------------

  /**
   * @notice Creates an instance of perpetual and registers it within the registry.
   * @param params is a `ConstructorParams` object from Perpetual.
   * @return address of the deployed contract.
   */
  function createPerpetual(Params memory params)
    public
    virtual
    nonReentrant()
    returns (address)
  {
    // Create a new synthetic token using the params.
    require(bytes(params.syntheticName).length != 0, 'Missing synthetic name');
    require(
      bytes(params.syntheticSymbol).length != 0,
      'Missing synthetic symbol'
    );
    address derivative;
    if (params.syntheticToken == address(0)) {
      // If the collateral token does not have a `decimals()` method,
      // then a default precision of 18 will be applied to the newly created synthetic token.
      IMintableBurnableTokenFactory tokenFactory =
        IMintableBurnableTokenFactory(
          ISynthereumFinder(synthereumFinder).getImplementationAddress(
            SynthereumInterfaces.TokenFactory
          )
        );
      MintableBurnableIERC20 tokenCurrency =
        tokenFactory.createToken(
          params.syntheticName,
          params.syntheticSymbol,
          18
        );
      derivative = PerpetualPoolPartyLib.deploy(
        _convertParams(params, tokenCurrency)
      );
      // Give permissions to new derivative contract and then hand over ownership.
      tokenCurrency.addMinter(derivative);
      tokenCurrency.addBurner(derivative);
      tokenCurrency.addAdmin(
        synthereumFinder.getImplementationAddress(SynthereumInterfaces.Manager)
      );
      tokenCurrency.renounceAdmin();
    } else {
      MintableBurnableIERC20 tokenCurrency =
        MintableBurnableIERC20(params.syntheticToken);
      require(
        keccak256(abi.encodePacked(tokenCurrency.name())) ==
          keccak256(abi.encodePacked(params.syntheticName)),
        'Wrong synthetic token name'
      );
      require(
        keccak256(abi.encodePacked(tokenCurrency.symbol())) ==
          keccak256(abi.encodePacked(params.syntheticSymbol)),
        'Wrong synthetic token symbol'
      );
      require(
        tokenCurrency.decimals() == uint8(18),
        'Decimals of synthetic token must be 18'
      );
      derivative = PerpetualPoolPartyLib.deploy(
        _convertParams(params, tokenCurrency)
      );
    }

    _registerContract(new address[](0), address(derivative));

    emit CreatedPerpetual(address(derivative), msg.sender);

    return address(derivative);
  }

  //----------------------------------------
  // Internal functions
  //----------------------------------------

  // Converts createPerpetual params to Perpetual constructor params.
  function _convertParams(
    Params memory params,
    MintableBurnableIERC20 newTokenCurrency
  )
    internal
    view
    returns (PerpetualPoolParty.ConstructorParams memory constructorParams)
  {
    // Known from creator deployment.
    constructorParams.positionManagerParams.finderAddress = finderAddress;
    constructorParams.positionManagerParams.synthereumFinder = synthereumFinder;
    constructorParams.positionManagerParams.timerAddress = timerAddress;

    // Enforce configuration constraints.
    require(params.withdrawalLiveness != 0, 'Withdrawal liveness cannot be 0');
    require(
      params.liquidationLiveness != 0,
      'Liquidation liveness cannot be 0'
    );
    require(
      params.excessTokenBeneficiary != address(0),
      'Token Beneficiary cannot be 0x0'
    );
    require(params.admins.length > 0, 'No admin addresses set');

    // We don't want perpetual deployers to be able to intentionally or unintentionally set
    // liveness periods that could induce arithmetic overflow, but we also don't want
    // to be opinionated about what livenesses are "correct", so we will somewhat
    // arbitrarily set the liveness upper bound to 100 years (5200 weeks). In practice, liveness
    // periods even greater than a few days would make the perpetual unusable for most users.
    require(
      params.withdrawalLiveness < 5200 weeks,
      'Withdrawal liveness too large'
    );
    require(
      params.liquidationLiveness < 5200 weeks,
      'Liquidation liveness too large'
    );

    // Input from function call.

    constructorParams.positionManagerParams.tokenAddress = address(
      newTokenCurrency
    );
    constructorParams.positionManagerParams.collateralAddress = params
      .collateralAddress;
    constructorParams.positionManagerParams.priceFeedIdentifier = params
      .priceFeedIdentifier;
    constructorParams.liquidatableParams.collateralRequirement = params
      .collateralRequirement;
    constructorParams.liquidatableParams.disputeBondPct = params.disputeBondPct;
    constructorParams.liquidatableParams.sponsorDisputeRewardPct = params
      .sponsorDisputeRewardPct;
    constructorParams.liquidatableParams.disputerDisputeRewardPct = params
      .disputerDisputeRewardPct;
    constructorParams.positionManagerParams.minSponsorTokens = params
      .minSponsorTokens;
    constructorParams.positionManagerParams.withdrawalLiveness = params
      .withdrawalLiveness;
    constructorParams.liquidatableParams.liquidationLiveness = params
      .liquidationLiveness;
    constructorParams.positionManagerParams.excessTokenBeneficiary = params
      .excessTokenBeneficiary;
    constructorParams.roles.admins = params.admins;
    constructorParams.roles.pools = params.pools;
  }
}
