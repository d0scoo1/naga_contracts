// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "one-of-ones/contracts/OneOfOnes.sol";

contract Awardz is OneOfOnes {
  constructor() ERC721A("Awardz", "AWARDZ") {}
}