// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/utils/Context.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '../ERC721AJ.sol';

/**
 * @title ERC721AJ Salable Token
 */
abstract contract ERC721AJSaleable is Context, Ownable, ERC721AJ {
  using SafeMath for uint256;

  struct SaleConfig {
    uint256 maxSupply;
  }

  SaleConfig public saleConfig;

  function preserve(uint256 qty, address to) public onlyOwner {
    require(totalSupply().add(qty) <= saleConfig.maxSupply, 'Saleable: sold out');
    _safeMint(to, qty);
  }

  function setSaleConfig(SaleConfig memory config) public onlyOwner {
    saleConfig = config;
  }
}
