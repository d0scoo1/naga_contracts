// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.6;

import "IERC20.sol";
import "IUniswapV3Pool.sol";
import "IUniswapV3Factory.sol";
import "IUniswapPriceConverter.sol";

import "AddressLibrary.sol";

contract UniswapV3Oracle {

  using AddressLibrary for address;

  IUniswapV3Factory public constant uniFactory = IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);
  address           public constant WETH       = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  uint24            public constant POOL_FEE   = 3000;

  uint32 public twapPeriod;
  uint16 public minObservations;

  IUniswapPriceConverter public uniPriceConverter;

  constructor(
    address _uniPriceConverter,
    uint32  _twapPeriod,
    uint16  _minObservations
  ) {
    uniPriceConverter = IUniswapPriceConverter(_uniPriceConverter);
    twapPeriod        = _twapPeriod;
    minObservations   = _minObservations;
  }

  // Returns token price in ETH
  function price(address _token) public view returns(uint) {
    require(tokenSupported(_token), "UniswapV3Oracle: token not supported");
    if (_token == WETH) { return 1e18; }

    return uniPriceConverter.assetToEth(
      _token,
      10 ** IERC20(_token).decimals(),
      twapPeriod
    );
  }

  function tokenSupported(address _token) public view returns(bool) {
    if (_token == WETH) { return true; }
    address poolAddress = uniFactory.getPool(_token, WETH, POOL_FEE);
    if (poolAddress == address(0)) { return false; }

    (, , , , uint16 observationSlots, ,) = IUniswapV3Pool(poolAddress).slot0();
    return observationSlots >= minObservations;
  }
}
