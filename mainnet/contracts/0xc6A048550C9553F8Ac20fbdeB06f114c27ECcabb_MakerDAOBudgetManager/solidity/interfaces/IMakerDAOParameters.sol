// SPDX-License-Identifier: MIT

pragma solidity >=0.8.4 <0.9.0;

/// @title MakerDaoParameters contract
/// @notice Handles all the MakerDAO parameters needed to vest DAI
interface IMakerDAOParameters {
  // Events

  /// @notice Emitted when Maker sets new buffer thresholds
  /// @param _minBuffer Minimum amount to DAI to be claimable
  /// @param _maxBuffer Maximum amount to DAI to be claimable
  event BufferSet(uint256 _minBuffer, uint256 _maxBuffer);

  /// @notice Emitted when Maker sets a new vest
  /// @param _vestId The ID of the new vest
  /// @param _bgn The start timestamp of the vest
  /// @param _clf The cliff timestamp of the vest
  /// @param _fin The end timestamp of the vest
  /// @param _tot The total amount of DAI on the vest
  event VestSet(uint256 indexed _vestId, uint48 _bgn, uint48 _clf, uint48 _fin, uint128 _tot);

  // Errors

  /// @notice Throws when the provided vest ID doesn't have contract as beneficiary
  error IncorrectVestId();
  /// @notice Throws when an unallowed address tries to trigger Maker methods
  error OnlyMaker();

  // Views

  /// @notice The address of DAI
  function DAI() external view returns (address dai);

  /// @notice The address of DAI JOIN
  function DAI_JOIN() external view returns (address daiJoin);

  /// @notice The address of DSS VEST
  function DSS_VEST() external view returns (address dssVest);

  /// @notice The address of MAKER DAO
  function MAKER_DAO() external view returns (address makerDao);

  /// @notice The address of VOW
  function VOW() external view returns (address vow);

  /// @notice The minimum amount of DAI to be vested
  function minBuffer() external view returns (uint256 minBuffer);

  /// @notice The maximum amount of DAI to be vested at a time
  function maxBuffer() external view returns (uint256 maxBuffer);

  /// @notice Returns the buffer thresholds
  function buffer() external view returns (uint256 minBuffer, uint256 maxBuffer);

  // Methods

  /// @notice The Vest ID
  function vestId() external view returns (uint256 vestId);

  /// @notice Allows Maker to set the buffer thresholds
  function setBuffer(uint256 _minBuffer, uint256 _maxBuffer) external;

  /// @notice Allows Maker to set the vest ID
  function setVestId(uint256 _vestId) external;
}
