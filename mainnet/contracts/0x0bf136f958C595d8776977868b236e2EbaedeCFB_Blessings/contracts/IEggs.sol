pragma solidity >=0.8.7;

import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

interface IEggs is IERC721Enumerable {

  function userBlessings(
    address user
  ) external view returns (uint256);

  function totalBlessings() external view returns (uint256);

  function balanceOf(address user) external view returns (uint256);

  function blessEggs(
    address user,
    uint256 amount
  ) external;
}

